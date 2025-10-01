# TASK-ST-002-03: Implement GET /api/admin/users (listing + filters + pagination)

Identity
- TITLE (TK-ID): Implement GET /api/admin/users (listing + filters + pagination) (TASK-ST-002-03)

Goal
- GOAL AND RESULT: Provide an admin-only endpoint to list users with pagination and filtering (by role), returning UserOut records and minimal stats. Result: GET /api/admin/users implemented with tests and documented query parameters.

Context (INPUTS)
- Story: ST-002 — Admin user management
- OpenAPI: ensure path added (TASK-ST-002-01)
- DB: users table with indexes for email/role
- RTM: ST-002

Plan (SCOPE AND IMPLEMENTATION STEPS)
1. Define query parameters: page (int, default 1), limit (int, default 50, max 200), role (optional).
2. Implement route handler in `backend/app/routes/admin_users.py`:
   - Enforce admin-only access and CIDR check dependency.
   - Compute offset = (page-1)*limit, run query with optional WHERE role=:role and NOT is_deleted (or include deleted flag via param).
   - Return payload: { items: [UserOut], total: int, page: int, limit: int }.
3. Add DB optimizations: ensure query uses index on role; add limit cap.
4. Add unit tests `backend/tests/test_admin_users_list.py`:
   - Test pagination boundaries, role filter, and is_deleted exclusion.
   - Test large page returns empty list gracefully.
5. Update OpenAPI docs or ensure TASK-ST-002-01 added appropriate spec.

Files (FILES TO CREATE/CHANGE)
- Modify/Create:
  - `backend/app/routes/admin_users.py` (append GET handler)
  - `backend/tests/test_admin_users_list.py`

Quality (REQUIRED TESTS)
- Unit tests covering role filter, pagination, and exclusion of soft-deleted users.
- Performance: listing should run efficiently for small MVP datasets.

DoD (DEFINITION OF DONE)
- [ ] GET /api/admin/users implemented and returns paginated UserOut list
- [ ] Tests added and passing
- [ ] OpenAPI path item present or referenced
- [ ] CIDR + admin role enforcement in place for endpoint

Metadata (TIME AND RISKS)
- Estimated time: 0.5 day
- Risks: none significant; ensure indexing if dataset grows