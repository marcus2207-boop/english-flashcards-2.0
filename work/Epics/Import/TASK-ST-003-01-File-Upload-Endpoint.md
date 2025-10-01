# TASK-ST-003-01: Implement file upload endpoint and imports row

Identity
- TITLE (TK-ID): Implement file upload endpoint and imports row (TASK-ST-003-01)

Goal
- GOAL AND RESULT: Implement POST /api/imports to accept multipart/form-data uploads, persist the uploaded file to ./data/imports/, create an imports row with status='uploaded' and return importId. Result: upload storage + DB row for later preview/parse steps.

Context (INPUTS)
- API Contract: `openapi/openapi.yaml` — POST /api/imports
- DDL/Model: `db/schema.sql` — imports table
- UX: Admin Import UI — `UX_UI_Design_Package.md` (admin import screen)
- RTM: ST-003 (Import)

Plan (SCOPE AND IMPLEMENTATION STEPS)
1. Add Pydantic response schema ImportCreated (id, status) in `backend/app/schemas/imports.py` or extend existing schemas.
2. Create route handler `POST /api/imports` in `backend/app/routes/imports.py`:
   - Require admin role + CIDR enforcement dependency.
   - Accept multipart/form-data field `file`.
   - Validate file extension (.csv or .json) and basic mime type.
   - Enforce max file size (configurable, default 5MB).
   - Save raw file under `./data/imports/{YYYYMMDD}/{timestamp}_{uuid}_{original_name}` ensuring directories exist.
   - Insert imports row with uploaded_by=current_user.id, filename=stored_path, status='uploaded'.
   - Return 202 Accepted (or 201) with { importId }.
3. Log audit event in audit_logs (actor_user_id, action 'upload_import', details).
4. Add minimal error handling (missing file => 400; invalid type => 415; storage error => 500).
5. Document upload usage in `smoke-tests/README.md` linking to `smoke-tests/import-e2e.sh`.

Files (FILES TO CREATE/CHANGE)
- Create: `backend/app/routes/imports.py`
- Create/Modify: `backend/app/schemas/imports.py`
- Create: `backend/tests/test_import_upload.py`
- Create: `./data/imports/.gitkeep` (ensure dir presence)
- Modify: register router in `backend/app/main.py` if necessary

Quality (REQUIRED TESTS)
- Unit tests:
  - POST with valid small CSV creates imports row and stores file.
  - POST missing file returns 400.
  - POST invalid extension returns 415.
- Integration test:
  - Use TestClient to upload sample CSV and assert imports row exists and file saved.
- Lint and type checks.

Budget (NFR TARGETS)
- Supports uploads up to 5MB by default; document ENV override (IMPORT_MAX_SIZE_BYTES).
- Secure file storage: sanitize filenames, use UUID prefixes, avoid path traversal.

DoD (DEFINITION OF DONE)
- [ ] POST /api/imports implemented and registered
- [ ] Uploaded file stored under ./data/imports with unique name
- [ ] imports DB row created with status='uploaded' and uploaded_by set
- [ ] Audit log entry created
- [ ] Unit/integration tests added and passing
- [ ] README updated with how to run import-e2e smoke test

Metadata (TIME AND RISKS)
- Estimated time: 0.5–1 day
- Risks: host volume permissions — mitigate by documenting required volume mount in docker-compose and checking at startup