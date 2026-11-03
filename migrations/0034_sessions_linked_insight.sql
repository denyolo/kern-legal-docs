-- 0034: Gedanke ↔ Erkenntnis auch in der Cloud (31.10.2026)
--
-- Ein Gedanke (Session type=thought) gehört über linkedInsightId zu einer Erkenntnis. Das
-- Feld ging nie in die Cloud: Nach Abmelden oder Neuinstallation standen die Gedanken nicht
-- mehr unter ihrer Erkenntnis und wurden beim Löschen nicht mitgelöscht.
--
-- Nur eine Kennung, kein Inhalt, deshalb Klartext (nicht in ENCRYPTED_FIELDS).
-- TEXT und ohne Fremdschlüssel: Gedanke und Erkenntnis gehen unabhängig hoch, ein
-- Fremdschlüssel lehnte den Gedanken ab, solange die Erkenntnis noch fehlt.
-- Ältere App-Versionen senden die Spalte nicht und lassen sie unverändert.
--
-- Deploy VOR jedem Build, der sie sendet:
-- supabase db query --linked --file supabase/migrations/0034_sessions_linked_insight.sql

ALTER TABLE public.sessions
  ADD COLUMN IF NOT EXISTS linked_insight_id TEXT;
