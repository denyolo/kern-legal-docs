-- 0025 — event_type 'paywall_viewed' erlauben (07.09.2026, Release 1.1)
--
-- 🚨 WARUM DIESE MIGRATION VOR DEM APP-BUILD KOMMEN MUSS (Tag-62-Regel):
-- Der Client feuert Telemetrie fire-and-forget. Fehlt der Typ im CHECK, lehnt
-- Postgres jeden Insert mit 23514 STILL ab - niemand merkt es. Bei JEDEM neuen
-- event_type zuerst chk_event_type erweitern (Vorlage: 0024).
--
-- Zweck: Trichter-Schritt „Paywall geöffnet". Feuert genau EINMAL pro Öffnen
-- (Ref-Guard in paywall.tsx), optional mit category (welche gesperrte Meditation
-- den Aufruf auslöste). Anonym, inhaltsfrei - eine reine Marketing-Zahl.
-- Rein hinzufügend: keine bestehenden Daten/Typen berührt, nur die erlaubte
-- Menge erweitert.
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
    'meditation_rated', 'paywall_viewed'
  ])
);
