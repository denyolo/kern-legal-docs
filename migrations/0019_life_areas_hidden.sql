-- ============================================================================
-- Migration 0019 (Tag 54): life_areas.hidden
-- ============================================================================
-- Der `hidden`-Flag von Lebensbereichen wurde bisher NUR lokal gehalten:
-- mapLifeAreaToRow() ließ ihn weg + die Tabelle hatte keine Spalte. Folge:
-- ein lokal verborgener Bereich kam nach Sign-Out/Sign-In als AKTIV zurück
-- (pullFromCloud rekonstruierte ihn ohne hidden). Analog zu blockade_meta.hidden
-- (Migration 0009). DEFAULT false = Bestands-Bereiche bleiben sichtbar (korrekt).
--
-- Deploy: supabase db query --linked --file supabase/migrations/0019_life_areas_hidden.sql
-- (NICHT db push — Remote-schema_migrations-Historie ist leer, s. CLAUDE.md Tag 42.)
-- ============================================================================

ALTER TABLE public.life_areas
  ADD COLUMN IF NOT EXISTS hidden BOOLEAN NOT NULL DEFAULT false;
