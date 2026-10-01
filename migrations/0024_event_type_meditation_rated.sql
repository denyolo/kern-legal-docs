-- 0024 — event_type 'meditation_rated' erlauben (21.08.2026)
--
-- 🚨 WARUM DIESE MIGRATION VOR DEM APP-BUILD KOMMEN MUSS:
-- Der Client feuert Telemetrie fire-and-forget. Fehlt der Typ im CHECK, lehnt
-- Postgres jeden Insert mit 23514 ab - STILL, niemand merkt es. Genau das ist an
-- Tag 62 passiert: vier Event-Typen wurden wochenlang lautlos verworfen.
-- Regel (CLAUDE.md): bei JEDEM neuen event_type zuerst chk_event_type prüfen.
--
-- Zweck des Events: Die Meditations-Bewertung (Daumen hoch/runter) wurde bisher
-- zwar gespeichert, aber NIRGENDS gelesen - der einzige lesende Code-Pfad hat
-- app-weit keinen Aufrufer. Jetzt fließt sie als anonymes Aggregat ins
-- Beta-Dashboard: welche Meditations-Kategorie wird gemocht, welche nicht.
-- Inhaltsfrei: category + numeric_1 (1 = gut / 0 = weniger), gehashte Kennung.
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
    'meditation_rated'
  ])
);
