-- ════════════════════════════════════════════════════════════════════════════
-- Migration 0014 — goals.gefuehl: 0 erlauben ("noch nicht selbst eingeschätzt")
-- ════════════════════════════════════════════════════════════════════════════
-- Das Onboarding legt Ziele mit gefuehl=0 an (= "noch nicht selbst eingeschätzt";
-- der User setzt den Wert später aktiv im Manifestation-Tab). Die ursprüngliche
-- CHECK-Constraint erlaubte aber nur 1..10 → JEDER Onboarding-Goal-Push wurde mit
-- Fehler 23514 (check_violation, "goals_gefuehl_check") still abgelehnt → frisch
-- onboardete, noch unbewertete Ziele synchronisierten NIE in die Cloud und gingen
-- bei Reinstall / Sign-Out verloren. 0 ist ein legitimer App-Zustand →
-- Constraint auf 0..10 erweitern.
--
-- Deploy: supabase db push  (oder im SQL-Editor ausführen).

ALTER TABLE public.goals DROP CONSTRAINT IF EXISTS goals_gefuehl_check;
ALTER TABLE public.goals ADD CONSTRAINT goals_gefuehl_check CHECK (gefuehl BETWEEN 0 AND 10);
