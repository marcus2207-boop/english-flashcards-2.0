# TASK-ST-001-02: Implement POST /api/auth/login endpoint

Identity
- TITLE (TK-ID): Implement POST /api/auth/login endpoint (TASK-ST-001-02)

Goal
- GOAL AND RESULT: Implement the login endpoint that validates input, verifies password using Argon2id utility, creates a server-side session (or signed session cookie), and returns user info. Result: working endpoint with unit tests and integration test stubs.

Context (INPUTS)
- API Contract: `openapi/openapi.yaml` — POST /api/auth/login (see lines ~13-40)
- DDL/Model: `db/schema.sql` users table (users.email, users.password_hash)
- RTM: ST-001
- Auth util: `work/Epics/Auth_and_Users/TASK-ST-001-01-Argon2id-Utility.md` (hash/verify functions)
- UX: Login flow in `UX_UI_Design_Package.md`: lines ~29-36

Plan (SCOPE AND IMPLEMENTATION STEPS)
1. Add Pydantic request schema for login (email, password) in `backend/app/schemas.py` or create `backend/app/schemas/auth.py`.
2. Implement endpoint handler in `backend/app/main.py` or `backend/app/routes/auth.py`:
   - Validate request body
   - Lookup user by email in DB
   - If no user -> return 401
   - Verify password via Argon2id util; on failure return 401 and increment rate limiter (handled separately)
   - On success, create session cookie:
     - Generate session token (signed cookie or UUID + server-side session store)
     - Set cookie attributes: HttpOnly, Secure conditional on config, SameSite=Lax
   - Return minimal user payload (id, email, nickname, role)
3. Use dependency to get DB session (SQLAlchemy) and current config for cookie settings.
4. Add unit tests for handler logic (mock DB, password verify) in `backend/tests/test_auth.py`.
5. Add integration test that runs the app with test client (TestClient) to POST login and assert cookie set and protected route accessible.

Files (FILES TO CREATE/CHANGE)
- Create/Modify:
  - `backend/app/routes/auth.py` (new)
  - `backend/app/schemas/auth.py` (new or modify existing)
  - `backend/tests/test_auth.py` (new)
  - optionally modify `backend/app/main.py` to include auth router
  - add `.env.sample` notes for SESSION_SECRET / COOKIE_SECURE (if not present)

Quality (REQUIRED TESTS)
- Unit tests verifying:
  - correct 401 on missing user
  - correct 401 on wrong password
  - correct 200 and cookie set on success
- Integration test:
  - run TestClient, perform login, assert Set-Cookie header and that subsequent request to protected endpoint succeeds.
- Lint and static type checks.

Budget (NFR TARGETS)
- Response time: login should be reasonably fast (<200ms typical), but NFRs concentrate on other endpoints.
- Security: Ensure cookies have Secure=true when HTTPS enabled.

DoD (DEFINITION OF DONE)
- [ ] `backend/app/routes/auth.py` implemented and registered
- [ ] Unit tests in `backend/tests/test_auth.py` pass
- [ ] Integration test demonstrates cookie set and protected route access
- [ ] Documentation snippet added to README for env vars related to sessions

Metadata (TIME AND RISKS)
- Estimated time: 1 day
- Risks: session management choice (signed cookie vs server-side store) — pick signed cookie for MVP simplicity; document tradeoffs.