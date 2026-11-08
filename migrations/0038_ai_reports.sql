-- 0038: KI-Antworten melden (App-Version 1.3.0, Googles Richtlinie „AI-Generated Content“,
-- für iOS und Android).
--
-- Lange auf eine KI-Antwort drücken → Grund wählen, optional die Antwort mitschicken
-- (components/AiReportSheet.tsx, services/aiReport.ts).
--
-- Bewusst OHNE user_id: Die Meldung ist mit keinem Konto verknüpft. Gespeichert werden der
-- Grund, der Ort (welches Gespräch), Plattform, App-Version und, nur wenn die Person den
-- Schalter einschaltet, der Text dieser EINEN KI-Antwort. Nie die eigenen Texte. Deshalb steht
-- die Tabelle in keiner der Konto-Listen (USER_TABLES, WIPE_TABLES, ORPHAN_*): „Konto löschen“
-- kann sie nicht zuordnen, die Datenschutzerklärung sagt das so.
-- 🚨 Die eine bewusste Klartext-Stelle neben dem E2E-Versprechen: Wer die Antwort mitschickt,
-- erlaubt KERN, genau diesen Text zu lesen (docs/legal/admin-conduct.md).
--
-- Zugang nur über report_ai_reply (SECURITY DEFINER): nur für angemeldete Konten (auch
-- anonyme), die Kennung prüft sie, speichert sie aber nicht. Clients lesen die Tabelle nie,
-- RLS ohne Policy plus REVOKE. Unbekannte Plattform oder zu lange Version → NULL, zu langer
-- Text wird auf 8.000 Zeichen gekürzt (die App kürzt vorher selbst).
-- Löschfrist: 12 Monate (eigene Migration, Zeitplaner).
--
-- Deploy (NICHT db push): supabase db query --linked --file <diese Datei>
-- Vorher in einer abgebrochenen Transaktion geprüft (Probe mit RAISE EXCEPTION).

BEGIN;

CREATE TABLE public.ai_reports (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  reason      TEXT NOT NULL,
  surface     TEXT NOT NULL,
  platform    TEXT,
  app_version TEXT,
  reply_text  TEXT,
  CONSTRAINT chk_ai_report_reason CHECK (reason IN ('hurtful', 'wrong', 'other')),
  CONSTRAINT chk_ai_report_surface CHECK (surface IN ('reflection', 'guided', 'onboarding')),
  CONSTRAINT chk_ai_report_platform CHECK (platform IS NULL OR platform IN ('ios', 'android')),
  CONSTRAINT chk_ai_report_app_version CHECK (app_version IS NULL OR length(app_version) <= 32),
  CONSTRAINT chk_ai_report_text CHECK (reply_text IS NULL OR length(reply_text) <= 8000)
);

CREATE INDEX idx_ai_reports_created_at ON public.ai_reports (created_at);

ALTER TABLE public.ai_reports ENABLE ROW LEVEL SECURITY;
-- Keine Policy: Kein Client liest oder schreibt die Tabelle direkt.
REVOKE ALL ON public.ai_reports FROM PUBLIC, anon, authenticated;

COMMENT ON TABLE public.ai_reports IS
  'Gemeldete KI-Antworten (1.3.0). Ohne user_id. reply_text nur, wenn die Person ihn ausdrücklich '
  'mitschickt. Zugang nur über report_ai_reply. Löschfrist 12 Monate.';

CREATE FUNCTION public.report_ai_reply(
  p_reason      TEXT,
  p_surface     TEXT,
  p_platform    TEXT DEFAULT NULL,
  p_app_version TEXT DEFAULT NULL,
  p_reply_text  TEXT DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public', 'pg_temp'
AS $function$
BEGIN
  -- Nur angemeldete Konten (auch anonyme). Die Kennung wird NICHT gespeichert.
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'ai_report: not authenticated';
  END IF;

  INSERT INTO public.ai_reports (reason, surface, platform, app_version, reply_text)
  VALUES (
    p_reason,
    p_surface,
    CASE WHEN p_platform IN ('ios', 'android') THEN p_platform ELSE NULL END,
    CASE WHEN p_app_version IS NOT NULL AND length(p_app_version) <= 32 THEN p_app_version ELSE NULL END,
    NULLIF(left(p_reply_text, 8000), '')
  );
END;
$function$;

REVOKE EXECUTE ON FUNCTION public.report_ai_reply(TEXT, TEXT, TEXT, TEXT, TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.report_ai_reply(TEXT, TEXT, TEXT, TEXT, TEXT) TO authenticated;

COMMENT ON FUNCTION public.report_ai_reply(TEXT, TEXT, TEXT, TEXT, TEXT) IS
  'KI-Antwort melden (1.3.0). Schreibt ai_reports ohne Kennung, nur für angemeldete Konten.';

COMMIT;

NOTIFY pgrst, 'reload schema';
