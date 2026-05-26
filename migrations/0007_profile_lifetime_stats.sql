-- ════════════════════════════════════════════════════════════════════════════
-- Migration 0007: Lebens-Zähler-Spalte für profiles
--
-- Vorher: profile.lifetimeStats war nur lokal in AsyncStorage. Bei
-- Sign-Out + Re-Login auf gleichem oder anderem Device gingen alle
-- INSGESAMT-Counter (Meditationen, Meditationsminuten, Reflexionen,
-- Gedanken, Affirmationen, Insights) verloren — auch wenn die Sessions
-- in der Cloud waren, weil der _bootstrapLifetimeStats-Fallback ein
-- leeres Object {0,0,0,...} schreibt sobald irgendeine neue Aktivität
-- (z.B. eine frische Reflexion nach Login) den Increment-Pfad triggert.
--
-- Fix: lifetime_stats als JSONB in profiles. mapProfileToRow + pullFromCloud
-- pushen/pullen die Werte. Bestehende Profile bekommen einen NULL-Wert →
-- _bootstrapLifetimeStats rekonstruiert aus den gepullten Sessions wie
-- bisher und schreibt dann auch in die Cloud.
-- ════════════════════════════════════════════════════════════════════════════

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS lifetime_stats JSONB;

-- Default-NULL ist gewünscht (nicht {}), damit der Bootstrap-Pfad in
-- storage.ts (Z.829: `if (profile.lifetimeStats) return;`) korrekt
-- triggert für Profile die noch nie gesynct wurden.

COMMENT ON COLUMN public.profiles.lifetime_stats IS
  'Lebens-Zähler (Mission "Reise wächst nur"). Wird nur inkrementiert, nie dekrementiert. Beim Sign-In auf neuem Device wird das vom Cloud-Pull restored; bei NULL rechnet _bootstrapLifetimeStats aus den gepullten Sessions.';
