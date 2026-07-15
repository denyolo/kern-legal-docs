-- ════════════════════════════════════════════════════════════════════════════
-- Migration 0018 — premium_status.last_event_ms (RevenueCat-Event-Ordering)
-- ════════════════════════════════════════════════════════════════════════════
-- Der revenuecat-webhook wendet Events nur an, wenn ihr event_timestamp_ms >=
-- dem zuletzt verarbeiteten Stand ist (RevenueCat garantiert KEINE Reihenfolge;
-- Retries können umsortieren). Ohne diesen Guard würde ein verspätetes/älteres
-- EXPIRATION einen aktiven Zahler auf Free stranden; MIT einer nur ablaufzeit-
-- basierten Variante würde umgekehrt ein Refund nie greifen. Der Vergleich über
-- den Event-Zeitstempel löst beides korrekt — braucht aber diese Spalte, um den
-- zuletzt verarbeiteten Zeitstempel zu speichern.
--
-- service_role hat bereits SELECT/INSERT/UPDATE auf premium_status (Migration
-- 0016, table-level → deckt neue Spalten mit ab) → kein zusätzlicher GRANT nötig.
--
-- Deploy (NICHT db push — Remote-Historie ist leer, s. CLAUDE.md Tag-42):
--   supabase db query --linked --file supabase/migrations/0018_premium_status_last_event_ms.sql

ALTER TABLE public.premium_status
  ADD COLUMN IF NOT EXISTS last_event_ms BIGINT;
