# ST-001 — Authentication: email + password

Persona: P-001 (Uczeń), P-002 (Rodzic/Admin)  
Priority: Must (MVP)  
Estimated size: M (2–3 days total; can be broken into atomics)

Summary
- Implement authentication endpoint and session handling.
- Requirements: Argon2id password hashing, secure HttpOnly session cookie, rate limiting for login attempts.

Acceptance Criteria (AC)
- Email validated (basic RFC compliance).
- Password minimum 10 characters enforced on registration/create user.
- Argon2id hashing used with default params (time=2, mem=64MB, parallelism=1) and configurable via env.
- Successful login issues secure HttpOnly cookie (SameSite=Lax).
- Rate limiting: max 10 login attempts per minute per IP.
- Unit tests covering hash verification and rate-limiter behavior.
- Integration test for login -> cookie set -> access protected endpoint.

Implementation Notes
- Backend: FastAPI dependency (preferred), use passlib/argon2 for hashing.
- Storage: users table (see `db/schema.sql` users table).
- Endpoints:
  - POST /api/auth/login — request {email,password} — returns 200 and sets session cookie or 401.
- Security:
  - Ensure cookies have Secure=true when HTTPS is used (configurable).
  - Logging: audit_logs entry for admin/critical auth events if applicable.

Atomic Tasks (0.5–2 days each)
- Task 1: Add Argon2id config + utility wrapper (hash, verify) — 0.5 day
- Task 2: Implement POST /api/auth/login endpoint (validate, verify, set cookie) — 1 day
- Task 3: Implement rate-limiting middleware for login endpoint — 1 day
- Task 4: Unit tests for hashing & login flow — 0.5 day
- Task 5: Integration test for session cookie and protected route access — 1 day

RTM / Traceability
- Linked RTM: ST-001 -> `/api/auth/login` (OpenAPI annotated)
- DB: users.email, users.password_hash

Notes for AI Agent
- Provide exact library choices (passlib, fastapi-users optional) in task description.
- Use test fixtures to create a temporary SQLite DB for unit/integration tests.
- Mark any env vars required in .env.sample (ARGON2_TIME, ARGON2_MEMORY_KB, ARGON2_PARALLELISM, SESSION_SECRET).
