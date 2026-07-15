-- ============================================================================
-- Migration 0020 (Tag 54): goals.hidden
-- ============================================================================
-- Analog zu 0019 (life_areas.hidden): `Goal.hidden` (Swipe-to-Hide, ≠ status
-- 'archived') wurde nur lokal gehalten — mapGoalToRow synct `status`, aber NICHT
-- `hidden`, und die Tabelle hatte keine Spalte. Folge: ein lokal verborgenes Ziel
-- kam nach Sign-Out/Sign-In als sichtbar zurück (gleiche Bug-Klasse wie
-- life_areas). DEFAULT false = Bestands-Ziele bleiben sichtbar (korrekt).
--
-- Deploy: supabase db query --linked --file supabase/migrations/0020_goals_hidden.sql
-- (Reihenfolge: 0019 + 0020 BEIDE vor dem App-Build.)
-- ============================================================================

ALTER TABLE public.goals
  ADD COLUMN IF NOT EXISTS hidden BOOLEAN NOT NULL DEFAULT false;
