# TASK-ST-001-04: Unit tests for hashing & login flow

Identity
- TITLE (TK-ID): Unit tests for hashing & login flow (TASK-ST-001-04)

Goal
- GOAL AND RESULT: Create unit tests that validate the Argon2id utility and the login handler logic in isolation. Result: test suite that ensures hashing/verification correctness and basic login flow behaviors (successful login path and failure modes).

Context (INPUTS)
- Hash utility: `backend/app/auth/hash.py` (TASK-ST-001-01)
- Login handler: `backend/app/routes/auth.py` (TASK-ST-001-02)
- DB model: `backend/app/models.py` users table
- RTM: ST-001
- Test runner: pytest (project uses pytest in CI)

Plan (SCOPE AND IMPLEMENTATION STEPS)
1. Create test file `backend/tests/test_hash.py`:
   - Test hash/verify roundtrip for sample password.
   - Test that incorrect password fails verification.
   - Test environment overrides (e.g., ARGON2_TIME) by monkeypatching env and re-importing config if necessary.
2. Create test file `backend/tests/test_auth_handler_unit.py`:
   - Mock DB session lookup to return a user object with precomputed password_hash (use hash utility to create).
   - Mock Argon2 verify to simulate failure and success scenarios if needed.
   - Test cases:
     - Login with unknown email -> handler returns 401
     - Login with wrong password -> handler returns 401
     - Login with correct credentials -> handler returns 200 and sets cookie (assert set_cookie called on response object or returned dict includes session info depending on implementation)
   - Ensure rate-limiter dependency is bypassed or mocked so unit tests do not trigger rate limit.
3. Use fixtures for temporary config and in-memory DB if required (sqlite:///:memory:).
4. Ensure tests run fast and avoid external dependencies (no network, no Coqui).

Files (FILES TO CREATE/CHANGE)
- Create: `backend/tests/test_hash.py`
- Create: `backend/tests/test_auth_handler_unit.py`
- Modify (optional): `backend/conftest.py` to add fixtures for test client, temp DB, and monkeypatch helpers if not present.

Quality (REQUIRED TESTS)
- Tests must run in CI and pass under pytest.
- Provide clear assertions and cleanup.
- Coverage: these unit tests should cover the main logic branches for hash verification and login handler success/failure.

DoD (DEFINITION OF DONE)
- [ ] `backend/tests/test_hash.py` exists and passes
- [ ] `backend/tests/test_auth_handler_unit.py` exists and passes
- [ ] Tests are self-contained and do not require external services
- [ ] Tests documented in README or test-run instructions

Metadata (TIME AND RISKS)
- Estimated time: 0.5 day
- Risks: flaky tests due to improper fixture isolation — mitigate by using tmp paths and isolated envs