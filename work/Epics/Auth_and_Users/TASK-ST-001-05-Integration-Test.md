# TASK-ST-001-05: Integration test for session cookie and protected route access

Identity
- TITLE (TK-ID): Integration test for session cookie and protected route access (TASK-ST-001-05)

Goal
- GOAL AND RESULT: Provide an integration test that exercises full auth flow: create test user (seed), POST /api/auth/login, assert Set-Cookie header, then call a protected endpoint with cookie and assert access is granted. Result: an automated integration test `backend/tests/test_auth_integration.py` that can run in CI.

Context (INPUTS)
- Endpoints: POST /api/auth/login, protected endpoint (create a small protected test route if needed)
- DB: SQLite test DB via alembic or SQLAlchemy create_all in test fixture
- RTM: ST-001

Plan (SCOPE AND IMPLEMENTATION STEPS)
1. Create integration test file `backend/tests/test_auth_integration.py`.
2. Implement fixtures in `backend/conftest.py` for TestClient with app configured to use in-memory SQLite and test settings (SESSION_SECRET, cookie secure off).
3. Seed a test user into the DB using the Argon2 hash utility.
4. Perform TestClient POST /api/auth/login with correct credentials; assert response status 200 and presence of Set-Cookie header with session cookie.
5. Use TestClient with returned cookies to call a protected endpoint (create a simple /api/test/protected that requires auth for tests) and assert 200.
6. Clean up DB after test.

Files (FILES TO CREATE/CHANGE)
- Create: `backend/tests/test_auth_integration.py`
- Modify/Create: `backend/conftest.py` (fixtures) if not present

Quality (REQUIRED TESTS)
- Integration test must be deterministic and self-contained (no external services).
- Ensure test CI configuration runs integration tests in a dedicated environment.

DoD (DEFINITION OF DONE)
- [ ] `backend/tests/test_auth_integration.py` exists and passes locally
- [ ] Test uses fixtures and is idempotent
- [ ] Documentation for running integration tests in README or test README

Metadata (TIME AND RISKS)
- Estimated time: 1 day
- Risks: environment config differences between local and CI (mitigate via fixtures)