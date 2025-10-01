# TASK-ST-002-01: Add OpenAPI stubs for /api/admin/users (CRUD)

Identity
- TITLE (TK-ID): Add OpenAPI stubs for /api/admin/users (CRUD) (TASK-ST-002-01)

Goal
- GOAL AND RESULT: Add explicit OpenAPI operation definitions (GET, POST, PUT, DELETE) for /api/admin/users and related schemas so RTM ST-002 is fully represented in spec. Result: updated `openapi/openapi.yaml` with admin users operations and pydantic-compatible schemas.

Context (INPUTS)
- RTM: ST-002 (Admin user management) — see `Final_Verified_Requirements_Document.md`: lines 50-56
- UX: Admin Users page — `UX_UI_Design_Package.md`: lines 35-37
- DB: users table (`db/schema.sql`:8-18)
- Existing OpenAPI file: `openapi/openapi.yaml`

Plan (SCOPE AND IMPLEMENTATION STEPS)
1. Add Pydantic/OpenAPI schemas:
   - UserCreate: email, nickname, password (password optional if admin-created users may be set later)
   - UserUpdate: nickname, role
   - UserOut: id, email, nickname, role, created_at, deleted_at
2. Add path item `/api/admin/users`:
   - GET: list users (parameters: page/limit, filter role), responses 200 -> array of UserOut
   - POST: create user, requestBody -> UserCreate, responses 201 -> UserOut
3. Add path item `/api/admin/users/{userId}`:
   - GET: get user detail (optional)
   - PUT: update user (UserUpdate)
   - DELETE: soft-delete user (sets deleted_at) — 200
4. Annotate each operation description with "Story: ST-002" for RTM traceability.
5. Update `openapi/openapi.yaml` ensuring YAML formatting and run OpenAPI linter (if available).
6. Add a small note in `architecture/rtm_reconciliation_phase1.md` referencing fix applied.

Files (FILES TO CREATE/CHANGE)
- Modify: `openapi/openapi.yaml` (add schemas and operations)
- Modify: `architecture/rtm_reconciliation_phase1.md` (append note that ST-002 stub added)

Quality (REQUIRED TESTS)
- Validate OpenAPI syntax with `openapi-cli` or `swagger-cli` (if available).
- Ensure generated schemas map to Pydantic models (manual review or use codegen check).
- Lint YAML (yamllint) for formatting.

Budget (NFR TARGETS)
- Spec change only; negligible runtime cost.
- Ensure descriptions include RTM ID for traceability.

DoD (DEFINITION OF DONE)
- [ ] `openapi/openapi.yaml` contains admin users CRUD operations and schemas.
- [ ] All operations include "Story: ST-002" annotation.
- [ ] OpenAPI file passes basic lint check (syntax).
- [ ] `architecture/rtm_reconciliation_phase1.md` updated to mark ST-002 addressed.

Metadata (TIME AND RISKS)
- Estimated time: 0.5 day
- Risks: YAML indentation errors — mitigated by linting and small incremental edits.