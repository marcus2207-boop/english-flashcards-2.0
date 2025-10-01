# ST-004 — CRUD lekcji/rozdziałów

Persona: P-001 (Uczeń), P-002 (Rodzic/Admin)  
Priority: Must (MVP)  
Estimated size: M (1.5–2 days total; broken into atomics)

Summary
- Implement endpoints and UI for creating, listing, updating, and soft-deleting lessons (collections of lesson_items).
- Ownership rules: owner_user_id can edit; admin can override. Soft-delete retention 30 days.

Acceptance Criteria (AC)
- Endpoints: GET /api/users/{userId}/lessons, POST /api/users/{userId}/lessons, GET /api/lessons/{id}, PUT /api/lessons/{id}, DELETE /api/lessons/{id} (soft-delete).
- Soft-delete: set is_deleted flag; deleted lessons excluded from normal lists; restore possible by admin within 30 days.
- Concurrency: last-write-wins with warning on conflicting updates.
- Unit and integration tests for ownership enforcement and soft-delete behavior.

Implementation Notes
- Storage: lessons table (see `db/schema.sql`).
- Frontend: lesson list and lesson details pages; lesson creation flows integrated with import commit dialog.
- Pagination for lesson lists (offset/limit), default limit 50.

Atomic Tasks (0.5–2 days)
- Task 1: Implement lesson list endpoint (GET /api/users/{userId}/lessons) with ownership filter and pagination — 0.5 day
- Task 2: Implement POST /api/users/{userId}/lessons create endpoint with validation and owner assignment — 0.5 day
- Task 3: Implement GET/PUT/DELETE for lesson details + soft-delete semantics — 1 day
- Task 4: Tests for ownership and soft-delete + integration with import commit — 1 day

RTM / Traceability
- Linked RTM: ST-004 -> `/api/users/{userId}/lessons`
- DB: lessons, lesson_items

Notes for AI Agent
- Use Pydantic models for create/update payloads; validate title non-empty and max length 255.
- Ensure lesson list endpoint returns basic stats required by dashboard (mastered count, avg score).