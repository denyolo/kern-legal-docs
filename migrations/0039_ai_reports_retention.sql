-- 0039: Löschfrist für gemeldete KI-Antworten (App-Version 1.3.0): automatisch nach 12 Monaten.
--
-- Die Datenschutzerklärung (Abschnitt 2.e und 6) sagt: Meldungen werden nach 12 Monaten
-- gelöscht, automatisch. Dafür läuft jede Nacht ein Zeitplaner-Job der Datenbank (pg_cron,
-- Standard-Erweiterung von Supabase, kein neuer Dienst). Er löscht NUR in ai_reports und nur
-- nach Alter der einzelnen Meldung (created_at), keine anderen Tabellen, keine Konten.
--
-- Prüfen:   select jobname, schedule, command, active from cron.job;
-- Läufe:    select status, start_time, return_message from cron.job_run_details order by start_time desc limit 5;
-- Abschalten: select cron.unschedule('ai-reports-loeschfrist');
--
-- Deploy (NICHT db push): supabase db query --linked --file <diese Datei>
-- Vorher in einer abgebrochenen Transaktion geprüft (Probe mit RAISE EXCEPTION).

BEGIN;

CREATE EXTENSION IF NOT EXISTS pg_cron WITH SCHEMA pg_catalog;
GRANT USAGE ON SCHEMA cron TO postgres;

SELECT cron.schedule(
  'ai-reports-loeschfrist',
  '17 3 * * *',
  $$DELETE FROM public.ai_reports WHERE created_at < now() - interval '12 months'$$
);

COMMIT;
