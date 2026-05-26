-- ════════════════════════════════════════════════════════════════════════════
-- Migration 0009: linked_blockade / linked_area auf sessions + insights
--                 + blockade_meta Status-Felder (resolved/hidden/etc.)
--
-- Bug-Diagnose (Tag 20, Mai 25, 2026):
--   Lokal speichert die App auf Sessions UND Insights jeweils einen
--   linkedBlockade- und linkedArea-Text (welche Blockade/welcher Bereich
--   wurde reflektiert/integriert). Aber: die Cloud-Tabellen `sessions` und
--   `insights` haben diese Spalten nie bekommen → mapSessionToRow und
--   mapInsightToRow mappen sie auch nicht.
--   Folge: nach Sign-Out/Re-Sign-In sind alle gepullten Sessions/Insights
--   ohne Blockaden-Verknüpfung. Symptom:
--     a) Home-CTA "Vertiefe eine Blockade" zeigt bereits vertiefte Blockaden
--        weiter, weil reflectedBlockades-Set leer ist
--     b) Insight-Card im Lebensbereich-Detail kennt seinen Bereich nicht
--     c) Vertieft-Badge im Reflexion-Hub erkennt nichts
--
--   Plus: BlockadeMeta-Status-Felder (resolved, resolvedAt, hidden,
--   highFeelingCount, autoResolvePromptShown) werden lokal genutzt aber
--   auch nicht in der Cloud persistiert. Folge: Auflösungs-Status, Hidden-
--   Toggle und Auto-Resolve-Prompt-Memory gehen bei Re-Sign-In verloren.
--
-- Mapper- und Pull-Updates kommen parallel in syncMapper.ts und
-- storageSync.ts. Diese Migration ist die Schema-Voraussetzung.
--
-- Idempotent: ADD COLUMN IF NOT EXISTS (Postgres 9.6+).
-- ════════════════════════════════════════════════════════════════════════════

-- sessions: linked_blockade + linked_area
ALTER TABLE public.sessions
  ADD COLUMN IF NOT EXISTS linked_blockade TEXT,
  ADD COLUMN IF NOT EXISTS linked_area     TEXT;

COMMENT ON COLUMN public.sessions.linked_blockade IS
  'Blockaden-Text (free-form) zu der die Session gehört. Z.B. die vertiefte Blockade einer reflection-Session. Nullable.';
COMMENT ON COLUMN public.sessions.linked_area IS
  'Lebensbereich-Name (free-form) zu dem die Session gehört. Z.B. der Bereich-Kontext einer freien Reflexion. Nullable.';

-- insights: linked_blockade + linked_area
ALTER TABLE public.insights
  ADD COLUMN IF NOT EXISTS linked_blockade TEXT,
  ADD COLUMN IF NOT EXISTS linked_area     TEXT;

COMMENT ON COLUMN public.insights.linked_blockade IS
  'Blockaden-Text zu der die Erkenntnis gehört. Wird beim KI-Synthese-JSON via linkedBlockadeSuggestion gefüllt oder manuell vom User gesetzt. Nullable.';
COMMENT ON COLUMN public.insights.linked_area IS
  'Lebensbereich-Name zu dem die Erkenntnis gehört. Analog zu linked_blockade. Nullable.';

-- blockade_meta: Status-Felder
ALTER TABLE public.blockade_meta
  ADD COLUMN IF NOT EXISTS resolved                   BOOLEAN,
  ADD COLUMN IF NOT EXISTS resolved_at                TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS hidden                     BOOLEAN,
  ADD COLUMN IF NOT EXISTS high_feeling_count         INTEGER,
  ADD COLUMN IF NOT EXISTS auto_resolve_prompt_shown  BOOLEAN;

COMMENT ON COLUMN public.blockade_meta.resolved IS
  'User hat die Blockade als nicht mehr aktiv markiert (Auflösungs-Mechanik seit Mai 15).';
COMMENT ON COLUMN public.blockade_meta.resolved_at IS
  'Datum der Auflösung (für Reaktivierung + Archiv).';
COMMENT ON COLUMN public.blockade_meta.hidden IS
  'Verbergen-Flag — aus aktiver Anzeige verborgen, Daten bleiben. Reversibel.';
COMMENT ON COLUMN public.blockade_meta.high_feeling_count IS
  'Zählt wie oft die User-Erinnerung mit Feeling-Score ≥9 bewertet wurde. Bei 5+ fragt App "Möchtest du auflösen?" einmalig.';
COMMENT ON COLUMN public.blockade_meta.auto_resolve_prompt_shown IS
  'True wenn der Auto-Resolve-Dialog schon einmal erschienen ist (damit er nicht wiederkommt).';
