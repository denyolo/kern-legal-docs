-- ============================================================================
-- KERN — Admin Audit Fix (Sprint #25 Patch, Tag 13)
-- ============================================================================
--
-- Bug-Fix für 0002_admin_audit.sql:
--
-- Die ursprüngliche Funktion checkte auf
--   `current_setting('request.jwt.claims')::jsonb->>'role' = 'service_role'`
--
-- Im Supabase Dashboard SQL Editor wird die Query als `postgres`-User ohne
-- JWT-Claims ausgeführt → request.jwt.claims ist NULL → Check schlug auch
-- für legitime Owner-Aufrufe fehl mit:
--   ERROR: admin_inspect_user_data is restricted to service_role
--
-- Fix: Statt JWT-Role nutzen wir `current_user`, der robuster ist über alle
-- Aufruf-Kontexte:
--   • Dashboard SQL Editor:    current_user = 'postgres' oder 'supabase_admin'
--   • API via service_role key: current_user = 'service_role'
--   • API via anon key:         current_user = 'anon'           (blockiert)
--   • API via authenticated:    current_user = 'authenticated'  (blockiert)
-- ============================================================================

CREATE OR REPLACE FUNCTION public.admin_inspect_user_data(
  target_user_id UUID,
  reason TEXT
)
RETURNS TABLE (
  source_table TEXT,
  row_data     JSONB
)
LANGUAGE plpgsql
AS $$
DECLARE
  caller_id UUID;
BEGIN
  -- Verteidigungslinie 1: Caller muss Admin-Rolle sein.
  -- Dashboard läuft als postgres/supabase_admin; API als service_role.
  IF current_user NOT IN ('postgres', 'supabase_admin', 'service_role') THEN
    RAISE EXCEPTION 'admin_inspect_user_data is restricted to admin callers (got role: %)', current_user;
  END IF;

  -- Caller-ID für Audit-Eintrag:
  -- • API-Call: aus JWT-Claim 'sub'
  -- • Dashboard-Call: kein JWT vorhanden → leere UUID als Marker
  caller_id := COALESCE(
    (current_setting('request.jwt.claims', true)::jsonb->>'sub')::uuid,
    '00000000-0000-0000-0000-000000000000'::uuid
  );

  -- Verteidigungslinie 2: Reason-Länge validieren (gegen lazy "test"-Reasons).
  IF length(trim(reason)) < 10 THEN
    RAISE EXCEPTION 'Reason must be at least 10 characters — document why you''re accessing this user''s data';
  END IF;

  -- Audit-Eintrag (passiert IMMER vor dem Daten-Return).
  INSERT INTO public.admin_access_log (
    admin_user_id, accessed_user_id, accessed_tables, reason
  )
  VALUES (
    caller_id,
    target_user_id,
    ARRAY['profiles', 'reflections', 'insights', 'sessions', 'affirmations', 'goals', 'life_areas', 'blockade_meta'],
    reason
  );

  -- Daten-Return: aggregiert aus allen Inhalts-Tabellen.
  RETURN QUERY
    SELECT 'profile'::TEXT,        to_jsonb(p) FROM public.profiles p        WHERE p.user_id = target_user_id
    UNION ALL
    SELECT 'goal'::TEXT,           to_jsonb(g) FROM public.goals g           WHERE g.user_id = target_user_id
    UNION ALL
    SELECT 'life_area'::TEXT,      to_jsonb(la) FROM public.life_areas la    WHERE la.user_id = target_user_id
    UNION ALL
    SELECT 'reflection'::TEXT,     to_jsonb(r) FROM public.reflections r     WHERE r.user_id = target_user_id
    UNION ALL
    SELECT 'insight'::TEXT,        to_jsonb(i) FROM public.insights i        WHERE i.user_id = target_user_id
    UNION ALL
    SELECT 'session'::TEXT,        to_jsonb(s) FROM public.sessions s        WHERE s.user_id = target_user_id
    UNION ALL
    SELECT 'affirmation'::TEXT,    to_jsonb(a) FROM public.affirmations a    WHERE a.user_id = target_user_id
    UNION ALL
    SELECT 'blockade_meta'::TEXT,  to_jsonb(bm) FROM public.blockade_meta bm WHERE bm.user_id = target_user_id;
END;
$$;

-- Execute-Grants re-applizieren (sicherheitshalber, sind nach CREATE OR REPLACE
-- meist erhalten, aber explizit zur Klarheit).
REVOKE EXECUTE ON FUNCTION public.admin_inspect_user_data(UUID, TEXT) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.admin_inspect_user_data(UUID, TEXT) FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.admin_inspect_user_data(UUID, TEXT) FROM anon;
GRANT  EXECUTE ON FUNCTION public.admin_inspect_user_data(UUID, TEXT) TO service_role;
GRANT  EXECUTE ON FUNCTION public.admin_inspect_user_data(UUID, TEXT) TO postgres;

COMMENT ON FUNCTION public.admin_inspect_user_data IS
  'KERN audit-gated owner access. Call instead of direct SELECT to maintain audit trail. '
  'Reason must be at least 10 chars. Logged in admin_access_log. '
  'Allowed callers: postgres, supabase_admin (Dashboard) / service_role (API). '
  'See docs/legal/admin-conduct.md.';
