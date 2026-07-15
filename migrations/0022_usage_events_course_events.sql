-- 0022 — usage_events: Kurs-Funnel-Event-Typen (Kurs 1 „Dein Einstieg")
--
-- Kontext: Der Kurs-Funnel hatte bis heute NULL Events. course.tsx und der
-- Kurs-Storage importieren die Telemetrie gar nicht, und `course_progress` ist
-- seit Migration 0015 E2E-verschlüsselt → serverseitig NICHT ableitbar. Kurs-
-- Metriken MÜSSEN also über usage_events laufen.
--
-- Warum das zählt: Der Onboarding-fork schickt die Leute prominent in Kurs 1.
-- Ohne diese Events endet jede Beta-Auswertung bei „X sind durchs Onboarding"
-- und schweigt genau da, wo sich entscheidet, ob jemand bleibt (Retention =
-- zentrale Daueraufgabe, s. Launch-Philosophie).
--
-- NEU:
--   course_started       — Kurs 1 wurde gestartet (echter Neustart-Zweig in
--                          storage.startCourse). „Wie viele fangen an?"
--   course_day_completed — ein Kurstag ist fertig (numeric_1 = Tag 1-7).
--                          Ergibt die Retention-Kurve pro Tag: wo bricht es ab?
--   course_completed     — Kurs abgeschlossen (numeric_1 = Kalendertage vom
--                          Start bis zum Abschluss). „Wie viele kommen durch?"
--
-- 🚨 INHALTSFREI: focusBlockade/focusArea gehen NIE ins Event - das ist
-- User-Content. Nur Tag-Nummer + Zeit-Deltas, wie bei allen anderen Events.
--
-- 🚨 Die Lehre von 0021 (Tag 62): Ein event_type, der hier NICHT drinsteht,
-- wird von Postgres 23514-rejected - der fire-and-forget-Client-Insert schlägt
-- STILL fehl, niemand merkt es. affirmation_practiced lief so monatelang ins
-- Leere. Bei JEDEM neuen Event-Typ zuerst diese Liste erweitern.
--
-- Deploy (Prod-Migrations-Historie ist gedriftet → NICHT `db push`):
--   supabase db query --linked --file supabase/migrations/0022_usage_events_course_events.sql

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
  -- 0021: Fix (seit Tag 35 gefeuert, aber nie erlaubt)
  'affirmation_practiced',
  -- 0021: Onboarding-Funnel (Weg 3)
  'onboarding_started',
  'browse_entered',
  'meditation_started',
  -- 0022: Kurs-Funnel (Kurs 1 „Dein Einstieg")
  'course_started',
  'course_day_completed',
  'course_completed'
));

COMMENT ON CONSTRAINT chk_event_type ON public.usage_events IS
  'Erlaubte anonyme Telemetrie-Event-Typen. 0021: + affirmation_practiced (Fix) '
  '+ onboarding_started / browse_entered / meditation_started (Onboarding-Funnel). '
  '0022: + course_started / course_day_completed / course_completed (Kurs-Funnel; '
  'course_progress ist E2E-verschluesselt und serverseitig nicht ableitbar).';
