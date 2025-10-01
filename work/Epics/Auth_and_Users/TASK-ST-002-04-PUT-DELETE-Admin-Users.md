# TASK-ST-002-04: Implement PUT/DELETE for admin user modifications and soft-delete behavior

Identity
- TITLE (TK-ID): Implement PUT/DELETE for admin user modifications and soft-delete behavior (TASK-ST-002-04)

Goal
- GOAL AND RESULT: Implement endpoints to update user metadata (nickname, role) and to soft-delete users (set deleted_at / is_deleted). Result: working PUT and DELETE endpoints with tests and audit logging.

Context (INPUTS)
- Story: ST-002 — Admin user management
- DB: users table supports deleted_at / is_deleted semantics
- RTM: ST-002

Plan (SCOPE AND IMPLEMENTATION STEPS)
1. Implement PUT /api/admin/users/{userId}:
   - Validate payload (UserUpdate schema).
   - Apply updates (nickname, role).
   - Prevent demoting last admin if that would leave system without admin (optional policy).
   - Create audit_log entry: action 'update_user' with details.
2. Implement DELETE /api/admin/users/{userId}:
   - Soft-delete: set deleted_at to current timestamp and is_deleted flag (or rename field).
   - Do not cascade delete dependent data; record audit_log 'delete_user'.
   - Ensure admin-only + CIDR checks apply.
3. Add unit tests `backend/tests/test_admin_users_modify_delete.py`:
   - Test PUT updates fields and audit log created.
   - Test DELETE sets deleted_at and audit log entry exists.
   - Test 403 when non-admin attempts modifications.

Files (FILES TO CREATE/CHANGE)
- Modify: `backend/app/routes/admin_users.py` (add PUT/DELETE handlers)
- Create: `backend/tests/test_admin_users_modify_delete.py`

Quality (REQUIRED TESTS)
- Unit tests for update and delete flows; audit log verification.

DoD (DEFINITION OF DONE)
- [ ] PUT implemented and updates user fields
- [ ] DELETE implemented as soft-delete
- [ ] Audit logs created for both operations
- [ ] Tests added and passing

Metadata (TIME AND RISKS)
- Estimated time: 0.5 day
- Risks: policy for admin demotion — recommend confirming policy or implementing safe guard