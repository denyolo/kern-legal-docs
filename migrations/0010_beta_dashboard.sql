-- ============================================================================
-- KERN — Beta-Dashboard (Tag 30, 07.06.2026)
-- ============================================================================
--
-- Bequeme, SICHERE Aggregat-Views für die Beta-Auswertung. Owner (Dennis)
-- ruft `SELECT * FROM kern_beta_*;` im SQL-Editor — statt im Table-Editor zu
-- browsen, wo man versehentlich eine Inhalts-Tabelle öffnen würde.
--
-- 🔒 HARTE SICHERHEITS-EIGENSCHAFT:
--    JEDE View hier liest AUSSCHLIESSLICH aus `public.usage_events`.
--    Keine Joins, keine Inhalts-Tabelle (reflections/insights/sessions/
--    profiles/conversation_history/…) wird je berührt. usage_events enthält
--    nur Zahlen, Enums und eine GEHASHTE user_id (Salt nur in DB) — niemals
--    Inhalte. Diese Views auszuwerten ist KEIN Inhalts-Zugriff und erzeugt
--    daher KEINEN admin_access_log-Eintrag. Das „Audit-Log bleibt leer"-
--    Versprechen an die Tester bleibt intakt.
--
-- Anonymität: `user_id_hashed` = SHA-256(user_id || salt). Man sieht die
--    Aktivität PRO anonymem Hash ("ein Tester machte 5 Reflexionen"), kann
--    aber NIE auf eine Person zurückschließen (Salt verlässt die DB nie).
--
-- Einspielen: Supabase → SQL Editor → diesen Datei-Inhalt einfügen → Run.
--    Idempotent (CREATE OR REPLACE), reine Views, keine Daten betroffen.
-- ============================================================================


-- ─── 1) Gesamt-Puls: ein Blick, lebt die Telemetrie überhaupt? ──────────────
CREATE OR REPLACE VIEW public.kern_beta_overview AS
  SELECT
    event_type,
    COUNT(*)                       AS events,
    COUNT(DISTINCT user_id_hashed) AS unique_users,
    MIN(occurred_at)               AS first_event,
    MAX(occurred_at)               AS last_event
  FROM public.usage_events
  GROUP BY event_type
  ORDER BY events DESC;

COMMENT ON VIEW public.kern_beta_overview IS
  'Beta-Dashboard: Events + unique (gehashte) User pro Event-Typ. Health-Check.';


-- ─── 2) Aktivität pro anonymem Tester: wer ist aktiv, wer Karteileiche? ─────
-- Beantwortet "wie viele Sessions hat jemand gemacht" — pro Hash, nie pro Name.
CREATE OR REPLACE VIEW public.kern_beta_activity_per_user AS
  SELECT
    user_id_hashed,
    BOOL_OR(event_type = 'onboarding_completed')                AS onboarded,
    COUNT(*) FILTER (WHERE event_type = 'reflection_completed') AS reflections_done,
    COUNT(*) FILTER (WHERE event_type = 'reflection_aborted')   AS reflections_aborted,
    COUNT(*) FILTER (WHERE event_type = 'meditation_completed') AS meditations,
    COUNT(*) FILTER (WHERE event_type = 'affirmation_generated') AS integrations,
    COUNT(*) FILTER (WHERE event_type = 'app_session')          AS app_opens,
    COUNT(*)                                                    AS total_events,
    MIN(occurred_at)                                            AS first_seen,
    MAX(occurred_at)                                            AS last_seen
  FROM public.usage_events
  WHERE user_id_hashed IS NOT NULL
  GROUP BY user_id_hashed
  ORDER BY last_seen DESC;

COMMENT ON VIEW public.kern_beta_activity_per_user IS
  'Beta-Dashboard: Aktivitäts-Profil pro anonymem Hash. Anonym — keine Person zuordenbar.';


-- ─── 3) Reflexions-Funnel pro Modus: wie viele kommen durch? ────────────────
CREATE OR REPLACE VIEW public.kern_beta_reflection_funnel AS
  SELECT
    category AS mode,
    (COUNT(*) FILTER (WHERE event_type = 'reflection_completed')) AS completed,
    (COUNT(*) FILTER (WHERE event_type = 'reflection_aborted'))   AS aborted,
    ROUND(
      100.0 * (COUNT(*) FILTER (WHERE event_type = 'reflection_completed'))
      / NULLIF(COUNT(*) FILTER (WHERE event_type IN ('reflection_completed','reflection_aborted')), 0)
    , 1) AS completion_pct,
    (AVG(numeric_1) FILTER (WHERE event_type = 'reflection_completed'))::INT AS avg_chars,
    (AVG(numeric_2) FILTER (WHERE event_type = 'reflection_completed'))::INT AS avg_turns,
    (AVG(numeric_3) FILTER (WHERE event_type = 'reflection_completed'))::INT AS avg_duration_sec
  FROM public.usage_events
  WHERE event_type IN ('reflection_completed','reflection_aborted')
  GROUP BY category
  ORDER BY (completed + aborted) DESC;

COMMENT ON VIEW public.kern_beta_reflection_funnel IS
  'Beta-Dashboard: completed vs aborted + Abschluss-Quote + Ø Zeichen/Züge/Dauer pro Reflexions-Modus.';


-- ─── 4) Abbruch-Punkte: WO steigen Leute aus? ──────────────────────────────
-- Beantwortet "wann hat er abgebrochen" — bei welcher Frage (1–4).
CREATE OR REPLACE VIEW public.kern_beta_reflection_abort_points AS
  SELECT
    category           AS mode,
    numeric_2          AS aborted_at_question,
    COUNT(*)           AS aborts,
    (AVG(numeric_1))::INT AS avg_chars_written
  FROM public.usage_events
  WHERE event_type = 'reflection_aborted'
  GROUP BY category, numeric_2
  ORDER BY mode, aborted_at_question;

COMMENT ON VIEW public.kern_beta_reflection_abort_points IS
  'Beta-Dashboard: Abbruch-Heatmap — bei welcher Frage steigen User aus, mit Ø geschriebenen Zeichen.';


-- ─── 5) Onboarding: First-Impression-Funnel ────────────────────────────────
CREATE OR REPLACE VIEW public.kern_beta_onboarding AS
  SELECT
    COUNT(*)                       AS completed_onboardings,
    COUNT(DISTINCT user_id_hashed) AS unique_users,
    (AVG(numeric_1))::INT          AS avg_duration_sec,
    ROUND(AVG(numeric_2), 1)       AS avg_life_areas,
    ROUND(AVG(numeric_3), 1)       AS avg_blockades
  FROM public.usage_events
  WHERE event_type = 'onboarding_completed';

COMMENT ON VIEW public.kern_beta_onboarding IS
  'Beta-Dashboard: Onboarding-Abschlüsse, Ø Dauer + Ø erkannte Lebensbereiche/Blockaden.';


-- ─── 6) Meditationen: welche Kategorien, wie lang gehört? ───────────────────
CREATE OR REPLACE VIEW public.kern_beta_meditation AS
  SELECT
    category,
    COUNT(*)                       AS sessions,
    COUNT(DISTINCT user_id_hashed) AS unique_users,
    ROUND(AVG(numeric_1) / 60.0, 1) AS avg_chosen_min,
    ROUND(AVG(numeric_2) / 60.0, 1) AS avg_actual_min,
    ROUND(100.0 * AVG(numeric_2::NUMERIC / NULLIF(numeric_1, 0)), 0) AS avg_completion_pct
  FROM public.usage_events
  WHERE event_type = 'meditation_completed'
  GROUP BY category
  ORDER BY sessions DESC;

COMMENT ON VIEW public.kern_beta_meditation IS
  'Beta-Dashboard: Meditationen pro Kategorie — Ø gewählte vs. tatsächlich gehörte Minuten + Abschluss-%.';


-- ─── 7) Tages-Trend: Lebenszeichen über die Zeit ───────────────────────────
CREATE OR REPLACE VIEW public.kern_beta_engagement_daily AS
  SELECT
    (occurred_at AT TIME ZONE 'UTC')::DATE                      AS day,
    COUNT(DISTINCT user_id_hashed)                              AS active_users,
    COUNT(*) FILTER (WHERE event_type = 'app_session')          AS app_opens,
    COUNT(*) FILTER (WHERE event_type = 'reflection_completed') AS reflections,
    COUNT(*) FILTER (WHERE event_type = 'meditation_completed') AS meditations,
    COUNT(*)                                                    AS total_events
  FROM public.usage_events
  GROUP BY 1
  ORDER BY 1 DESC;

COMMENT ON VIEW public.kern_beta_engagement_daily IS
  'Beta-Dashboard: Aktivität pro Tag (aktive User, App-Opens, Reflexionen, Meditationen).';


-- ─── Sicherheit: Aggregate sind NICHT öffentlich ───────────────────────────
-- Nur der Owner (service_role im SQL-Editor) liest diese Views. anon +
-- authenticated (= die App-User) bekommen explizit keinen Zugriff — auch
-- nicht auf die anonymen Aggregate.
REVOKE ALL ON public.kern_beta_overview               FROM anon, authenticated;
REVOKE ALL ON public.kern_beta_activity_per_user      FROM anon, authenticated;
REVOKE ALL ON public.kern_beta_reflection_funnel      FROM anon, authenticated;
REVOKE ALL ON public.kern_beta_reflection_abort_points FROM anon, authenticated;
REVOKE ALL ON public.kern_beta_onboarding             FROM anon, authenticated;
REVOKE ALL ON public.kern_beta_meditation             FROM anon, authenticated;
REVOKE ALL ON public.kern_beta_engagement_daily       FROM anon, authenticated;
