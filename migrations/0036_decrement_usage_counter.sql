-- 0036: Gezählten Versuch zurückgeben, wenn die KI ausgefallen ist (01.11.2026).
--
-- mirror erhöht den Zähler VOR dem Aufruf bei Anthropic. Schlägt der Aufruf fehl, war der
-- Versuch trotzdem verbraucht, und jede Wiederholung des Clients zählte erneut: Am Ende
-- einer geführten Reflexion kostete ein Ausfall bis zu 8 Versuche, Gratis-Nutzer haben dort
-- 8 für immer. Diese Funktion gibt genau einen zurück, atomar und nie unter 0.
--
-- Rechte wie 0029: nur service_role, sonst könnte jede App ihren Zähler selbst senken.
--
-- Deploy (NICHT db push): supabase db query --linked --file <diese Datei>
-- Reihenfolge: VOR dem Deploy von mirror.

CREATE OR REPLACE FUNCTION public.decrement_usage_counter(
  p_user_id      UUID,
  p_counter_type TEXT,
  p_period_key   TEXT
)
RETURNS VOID
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  UPDATE public.usage_counters
     SET count = count - 1
   WHERE user_id = p_user_id
     AND counter_type = p_counter_type
     AND period_key = p_period_key
     AND count > 0;
$$;

REVOKE ALL ON FUNCTION public.decrement_usage_counter(UUID, TEXT, TEXT) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.decrement_usage_counter(UUID, TEXT, TEXT) TO service_role;
