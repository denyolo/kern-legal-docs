-- 0037: Telemetrie bekommt Plattform und App-Version, dazu das Ereignis
-- „Erlaubnis-Fenster gezeigt“ (App-Version 1.3.0).
--
-- Warum: Ohne Plattform sähen Android-Ereignisse aus wie iOS-Ereignisse, und
-- Funnel-Zahlen ließen sich
-- nicht nach App-Version trennen. „Fenster gezeigt“ ergänzt `ai_consent` (die
-- Antwort), erst damit lässt sich sagen, wie viele das Fenster sehen und wie viele
-- davon zustimmen.
--
-- 🚨 log_usage_event NIE per CREATE OR REPLACE mit neuen Parametern überladen:
-- Eine zweite Signatur gibt PGRST203, und die Telemetrie aller iPhones fällt still
-- aus. Deshalb DROP + CREATE in EINER Transaktion, die neuen Parameter mit DEFAULT
-- NULL. Alte App-Versionen rufen mit ihren sechs Parametern auf und landen über die
-- Defaults in derselben Funktion.
--
-- Inhaltsfrei: platform nur 'ios' oder 'android', app_version höchstens 32 Zeichen
-- (Form „1.3.0 (351)“). Unbekannte oder zu lange Werte werden zu NULL, statt das
-- Ereignis abzulehnen: Ein Ereignis geht nie wegen der Versionsangabe verloren.
-- Alte Zeilen bleiben ohne Plattform (kein UPDATE): NULL heißt „vor 1.3.0“.
--
-- Funktionskörper = Live-Definition vom 07.11.2026 (pg_get_functiondef) plus die
-- zwei Felder. Rechte wie live: EXECUTE für anon und authenticated, nicht PUBLIC
-- (seit 0029 nicht mehr automatisch). Ereignisliste = live (pg_get_constraintdef,
-- 07.11.2026, 30 Typen, gleich 0035) plus 'ai_consent_shown'.
--
-- Deploy (NICHT db push): supabase db query --linked --file <diese Datei>
-- Reihenfolge: vor dem Release von 1.3.0. Vorher in einer abgebrochenen
-- Transaktion geprüft (Probe mit RAISE EXCEPTION, nichts gespeichert).

BEGIN;

ALTER TABLE public.usage_events
  ADD COLUMN IF NOT EXISTS platform TEXT,
  ADD COLUMN IF NOT EXISTS app_version TEXT;

ALTER TABLE public.usage_events DROP CONSTRAINT IF EXISTS chk_platform;
ALTER TABLE public.usage_events ADD CONSTRAINT chk_platform
  CHECK (platform IS NULL OR platform IN ('ios', 'android'));

ALTER TABLE public.usage_events DROP CONSTRAINT IF EXISTS chk_app_version;
ALTER TABLE public.usage_events ADD CONSTRAINT chk_app_version
  CHECK (app_version IS NULL OR length(app_version) <= 32);

COMMENT ON COLUMN public.usage_events.platform IS
  'ios oder android, gesetzt ab App-Version 1.3.0. NULL = ältere App-Version (iOS).';
COMMENT ON COLUMN public.usage_events.app_version IS
  'App-Version mit Build-Nummer, z.B. „1.3.0 (351)“, ab 1.3.0. Keine Inhalte.';

DROP FUNCTION public.log_usage_event(TEXT, TEXT, INTEGER, INTEGER, INTEGER, TEXT);

CREATE FUNCTION public.log_usage_event(
  p_event_type    TEXT,
  p_category      TEXT     DEFAULT NULL,
  p_numeric_1     INTEGER  DEFAULT NULL,
  p_numeric_2     INTEGER  DEFAULT NULL,
  p_numeric_3     INTEGER  DEFAULT NULL,
  p_session_token TEXT     DEFAULT NULL,
  p_platform      TEXT     DEFAULT NULL,
  p_app_version   TEXT     DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public', 'pg_temp'
AS $function$
DECLARE
  v_user_id UUID;
  v_platform TEXT;
  v_app_version TEXT;
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

  -- 0037: nur bekannte Plattformen, Version höchstens 32 Zeichen, sonst NULL
  -- (das Ereignis selbst wird nie deswegen abgelehnt).
  v_platform := CASE WHEN p_platform IN ('ios', 'android') THEN p_platform ELSE NULL END;
  v_app_version := CASE
    WHEN p_app_version IS NOT NULL AND length(p_app_version) <= 32 THEN p_app_version
    ELSE NULL
  END;

  INSERT INTO public.usage_events (
    event_type,
    user_id_hashed,
    category,
    numeric_1,
    numeric_2,
    numeric_3,
    session_token,
    platform,
    app_version
  ) VALUES (
    p_event_type,
    public.telemetry_hash_user_id(v_user_id),
    p_category,
    p_numeric_1,
    p_numeric_2,
    p_numeric_3,
    p_session_token,
    v_platform,
    v_app_version
  );
END;
$function$;

REVOKE EXECUTE ON FUNCTION public.log_usage_event(TEXT, TEXT, INTEGER, INTEGER, INTEGER, TEXT, TEXT, TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.log_usage_event(TEXT, TEXT, INTEGER, INTEGER, INTEGER, TEXT, TEXT, TEXT) TO anon, authenticated;

COMMENT ON FUNCTION public.log_usage_event(TEXT, TEXT, INTEGER, INTEGER, INTEGER, TEXT, TEXT, TEXT) IS
  'Inhaltsfreie Telemetrie (usage_events). 0037: + p_platform, p_app_version mit DEFAULT NULL, '
  'per DROP + CREATE (nie überladen, sonst PGRST203).';

ALTER TABLE public.usage_events DROP CONSTRAINT IF EXISTS chk_event_type;
ALTER TABLE public.usage_events ADD CONSTRAINT chk_event_type CHECK (
  event_type = ANY (ARRAY[
    'reflection_completed', 'reflection_aborted', 'affirmation_generated',
    'meditation_completed', 'onboarding_completed', 'limit_reached',
    'premium_converted', 'app_session', 'affirmation_practiced',
    'onboarding_started', 'browse_entered', 'meditation_started',
    'course_started', 'course_day_completed', 'course_completed',
    'onboarding_intro_advanced', 'onboarding_turn', 'onboarding_reveal_reached',
    'onboarding_backup_reached', 'onboarding_abandoned',
    'meditation_rated', 'paywall_viewed', 'reflection_summary_failed',
    'explainer_started', 'explainer_ended', 'explainer_cta',
    'share_opened',
    'next_course_card_viewed', 'next_course_card_tapped',
    'ai_consent',
    'ai_consent_shown'
  ])
);

COMMIT;

NOTIFY pgrst, 'reload schema';
