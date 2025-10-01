# RTM Reconciliation — Phase 1 (Summary)

Date: 2025-10-01  
Author: AI Lead Developer (LD)

## Purpose
This document summarizes reconciliation of RTM entries (CSV) with the OpenAPI spec and UX/UI Design Package for Phase 1. It identifies matched story IDs (ST-XXX), confirms endpoint & UX mappings, and lists gaps or suggested actions for unresolved items.

## Sources used
- RTM CSV: [`architecture/rtm_mapping.csv`](architecture/rtm_mapping.csv:1)
- RTM Columns CSV: [`architecture/rtm_mapping_columns.csv`](architecture/rtm_mapping_columns.csv:1)
- OpenAPI: [`openapi/openapi.yaml`](openapi/openapi.yaml:1)
- UX/UI: [`UX_UI_Design_Package.md`](UX_UI_Design_Package.md:1)
- DB schema seed: [`db/schema.sql`](db/schema.sql:165)

---

## High-level result
- Total distinct ST-XXX found in RTM CSV: 12 (ST-001 .. ST-012)
- All ST-XXX have corresponding endpoints in the OpenAPI spec or in UX mapping except where noted below.
- Seed rows for these ST-XXX also exist in `db/schema.sql` (rtm_mapping insert statements).
- Action: RTM CSV imported with `scripts/import_rtm.sh` (idempotent SQL seed style). See scripts/import_rtm.sh.

---

## Reconciled mapping (confirmed)
The following mappings were cross-checked between RTM CSV, OpenAPI, and UX:

- ST-001
  - RTM CSV: `/api/auth/login`
  - OpenAPI: `/api/auth/login` — Present (operation annotated ST-001)
  - UX: `/login` (UX route) mapped in UX package
  - Status: OK

- ST-002
  - RTM CSV: `/api/admin/users`
  - OpenAPI: Admin users endpoints referenced in UX; `/api/admin/users` not explicitly in OpenAPI file but related admin endpoints exist (`/api/admin/exports`, `/api/admin/exports/{exportId}/download`).
  - UX: `/admin/users` is present in sitemap
  - Status: Needs explicit OpenAPI operation for `/api/admin/users` (create OpenAPI stub)

- ST-003
  - RTM CSV: `/api/imports`, `/api/imports/{importId}/preview`, `/api/imports/{importId}/commit`
  - OpenAPI: All three endpoints present and annotated ST-003
  - UX: Admin Import page `/admin/import` mapped
  - Status: OK

- ST-004
  - RTM CSV: `/api/users/{userId}/lessons`
  - OpenAPI: Present and annotated (ST-008 / ST-004)
  - UX: `/lessons` and dashboard flows include lesson listing
  - Status: OK

- ST-005a / ST-005b / ST-012 (TTS + Session)
  - RTM CSV: `/api/sessions/{sessionId}/answer`, `/api/sessions/{sessionId}/progress`, `/api/tts/generate`, `/api/tts/cache/{hash}`
  - OpenAPI: Present and annotated (ST-005a, ST-005b, ST-012)
  - UX: Session flows and TTS components described
  - Status: OK

- ST-006
  - RTM CSV: Spaced repetition mappings to `/api/sessions/{sessionId}/answer` (also DDL table)
  - OpenAPI: `/api/sessions/{sessionId}/answer` annotated with ST-006
  - UX: Session / SR behavior included in UX package
  - Status: OK

- ST-007
  - RTM CSV: `/api/sessions/{sessionId}/answer` (quiz)
  - OpenAPI: `/api/sessions/{sessionId}/answer` annotated with ST-007
  - UX: MCQ & Session flows include quiz
  - Status: OK

- ST-008
  - RTM CSV: `/api/users/{userId}/lessons`
  - OpenAPI: Present (annotations include ST-008)
  - UX: Dashboard `/dashboard` mapping present
  - Status: OK

- ST-009
  - RTM CSV: `/api/admin/exports`, `/api/admin/exports/{exportId}/download`
  - OpenAPI: Present (ST-009)
  - UX: Admin exports present; note: admin CIDR restriction described in UX and Phase 1 docs
  - Status: OK

- ST-010
  - RTM CSV: same endpoint as lessons (owner edits)
  - OpenAPI: Covered by `/api/users/{userId}/lessons`
  - UX: Lessons owner flow present
  - Status: OK

- ST-011
  - RTM CSV: `/api/users/{userId}`
  - OpenAPI: `/api/users/{userId}` delete operation present (ST-011)
  - UX: Privacy & deletion described
  - Status: OK

- ST-012
  - RTM CSV: `/api/tts/generate`
  - OpenAPI: Present (annotated)
  - UX: TTS settings in `/settings`
  - Status: OK

---

## Gaps & Action Items (Phase 1)
1. ST-002: `/api/admin/users` is listed in RTM and UX but is not present as an explicit operation in `openapi/openapi.yaml`. Action: create OpenAPI operation stubs for admin users CRUD (GET/POST/PUT/DELETE) and mark ST-002 in descriptions.
   - Priority: High
   - Owner: LD / Backend Engineer

2. RTM CSV column "columns" (present in `architecture/rtm_mapping.csv`) is not persisted into `rtm_mapping` seed table (schema/table has columns: story_id, endpoint, table_name, notes). The columns-level mapping exists in `architecture/rtm_mapping_columns.csv` and is the canonical source for field-level traceability. Action: keep `rtm_mapping_columns.csv` as canonical; consider adding a separate seed table `rtm_mapping_columns` in Phase 4 if needed.
   - Priority: Medium
   - Owner: LD / DB Designer

3. OpenAPI completeness: Review and add any missing admin endpoints noted in UX (e.g., admin user listing, admin import UI-related endpoints). Action: create a small OpenAPI checklist and update `openapi/openapi.yaml`.
   - Priority: Medium

4. Add explicit test mapping entries linking smoke-tests scripts to RTM IDs (some are referenced in `Phase_1_RTM_Mapping.md` but not fully enumerated). Action: update `smoke-tests/README.md` with RTM references.
   - Priority: Low

---

## Imported/Seeded RTM
- The project now includes a script `scripts/import_rtm.sh` that imports `architecture/rtm_mapping.csv` into the database file (default: `./data/dev.sqlite3`). The DB also contains example INSERTs in `db/schema.sql` for quick reference. Run the script to synchronize CSV -> DB.

Example:
```bash
# import into local DB (default path)
./scripts/import_rtm.sh

# custom DB
./scripts/import_rtm.sh ./data/dev.sqlite3 architecture/rtm_mapping.csv
```

---

## Next steps for Phase 1 completion (LD actions)
- [ ] Create OpenAPI stubs for admin users (ST-002) and any missing admin endpoints referenced in UX.
- [ ] Update `smoke-tests/README.md` to reference RTM IDs per test script.
- [ ] Decide whether to create `rtm_mapping_columns` table and seed for column-level traceability (recommended in Phase 4).
- [ ] Prepare short RTM validation report CSV summarizing matched/unmatched (I can produce this CSV on request).

---

## Conclusion
Phase 1 RTM reconciliation shows good coverage: most ST-XXX entries are present in both OpenAPI and UX artifacts. A small number of admin-related endpoints require explicit OpenAPI stubs (notably ST-002). With the previously-agreed decision (Coqui required in MVP, CIDR=192.168.1.0/24), Phase 1 deliverables can be finalized after addressing the action items above.
