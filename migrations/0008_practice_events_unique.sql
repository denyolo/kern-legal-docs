-- ════════════════════════════════════════════════════════════════════════════
-- Migration 0008: UNIQUE-Constraint auf affirmation_practice_events
--
-- Bug-Diagnose (Tag 19, Mai 24, 2026):
--   Cloud-Count zeigte "Affirmations-Praxis-Events: 0" obwohl der User
--   mehrere Affirmationen praktiziert hat. Root-Cause:
--     services/storageSync.ts Z.89-92 macht syncEngine.upsert(...,
--     onConflict: 'user_id,affirmation_id,practiced_at')
--   ABER das Schema in 0001 hat KEINEN UNIQUE-Index auf dieses Tuple →
--   Postgres rejected jeden Upsert silently mit
--     "there is no unique or exclusion constraint matching the
--      ON CONFLICT specification"
--   → Practice-Events kamen NIE in die Cloud → totalAffirmations-Counter
--   nach Sign-Out/Re-Login immer 0 (rechnet aus practiceDates).
--
-- Idempotent: ADD CONSTRAINT IF NOT EXISTS wird über DO-Block emuliert
-- (Postgres < 17 unterstützt das nicht direkt).
-- ════════════════════════════════════════════════════════════════════════════

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'affirmation_practice_events_user_aff_time_uniq'
  ) THEN
    ALTER TABLE public.affirmation_practice_events
      ADD CONSTRAINT affirmation_practice_events_user_aff_time_uniq
      UNIQUE (user_id, affirmation_id, practiced_at);
  END IF;
END $$;

COMMENT ON CONSTRAINT affirmation_practice_events_user_aff_time_uniq
  ON public.affirmation_practice_events IS
  'Verhindert Doppel-Events bei gleichem User+Affirmation+Zeitpunkt. Pflicht für ON CONFLICT-Upsert in services/storageSync.ts.';
