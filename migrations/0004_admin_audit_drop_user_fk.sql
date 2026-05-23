-- ============================================================================
-- KERN — Admin Audit Schema-Fix (Sprint #25 Patch, Tag 13)
-- ============================================================================
--
-- Bug-Fix für 0002_admin_audit.sql:
--
-- Das FK `accessed_user_id REFERENCES auth.users(id)` blockte Audit-Einträge
-- für UUIDs, die noch nicht in auth.users existieren. Das ist semantisch
-- falsch: der Audit-Trail soll auch Zugriffe auf falsche/gelöschte/nicht-
-- existierende User-IDs protokollieren — gerade die sind forensisch wichtig
-- (jemand versucht eine UUID zu inspizieren, die er erraten hat).
--
-- Außerdem würde ON DELETE SET NULL beim DSGVO-Löschen den Eintrag
-- anonymisieren — aber das wollen wir bei jedem Insert ohnehin schon
-- entkoppeln.
--
-- Fix: FK droppen. Die accessed_user_id bleibt UUID-Spalte ohne Referenz.
-- Logs sind dann unabhängig vom auth.users-Lifecycle.
-- ============================================================================

ALTER TABLE public.admin_access_log
  DROP CONSTRAINT IF EXISTS admin_access_log_accessed_user_id_fkey;
