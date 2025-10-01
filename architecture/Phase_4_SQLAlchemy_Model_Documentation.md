# Phase 4.A — SQLAlchemy Models Documentation (Column Reference)

Wersja: 0.1  
Data: 2025-10-01

Dokumentacja wygenerowana automatycznie na podstawie `backend/app/models.py`. Zawiera listę modeli (tabel) i ich kolumn — użyteczna do mapowania kolumn ↔ ST-XXX.

## Uwaga
- Typy i nazwy kolumn zaprojektowane pod SQLite z kompatybilnością Postgres.
- Kolumny służą jako docelowe elementy RTM (kolumna-level mapping) — szczegóły w `architecture/rtm_mapping_columns.csv`.

---

## users (table)
- id: INTEGER PRIMARY KEY AUTOINCREMENT
- email: STRING (TEXT) NOT NULL UNIQUE
- nickname: STRING (TEXT) NOT NULL
- password_hash: TEXT NOT NULL
- role: STRING (TEXT) NOT NULL DEFAULT 'user'
- created_at: DATETIME DEFAULT CURRENT_TIMESTAMP
- deleted_at: DATETIME NULL

Powiązane ST: ST-001, ST-002, ST-011

## lessons (table)
- id: INTEGER PRIMARY KEY AUTOINCREMENT
- owner_user_id: INTEGER NOT NULL (FK -> users.id)
- title: STRING NOT NULL
- description: TEXT
- is_deleted: BOOLEAN DEFAULT False
- created_at: DATETIME DEFAULT CURRENT_TIMESTAMP
- updated_at: DATETIME DEFAULT CURRENT_TIMESTAMP

Powiązane ST: ST-004, ST-010, ST-008

## lesson_items (table)
- id: INTEGER PRIMARY KEY AUTOINCREMENT
- lesson_id: INTEGER NOT NULL (FK -> lessons.id)
- english: STRING NOT NULL
- polish: STRING
- example: TEXT
- tags: STRING (CSV)
- phonetic_hint: STRING
- created_at: DATETIME DEFAULT CURRENT_TIMESTAMP

Powiązane ST: ST-003, ST-005a

## imports (table)
- id: INTEGER PRIMARY KEY AUTOINCREMENT
- uploaded_by: INTEGER NOT NULL (FK -> users.id)
- filename: STRING
- total_rows: INTEGER
- error_rows: INTEGER
- status: STRING NOT NULL DEFAULT 'uploaded'
- created_at: DATETIME DEFAULT CURRENT_TIMESTAMP

Powiązane ST: ST-003

## import_rows (table)
- id: INTEGER PRIMARY KEY AUTOINCREMENT
- import_id: INTEGER NOT NULL (FK -> imports.id)
- row_number: INTEGER
- english: STRING
- polish: STRING
- valid: BOOLEAN DEFAULT False
- error_message: TEXT
- processed_at: DATETIME

Powiązane ST: ST-003

## sessions (table)
- id: INTEGER PRIMARY KEY AUTOINCREMENT
- user_id: INTEGER NOT NULL (FK -> users.id)
- lesson_id: INTEGER (FK -> lessons.id)
- started_at: DATETIME DEFAULT CURRENT_TIMESTAMP
- finished_at: DATETIME
- duration_seconds: INTEGER
- score: INTEGER
- created_at: DATETIME DEFAULT CURRENT_TIMESTAMP

Powiązane ST: ST-005a, ST-006, ST-007

## session_answers (table)
- id: INTEGER PRIMARY KEY AUTOINCREMENT
- session_id: INTEGER NOT NULL (FK -> sessions.id)
- question_id: STRING
- user_answer: TEXT
- is_correct: BOOLEAN DEFAULT False
- created_at: DATETIME DEFAULT CURRENT_TIMESTAMP

Powiązane ST: ST-005a, ST-006, ST-007

## spaced_repetition (table)
- id: INTEGER PRIMARY KEY AUTOINCREMENT
- user_id: INTEGER NOT NULL (FK -> users.id)
- lesson_item_id: INTEGER NOT NULL (FK -> lesson_items.id)
- state: STRING NOT NULL DEFAULT 'new'
- last_reviewed_at: DATETIME
- next_review_at: DATETIME
- interval_days: INTEGER DEFAULT 0
- history: TEXT (JSON stored as text for SQLite)

Powiązane ST: ST-006

## audio_cache (table)
- id: INTEGER PRIMARY KEY AUTOINCREMENT
- hash: STRING NOT NULL UNIQUE
- word: STRING NOT NULL
- engine: STRING NOT NULL
- accent: STRING
- path: STRING NOT NULL
- size_bytes: INTEGER
- created_at: DATETIME DEFAULT CURRENT_TIMESTAMP
- last_accessed_at: DATETIME

Powiązane ST: ST-005a, ST-005b, ST-012

## exports (table)
- id: INTEGER PRIMARY KEY AUTOINCREMENT
- requested_by: INTEGER NOT NULL (FK -> users.id)
- period: STRING
- format: STRING DEFAULT 'csv'
- status: STRING DEFAULT 'pending'
- file_path: STRING
- created_at: DATETIME DEFAULT CURRENT_TIMESTAMP
- completed_at: DATETIME

Powiązane ST: ST-009

## audit_logs (table)
- id: INTEGER PRIMARY KEY AUTOINCREMENT
- actor_user_id: INTEGER
- action: STRING NOT NULL
- target_table: STRING
- target_id: INTEGER
- details: TEXT
- created_at: DATETIME DEFAULT CURRENT_TIMESTAMP

Powiązane ST: ST-002, ST-003, ST-009, ST-011

## rtm_mapping (table)
- id: INTEGER PRIMARY KEY AUTOINCREMENT
- story_id: STRING NOT NULL
- endpoint: STRING
- table_name: STRING
- notes: TEXT

Użycie: tabela pomocnicza do śledzenia mapowania RTM -> endpointy/tabele. Zawiera wpisy INSERT w `db/schema.sql` oraz CSV w `architecture/rtm_mapping.csv`.

---

Plik następny: `architecture/rtm_mapping_columns.csv` (tworzę teraz) będzie zawierać kolumnowy poziom mapowania (story_id, endpoint, table, column, notes).