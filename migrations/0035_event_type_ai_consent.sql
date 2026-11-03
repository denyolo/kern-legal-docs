-- 0035: Telemetrie-Ereignis für die Erlaubnis zur KI (1.2.7).
--
-- Inhaltsfrei: nur wo gefragt wurde (category) und ob Einverstanden (numeric_1).
-- Rein hinzufügend, Liste = 0030 wörtlich + das neue Ereignis (0031 bis 0034 fassen
-- den CHECK nicht an, gegen pg_get_constraintdef geprüft am 01.11.2026).
--
-- Deploy (NICHT db push): supabase db query --linked --file <diese Datei>
-- Reihenfolge: vor dem Release. Ohne diese Migration lehnt Postgres das Ereignis
-- still ab, die App läuft trotzdem.

ALTER TABLE public.usage_events DROP CONSTRAINT IF EXISTS chk_event_type;
ALTER TABLE public.usage_events ADD CONSTRAINT chk_event_type CHECK (
  event_type = ANY (ARRAY[
    'reflection_completed', 'reflection_aborted', 'affirmation_generated',
    'meditation_completed', 'onboarding_completed', 'limit_reached',
    'premium_converted', 'app_session', 'affirmation_practiced',
    'onboarding_started', 'browse_entered', 'meditation_started',
    'course_started', 'course_day_completed', 'course_completed',
    'onboarding_intro_advanced', 'onboarding_turn', 'onboarding_reveal_reached',
    'onboarding_backup_reached', 'onboarding_abandoned',
    'meditation_rated', 'paywall_viewed', 'reflection_summary_failed',
    'explainer_started', 'explainer_ended', 'explainer_cta',
    'share_opened',
    'next_course_card_viewed', 'next_course_card_tapped',
    'ai_consent'
  ])
);
