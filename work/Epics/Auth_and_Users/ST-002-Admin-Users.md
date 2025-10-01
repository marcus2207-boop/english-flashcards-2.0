# ST-002 — Admin: create/manage student accounts

Persona: P-002 (Rodzic / Admin)  
Priority: Must (MVP)  
Estimated size: M (1.5–2 days total; can be broken into atomics)

Summary
- Admin functionality for creating and managing student (user) accounts.
- Requirements: unique email, nickname, role assignment (user/admin), audit logging, basic listing and search.

Acceptance Criteria (AC)
- Admin can create a student account with email (unique) and nickname.
- Duplicate email returns validation error.
- Admin can list users and filter by role.
- Audit log entry is created for create/update/delete actions (audit_logs table).
- Warning or confirmation when creating >20 accounts.
- Unit tests for CRUD operations and audit logging.
- OpenAPI: add explicit admin users endpoints (CRUD) — ensure operation descriptions include ST-002.

Implementation Notes
- Backend: FastAPI endpoints under /api/admin/users (GET, POST, PUT, DELETE).
- Storage: users table; audit entries in audit_logs table.
- Security: endpoints restricted to admin role and app-level CIDR check (/admin network enforcement).
- Pagination for listing (offset/limit) with default limit 50.

Atomic Tasks (0.5–2 days each)
- Task 1: OpenAPI stub additions for /api/admin/users (GET/POST/PUT/DELETE) — 0.5 day
- Task 2: Implement POST /api/admin/users with validation + Argon2 password handling for created users — 1 day
- Task 3: Implement GET /api/admin/users (listing + filters + pagination) — 0.5 day
- Task 4: Implement PUT/DELETE for admin user modifications and soft-delete behavior — 0.5 day
- Task 5: Unit tests + integration tests + audit_log verification — 1 day

RTM / Traceability
- Linked RTM: ST-002 -> `/api/admin/users`
- DB: users table, audit_logs

Notes for AI Agent
- Use pydantic models for payload validation; include request/response schemas in OpenAPI.
- Add role checks in dependency injection (FastAPI dependency).
- App-level CIDR check middleware should be referenced in admin endpoints' docs and tested via X-Forwarded-For header mocks.