-- 0040: Bei der Anmeldung mit Google speichert KERN weder Namen noch Bild (Android, 15.11.2026).
--
-- Googles Anmelde-Token enthält immer Name und Profilbild. Supabase legt es beim Verknüpfen in
-- auth.identities.identity_data ab und bei jeder Anmeldung mit Google zusätzlich in
-- auth.users.raw_user_meta_data. Die Datenschutzerklärung sagt: „Deinen Namen speichern wir nicht.“
-- Deshalb entfernen zwei Trigger diese Angaben, bevor eine Zeile gespeichert wird:
--   name, full_name, given_name, family_name, picture, avatar_url.
-- E-Mail-Adresse und Google-Kennung (sub) bleiben: Über die Kennung findet die Anmeldung das Konto wieder,
-- über die E-Mail verknüpft Supabase Konten mit derselben bestätigten Adresse.
--
-- - Nur Google: auth.identities mit provider = 'google', auth.users nur, wenn Google unter den
--   Anbietern des Kontos steht (raw_app_meta_data). Apple-Anmeldungen bleiben unberührt.
-- - Ein Fehler in einem Trigger auf auth.* würde jede Anmeldung blockieren, auch am iPhone. Deshalb
--   fangen beide Funktionen jeden eigenen Fehler ab und lassen die Zeile dann unverändert durch.
-- - Die Funktionen ändern nur die Zeile, die gerade gespeichert wird, lesen und schreiben keine
--   Tabelle (SECURITY INVOKER, leerer search_path).
--
-- Prüfen:  select tgname, tgrelid::regclass, tgenabled from pg_trigger where tgname = 'kern_google_ohne_name_bild';
-- Abschalten (nur zusammen mit der Datenschutzerklärung):
--   drop trigger kern_google_ohne_name_bild on auth.identities;
--   drop trigger kern_google_ohne_name_bild on auth.users;
--
-- Deploy (NICHT db push): supabase db query --linked --file <diese Datei>
-- Vorher in einer abgebrochenen Transaktion geprüft (Probe mit RAISE EXCEPTION), danach sofort die
-- Anmeldung am iPhone geprüft.

BEGIN;

-- Die Trigger brauchen kurz eine Sperre auf auth.users und auth.identities: nie länger als 5 s auf sie
-- warten (sonst warteten Anmeldungen hinter dieser Migration), dann lieber abbrechen und neu versuchen.
SET LOCAL lock_timeout = '5s';

CREATE OR REPLACE FUNCTION public.kern_google_identitaet_ohne_name_bild()
RETURNS trigger
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
BEGIN
  BEGIN
    IF NEW.provider = 'google' AND jsonb_typeof(NEW.identity_data) = 'object' THEN
      NEW.identity_data := NEW.identity_data
        - ARRAY['name', 'full_name', 'given_name', 'family_name', 'picture', 'avatar_url']::text[];
    END IF;
  EXCEPTION WHEN OTHERS THEN
    -- Nie eine Anmeldung blockieren: die Zeile unverändert durchlassen.
    RAISE WARNING 'kern_google_identitaet_ohne_name_bild: %', SQLSTATE;
  END;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.kern_google_konto_ohne_name_bild()
RETURNS trigger
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
BEGIN
  BEGIN
    IF jsonb_typeof(NEW.raw_user_meta_data) = 'object'
       AND jsonb_typeof(NEW.raw_app_meta_data) = 'object'
       AND (
         NEW.raw_app_meta_data ->> 'provider' = 'google'
         OR (jsonb_typeof(NEW.raw_app_meta_data -> 'providers') = 'array'
             AND (NEW.raw_app_meta_data -> 'providers') ? 'google')
       ) THEN
      NEW.raw_user_meta_data := NEW.raw_user_meta_data
        - ARRAY['name', 'full_name', 'given_name', 'family_name', 'picture', 'avatar_url']::text[];
    END IF;
  EXCEPTION WHEN OTHERS THEN
    -- Nie eine Anmeldung blockieren: die Zeile unverändert durchlassen.
    RAISE WARNING 'kern_google_konto_ohne_name_bild: %', SQLSTATE;
  END;
  RETURN NEW;
END;
$$;

COMMENT ON FUNCTION public.kern_google_identitaet_ohne_name_bild() IS
  'Entfernt Name und Bild aus Google-Identitäten (auth.identities), bevor sie gespeichert werden. Migration 0040.';
COMMENT ON FUNCTION public.kern_google_konto_ohne_name_bild() IS
  'Entfernt Name und Bild aus den Konto-Angaben (auth.users) von Konten mit Google, bevor sie gespeichert werden. Migration 0040.';

-- Nur die Anmeldung (supabase_auth_admin) führt sie aus, nie ein Client.
REVOKE ALL ON FUNCTION public.kern_google_identitaet_ohne_name_bild() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.kern_google_konto_ohne_name_bild() FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.kern_google_identitaet_ohne_name_bild() TO supabase_auth_admin;
GRANT EXECUTE ON FUNCTION public.kern_google_konto_ohne_name_bild() TO supabase_auth_admin;

-- auth.identities: beim Anlegen und wenn sich die Angaben ändern (jede Anmeldung schreibt sie neu).
CREATE TRIGGER kern_google_ohne_name_bild
  BEFORE INSERT OR UPDATE OF identity_data, provider ON auth.identities
  FOR EACH ROW EXECUTE FUNCTION public.kern_google_identitaet_ohne_name_bild();

-- auth.users: auch wenn nur die Anbieter-Liste neu geschrieben wird (verknüpft Supabase Google über
-- dieselbe E-Mail mit einem bestehenden Konto, schreibt es die Angaben vor der Anbieter-Liste).
CREATE TRIGGER kern_google_ohne_name_bild
  BEFORE INSERT OR UPDATE OF raw_user_meta_data, raw_app_meta_data ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.kern_google_konto_ohne_name_bild();

COMMIT;
