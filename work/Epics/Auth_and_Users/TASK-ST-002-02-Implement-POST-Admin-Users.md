# TASK-ST-002-02: Implement POST /api/admin/users with validation + Argon2 handling

Identity
- TITLE (TK-ID): Implement POST /api/admin/users with validation + Argon2 password handling (TASK-ST-002-02)

Goal
- GOAL AND RESULT: Implement admin endpoint to create user accounts with validation, Argon2id password hashing, role assignment, and audit log entry. Result: working POST /api/admin/users with unit tests.

Context (INPUTS)
- Story: ST-002 — Admin user management (`work/Epics/Auth_and_Users/ST-002-Admin-Users.md`)
- OpenAPI: Additions from TASK-ST-002-01
- DB: `users` table (`db/schema.sql`) and `audit_logs` table
- Auth util: Argon2id hashing from TASK-ST-001-01

Plan (SCOPE AND IMPLEMENTATION STEPS)
1. Add Pydantic schema UserCreate (email, nickname, password, role) if not already present in OpenAPI/schema tasks.
2. Implement route handler `POST /api/admin/users` in `backend/app/routes/admin_users.py`:
   - Validate payload (email RFC basic, password min 10 chars).
   - Ensure email uniqueness (query users table).
   - Hash password with Argon2 utility and store password_hash.
   - Create user row with role (default 'user' if not provided).
   - Create audit_logs entry with actor_user_id and action 'create_user' and details (new user id/email).
   - Return 201 with created user (UserOut).
3. Add unit tests `backend/tests/test_admin_users_create.py`:
   - Test creating user succeeds and password stored hashed.
   - Test duplicate email returns 400.
   - Test admin-only access enforced (mock current_user role).
4. Add check for >20 accounts warning: if count(users) > 20 after create, include header X-Warning or include warning in response body (per AC).

Files (FILES TO CREATE/CHANGE)
- Create/Modify:
  - `backend/app/routes/admin_users.py`
  - `backend/app/schemas/admin_users.py` (or extend schemas)
  - `backend/tests/test_admin_users_create.py`
  - Register router in `backend/app/main.py`

Quality (REQUIRED TESTS)
- Unit tests for happy path and duplicate email.
- Lint/type checks.

DoD (DEFINITION OF DONE)
- [ ] POST /api/admin/users implemented and returns 201 with user data
- [ ] Password stored hashed using Argon2 utility
- [ ] Audit log entry created
- [ ] Unit tests added and passing
- [ ] Response includes warning when total user count >20

Metadata (TIME AND RISKS)
- Estimated time: 1 day
- Risks: race condition on unique email in concurrent creates — recommend DB unique constraint and handle IntegrityError.