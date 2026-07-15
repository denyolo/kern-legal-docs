-- Migration 0015: Kurs-Fortschritt in die Cloud syncen.
--
-- Der Beginnerkurs (und künftige Kurse) speicherten ihren Fortschritt bisher
-- NUR lokal (AsyncStorage 'kern:course-progress') → ging bei Sign-Out/Reinstall/
-- Gerätewechsel verloren. Jetzt als JSONB-Spalte am profiles-Singleton.
--
-- Inhalt = CourseProgress (constants/courses.ts): courseId, startedAt, currentDay,
-- days{}, thematicCategory, focusBlockade, focusArea, completedAt. focusBlockade/
-- focusArea sind User-Content → werden client-seitig E2E-verschlüsselt
-- (crypto.ts ENCRYPTED_FIELDS.profiles.json: 'course_progress'). Der Server sieht
-- nur den Envelope-String (gültiges JSONB).
--
-- Deploy (Tag-42-Lehre — NICHT db push, Remote-Migrationshistorie ist leer):
--   supabase db query --linked --file supabase/migrations/0015_course_progress.sql

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS course_progress JSONB;
