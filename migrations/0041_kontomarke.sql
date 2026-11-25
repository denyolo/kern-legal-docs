-- 0041: Kontomarke, ein Konto, ein Schlüssel (E7-Nachtrag, Nikolaus-Update, 17.11.2026).
--
-- Bisher erkannte KERN den Schlüssel eines Kontos nur an einer Hülle, die gerade zufällig in der Cloud lag.
-- Fehlte sie (nach jedem Leeren, bei neuen Konten bis zum ersten Profil-Upload, bei „Nur auf diesem Gerät“),
-- trat ein Gerät mit einem anderen Schlüssel still bei und lud damit hoch: zwei Schlüssel in einem Konto.
--
-- Neu ist profiles.key_check, die Kontomarke: ein fester Prüftext ohne Inhalt, auf dem Gerät mit dem Schlüssel
-- des Kontos verschlüsselt (k1-Hülle wie alle Inhalte). Der Server kann sie weder lesen noch einem Schlüssel
-- zuordnen. Vor jedem Upload prüft die App, ob ihr Schlüssel die Marke öffnet (services/keyMark.ts, im einen
-- Schreibweg syncEngine._doUpsert).
-- - claim_key_check: Das erste Gerät setzt die Marke, der erste gewinnt. Zurück kommt die Marke, die danach
--   gilt (die eigene oder die eines anderen Geräts). Fehlt die Profil-Zeile, entsteht sie dabei.
-- - reset_key_check: eine neue Marke nur für ein leeres Konto, zusammen mit einem bewussten Leeren mit
--   Weitermachen („Neu anfangen“, „Hier neu anfangen“, „Hier weitermachen“). Löscht die Profil-Zeile und legt
--   sie mit der neuen Marke neu an. Liegt in einer Inhaltstabelle noch eine Zeile, Fehler 55000, nichts
--   geändert (ein später Upload eines abgemeldeten Geräts rutscht so nicht unter die neue Marke).
-- - Beide SECURITY INVOKER: RLS und die Tabellen-Rechte aus 0001 gelten. Die erwartete Kennung (p_expected)
--   muss zur Sitzung gehören (sonst 42501), die Marke muss das k1-Format haben (sonst 22023).
-- - Ein Trigger hält eine gesetzte Marke still fest (kein Fehler: ein Fehler im Client ließe sonst jeden
--   Profil-Upload scheitern). Von NULL auf einen Wert geht, ersetzt wird nur über reset_key_check.
-- - „Nur auf diesem Gerät“ und „Konto löschen“ löschen die Profil-Zeile samt Marke wie bisher, es entsteht
--   keine neue (die App beansprucht nur bei eingeschaltetem Backup).
-- - Unverändert: move_orphan_rows (der UPDATE-Zweig fasst key_check nicht an, der ELSE-Zweig trägt die Marke
--   mit den Zeilen, die sie beschreibt), handle_new_user (neue Zeile ohne Marke), delete-account (CASCADE).
-- - Die Tabellenliste in reset_key_check ist WIPE_TABLES aus services/storageSync.ts ohne profiles: Eine neue
--   Tabelle mit user_id gehört auch hierher (per neuer Migration).
-- - Alte App-Versionen (bis 1.3.1) kennen die Spalte nicht und senden sie nie, ein Upsert setzt nur die
--   mitgeschickten Spalten. Kein Backfill: Bestehende Konten bekommen die Marke beim ersten Upload eines Geräts
--   mit dem Update.
--
-- Prüfen:
--   select column_name from information_schema.columns
--     where table_schema = 'public' and table_name = 'profiles' and column_name = 'key_check';
--   select proname, prosecdef, proconfig, proacl from pg_proc
--     where proname in ('claim_key_check', 'reset_key_check', 'profiles_key_check_once');
--   select tgname, tgenabled from pg_trigger where tgname = 'profiles_key_check_once';
-- Rückweg (nur mit Dennis, vorher in einer abgebrochenen Transaktion prüfen):
--   drop function public.claim_key_check(uuid, text); drop function public.reset_key_check(uuid, text);
--   drop trigger profiles_key_check_once on public.profiles; drop function public.profiles_key_check_once();
--   Danach entsteht keine neue Marke (PGRST202). Gesetzte Marken entscheiden aber weiter (Hochladen, Abgleich,
--   Anmelden). Sind die Marken selbst das Problem, danach eins von beiden, erst nach dem drop trigger (der Trigger
--   hielte sie fest): update public.profiles set key_check = null where key_check is not null; oder
--   alter table public.profiles drop column key_check; (dann 42703, die Prüfregel fällt mit). Zum Schluss
--   notify pgrst, 'reload schema';. Dann verhält sich die App wie bei einem Server ohne 0041: Sie prüft weiter gegen
--   die übrigen Hüllen des Kontos, und ein Konto ohne Hülle nimmt wieder jedes Gerät an.
--
-- Deploy (NICHT db push): supabase db query --linked --file supabase/migrations/0041_kontomarke.sql
-- Vorher in einer abgebrochenen Transaktion geprüft (Probe mit RAISE EXCEPTION), danach sofort der Gerätetest
-- „erster Upload“. Erst dann der erste Build mit dem Fix.

BEGIN;

-- Neue Spalte, Prüfregel und Trigger sperren profiles kurz: nie länger als 5 s darauf warten (sonst warteten
-- Uploads hinter dieser Migration), dann lieber abbrechen und neu versuchen.
SET LOCAL lock_timeout = '5s';

ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS key_check text;

-- Nur NULL oder eine Hülle im Format von ENVELOPE_RE (services/crypto.ts), höchstens 256 Zeichen. Hält
-- Klartext fern, auch wenn ein künftiger Fehler im Client etwas anderes schickte.
ALTER TABLE public.profiles DROP CONSTRAINT IF EXISTS chk_profiles_key_check;
ALTER TABLE public.profiles ADD CONSTRAINT chk_profiles_key_check CHECK (
  key_check IS NULL
  OR (length(key_check) <= 256 AND key_check ~ '^k1:[0-9a-f]{24}:([0-9a-f]{2}){16,}$')
);

COMMENT ON COLUMN public.profiles.key_check IS
  'Kontomarke (0041): verschlüsselter Prüftext ohne Inhalt. Ein Gerät erkennt daran, ob sein Schlüssel zum '
  'Konto passt. Einmal setzbar (claim_key_check), neu nur über reset_key_check bei leerem Konto.';

-- ─── Gesetzt bleibt gesetzt ──────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.profiles_key_check_once()
RETURNS trigger
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
BEGIN
  -- Auch gegen NULL. Kein Fehler: der Rest der Zeile wird wie gewohnt geschrieben.
  IF OLD.key_check IS NOT NULL AND NEW.key_check IS DISTINCT FROM OLD.key_check THEN
    NEW.key_check := OLD.key_check;
  END IF;
  RETURN NEW;
END;
$$;

COMMENT ON FUNCTION public.profiles_key_check_once() IS
  'Hält eine gesetzte Kontomarke fest (0041). Ersetzt wird sie nur über reset_key_check.';

-- Trigger-Funktion: Das Recht wird beim Anlegen des Triggers geprüft, nicht beim Feuern (wie 0032).
REVOKE ALL ON FUNCTION public.profiles_key_check_once() FROM PUBLIC, anon, authenticated;

-- Feuert nur, wenn key_check im SET steht. move_orphan_rows und die Profil-Uploads der App setzen es nie.
DROP TRIGGER IF EXISTS profiles_key_check_once ON public.profiles;
CREATE TRIGGER profiles_key_check_once
  BEFORE UPDATE OF key_check ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.profiles_key_check_once();

-- ─── Marke beanspruchen ──────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.claim_key_check(p_expected uuid, p_check text)
RETURNS text
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_uid uuid := auth.uid();
  v_mark text;
BEGIN
  IF v_uid IS NULL OR p_expected IS NULL OR v_uid <> p_expected THEN
    RAISE EXCEPTION 'claim_key_check: Sitzung gehört nicht zur erwarteten Kennung' USING ERRCODE = '42501';
  END IF;
  IF p_check IS NULL OR length(p_check) > 256 OR p_check !~ '^k1:[0-9a-f]{24}:([0-9a-f]{2}){16,}$' THEN
    RAISE EXCEPTION 'claim_key_check: keine gültige Marke' USING ERRCODE = '22023';
  END IF;

  -- Fehlt die Profil-Zeile (vor dem ersten Profil-Upload, nach einem Leeren), entsteht sie hier.
  INSERT INTO public.profiles (user_id, key_check) VALUES (v_uid, p_check)
    ON CONFLICT (user_id) DO NOTHING;
  -- Nur, solange keine Marke gesetzt ist. Zwei gleichzeitige Aufrufe: Der zweite wartet auf die Zeilensperre
  -- und prüft die Bedingung danach am neuen Stand (READ COMMITTED), er ändert also nichts.
  UPDATE public.profiles SET key_check = p_check
    WHERE user_id = v_uid AND key_check IS NULL;
  SELECT key_check INTO v_mark FROM public.profiles WHERE user_id = v_uid;
  RETURN v_mark;
END;
$$;

COMMENT ON FUNCTION public.claim_key_check(uuid, text) IS
  'Kontomarke beanspruchen (0041): setzt sie nur, wenn noch keine gilt. Gibt die Marke zurück, die danach gilt.';

-- ─── Neue Marke für ein leeres Konto ─────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.reset_key_check(p_expected uuid, p_check text)
RETURNS text
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_uid uuid := auth.uid();
  t text;
  v_found boolean;
BEGIN
  IF v_uid IS NULL OR p_expected IS NULL OR v_uid <> p_expected THEN
    RAISE EXCEPTION 'reset_key_check: Sitzung gehört nicht zur erwarteten Kennung' USING ERRCODE = '42501';
  END IF;
  IF p_check IS NULL OR length(p_check) > 256 OR p_check !~ '^k1:[0-9a-f]{24}:([0-9a-f]{2}){16,}$' THEN
    RAISE EXCEPTION 'reset_key_check: keine gültige Marke' USING ERRCODE = '22023';
  END IF;

  -- WIPE_TABLES aus services/storageSync.ts ohne profiles (RLS: nur die eigenen Zeilen).
  FOREACH t IN ARRAY ARRAY['affirmation_practice_events', 'affirmations', 'article_reads', 'blockade_meta',
                           'conversation_history', 'goals', 'insights', 'life_areas', 'meditation_ratings',
                           'reflections', 'sessions', 'summaries'] LOOP
    EXECUTE format('SELECT EXISTS (SELECT 1 FROM public.%I WHERE user_id = $1)', t) INTO v_found USING v_uid;
    IF v_found THEN
      RAISE EXCEPTION 'reset_key_check: Konto nicht leer (%)', t USING ERRCODE = '55000';
    END IF;
  END LOOP;

  -- In einer Transaktion: kein Moment ohne Marke, die Einstellungen beginnen mit den Standardwerten.
  DELETE FROM public.profiles WHERE user_id = v_uid;
  INSERT INTO public.profiles (user_id, key_check) VALUES (v_uid, p_check);
  RETURN p_check;
END;
$$;

COMMENT ON FUNCTION public.reset_key_check(uuid, text) IS
  'Neue Kontomarke nach einem bewussten Leeren (0041): nur bei leerem Konto (sonst 55000), ersetzt die Profil-Zeile.';

-- Pflicht seit 0029: Rechte ausdrücklich. Nur angemeldete Konten (auch anonyme), nie anon.
REVOKE ALL ON FUNCTION public.claim_key_check(uuid, text) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.reset_key_check(uuid, text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.claim_key_check(uuid, text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.reset_key_check(uuid, text) TO authenticated;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger
    WHERE tgrelid = 'public.profiles'::regclass
      AND tgname = 'profiles_key_check_once' AND tgenabled = 'O'
  ) THEN
    RAISE EXCEPTION '0041: Trigger fehlt nach dem Anlegen - Abbruch';
  END IF;
END $$;

COMMIT;

NOTIFY pgrst, 'reload schema';
