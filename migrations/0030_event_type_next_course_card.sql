-- 0030 — event_types für die Kurs-2-Karte am Ende von Kurs 1 erlauben (26.10.2026, 1.2.5)
--
-- 🚨 WARUM DIESE MIGRATION VOR DEM APP-BUILD KOMMEN MUSS (Tag-62-Regel):
-- Der Client feuert Telemetrie fire-and-forget. Fehlt der Typ im CHECK, lehnt
-- Postgres jeden Insert mit 23514 STILL ab - niemand merkt es.
-- Einspielen per `supabase db query --linked --file <diese Datei>`, NICHT `db push`
-- (Remote-Migrationshistorie ist leer, Tag 42).
--
-- Zweck: misst den Kauf-Hebel am Ende von Kurs 1. Bisher gab es erst
-- paywall_viewed('course1_end') nach zwei weiteren Tipps - ob die Karte überhaupt
-- gesehen und angetippt wird, war unsichtbar. Trichter:
-- viewed → tapped → paywall_viewed('course1_end') → Kauf.
--   next_course_card_viewed  category  = nächster Kurs (feste Kennung, heute 'breathwork')
--                            numeric_1 = lokale Kalendertage seit Abschluss von Kurs 1 (0 = gleicher Tag)
--   next_course_card_tapped  category  = wie viewed
--                            numeric_1 = lokale Kalendertage seit Abschluss von Kurs 1 (0 = gleicher Tag)
--                            numeric_2 = 1 wenn die Oktober-Angebotszeile sichtbar war, sonst 0
-- Auswertung nur pro Person (DISTINCT user_id_hashed), nicht pro session_token:
-- viewed wird einmal pro App-Start gemeldet, das Token wechselt öfter.
-- Anonym, inhaltsfrei. Rein hinzufügend: keine bestehenden Daten/Typen berührt
-- (Liste = 0028 wörtlich + die zwei neuen; 0029 fasst den CHECK nicht an).
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
    'next_course_card_viewed', 'next_course_card_tapped'
  ])
);
