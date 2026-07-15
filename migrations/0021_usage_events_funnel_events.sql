-- 0021 — usage_events: Funnel-Event-Typen für den Onboarding-Umbau (Weg 3)
-- + Fix für affirmation_practiced.
--
-- Kontext: chk_event_type (0005) erlaubt exakt 8 event_type-Werte. Jeder andere
-- Wert wird von Postgres 23514-rejected → der fire-and-forget-Client-Insert
-- schlägt STILL fehl (nur console.warn), die Zeile landet NIE in der Tabelle.
--
-- 🚨 affirmation_practiced wird seit Tag 35 vom Client gefeuert
-- (app/affirmation.tsx) UND vom Beta-Dashboard gelesen, war aber NIE in der
-- CHECK-Liste → alle diese Inserts wurden seit Monaten still verworfen
-- („Geübt"-Spalte strukturell leer). Dieser Fix nimmt es endlich auf.
--
-- NEU für den Onboarding-A/B-Funnel (Weg 3 / ONBOARDING_V2):
--   onboarding_started — Onboarding betreten (Denominator für Drop-off; feuert
--                        in BEIDEN Armen, category = 'browse' | 'classic')
--   browse_entered     — Reinschauer ist ohne Profil in der App gelandet
--                        (nur Browse-Arm; die „einfach reinschauen"-Landung)
--   meditation_started — eine Meditation wurde gestartet (Funnel-Schritt:
--                        führt Browsen zur Meditation?; category = Kategorie)
--
-- Alle Events bleiben streng inhaltsfrei (nur Enums/Zahlen). Kein Schema-Feld
-- ändert sich außer der event_type-Whitelist.
--
-- Deploy (Prod-Migrations-Historie ist gedriftet → NICHT `db push`):
--   supabase db query --linked --file supabase/migrations/0021_usage_events_funnel_events.sql

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
  -- Fix: seit Tag 35 gefeuert + gelesen, aber nie erlaubt
  'affirmation_practiced',
  -- NEU: Onboarding-A/B-Funnel (Weg 3)
  'onboarding_started',
  'browse_entered',
  'meditation_started'
));

COMMENT ON CONSTRAINT chk_event_type ON public.usage_events IS
  'Erlaubte anonyme Telemetrie-Event-Typen. 0021: + affirmation_practiced (Fix) '
  '+ onboarding_started / browse_entered / meditation_started (Onboarding-Funnel).';
