-- 0029: Rechte-Härtung (01.10.2026)
--
-- Befund (Faktencheck Pitch-Briefing, per Metadaten-Abfrage bestätigt):
-- 1) public.increment_usage_counter ist SECURITY DEFINER und für PUBLIC
--    ausführbar ('=X/postgres'). Über die REST-Schnittstelle (/rpc) hätte jeder
--    mit dem öffentlichen Anon-Key die Free-Zähler einer fremden user_id
--    hochzählen können. Aufgerufen wird die Funktion NUR von der Edge Function
--    `mirror` mit dem service_role-Client (Migration 0017) - nie vom Client.
-- 2) Supabase vergibt neuen Tabellen standardmäßig ALLE Rechte an anon und
--    authenticated. SELECT/INSERT/UPDATE/DELETE sind über RLS bzw. frühere
--    REVOKEs geregelt, TRUNCATE / TRIGGER / REFERENCES wurden aber nie entzogen
--    (u.a. auf admin_access_log und app_secrets). Über die REST-Schnittstelle
--    sind sie nicht erreichbar, die App braucht sie nie - Verteidigung in der
--    Tiefe, und das Audit-Protokoll ist ein Vertrauensversprechen.
--
-- Deploy wie immer: supabase db query --linked --file supabase/migrations/0029_harden_grants.sql
-- (NICHT db push - Remote-Migrationshistorie ist leer, s. CLAUDE.md Tag 42).

-- 1) Zähler-Funktion nur noch für den Server
REVOKE EXECUTE ON FUNCTION public.increment_usage_counter(uuid, text, text, integer) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.increment_usage_counter(uuid, text, text, integer) FROM anon, authenticated;
GRANT  EXECUTE ON FUNCTION public.increment_usage_counter(uuid, text, text, integer) TO service_role;

-- 2) Unnötige Tabellen-Rechte der App-Rollen entziehen (bestehende Tabellen + Views)
-- (MAINTAIN = neues Postgres-17-Recht: VACUUM/ANALYZE/REINDEX/LOCK - ebenfalls nie gebraucht)
REVOKE TRUNCATE, TRIGGER, REFERENCES, MAINTAIN ON ALL TABLES IN SCHEMA public FROM anon, authenticated;

-- 3) ... und für künftig von postgres angelegte Tabellen gar nicht erst vergeben
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
  REVOKE TRUNCATE, TRIGGER, REFERENCES, MAINTAIN ON TABLES FROM anon, authenticated;

-- 4) Neue Funktionen nicht mehr automatisch für alle ausführbar (so entstand die
--    Lücke bei 0017). Funktionen, die die App aufrufen soll (z.B. log_usage_event),
--    bekommen ihr Recht ausdrücklich per GRANT - wie bisher schon.
ALTER DEFAULT PRIVILEGES FOR ROLE postgres
  REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;
