-- 0027 — event_types fürs Erklärvideo erlauben (26.09.2026, Tag 122, 1.1.8 Strang 2)
--
-- 🚨 WARUM DIESE MIGRATION VOR DEM APP-BUILD KOMMEN MUSS (Tag-62-Regel):
-- Der Client feuert Telemetrie fire-and-forget. Fehlt der Typ im CHECK, lehnt
-- Postgres jeden Insert mit 23514 STILL ab - niemand merkt es. Bei JEDEM neuen
-- event_type zuerst chk_event_type erweitern (Vorlage: 0026).
--
-- Zweck: misst, ob Denyos Erklärvideo mehr Leute ins erste Gespräch bringt.
--   explainer_started  category  = Herkunft ('intro' | 'home' | 'wissen')
--   explainer_ended    category  = 'completed' | 'skipped' | 'closed' | 'error'
--                      numeric_1 = geschaute Sekunden, numeric_2 = Herkunft (1 intro, 2 home, 3 wissen)
--   explainer_cta      category  = 'reflect' | 'browse' | 'close', numeric_1 = Herkunft-Code
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
    'meditation_rated', 'paywall_viewed', 'reflection_summary_failed',
    'explainer_started', 'explainer_ended', 'explainer_cta'
  ])
);
