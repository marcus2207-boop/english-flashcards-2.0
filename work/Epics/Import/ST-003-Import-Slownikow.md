# ST-003 — Import słówek (CSV/JSON)

Persona: P-002 (Rodzic / Admin)  
Priority: Must (MVP)  
Estimated size: L (3–5 days overall; broken into atomic tasks)

Summary
- Implement import pipeline allowing admins to upload CSV/JSON files containing vocabulary rows (english, polish, optional example, tags).
- Provide preview with per-row validation, inline edit for small errors, and transactional commit semantics (reject commit if >50% rows invalid).
- Performance target: 20–200 rows end-to-end <10s (measured in smoke-tests).

Acceptance Criteria (AC)
- POST /api/imports accepts multipart/form-data file and returns importId.
- GET /api/imports/{importId}/preview returns parsed rows with per-row validation (valid flag, error_message).
- POST /api/imports/{importId}/commit commits valid rows into lesson_items, updates imports summary (total_rows/error_rows/status).
- Per-row deduplication (unique lesson_id + english + polish) on commit.
- Transactional behavior: if >50% rows invalid, commit fails and status=failed; partial commit not allowed.
- Inline edit: preview allows edit of up to 10 rows (frontend), but backend supports updated payload on commit.
- Unit/integration tests covering parsing, validation, deduplication, rollback behavior.
- Performance smoke-test script available: `smoke-tests/import-e2e.sh`.

Implementation Notes
- Parsing: use Python csv module (handle UTF-8 and BOM), validate required columns 'english' and 'polish'.
- Validation rules: non-empty english; optional polish; trim whitespace; max lengths (english 255, polish 255).
- Storage: imports table + import_rows + lesson_items tables (see `db/schema.sql`).
- API: conform to OpenAPI spec entries.
- Idempotency: uploading same file twice should create separate import job IDs; commit should be guarded by import job id.

Atomic Tasks (0.5–2 days)
- Task 1: Implement file upload endpoint and store raw file + create imports row — 0.5 day
- Task 2: Implement parser job that creates import_rows with validation flags (sync for MVP) — 1 day
- Task 3: Implement preview endpoint returning paged preview and validation results — 0.5 day
- Task 4: Implement commit endpoint with transactional insert into lesson_items and imports summary update — 1 day
- Task 5: Deduplication logic + tests — 0.5 day
- Task 6: Integration tests + performance measurement (hook smoke-test) — 1 day

RTM / Traceability
- Linked RTM: ST-003 -> `/api/imports`, `/api/imports/{importId}/preview`, `/api/imports/{importId}/commit`
- DB: imports, import_rows, lesson_items

Notes for AI Agent
- Provide exact parsing behavior; prefer streaming parse for large files but MVP can use memory parse for 200 rows.
- Use database transactions and ensure rollback on failure.
- Add unit tests using temporary SQLite DB and fixture CSV files (valid, mixed, >50% invalid).