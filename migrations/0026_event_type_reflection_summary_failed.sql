-- 0026 — event_type 'reflection_summary_failed' erlauben (25.09.2026, Tag 121)
--
-- 🚨 WARUM DIESE MIGRATION VOR DEM APP-BUILD KOMMEN MUSS (Tag-62-Regel):
-- Der Client feuert Telemetrie fire-and-forget. Fehlt der Typ im CHECK, lehnt
-- Postgres jeden Insert mit 23514 STILL ab - niemand merkt es. Bei JEDEM neuen
-- event_type zuerst chk_event_type erweitern (Vorlage: 0025).
--
-- Zweck: misst, WIE OFT die Reflexions-Synthese scheitert und der Nutzer den
-- ehrlichen generationFailed-Screen sieht (Sebastian-Meldung, Tag 120). Die Rate
-- war bis hier NICHT messbar (kein Event existierte). Feuert erst NACH dem
-- Nachversuch (Fix A) = echte user-facing Fehlerquote.
--   category  = 'free' (generateStructuredSummary) | 'guided' (generateGuidedReflectionSummary)
--   numeric_1 = Fehlerklasse (KEIN Inhalt): 1=parse (JSON kaputt/Dialog-Fortsetzung),
--               2=network/timeout, 3=truncated, 4=rate_limited, 9=sonstiges
-- Anonym, inhaltsfrei. Rein hinzufügend: keine bestehenden Daten/Typen berührt,
-- nur die erlaubte Menge erweitert.
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
    'meditation_rated', 'paywall_viewed', 'reflection_summary_failed'
  ])
);
