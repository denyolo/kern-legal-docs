-- 0033: Zeilen eines zurückgebliebenen anonymen Kontos in EINER Transaktion umhängen (1.2.7)
--
-- Wechselt KERN beim Anmelden mit Apple in ein anderes Konto, tragen die Zeilen des
-- Geräts Kennungen, die noch dem alten Konto gehören. RLS lehnt ihren Upload unter dem
-- neuen Konto ab (42501). Löscht die App die alten Zeilen vorher, ist das Gerät bis zum
-- fertigen Upload die einzige Kopie, und jeder Abbruch dazwischen verliert Inhalte.
-- Deshalb hängt der Server die Zeilen um, wie scripts/repair_account_split.py: alles
-- oder nichts, Inhalte bleiben verschlüsselt, gelesen wird nichts. Der Schlüssel liegt
-- auf dem Gerät, nicht am Konto.
--
-- Nicht dabei: usage_counters und premium_status (Server-Zustand pro Konto).
-- Was B schon hat, bleibt bei B. Reste bei A fallen mit dem Löschen von A weg.
--
-- Aufgerufen nur von der Edge Function move-orphan, die beide Konten per Token prüft.
-- Deploy: supabase db query --linked --file supabase/migrations/0033_move_orphan_rows.sql

CREATE OR REPLACE FUNCTION public.move_orphan_rows(p_from uuid, p_to uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  t text;
  n integer;
  moved jsonb := '{}'::jsonb;
BEGIN
  IF p_from IS NULL OR p_to IS NULL OR p_from = p_to THEN
    RAISE EXCEPTION 'move_orphan_rows: ungültige Kennungen';
  END IF;

  -- Eigene id, keine Eindeutigkeit über user_id.
  FOREACH t IN ARRAY ARRAY['life_areas', 'goals', 'sessions', 'insights', 'reflections',
                           'affirmations', 'meditation_ratings', 'article_reads',
                           'conversation_history'] LOOP
    EXECUTE format('UPDATE public.%I SET user_id = $1 WHERE user_id = $2', t) USING p_to, p_from;
    GET DIAGNOSTICS n = ROW_COUNT;
    moved := moved || jsonb_build_object(t, n);
  END LOOP;

  UPDATE public.affirmation_practice_events e SET user_id = p_to
  WHERE e.user_id = p_from AND NOT EXISTS (
    SELECT 1 FROM public.affirmation_practice_events y
    WHERE y.user_id = p_to AND y.affirmation_id = e.affirmation_id AND y.practiced_at = e.practiced_at);
  GET DIAGNOSTICS n = ROW_COUNT;
  moved := moved || jsonb_build_object('affirmation_practice_events', n);

  UPDATE public.blockade_meta m SET user_id = p_to
  WHERE m.user_id = p_from AND NOT EXISTS (
    SELECT 1 FROM public.blockade_meta y
    WHERE y.user_id = p_to AND y.blockade_text = m.blockade_text);
  GET DIAGNOSTICS n = ROW_COUNT;
  moved := moved || jsonb_build_object('blockade_meta', n);

  UPDATE public.summaries s SET user_id = p_to
  WHERE s.user_id = p_from AND NOT EXISTS (
    SELECT 1 FROM public.summaries y
    WHERE y.user_id = p_to AND y.period_type = s.period_type AND y.period_key = s.period_key);
  GET DIAGNOSTICS n = ROW_COUNT;
  moved := moved || jsonb_build_object('summaries', n);

  -- Die Profil-Zeile gibt es je Konto genau einmal. Fehlt sie bei B, zieht sie um. Sonst
  -- bekommt B nur, was dort noch leer ist: Hat das Gerät schon hochgeladen, ist sein
  -- Stand neuer. Einstellungen bleiben bei B.
  -- Leer heißt auch verschlüsselt leer: Die App verschlüsselt [] und {} als Hülle mit genau
  -- 64 Zeichen (k1:, 24 Nonce, :, 36 Chiffre), der kleinste echte Inhalt ist länger. Die
  -- Reise-Zähler stehen im Klartext und sind bei einer Hülle alle 0.
  IF EXISTS (SELECT 1 FROM public.profiles WHERE user_id = p_to) THEN
    UPDATE public.profiles b SET
      goals              = CASE WHEN cardinality(b.goals) = 0 THEN a.goals ELSE b.goals END,
      blocks             = CASE WHEN cardinality(b.blocks) = 0 THEN a.blocks ELSE b.blocks END,
      focus_area         = CASE WHEN b.focus_area = '' THEN a.focus_area ELSE b.focus_area END,
      onboarding_answers = CASE WHEN b.onboarding_answers = '[]'::jsonb
                                  OR (jsonb_typeof(b.onboarding_answers) = 'string' AND length(b.onboarding_answers #>> '{}') = 64)
                                THEN a.onboarding_answers ELSE b.onboarding_answers END,
      onboarding_summary = CASE WHEN b.onboarding_summary = '' THEN a.onboarding_summary ELSE b.onboarding_summary END,
      blockade_types     = CASE WHEN b.blockade_types = '{}'::jsonb
                                  OR (jsonb_typeof(b.blockade_types) = 'string' AND length(b.blockade_types #>> '{}') = 64)
                                THEN a.blockade_types ELSE b.blockade_types END,
      dismissed_insights = CASE WHEN cardinality(b.dismissed_insights) = 0 THEN a.dismissed_insights ELSE b.dismissed_insights END,
      completed_insights = CASE WHEN cardinality(b.completed_insights) = 0 THEN a.completed_insights ELSE b.completed_insights END,
      hidden_journal_ids = CASE WHEN cardinality(b.hidden_journal_ids) = 0 THEN a.hidden_journal_ids ELSE b.hidden_journal_ids END,
      lifetime_stats     = CASE WHEN b.lifetime_stats IS NULL OR NOT EXISTS (
                                    SELECT 1 FROM jsonb_each(b.lifetime_stats) x
                                    WHERE (jsonb_typeof(x.value) = 'number' AND (x.value #>> '{}')::numeric > 0)
                                       OR (x.key = 'firstActivityAt' AND jsonb_typeof(x.value) = 'string'))
                                THEN COALESCE(a.lifetime_stats, b.lifetime_stats) ELSE b.lifetime_stats END,
      course_progress    = COALESCE(b.course_progress, a.course_progress),
      disclaimer_agreed_at = COALESCE(b.disclaimer_agreed_at, a.disclaimer_agreed_at)
    FROM public.profiles a
    WHERE a.user_id = p_from AND b.user_id = p_to;
    GET DIAGNOSTICS n = ROW_COUNT;
    DELETE FROM public.profiles WHERE user_id = p_from;
  ELSE
    UPDATE public.profiles SET user_id = p_to WHERE user_id = p_from;
    GET DIAGNOSTICS n = ROW_COUNT;
  END IF;
  moved := moved || jsonb_build_object('profiles', n);

  RETURN moved;
END;
$$;

REVOKE ALL ON FUNCTION public.move_orphan_rows(uuid, uuid) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.move_orphan_rows(uuid, uuid) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION public.move_orphan_rows(uuid, uuid) TO service_role;

COMMENT ON FUNCTION public.move_orphan_rows(uuid, uuid) IS
  'Hängt die Zeilen eines zurückgebliebenen anonymen Kontos in einer Transaktion um (1.2.7). Nur für die Edge Function move-orphan.';
