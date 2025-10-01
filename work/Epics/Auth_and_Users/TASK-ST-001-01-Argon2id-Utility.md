# TASK-ST-001-01: Add Argon2id config + utility wrapper

Identity
- TITLE (TK-ID): Add Argon2id config + utility wrapper (TASK-ST-001-01)

Goal
- GOAL AND RESULT: Deliver a reusable password hashing utility for Argon2id with configuration driven by env vars and unit tests. Result: working module with hash(password) and verify(password, hash) functions and documented env variables.

Context (INPUTS)
- API/Event Contract: POST /api/auth/login (see `openapi/openapi.yaml`:13)
- DDL/Model: users.password_hash column (`db/schema.sql`:12-16)
- UI Design: login/register flows referenced in `UX_UI_Design_Package.md`: lines 29-36
- RTM references: ST-001
- Files referencing: backend/app/models.py (User), backend/app/schemas.py

Plan (SCOPE AND IMPLEMENTATION STEPS)
1. Add env vars to `.env.sample` (ARGON2_TIME, ARGON2_MEMORY_KB, ARGON2_PARALLELISM).
2. Create new module `backend/app/auth/hash.py` implementing:
   - load config from env with sensible defaults (time=2, memory_kb=65536, parallelism=1)
   - function hash_password(password: str) -> str
   - function verify_password(password: str, hash: str) -> bool
   - use passlib (argon2) or argon2-cffi; include fallback instructions in comments.
3. Add unit tests in `backend/tests/test_hash.py`:
   - test hash/verify roundtrip
   - test wrong password fails
   - test config override via env var
4. Update `README.md` (or `docs/`) with minimal usage snippet and env var descriptions.
5. Ensure packaging: add passlib or argon2-cffi to `backend/pyproject.toml` dependencies if missing (document only; PR to modify dependencies will be separate).

Files (FILES TO CREATE/CHANGE)
- Create: `backend/app/auth/hash.py`
- Create: `backend/tests/test_hash.py`
- Modify: `.env.sample` (add ARGON2_* entries) — if file exists
- Modify (optional): `backend/pyproject.toml` to include dependency note (or create an issue to add dependency)

Quality (REQUIRED TESTS)
- Unit tests in `backend/tests/test_hash.py` covering hash + verify and config overrides
- Lint: pass flake8/ruff rules and type checks (mypy optional)
- Security: ensure no plaintext passwords logged

Budget (NFR TARGETS)
- Execution time negligible (local hashing in unit tests) — acceptable CPU; ensure tests run under CI time budget.

DoD (DEFINITION OF DONE)
- [ ] `backend/app/auth/hash.py` created and imported where needed
- [ ] Unit tests pass (`pytest`)
- [ ] `.env.sample` updated with ARGON2_* variables and defaults documented
- [ ] No plaintext password output in logs
- [ ] PR-ready changelist and brief implementation note for reviewer

Metadata (TIME AND RISKS)
- Estimated time: 0.5 day
- Risks: missing dependency (passlib/argon2-cffi) — mitigated by adding dependency note and CI step