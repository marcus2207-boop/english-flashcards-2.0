-- SQLite schema for English Flashcards MVP
-- File: db/schema.sql
-- Note: schema designed to be Postgres-compatible where possible.
-- Each table includes a comment linking to related story IDs (ST-XXX) for RTM traceability.

PRAGMA foreign_keys = ON;

-- Users table
-- ST-001 (Authentication), ST-002 (Admin user management), ST-011 (Privacy/PII)
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL UNIQUE,         -- only email (minimal PII)
  nickname TEXT NOT NULL,
  password_hash TEXT NOT NULL,        -- Argon2id hash
  role TEXT NOT NULL DEFAULT 'user',  -- 'user' or 'admin'
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  deleted_at DATETIME NULL
);

-- Lessons (collections / chapters)
-- ST-004 (CRUD lessons), ST-003 (Import mapping)
CREATE TABLE lessons (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  owner_user_id INTEGER NOT NULL,     -- owner (student) or admin
  title TEXT NOT NULL,
  description TEXT,
  is_deleted INTEGER DEFAULT 0,       -- soft-delete
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(owner_user_id) REFERENCES users(id)
);

-- Lesson items (individual flashcards / words)
-- ST-003 (Import), ST-005a (Flashcards)
CREATE TABLE lesson_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  lesson_id INTEGER NOT NULL,
  english TEXT NOT NULL,
  polish TEXT,
  example TEXT,
  tags TEXT,                          -- simple CSV tags
  phonetic_hint TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(lesson_id, english, polish),
  FOREIGN KEY(lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
);

-- Imports: tracking import jobs and summary
-- ST-003 (Import)
CREATE TABLE imports (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  uploaded_by INTEGER NOT NULL,
  filename TEXT,
  total_rows INTEGER,
  error_rows INTEGER,
  status TEXT NOT NULL DEFAULT 'uploaded', -- uploaded|previewed|committed|failed
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(uploaded_by) REFERENCES users(id)
);

-- Import rows: per-row validation details (keeps per-row errors)
-- ST-003 (Import)
CREATE TABLE import_rows (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  import_id INTEGER NOT NULL,
  row_number INTEGER,
  english TEXT,
  polish TEXT,
  valid INTEGER DEFAULT 0,
  error_message TEXT,
  processed_at DATETIME,
  FOREIGN KEY(import_id) REFERENCES imports(id) ON DELETE CASCADE
);

-- Sessions: student session metadata
-- ST-005a (Flashcards + session), ST-006 (SR), ST-007 (Quizzes)
CREATE TABLE sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  lesson_id INTEGER,
  started_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  finished_at DATETIME,
  duration_seconds INTEGER,
  score INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(lesson_id) REFERENCES lessons(id)
);

-- Session answers / events (autosave each answer)
-- ST-005a, ST-006, ST-007
CREATE TABLE session_answers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  question_id TEXT,
  user_answer TEXT,
  is_correct INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(session_id) REFERENCES sessions(id) ON DELETE CASCADE
);

-- Spaced repetition state per user+item
-- ST-006 (Spaced repetition)
CREATE TABLE spaced_repetition (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  lesson_item_id INTEGER NOT NULL,
  state TEXT NOT NULL DEFAULT 'new',  -- new|learning|review|mastered
  last_reviewed_at DATETIME,
  next_review_at DATETIME,
  interval_days INTEGER DEFAULT 0,
  history JSON, -- optional JSON log of past reviews (SQLite supports JSON functions)
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(lesson_item_id) REFERENCES lesson_items(id),
  UNIQUE(user_id, lesson_item_id)
);

-- Audio cache metadata
-- ST-005a (audio cache)
CREATE TABLE audio_cache (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  hash TEXT NOT NULL UNIQUE,          -- hash(word+engine+accent)
  word TEXT NOT NULL,
  engine TEXT NOT NULL,
  accent TEXT,
  path TEXT NOT NULL,                 -- file path on host volume (./data/audio-cache/...)
  size_bytes INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  last_accessed_at DATETIME
);

-- Exports tracking (admin exports)
-- ST-009 (Admin exports)
CREATE TABLE exports (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  requested_by INTEGER NOT NULL,
  period TEXT,
  format TEXT DEFAULT 'csv',
  status TEXT DEFAULT 'pending',      -- pending|ready|failed
  file_path TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  completed_at DATETIME,
  FOREIGN KEY(requested_by) REFERENCES users(id)
);

-- Audit log for admin actions and export/import
-- ST-002 (admin actions), ST-009 (exports), ST-003 (import audit), ST-011 (data deletion audit)
CREATE TABLE audit_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  actor_user_id INTEGER,
  action TEXT NOT NULL,
  target_table TEXT,
  target_id INTEGER,
  details TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(actor_user_id) REFERENCES users(id)
);

-- Indexes to improve performance for MVP targets
CREATE INDEX idx_sessions_user ON sessions(user_id);
CREATE INDEX idx_spaced_user_item ON spaced_repetition(user_id, lesson_item_id);
CREATE INDEX idx_audio_hash ON audio_cache(hash);
CREATE INDEX idx_imports_status ON imports(status);

-- Initial seed metadata (optional): store story mapping table
-- This table maps story IDs to API endpoints/tables for traceability
CREATE TABLE rtm_mapping (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  story_id TEXT NOT NULL,    -- e.g., 'ST-001'
  endpoint TEXT,             -- API path (if applicable)
  table_name TEXT,           -- DDL table name related to story
  notes TEXT
);

-- Example RTM entries (insert statements)
INSERT INTO rtm_mapping (story_id, endpoint, table_name, notes) VALUES ('ST-001', '/api/auth/login', 'users', 'Authentication: email+password; Argon2id');
INSERT INTO rtm_mapping (story_id, endpoint, table_name, notes) VALUES ('ST-002', '/api/admin/users', 'users', 'Admin user CRUD and audit');
INSERT INTO rtm_mapping (story_id, endpoint, table_name, notes) VALUES ('ST-003', '/api/imports', 'imports, import_rows, lesson_items', 'Import CSV/JSON mapping');
INSERT INTO rtm_mapping (story_id, endpoint, table_name, notes) VALUES ('ST-004', '/api/users/{userId}/lessons', 'lessons, lesson_items', 'Lesson CRUD');
INSERT INTO rtm_mapping (story_id, endpoint, table_name, notes) VALUES ('ST-005a', '/api/sessions/{sessionId}/answer', 'sessions, session_answers, audio_cache', 'Flashcards & TTS playback');
INSERT INTO rtm_mapping (story_id, endpoint, table_name, notes) VALUES ('ST-005b', '/api/tts/generate', 'audio_cache', 'TTS config & test');
INSERT INTO rtm_mapping (story_id, endpoint, table_name, notes) VALUES ('ST-006', '/api/sessions/{sessionId}/answer', 'spaced_repetition', 'Spaced repetition engine state');
INSERT INTO rtm_mapping (story_id, endpoint, table_name, notes) VALUES ('ST-007', '/api/sessions/{sessionId}/answer', 'session_answers', 'Quiz answers and scoring');
INSERT INTO rtm_mapping (story_id, endpoint, table_name, notes) VALUES ('ST-008', '/api/users/{userId}/lessons', 'lessons', 'Student dashboard metrics');
INSERT INTO rtm_mapping (story_id, endpoint, table_name, notes) VALUES ('ST-009', '/api/admin/exports', 'exports, audit_logs', 'Admin exports and audit');
INSERT INTO rtm_mapping (story_id, endpoint, table_name, notes) VALUES ('ST-010', '/api/users/{userId}/lessons', 'lessons', 'Student lesson management');
INSERT INTO rtm_mapping (story_id, endpoint, table_name, notes) VALUES ('ST-011', '/api/users/{userId}', 'users, audit_logs', 'Privacy & data deletion');
INSERT INTO rtm_mapping (story_id, endpoint, table_name, notes) VALUES ('ST-012', '/api/tts/generate', 'audio_cache', 'TTS accent & test');

-- End of schema