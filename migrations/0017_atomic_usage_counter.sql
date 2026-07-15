-- ════════════════════════════════════════════════════════════════════════════
-- Migration 0017 — Atomarer Rate-Limit-Zähler (RPC)
-- ════════════════════════════════════════════════════════════════════════════
-- Der Zähl-Pfad in der mirror-Edge-Function war ein NICHT-atomares
-- Read-Check-Increment (SELECT count → prüfe < limit → UPSERT count+1). Zwei
-- gleichzeitige Requests desselben Users lesen denselben count, passen beide
-- den Check und schreiben beide count+1 → der Zähler zählt zu niedrig, die
-- Free-Wand (2/2/4 lifetime) ließ sich per parallelem Request-Burst
-- überschreiten (bezahlter Content leckt).
--
-- Diese Funktion macht Check + Increment ATOMAR in EINEM Statement:
--   INSERT ... ON CONFLICT DO UPDATE SET count = count + 1 WHERE count < limit
-- Bei Erfolg gibt sie den neuen Zählerstand + allowed=true zurück; ist das
-- Limit erreicht, greift die WHERE-Klausel nicht (keine Zeile aktualisiert) →
-- allowed=false + der aktuelle Stand.
--
-- Der ursprüngliche Kommentar in 0001_init.sql (Z.289 „Wird ... atomic
-- incrementiert via RPC") war die INTENTION — die RPC wurde nie gebaut, der
-- Code degradierte zum Read-Modify-Write. Das holt es nach.
--
-- Deploy (NICHT db push — Remote-Historie ist leer, s. CLAUDE.md Tag-42):
--   supabase db query --linked --file supabase/migrations/0017_atomic_usage_counter.sql

CREATE OR REPLACE FUNCTION public.increment_usage_counter(
  p_user_id      UUID,
  p_counter_type TEXT,
  p_period_key   TEXT,
  p_limit        INTEGER
)
RETURNS TABLE (new_count INTEGER, allowed BOOLEAN)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_count INTEGER;
BEGIN
  -- Erst-Insert (count=1) ODER atomarer Increment, aber nur solange unter Limit.
  -- Alias `uc` referenziert die bestehende Konflikt-Zeile eindeutig (die
  -- schema-qualifizierte Form public.usage_counters.count ist im ON-CONFLICT-
  -- DO-UPDATE-Kontext nicht zuverlässig auflösbar).
  INSERT INTO public.usage_counters AS uc (user_id, counter_type, period_key, count)
  VALUES (p_user_id, p_counter_type, p_period_key, 1)
  ON CONFLICT (user_id, counter_type, period_key)
  DO UPDATE SET count = uc.count + 1
  WHERE uc.count < p_limit
  RETURNING uc.count INTO v_count;

  IF v_count IS NULL THEN
    -- ON-CONFLICT-WHERE war false → schon am/über Limit, nichts geschrieben.
    -- Aktuellen Stand für die 429-Antwort nachlesen.
    SELECT count INTO v_count
      FROM public.usage_counters
     WHERE user_id = p_user_id
       AND counter_type = p_counter_type
       AND period_key = p_period_key;
    RETURN QUERY SELECT COALESCE(v_count, p_limit), FALSE;
  ELSE
    RETURN QUERY SELECT v_count, TRUE;
  END IF;
END;
$$;

-- Die mirror-Edge-Function ruft die RPC mit dem service_role-Client auf.
GRANT EXECUTE ON FUNCTION public.increment_usage_counter(UUID, TEXT, TEXT, INTEGER) TO service_role;
