-- 0028 — event_type fürs Weiterempfehlen erlauben (27.09.2026, 1.1.8, Referral Stufe 1)
--
-- 🚨 WARUM DIESE MIGRATION VOR DEM APP-BUILD KOMMEN MUSS (Tag-62-Regel):
-- Der Client feuert Telemetrie fire-and-forget. Fehlt der Typ im CHECK, lehnt
-- Postgres jeden Insert mit 23514 STILL ab - niemand merkt es.
--
-- Zweck: misst, ob Leute KERN überhaupt weiterempfehlen (Marketing-Konzept 19.09.,
-- Stufe 1: sanfter Teilen-Moment, kein Tracking von Personen, keine Belohnung).
--   share_opened  category  = Ort ('course_complete' | 'settings')
--                 numeric_1 = 1 wenn tatsächlich geteilt, 0 wenn das Teilen-Fenster
--                             ohne Teilen geschlossen wurde
-- Anonym, inhaltsfrei: weder Empfänger noch Nachricht werden erfasst. Rein
-- hinzufügend: keine bestehenden Daten/Typen berührt.
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
    'share_opened'
  ])
);
