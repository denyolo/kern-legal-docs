-- ════════════════════════════════════════════════════════════════════════════
-- Migration 0012: Verbergen-IDs für Journal-Einträge in profiles (Tag 32)
--
-- Vorher: profile.hiddenJournalIds (IDs von Meditationen/Reflexionen/
-- Integrationen, die der User aus dem Verlauf verborgen hat) lebte nur lokal
-- in AsyncStorage. mapProfileToRow synct es nicht → nach Sign-Out + Re-Login
-- kamen ALLE verborgenen Einträge zurück (app-weiter Verbergen-Bug).
--
-- Fix: hidden_journal_ids als TEXT[] in profiles. mapProfileToRow +
-- pullFromCloud pushen/pullen die IDs. Bestehende Profile bekommen '{}'.
--
-- Hinweis: Erkenntnisse + Gedanken nutzen KEIN Verbergen mehr (Tag 32: echtes
-- Löschen lokal + Cloud via deleteInsight/deleteAffirmation). Diese Spalte
-- betrifft nur den Journal-Soft-Hide für Aktivitäts-Belege (Sessions/Affirms),
-- deren Stats über lifetimeStats erhalten bleiben ("Reise schrumpft nie").
-- ════════════════════════════════════════════════════════════════════════════

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS hidden_journal_ids TEXT[] NOT NULL DEFAULT '{}';

COMMENT ON COLUMN public.profiles.hidden_journal_ids IS
  'IDs von Journal-Einträgen (Sessions/Affirmationen), die der User aus dem Verlauf verborgen hat (Soft-Hide). Stats bleiben unangetastet. Tag 32.';
