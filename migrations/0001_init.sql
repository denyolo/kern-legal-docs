-- ════════════════════════════════════════════════════════════════════════════
-- KERN App — Initial Database Schema
-- ════════════════════════════════════════════════════════════════════════════
--
-- Sprint 1 Backend (Mai 14, 2026)
--
-- Spiegelt das bisherige AsyncStorage-Schema aus services/storage.ts:
--  - 1:1 für persistente User-Daten
--  - Sub-Entitäten mit eigener Identität (Goals, Affirmations, Sessions etc.)
--    bekommen eigene Tabellen
--  - Sub-State (preferences, onboarding answers) bleibt JSONB in profiles
--
-- WICHTIG:
--  - Alle Tabellen haben user_id FK auf auth.users(id) ON DELETE CASCADE
--  - RLS ist immer aktiv, Policies werden weiter unten gesetzt
--  - updated_at wird über Trigger automatisch gesetzt
--
-- Ausführen: Supabase Dashboard → SQL Editor → diese Datei einfügen → Run
-- (Oder via supabase CLI: supabase db push)
-- ════════════════════════════════════════════════════════════════════════════

-- ─── Extensions ─────────────────────────────────────────────────────────────

-- Für gen_random_uuid() (ist eigentlich in Postgres 13+ schon dabei)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ─── Hilfsfunktion: updated_at Auto-Update ──────────────────────────────────

CREATE OR REPLACE FUNCTION public.touch_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- ════════════════════════════════════════════════════════════════════════════
-- 1) profiles — 1:1 mit auth.users
-- ════════════════════════════════════════════════════════════════════════════
-- Spiegelt UserProfile aus storage.ts. Sub-Entitäten mit eigener Identität
-- (goals, life_areas, affirmations, reflections, insights, blockade_meta)
-- sind separate Tabellen. Sub-State (preferences, onboardingAnswers) bleibt
-- als JSONB hier.

CREATE TABLE public.profiles (
  user_id           UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,

  -- Onboarding-Daten (Snapshot, kann später überschrieben werden)
  goals             TEXT[] NOT NULL DEFAULT '{}',
  blocks            TEXT[] NOT NULL DEFAULT '{}',
  focus_area        TEXT NOT NULL DEFAULT '',
  stress_response   TEXT NOT NULL DEFAULT 'mixed'
                    CHECK (stress_response IN ('head','gut','mixed')),
  onboarding_answers JSONB NOT NULL DEFAULT '[]'::jsonb,  -- [{question, answer}]
  onboarding_summary TEXT NOT NULL DEFAULT '',

  -- Legacy Blockade-Type-Mapping (record<blockText, type>)
  blockade_types    JSONB NOT NULL DEFAULT '{}'::jsonb,

  -- Smart-Insights: Slugs die User weggetippt hat / archiviert hat
  dismissed_insights  TEXT[] NOT NULL DEFAULT '{}',
  completed_insights  TEXT[] NOT NULL DEFAULT '{}',

  -- Einstellungen
  preferences       JSONB NOT NULL DEFAULT '{
    "language": "de",
    "voiceGender": "m",
    "notifications": {
      "morningEnabled": false,
      "morningTime": "07:30",
      "eveningEnabled": false,
      "eveningTime": "20:30",
      "gapReminderEnabled": false,
      "reEngagementEnabled": false
    }
  }'::jsonb,

  -- Legal
  disclaimer_agreed_at TIMESTAMPTZ,

  -- Legacy
  preferred_style   TEXT,  -- 'reflective' | 'direct' | 'goal-oriented'

  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.profiles IS 'Spiegel von UserProfile aus storage.ts (sub-state via JSONB, sub-entities via own tables)';


-- ════════════════════════════════════════════════════════════════════════════
-- 2) goals — aktive Ziele (Manifestation)
-- ════════════════════════════════════════════════════════════════════════════

CREATE TABLE public.goals (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  text          TEXT NOT NULL,
  status        TEXT NOT NULL DEFAULT 'active'
                CHECK (status IN ('active','achieved','paused','archived')),
  gefuehl       SMALLINT NOT NULL DEFAULT 1
                CHECK (gefuehl BETWEEN 1 AND 10),
  reflections   TEXT[] NOT NULL DEFAULT '{}',  -- Goal.reflections aus storage.ts
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- ════════════════════════════════════════════════════════════════════════════
-- 3) life_areas — Lebensbereiche mit zugeordneten Goals + Blockaden
-- ════════════════════════════════════════════════════════════════════════════

CREATE TABLE public.life_areas (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name          TEXT NOT NULL,                  -- "Selbstbestimmung & Zeit" etc.
  goal_ids      UUID[] NOT NULL DEFAULT '{}',   -- Verweise auf goals.id
  blockades     TEXT[] NOT NULL DEFAULT '{}',   -- Blockade-Texte als Strings
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- ════════════════════════════════════════════════════════════════════════════
-- 4) blockade_meta — Metadaten pro Blockade (Typ, Beschreibung, Reflexionsfragen)
-- ════════════════════════════════════════════════════════════════════════════
-- Gefüllt von mirror.analyzeBlockades. Ein Eintrag pro Kombi (user_id, text).

CREATE TABLE public.blockade_meta (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  blockade_text         TEXT NOT NULL,  -- Original-String aus profile.blocks
  type                  TEXT CHECK (type IN ('identity','energy','pattern','integration','safety','other')),
  description           TEXT NOT NULL DEFAULT '',
  reflection_questions  TEXT[] NOT NULL DEFAULT '{}',
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, blockade_text)
);


-- ════════════════════════════════════════════════════════════════════════════
-- 5) sessions — Meditationen, Reflexionen, Quick Thoughts
-- ════════════════════════════════════════════════════════════════════════════

CREATE TABLE public.sessions (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  type                  TEXT NOT NULL
                        CHECK (type IN ('presence','clarity','reflection','thought')),
  date                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Optional je nach type
  intention             TEXT,
  meditation_text       TEXT,
  journal_entries       JSONB,  -- Array<{question, answer}>
  summary               TEXT,
  structured_summary    JSONB,  -- ReflectionSummary
  duration_minutes      INTEGER NOT NULL DEFAULT 0,
  selected_duration     INTEGER,
  completed             BOOLEAN,

  -- Meditations-Metadaten (seit Mai 14, 2026)
  category              TEXT,        -- 'bodyscan', 'breathwork' etc.
  method                TEXT,        -- Legacy/Alias
  goal_context          TEXT,        -- Goal/Blockade-Text wenn aus Affirmation

  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- ════════════════════════════════════════════════════════════════════════════
-- 6) reflections — DatedEntry für Reflexions-Inhalte
-- ════════════════════════════════════════════════════════════════════════════

CREATE TABLE public.reflections (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  content       TEXT NOT NULL,
  context       TEXT CHECK (context IN ('reflection','meditation','manifestation')),
  date          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- ════════════════════════════════════════════════════════════════════════════
-- 7) insights — Erkenntnisse aus Reflexionen
-- ════════════════════════════════════════════════════════════════════════════

CREATE TABLE public.insights (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  content           TEXT NOT NULL,
  context           TEXT CHECK (context IN ('reflection','meditation','manifestation')),
  date              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  source_session_id UUID REFERENCES public.sessions(id) ON DELETE SET NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- ════════════════════════════════════════════════════════════════════════════
-- 8) affirmations + practice events
-- ════════════════════════════════════════════════════════════════════════════
-- Eine Affirmation hat 1..N Practice-Events (separate Tabelle für Mehrtag-Tracking)

CREATE TABLE public.affirmations (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  blockade_text   TEXT NOT NULL,
  goal_text       TEXT NOT NULL,
  area_name       TEXT NOT NULL,
  affirmations    TEXT[] NOT NULL DEFAULT '{}',  -- Liste der Affirmations-Texte
  feeling         TEXT,
  feeling_score   SMALLINT CHECK (feeling_score BETWEEN 1 AND 10),
  practice_count  INTEGER NOT NULL DEFAULT 0,
  last_practiced_at TIMESTAMPTZ,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.affirmation_practice_events (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  affirmation_id  UUID NOT NULL REFERENCES public.affirmations(id) ON DELETE CASCADE,
  practiced_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- ════════════════════════════════════════════════════════════════════════════
-- 9) meditation_ratings — Liked/Disliked-Meditationen
-- ════════════════════════════════════════════════════════════════════════════

CREATE TABLE public.meditation_ratings (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  intention       TEXT NOT NULL,
  meditation_text TEXT NOT NULL,
  rating          TEXT NOT NULL CHECK (rating IN ('liked','disliked')),
  date            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- ════════════════════════════════════════════════════════════════════════════
-- 10) article_reads — Wissens-Tab-Aufrufe (Throttle: 1×/Tag pro Slug client-side)
-- ════════════════════════════════════════════════════════════════════════════

CREATE TABLE public.article_reads (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  slug          TEXT NOT NULL,
  read_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- ════════════════════════════════════════════════════════════════════════════
-- 11) conversation_history — Mirror-Chat History pro Context
-- ════════════════════════════════════════════════════════════════════════════
-- Context-Werte: 'home', 'clarity', 'presence', 'reflection'

CREATE TABLE public.conversation_history (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  context       TEXT NOT NULL,
  role          TEXT NOT NULL CHECK (role IN ('user','assistant')),
  content       TEXT NOT NULL,
  timestamp     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- ════════════════════════════════════════════════════════════════════════════
-- 12) summaries — Wochen- + Monats-Zusammenfassungen (AI-generiert)
-- ════════════════════════════════════════════════════════════════════════════
-- Cached AI-Output. period_key: "2026-W19" oder "2026-05".

CREATE TABLE public.summaries (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  period_type   TEXT NOT NULL CHECK (period_type IN ('weekly','monthly')),
  period_key    TEXT NOT NULL,
  text          TEXT NOT NULL,
  generated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, period_type, period_key)
);


-- ════════════════════════════════════════════════════════════════════════════
-- 13) usage_counters — Rate-Limit (Free 3/Woche, Premium 100/Monat)
-- ════════════════════════════════════════════════════════════════════════════
-- Wird vom Edge Function /mirror/* atomic incrementiert via RPC.

CREATE TABLE public.usage_counters (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  counter_type  TEXT NOT NULL,    -- 'reflection_weekly' | 'affirmation_monthly' | ...
  period_key    TEXT NOT NULL,    -- "2026-W19" oder "2026-05"
  count         INTEGER NOT NULL DEFAULT 0,
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, counter_type, period_key)
);


-- ════════════════════════════════════════════════════════════════════════════
-- 14) premium_status — RevenueCat-Spiegel + Beta-Flag
-- ════════════════════════════════════════════════════════════════════════════
-- Bis RevenueCat live ist, ist is_premium_beta=true das Manual-Flag für Tester.

CREATE TABLE public.premium_status (
  user_id           UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  is_premium        BOOLEAN NOT NULL DEFAULT FALSE,
  is_premium_beta   BOOLEAN NOT NULL DEFAULT FALSE,
  expires_at        TIMESTAMPTZ,
  product_id        TEXT,  -- 'monthly_6_99' | 'yearly_49_99' | 'lifetime_99'
  source            TEXT,  -- 'revenuecat' | 'manual_beta' | 'admin'
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- ════════════════════════════════════════════════════════════════════════════
-- ─── INDICES für häufige Queries ────────────────────────────────────────────
-- ════════════════════════════════════════════════════════════════════════════

-- Sessions: meistens per user_id + date abgefragt (für Verlauf/Heatmap)
CREATE INDEX idx_sessions_user_date    ON public.sessions (user_id, date DESC);
CREATE INDEX idx_sessions_user_type    ON public.sessions (user_id, type);

-- Reflexionen/Insights: pro User chronologisch
CREATE INDEX idx_reflections_user_date ON public.reflections (user_id, date DESC);
CREATE INDEX idx_insights_user_date    ON public.insights (user_id, date DESC);

-- Goals: pro User + Status
CREATE INDEX idx_goals_user_status     ON public.goals (user_id, status);

-- Affirmations: pro User + Blockade-Text (lookup für getAffirmationForBlockade)
CREATE INDEX idx_affirmations_user_blockade ON public.affirmations (user_id, blockade_text);
CREATE INDEX idx_practice_events_affirmation ON public.affirmation_practice_events (affirmation_id, practiced_at DESC);
CREATE INDEX idx_practice_events_user_date ON public.affirmation_practice_events (user_id, practiced_at DESC);

-- Article Reads: für getProgress dailyActivity
CREATE INDEX idx_article_reads_user_date ON public.article_reads (user_id, read_at DESC);

-- Conversation: pro Context
CREATE INDEX idx_conversation_user_context ON public.conversation_history (user_id, context, timestamp DESC);

-- Summaries: per unique key schon Index via UNIQUE-Constraint
-- Usage Counters: per unique key schon Index via UNIQUE-Constraint


-- ════════════════════════════════════════════════════════════════════════════
-- ─── TRIGGER: updated_at Auto-Update ────────────────────────────────────────
-- ════════════════════════════════════════════════════════════════════════════

CREATE TRIGGER profiles_updated_at    BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();
CREATE TRIGGER goals_updated_at       BEFORE UPDATE ON public.goals
  FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();
CREATE TRIGGER life_areas_updated_at  BEFORE UPDATE ON public.life_areas
  FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();
CREATE TRIGGER blockade_meta_updated_at BEFORE UPDATE ON public.blockade_meta
  FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();
CREATE TRIGGER usage_counters_updated_at BEFORE UPDATE ON public.usage_counters
  FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();
CREATE TRIGGER premium_status_updated_at BEFORE UPDATE ON public.premium_status
  FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


-- ════════════════════════════════════════════════════════════════════════════
-- ─── ROW LEVEL SECURITY (RLS) — Enable ──────────────────────────────────────
-- ════════════════════════════════════════════════════════════════════════════
-- Da automatic-RLS-trigger schon aktiv ist, sollten neue Tabellen automatisch
-- RLS=enabled bekommen. Wir setzen es trotzdem explizit zur Sicherheit.

ALTER TABLE public.profiles                    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.goals                       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.life_areas                  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.blockade_meta               ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sessions                    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reflections                 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.insights                    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.affirmations                ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.affirmation_practice_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meditation_ratings          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.article_reads               ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conversation_history        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.summaries                   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.usage_counters              ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.premium_status              ENABLE ROW LEVEL SECURITY;


-- ════════════════════════════════════════════════════════════════════════════
-- ─── RLS POLICIES ───────────────────────────────────────────────────────────
-- ════════════════════════════════════════════════════════════════════════════
-- Standard-Pattern: User darf NUR seine eigenen Rows lesen/ändern.
-- auth.uid() = JWT-Claim aus Supabase Auth Token.

-- Helper-Macro-Pattern (per Tabelle 4 Policies: SELECT, INSERT, UPDATE, DELETE)

-- profiles ───────────────────────────────────────────────────────────────────
CREATE POLICY profiles_select ON public.profiles
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY profiles_insert ON public.profiles
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY profiles_update ON public.profiles
  FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY profiles_delete ON public.profiles
  FOR DELETE USING (auth.uid() = user_id);

-- goals ──────────────────────────────────────────────────────────────────────
CREATE POLICY goals_select ON public.goals FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY goals_insert ON public.goals FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY goals_update ON public.goals FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY goals_delete ON public.goals FOR DELETE USING (auth.uid() = user_id);

-- life_areas ─────────────────────────────────────────────────────────────────
CREATE POLICY life_areas_select ON public.life_areas FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY life_areas_insert ON public.life_areas FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY life_areas_update ON public.life_areas FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY life_areas_delete ON public.life_areas FOR DELETE USING (auth.uid() = user_id);

-- blockade_meta ──────────────────────────────────────────────────────────────
CREATE POLICY blockade_meta_select ON public.blockade_meta FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY blockade_meta_insert ON public.blockade_meta FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY blockade_meta_update ON public.blockade_meta FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY blockade_meta_delete ON public.blockade_meta FOR DELETE USING (auth.uid() = user_id);

-- sessions ───────────────────────────────────────────────────────────────────
CREATE POLICY sessions_select ON public.sessions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY sessions_insert ON public.sessions FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY sessions_update ON public.sessions FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY sessions_delete ON public.sessions FOR DELETE USING (auth.uid() = user_id);

-- reflections ────────────────────────────────────────────────────────────────
CREATE POLICY reflections_select ON public.reflections FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY reflections_insert ON public.reflections FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY reflections_update ON public.reflections FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY reflections_delete ON public.reflections FOR DELETE USING (auth.uid() = user_id);

-- insights ───────────────────────────────────────────────────────────────────
CREATE POLICY insights_select ON public.insights FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY insights_insert ON public.insights FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY insights_update ON public.insights FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY insights_delete ON public.insights FOR DELETE USING (auth.uid() = user_id);

-- affirmations ───────────────────────────────────────────────────────────────
CREATE POLICY affirmations_select ON public.affirmations FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY affirmations_insert ON public.affirmations FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY affirmations_update ON public.affirmations FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY affirmations_delete ON public.affirmations FOR DELETE USING (auth.uid() = user_id);

-- affirmation_practice_events ────────────────────────────────────────────────
CREATE POLICY ape_select ON public.affirmation_practice_events FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY ape_insert ON public.affirmation_practice_events FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY ape_update ON public.affirmation_practice_events FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY ape_delete ON public.affirmation_practice_events FOR DELETE USING (auth.uid() = user_id);

-- meditation_ratings ─────────────────────────────────────────────────────────
CREATE POLICY meditation_ratings_select ON public.meditation_ratings FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY meditation_ratings_insert ON public.meditation_ratings FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY meditation_ratings_update ON public.meditation_ratings FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY meditation_ratings_delete ON public.meditation_ratings FOR DELETE USING (auth.uid() = user_id);

-- article_reads ──────────────────────────────────────────────────────────────
CREATE POLICY article_reads_select ON public.article_reads FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY article_reads_insert ON public.article_reads FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY article_reads_delete ON public.article_reads FOR DELETE USING (auth.uid() = user_id);
-- (kein UPDATE — Reads sind immutable)

-- conversation_history ───────────────────────────────────────────────────────
CREATE POLICY conv_history_select ON public.conversation_history FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY conv_history_insert ON public.conversation_history FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY conv_history_delete ON public.conversation_history FOR DELETE USING (auth.uid() = user_id);
-- (kein UPDATE — Messages sind immutable)

-- summaries ──────────────────────────────────────────────────────────────────
CREATE POLICY summaries_select ON public.summaries FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY summaries_insert ON public.summaries FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY summaries_update ON public.summaries FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY summaries_delete ON public.summaries FOR DELETE USING (auth.uid() = user_id);

-- usage_counters ─────────────────────────────────────────────────────────────
-- WICHTIG: User darf SELECT lesen (für UI-Anzeige der verbleibenden Quota),
-- aber NICHT INSERT/UPDATE selbst — das macht NUR die Edge Function mit
-- service_role Key (umgeht RLS by design). So kann der User seine eigene
-- Quota nicht hochmanipulieren.
CREATE POLICY usage_counters_select ON public.usage_counters FOR SELECT USING (auth.uid() = user_id);
-- KEIN INSERT/UPDATE/DELETE für authenticated user — nur service_role darf

-- premium_status ─────────────────────────────────────────────────────────────
-- User darf SELECT (für Premium-Check in App), aber NICHT INSERT/UPDATE.
-- Schreibzugriff nur via RevenueCat-Webhook (Edge Function mit service_role)
-- oder manuelle Admin-Edits.
CREATE POLICY premium_status_select ON public.premium_status FOR SELECT USING (auth.uid() = user_id);
-- KEIN INSERT/UPDATE/DELETE für authenticated user


-- ════════════════════════════════════════════════════════════════════════════
-- ─── GRANTS für die `authenticated` Rolle ──────────────────────────────────
-- ════════════════════════════════════════════════════════════════════════════
-- Tabelle existiert technisch — User muss Zugriff bekommen damit RLS-Policies
-- überhaupt evaluiert werden. Ohne Grants gibt es "permission denied".

GRANT SELECT, INSERT, UPDATE, DELETE ON public.profiles                    TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.goals                       TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.life_areas                  TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.blockade_meta               TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.sessions                    TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.reflections                 TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.insights                    TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.affirmations                TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.affirmation_practice_events TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.meditation_ratings          TO authenticated;
GRANT SELECT, INSERT,         DELETE ON public.article_reads               TO authenticated;
GRANT SELECT, INSERT,         DELETE ON public.conversation_history        TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.summaries                   TO authenticated;
GRANT SELECT                          ON public.usage_counters             TO authenticated;
GRANT SELECT                          ON public.premium_status             TO authenticated;


-- ════════════════════════════════════════════════════════════════════════════
-- ─── AUTO-CREATE PROFILE ON USER SIGNUP ─────────────────────────────────────
-- ════════════════════════════════════════════════════════════════════════════
-- Wenn ein neuer User via auth.users entsteht, lege automatisch ein leeres
-- profile + premium_status (mit defaults) an.

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER  -- bypass RLS (function runs with creator's privileges)
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (user_id)
  VALUES (NEW.id);
  INSERT INTO public.premium_status (user_id)
  VALUES (NEW.id);
  RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


-- ════════════════════════════════════════════════════════════════════════════
-- ─── DONE ──────────────────────────────────────────────────────────────────
-- ════════════════════════════════════════════════════════════════════════════
-- Nächste Schritte:
-- 1) Migration in Supabase SQL Editor ausführen
-- 2) Manuell deinen User-Account is_premium_beta=true setzen (sobald registriert)
-- 3) services/supabase.ts Client-Setup
-- 4) services/auth.ts mit Apple Sign-In
-- 5) Sync-Layer in storage.ts
-- 6) Edge Function für Claude API
