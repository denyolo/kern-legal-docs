-- ============================================================================
-- KERN — Usage Events / Anonyme Telemetrie (Sprint #26, Tag 15)
-- ============================================================================
--
-- Dedizierte Telemetrie-Tabelle für anonyme Nutzungs-Metriken.
-- ENTHÄLT KEINE USER-INHALTE — nur Zahlen, Enums und gehashte User-IDs.
--
-- Privacy-Garantie (siehe docs/legal/admin-conduct.md + privacy-policy):
-- - Keine TEXT-Spalten für User-Eingaben oder Antworten
-- - User-ID wird über server-side Hash anonymisiert (Salt nur in DB)
-- - Schema im public GitHub-Repo nachvollziehbar
-- - admin_access_log (für sessions/reflections/etc.) bleibt durch diese
--   Tabelle UNBERÜHRT — sie ist KEIN User-Inhalt, sondern anonymes Aggregate
--
-- Was wird getrackt:
-- - reflection_completed, reflection_aborted
-- - affirmation_generated
-- - meditation_completed
-- - onboarding_completed
-- - limit_reached
-- - premium_converted
-- - app_session
--
-- Schreib-Pfad: Client ruft RPC `log_usage_event(...)`. Funktion hat
-- SECURITY DEFINER → liest user_id aus JWT, hashed sie, schreibt Event.
-- Client braucht keine crypto-lib + sieht das Salt nie.
-- ============================================================================

-- ─── Salt-Storage (Supabase Hosted: ALTER DATABASE ist gelocked, daher
--                  eigene Tabelle mit RLS-Lock auf service_role) ───────────
-- Owner muss nach Migration EINMALIG einen Random-Secret-String einfügen:
--   INSERT INTO public.app_secrets (key, value)
--   VALUES ('telemetry_salt', '<openssl rand -hex 16>');

CREATE TABLE IF NOT EXISTS public.app_secrets (
  key   TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- RLS aktivieren — KEINE Policies = niemand außer service_role kann lesen/schreiben
ALTER TABLE public.app_secrets ENABLE ROW LEVEL SECURITY;

COMMENT ON TABLE public.app_secrets IS
  'Server-side Secrets (z.B. Telemetrie-Hash-Salt). '
  'RLS-locked, nur service_role kann lesen/schreiben.';

-- ─── usage_events-Tabelle ──────────────────────────────────────────────────

CREATE TABLE public.usage_events (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  occurred_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Was: aus fester Enum-Liste (CHECK constraint), nie freier String
  event_type      TEXT NOT NULL,

  -- Wer: SHA-256(user_id || telemetry_salt), nullable bei pre-auth events
  user_id_hashed  TEXT,

  -- Kontext: aus festem Kategorie-Set (z.B. Meditations-Kategorie,
  -- Reflexions-Modus, Limit-Typ). KEINE freie User-Eingabe.
  category        TEXT,

  -- Drei numerische Felder, generisch nutzbar pro event_type:
  --   reflection_completed: numeric_1=char_count, numeric_2=turn_count, numeric_3=duration_sec
  --   affirmation_generated: numeric_1=char_count_output, numeric_2=retry_count
  --   meditation_completed: numeric_1=chosen_duration_sec, numeric_2=actual_duration_sec
  --   onboarding_completed: numeric_1=time_sec, numeric_2=areas_count, numeric_3=blocks_count
  --   limit_reached: numeric_1=attempts_after
  --   premium_converted: numeric_1=days_since_signup
  --   app_session: numeric_1=duration_active_sec
  numeric_1       INTEGER,
  numeric_2       INTEGER,
  numeric_3       INTEGER,

  -- Session-Token: ermöglicht das Verknüpfen mehrerer Events innerhalb
  -- derselben App-Session (z.B. limit_reached → premium_converted im
  -- gleichen Open-Cycle). KEINE User-ID, nur eine pro App-Open zufällig
  -- generierte UUID.
  session_token   TEXT,

  -- Hard-Constraint: nur erlaubte event_types
  CONSTRAINT chk_event_type CHECK (event_type IN (
    'reflection_completed',
    'reflection_aborted',
    'affirmation_generated',
    'meditation_completed',
    'onboarding_completed',
    'limit_reached',
    'premium_converted',
    'app_session'
  ))
);

COMMENT ON TABLE public.usage_events IS
  'KERN anonyme Telemetrie. Enthält KEINE User-Inhalte. Schreib-Pfad: '
  'RPC log_usage_event() mit SECURITY DEFINER. Read: nur service_role. '
  'Siehe docs/legal/admin-conduct.md + docs/legal/analytics-events.md.';

-- ─── Indizes für Aggregations-Queries ──────────────────────────────────────

-- Häufigste Queries: "wie viele Events vom Typ X in den letzten N Tagen"
CREATE INDEX idx_usage_event_type_time
  ON public.usage_events(event_type, occurred_at DESC);

-- Cohort-Queries: "alle Events eines bestimmten gehashten Users"
CREATE INDEX idx_usage_user_time
  ON public.usage_events(user_id_hashed, occurred_at DESC)
  WHERE user_id_hashed IS NOT NULL;

-- Session-Replay (für Funnel-Analyse): alle Events einer App-Session
CREATE INDEX idx_usage_session_time
  ON public.usage_events(session_token, occurred_at)
  WHERE session_token IS NOT NULL;

-- ─── RLS: niemand außer service_role kann SELECT ───────────────────────────

ALTER TABLE public.usage_events ENABLE ROW LEVEL SECURITY;

-- KEINE SELECT-Policy = niemand kann Rows direkt lesen
-- (außer service_role, das RLS standardmäßig umgeht)

-- KEINE INSERT-Policy = direkter INSERT durch User unmöglich
-- (Einzige Schreib-Route ist die RPC unten)

-- ─── Hash-Helper (interne Funktion) ────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.telemetry_hash_user_id(p_user_id UUID)
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER  -- braucht Lese-Zugriff auf app_secrets (RLS-locked sonst)
SET search_path = public, pg_temp
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

REVOKE EXECUTE ON FUNCTION public.telemetry_hash_user_id(UUID) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.telemetry_hash_user_id(UUID) FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.telemetry_hash_user_id(UUID) FROM anon;
-- Nur service_role + log_usage_event (via SECURITY DEFINER) dürfen das

-- ─── log_usage_event RPC (öffentlicher Schreib-Pfad) ───────────────────────

CREATE OR REPLACE FUNCTION public.log_usage_event(
  p_event_type    TEXT,
  p_category      TEXT     DEFAULT NULL,
  p_numeric_1     INTEGER  DEFAULT NULL,
  p_numeric_2     INTEGER  DEFAULT NULL,
  p_numeric_3     INTEGER  DEFAULT NULL,
  p_session_token TEXT     DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_user_id UUID;
BEGIN
  -- User-ID aus JWT-Claim 'sub'. Bei anon (pre-login) NULL.
  v_user_id := NULLIF(
    current_setting('request.jwt.claims', true)::jsonb->>'sub', ''
  )::uuid;

  -- Hard-Length-Check für category + session_token, damit niemand versucht
  -- hier Inhalte reinzusmugglen.
  IF p_category IS NOT NULL AND length(p_category) > 64 THEN
    RAISE EXCEPTION 'telemetry: category must be <= 64 chars (no content)';
  END IF;
  IF p_session_token IS NOT NULL AND length(p_session_token) > 64 THEN
    RAISE EXCEPTION 'telemetry: session_token must be <= 64 chars';
  END IF;

  INSERT INTO public.usage_events (
    event_type,
    user_id_hashed,
    category,
    numeric_1,
    numeric_2,
    numeric_3,
    session_token
  ) VALUES (
    p_event_type,
    public.telemetry_hash_user_id(v_user_id),
    p_category,
    p_numeric_1,
    p_numeric_2,
    p_numeric_3,
    p_session_token
  );
END;
$$;

-- Berechtigungen: authenticated + anon dürfen ausführen (für app_session
-- vor Login). service_role implizit.
REVOKE EXECUTE ON FUNCTION public.log_usage_event(TEXT, TEXT, INTEGER, INTEGER, INTEGER, TEXT) FROM PUBLIC;
GRANT  EXECUTE ON FUNCTION public.log_usage_event(TEXT, TEXT, INTEGER, INTEGER, INTEGER, TEXT) TO authenticated;
GRANT  EXECUTE ON FUNCTION public.log_usage_event(TEXT, TEXT, INTEGER, INTEGER, INTEGER, TEXT) TO anon;

COMMENT ON FUNCTION public.log_usage_event IS
  'Anonymer Telemetrie-Schreib-Pfad. Hashed user_id server-side. '
  'KEINE User-Inhalte. Siehe docs/legal/analytics-events.md.';

-- ─── Convenience-View für Aggregations-Queries (read: service_role only) ───

CREATE OR REPLACE VIEW public.usage_summary_30d AS
  SELECT
    event_type,
    COUNT(*)                        AS events,
    COUNT(DISTINCT user_id_hashed)  AS unique_users,
    AVG(numeric_1)::INTEGER         AS avg_num1,
    AVG(numeric_2)::INTEGER         AS avg_num2,
    AVG(numeric_3)::INTEGER         AS avg_num3
  FROM public.usage_events
  WHERE occurred_at > NOW() - INTERVAL '30 days'
  GROUP BY event_type
  ORDER BY events DESC;

COMMENT ON VIEW public.usage_summary_30d IS
  'Schneller 30-Tage-Überblick. Nur Aggregate, keine Einzel-Rows.';
