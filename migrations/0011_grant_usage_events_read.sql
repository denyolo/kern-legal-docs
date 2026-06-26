-- ============================================================================
-- KERN — service_role darf usage_events lesen (Tag 30)
-- ============================================================================
--
-- usage_events hat RLS aktiviert + KEINE SELECT-Policy (Migration 0005).
-- service_role umgeht zwar RLS, braucht aber trotzdem das table-level
-- SELECT-GRANT (eine separate Postgres-Privileg-Ebene). Ohne diesen GRANT
-- schlägt jeder Server-seitige Lese-Zugriff fehl mit:
--   "permission denied for table usage_events [42501]"
--
-- Betrifft: die beta-dashboard Edge Function, die usage_events mit
-- service_role liest. (Der Schreib-Pfad log_usage_event läuft als
-- SECURITY DEFINER und war davon nie betroffen.)
--
-- 🔒 NUR service_role (Server). anon + authenticated (= die App-User)
--    bekommen bewusst KEIN Leserecht — die anonymen Aggregate bleiben
--    für normale User unzugänglich. Privacy unverändert.
-- ============================================================================

GRANT SELECT ON public.usage_events TO service_role;
