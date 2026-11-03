-- 0031: blockade_meta.type erlaubt wieder 'safety' (Angst & Stress)
--
-- Befund 28.10.2026: Auf kern-prod fehlte 'safety' im CHECK
--   blockade_meta_type_check = ('identity','energy','pattern','integration','other')
-- obwohl 0001_init.sql 'safety' enthält (Drift: die Live-Tabelle wurde damals
-- per SQL-Editor angelegt, nicht aus dieser Datei). Die KI ordnet Angst-/Stress-
-- Blockaden als 'safety' ein (services/mirror.ts), und syncMapper hält 'safety'
-- für gültig (constants/blockadeTypes.ts ALL_BLOCKADE_TYPES) - jeder Push einer
-- solchen Blockaden-Zusatzinfo (Beschreibung, Reflexionsfragen, aufgelöst/
-- verborgen) wurde deshalb seit Mai mit 23514 abgelehnt, still.
--
-- Rein lockernd: ein erlaubter Wert mehr, keine bestehende Zeile wird ungültig.
-- Die App lädt die fehlenden Zeilen beim nächsten Öffnen selbst hoch
-- (Foreground-Resync → storageSync.profile → blockade_meta).
--
-- Deploy: supabase db query --linked --file supabase/migrations/0031_blockade_meta_type_safety.sql
-- (NICHT db push, s. CLAUDE.md Tag 42)

BEGIN;

ALTER TABLE public.blockade_meta DROP CONSTRAINT IF EXISTS blockade_meta_type_check;
ALTER TABLE public.blockade_meta ADD CONSTRAINT blockade_meta_type_check
  CHECK (type IN ('identity', 'energy', 'pattern', 'integration', 'safety', 'other'));

COMMIT;
