-- ============================================================================
-- KERN — Admin Audit System (Sprint #25, Tag 13)
-- ============================================================================
--
-- Owner-Selbstverpflichtung: jeder Zugriff auf User-Inhalte (reflections,
-- insights, sessions, affirmations, profile) geht über die SQL-Funktion
-- `admin_inspect_user_data(target_user_id, reason)`. Diese schreibt einen
-- Eintrag in `admin_access_log` und liefert die Daten zurück.
--
-- Schwächen (transparent):
-- - Honor System: direkter SELECT im Dashboard ist technisch weiter möglich
-- - Funktioniert nur als Selbst-Disziplin-Werkzeug, nicht als hartes Audit
-- - Wird mit Supabase Pro Plan + pgaudit später ersetzt/ergänzt
--
-- Code-of-Conduct (docs/legal/admin-conduct.md) verpflichtet zur Nutzung
-- dieser Funktion statt direkter SELECTs auf User-Daten.
-- ============================================================================

-- ─── Log-Tabelle ────────────────────────────────────────────────────────────

CREATE TABLE public.admin_access_log (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  accessed_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  -- Admin-User-ID: wer hat reingeschaut (immer = Owner solange kein Team)
  admin_user_id    UUID NOT NULL,
  -- Target-User: wessen Daten wurden inspiziert. ON DELETE SET NULL damit
  -- ein gelöschter User den Log-Eintrag nicht killt (Anonymisierung statt
  -- Lösch-Kaskade — DSGVO-konform: Log bleibt, ohne Personenbezug).
  accessed_user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  accessed_tables  TEXT[] NOT NULL,
  reason           TEXT NOT NULL CHECK (length(reason) >= 10)
);

CREATE INDEX idx_admin_log_admin ON public.admin_access_log(admin_user_id, accessed_at DESC);
CREATE INDEX idx_admin_log_user  ON public.admin_access_log(accessed_user_id, accessed_at DESC);

-- RLS aktivieren — keine Policies = niemand kann lesen außer service_role.
-- Das ist gewollt: das Log soll nur über das Dashboard (Service-Role) oder
-- per expliziter Owner-Funktion sichtbar sein, nicht für normale User.
ALTER TABLE public.admin_access_log ENABLE ROW LEVEL SECURITY;

COMMENT ON TABLE public.admin_access_log IS
  'KERN admin audit trail. Append-only via admin_inspect_user_data(). '
  'See docs/legal/admin-conduct.md.';

-- ─── Inspect-Funktion ──────────────────────────────────────────────────────

-- Owner-Funktion: schreibt Audit-Eintrag + liefert User-Daten aus allen
-- Inhalts-Tabellen zurück. Wird AUSSCHLIESSLICH vom Owner (mit service_role)
-- via Supabase SQL Editor aufgerufen.
--
-- Sicherheits-Gating:
-- 1) EXECUTE-Privileg nur für service_role (unten via GRANT)
-- 2) Runtime-Check `auth.role() = 'service_role'` (zweite Verteidigungslinie)
-- 3) Reason muss min. 10 Zeichen haben — verhindert lazy "test" Reasons
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
  caller_role TEXT;
  caller_id   UUID;
BEGIN
  -- Runtime-Check: nur service_role darf das aufrufen
  caller_role := current_setting('request.jwt.claims', true)::jsonb->>'role';
  IF caller_role IS NULL OR caller_role <> 'service_role' THEN
    RAISE EXCEPTION 'admin_inspect_user_data is restricted to service_role (admin) callers';
  END IF;

  -- Caller-ID aus JWT-Claims (für Audit-Eintrag).
  -- Bei service_role-Calls via Dashboard ist `sub` der Owner.
  caller_id := COALESCE(
    (current_setting('request.jwt.claims', true)::jsonb->>'sub')::uuid,
    '00000000-0000-0000-0000-000000000000'::uuid
  );

  -- Reason-Validierung (zusätzlich zum CHECK constraint)
  IF length(trim(reason)) < 10 THEN
    RAISE EXCEPTION 'Reason must be at least 10 characters — document why you''re accessing this user''s data';
  END IF;

  -- Audit-Eintrag (passiert IMMER vor dem Daten-Return)
  INSERT INTO public.admin_access_log (
    admin_user_id, accessed_user_id, accessed_tables, reason
  )
  VALUES (
    caller_id,
    target_user_id,
    ARRAY['profiles', 'reflections', 'insights', 'sessions', 'affirmations', 'goals', 'life_areas', 'blockade_meta'],
    reason
  );

  -- Daten-Return: aggregiert aus allen Haupt-Inhalts-Tabellen
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

COMMENT ON FUNCTION public.admin_inspect_user_data IS
  'KERN audit-gated owner access. Call instead of direct SELECT to maintain audit trail. '
  'Reason must be at least 10 chars. Logged in admin_access_log. '
  'See docs/legal/admin-conduct.md.';

-- ─── Berechtigungen sperren ────────────────────────────────────────────────

-- Default in Postgres ist EXECUTE für PUBLIC — das wäre eine RLS-Bypass-
-- Lücke. Explizit revoken und nur service_role granten.
REVOKE EXECUTE ON FUNCTION public.admin_inspect_user_data(UUID, TEXT) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.admin_inspect_user_data(UUID, TEXT) FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.admin_inspect_user_data(UUID, TEXT) FROM anon;
GRANT  EXECUTE ON FUNCTION public.admin_inspect_user_data(UUID, TEXT) TO service_role;

-- ─── Convenience-View: Letzte Log-Einträge ────────────────────────────────

-- Für schnelle Übersicht im Dashboard: SELECT * FROM admin_recent_access;
CREATE OR REPLACE VIEW public.admin_recent_access AS
  SELECT
    accessed_at,
    accessed_user_id,
    reason,
    accessed_tables
  FROM public.admin_access_log
  ORDER BY accessed_at DESC
  LIMIT 100;

COMMENT ON VIEW public.admin_recent_access IS
  'Schnellansicht der letzten 100 Admin-Zugriffe. Nur via service_role lesbar.';
