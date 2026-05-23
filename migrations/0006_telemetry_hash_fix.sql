-- ============================================================================
-- KERN — Telemetrie-Hash-Fix (Sprint #26, Tag 16)
-- ============================================================================
--
-- Tag-15-Bug: log_usage_event-Calls aus der App geben HTTP 400 zurück, weil
-- telemetry_hash_user_id() intern digest() aus pgcrypto aufruft, aber die
-- Extension in Supabase Hosted im `extensions`-Schema lebt — unser
-- SET search_path = public, pg_temp findet sie dort nicht.
--
-- Warum der manuelle SQL-Test in Supabase SQL Editor trotzdem passte:
-- Ohne JWT (SQL Editor läuft ohne Auth-Context) ist current_setting(
-- 'request.jwt.claims',true) NULL → v_user_id wird NULL →
-- telemetry_hash_user_id(NULL) short-circuited mit `IF p_user_id IS NULL
-- THEN RETURN NULL` BEVOR digest() jemals aufgerufen wird.
--
-- Vom App-Pfad mit echter Anonymous-Session ist `sub` immer eine valide
-- UUID → digest() wird tatsächlich aufgerufen → 42883
-- "function digest(text, unknown) does not exist" → PostgREST mappt
-- Fehlerklasse 42 auf HTTP 400.
--
-- Fix: `extensions` zum search_path hinzufügen, damit pgcrypto's
-- digest() resolvable ist. Schema-qualifierter Aufruf wäre die
-- defensivere Alternative, aber search_path matched Supabases
-- eigenes SECURITY-DEFINER-Pattern und hält den Diff minimal.
-- ============================================================================

CREATE OR REPLACE FUNCTION public.telemetry_hash_user_id(p_user_id UUID)
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, extensions, pg_temp
AS $$
DECLARE
  v_salt TEXT;
BEGIN
  IF p_user_id IS NULL THEN
    RETURN NULL;
  END IF;
  SELECT value INTO v_salt FROM public.app_secrets WHERE key = 'telemetry_salt';
  IF v_salt IS NULL OR v_salt = '' THEN
    v_salt := 'fallback-not-secure-please-insert-telemetry_salt-into-app_secrets';
  END IF;
  RETURN encode(digest(p_user_id::text || v_salt, 'sha256'), 'hex');
END;
$$;

-- Berechtigungen unverändert: nur service_role + intern aufgerufen via
-- log_usage_event (SECURITY DEFINER). Re-apply, damit die fix-Migration
-- standalone wiederherstellbar bleibt falls 0005 ohne 0006 läuft.
REVOKE EXECUTE ON FUNCTION public.telemetry_hash_user_id(UUID) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.telemetry_hash_user_id(UUID) FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.telemetry_hash_user_id(UUID) FROM anon;

COMMENT ON FUNCTION public.telemetry_hash_user_id IS
  'SHA-256-Hash der User-ID mit server-side Salt aus app_secrets. '
  'Tag-16-Fix: search_path includes `extensions` für pgcrypto-digest.';
