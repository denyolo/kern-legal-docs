-- 0023 — usage_events: Onboarding-Gesprächs-Funnel (Schritt für Schritt)
--
-- Kontext: Der Onboarding-Funnel war bis 0022 nur von drei Punkten geklammert
-- (browse_entered → onboarding_started → onboarding_completed). Zwischen
-- „Gespräch gestartet" und „fertig" liegen 4-6 dynamische Züge + Reveal/Backup -
-- eine Blackbox. Prod-Daten (12.08.): von den frischen LinkedIn-Nutzern starten
-- 16 das Gespräch, nur 6 schließen ab (~62% Abbruch) - aber WO sie aussteigen,
-- war nicht messbar. Diese Events machen den Schritt-für-Schritt-Funnel sichtbar.
--
-- NEU (alle streng inhaltsfrei - nur Zahlen/Enums, NIE Antwort-Text):
--   onboarding_intro_advanced — Intro-Slide erreicht (numeric_1 = 0 Willkommen /
--                               1 Mission / 2 Säulen). Die „wer steigt VOR dem
--                               Gespräch aus"-Blindzone.
--   onboarding_turn           — ein gesendeter Gesprächs-Zug (numeric_1 = 1..6).
--                               Der Kern: bei welchem Zug bricht es ab?
--   onboarding_reveal_reached — „Das hat KERN verstanden" gesehen (Gespräch durch).
--   onboarding_backup_reached — Backup-Wahl erreicht (letzter Schritt vor Commit).
--   onboarding_abandoned      — Gespräch über den Zurück-Pfeil verlassen
--                               (numeric_1 = wie weit gekommen).
--
-- 🚨 Die Lehre von 0021/0022 (Tag 62): ein event_type, der hier NICHT drinsteht,
-- wird von Postgres 23514-rejected - der fire-and-forget-Client-Insert schlägt
-- STILL fehl. Diese Migration MUSS deployen, BEVOR ein Build die Events feuert.
--
-- Deploy (Prod-Migrations-Historie ist gedriftet → NICHT `db push`):
--   supabase db query --linked --file supabase/migrations/0023_usage_events_onboarding_funnel.sql

ALTER TABLE public.usage_events DROP CONSTRAINT IF EXISTS chk_event_type;

ALTER TABLE public.usage_events ADD CONSTRAINT chk_event_type CHECK (event_type IN (
  -- Bestand (0005)
  'reflection_completed',
  'reflection_aborted',
  'affirmation_generated',
  'meditation_completed',
  'onboarding_completed',
  'limit_reached',
  'premium_converted',
  'app_session',
  -- 0021: Fix + Onboarding-Funnel (Weg 3)
  'affirmation_practiced',
  'onboarding_started',
  'browse_entered',
  'meditation_started',
  -- 0022: Kurs-Funnel
  'course_started',
  'course_day_completed',
  'course_completed',
  -- 0023: Onboarding-Gesprächs-Funnel (Schritt für Schritt)
  'onboarding_intro_advanced',
  'onboarding_turn',
  'onboarding_reveal_reached',
  'onboarding_backup_reached',
  'onboarding_abandoned'
));

COMMENT ON CONSTRAINT chk_event_type ON public.usage_events IS
  'Erlaubte anonyme Telemetrie-Event-Typen. 0021: + affirmation_practiced (Fix) '
  '+ onboarding_started / browse_entered / meditation_started. '
  '0022: + course_started / course_day_completed / course_completed. '
  '0023: + onboarding_intro_advanced / onboarding_turn / onboarding_reveal_reached '
  '/ onboarding_backup_reached / onboarding_abandoned (Gespraech-Schritt-Funnel).';
