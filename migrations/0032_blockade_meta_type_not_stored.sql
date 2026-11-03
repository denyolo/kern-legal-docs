-- 0032: blockade_meta.type wird nicht mehr gespeichert (Datenminimierung)
--
-- Entscheidung Dennis 28./29.10.2026 (Datenschutz-Runde): Die KI-Einordnung einer
-- Blockade (identity/energy/pattern/integration/safety/other) lag als Klartext in
-- blockade_meta.type. Verschlüsseln wurde verworfen (AES-GCM erhält die Länge, bei
-- sechs festen Wörtern verrät die Chiffre den Wert; alte App-Versionen schreiben
-- weiter Klartext). Die Art liegt zusätzlich E2E-verschlüsselt in
-- profiles.blockade_types, alle App-Leser haben den Rückfall
-- meta?.type || blockadeTypes[b] (seit Mai/Juni 2026).
--
-- Lösung: BEFORE INSERT OR UPDATE-Trigger setzt NEW.type auf NULL. Wirkt sofort für
-- ALLE App-Versionen, die type mitsenden (Stand 29.10.2026: alle bis einschließlich 1.2.6), ohne deren
-- Upserts scheitern zu lassen (ein Spalten-REVOKE würde jeden blockade_meta-Upsert
-- jeder Version, die type mitsendet, mit 42501 abbrechen, ein DROP COLUMN mit PGRST204).
--
-- Upsert-Pfad der App (syncEngine._doUpsert, onConflict 'id'):
--   INSERT ... ON CONFLICT (id) DO UPDATE SET type = EXCLUDED.type, ...
-- BEFORE INSERT läuft für jede vorgeschlagene Zeile, EXCLUDED.type ist danach schon
-- NULL. Im Konflikt-Zweig läuft zusätzlich BEFORE UPDATE. Beide Wege abgedeckt.
-- Der CHECK wird NACH den BEFORE-Triggern geprüft, NULL erfüllt ihn.
-- Sendet eine App-Version den Schlüssel type gar nicht (geplant ab 1.2.7), steht type
-- nicht im SET. BEFORE UPDATE feuert trotzdem, weil NEW.type dann den alten Wert trägt
-- (WHEN-Bedingung), und leert ihn beim nächsten Upload dieser Zeile.
--
-- 🚨 Spalte und CHECK bleiben bestehen: Alle App-Versionen bis einschließlich 1.2.6 senden
-- den Schlüssel type mit (services/syncMapper.ts mapBlockadeMetaToRow, Git-Tag
-- ios-1.2.6-336). Auch type: null zählt - schon der Schlüssel lässt jeden Upsert nach
-- einem DROP COLUMN mit PGRST204 scheitern. Geplant ist, dass die App ab 1.2.7 den
-- Schlüssel weglässt. DROP COLUMN erst, wenn eine Store-Version den Schlüssel gar nicht
-- mehr sendet UND keine ältere mehr im Umlauf ist. Vorher DROP TRIGGER
-- blockade_meta_strip_type und DROP FUNCTION public.blockade_meta_strip_type(): Die
-- WHEN-Bedingung des Triggers hängt an type, ohne das bricht DROP COLUMN ab. Wird je
-- eine Sicherung von vor dieser Migration zurückgespielt, fehlt der Trigger: dann
-- diese Datei und das einmalige Leeren (siehe internes Protokoll) erneut ausführen.
--
-- Rechte: SECURITY INVOKER (die Funktion fasst keine Tabelle an, DEFINER wäre
-- unnötige Rechte-Ausweitung). EXECUTE wird beim CREATE TRIGGER geprüft (Ersteller
-- postgres = Eigentümer), nicht beim Feuern. Die App-Rollen brauchen also kein
-- Recht, deshalb REVOKE wie in 0029 (Default-ACL für neue Funktionen ist ohnehin
-- {postgres=X}).
--
-- Deploy: supabase db query --linked --file supabase/migrations/0032_blockade_meta_type_not_stored.sql
-- (NICHT db push, s. CLAUDE.md Tag 42; nie parallel zu anderen supabase db-Aufrufen)
-- Notfall-Rückweg (sofort wirksam): DROP TRIGGER IF EXISTS blockade_meta_strip_type ON public.blockade_meta;

BEGIN;

-- Lieber sauber abbrechen als App-Schreibzugriffe hinter dem Lock stauen.
SET LOCAL lock_timeout = '5s';

CREATE OR REPLACE FUNCTION public.blockade_meta_strip_type()
RETURNS trigger
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
BEGIN
  NEW.type := NULL;
  RETURN NEW;
END;
$$;

COMMENT ON FUNCTION public.blockade_meta_strip_type() IS
  '0032: blockade_meta.type wird nie gespeichert. Die Art liegt E2E-verschlüsselt in profiles.blockade_types.';

REVOKE EXECUTE ON FUNCTION public.blockade_meta_strip_type() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.blockade_meta_strip_type() FROM anon, authenticated, service_role;

DROP TRIGGER IF EXISTS blockade_meta_strip_type ON public.blockade_meta;
CREATE TRIGGER blockade_meta_strip_type
  BEFORE INSERT OR UPDATE ON public.blockade_meta
  FOR EACH ROW
  WHEN (NEW.type IS NOT NULL)
  EXECUTE FUNCTION public.blockade_meta_strip_type();

COMMENT ON COLUMN public.blockade_meta.type IS
  'Seit 0032 immer NULL (Trigger blockade_meta_strip_type). Die Art liegt E2E-verschlüsselt in profiles.blockade_types. Spalte bleibt, solange eine App-Version den Schlüssel type mitsendet, auch als null (Stand 29.10.2026: alle Versionen bis einschließlich 1.2.6).';

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger
    WHERE tgrelid = 'public.blockade_meta'::regclass
      AND tgname = 'blockade_meta_strip_type' AND tgenabled = 'O'
  ) THEN
    RAISE EXCEPTION '0032: Trigger fehlt nach dem Anlegen - Abbruch';
  END IF;
END $$;

COMMIT;
