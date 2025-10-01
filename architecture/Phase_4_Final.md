# Phase 4 — Final Package (Database & API) — Ready for Review

Wersja: 0.1  
Data: 2025-10-01

Status: Completed (ready for stakeholder review)

## Scope covered
Phase 4 completes detailed database and API design, mapping RTM to endpoints and DDL, and provides migration/runbook artifacts.

## Delivered artifacts (locations)
- DB schema (SQLite): `db/schema.sql`
- RTM mapping:
  - Endpoint-level CSV: `architecture/rtm_mapping.csv`
  - Column-level CSV: `architecture/rtm_mapping_columns.csv`
  - DB seed: `db/schema.sql` (rtm_mapping INSERTs)
- SQLAlchemy models: `backend/app/models.py`
- Pydantic schemas: `backend/app/schemas.py`
- OpenAPI spec (skeleton + components): `openapi/openapi.yaml`
- Alembic skeleton + initial migration:
  - `backend/alembic/env.py`
  - `backend/alembic/versions/0001_initial.py`
- C4 component diagrams (PlantUML):
  - `diagrams/c4-components.puml`
- Phase 4 documentation & runbook:
  - `architecture/Phase_4_Database_and_API_Details.md`
  - `architecture/Phase_4_SQLAlchemy_Model_Documentation.md`
  - `architecture/Phase_4_Package_and_Runbook.md`
- Smoke-tests (skeletons): `smoke-tests/*`
- CI integration: `.github/workflows/ci.yml` (includes smoke-tests)

## Actions performed
- Finalized DB schema and RTM mapping (endpoint + column level).
- Created SQLAlchemy models and Pydantic schemas aligned with the schema and OpenAPI.
- Implemented alembic skeleton and initial migration that applies `db/schema.sql`.
- Produced C4 L3 component diagram (PlantUML).
- Produced Phase 4 runbook with migration and test instructions.
- Integrated smoke-tests into CI workflow for sanity checks.

## Verification & Acceptance Checklist
- [ ] Review DDL `db/schema.sql` and confirm table/column names (privacy: only email and nickname stored).
- [ ] Confirm RTM mappings (`architecture/rtm_mapping.csv`, `architecture/rtm_mapping_columns.csv`) align with your requirements and issue tracker.
- [ ] Optionally run local smoke-tests:
  - docker compose up --build -d
  - alembic upgrade head (or allow initial migration to run)
  - BASE_URL=http://localhost:8000 smoke-tests/import-e2e.sh tests/data/import_200.csv
  - BASE_URL=http://localhost:8000 smoke-tests/tts-latency.sh "example" "coqui" "uk"
  - k6 run smoke-tests/dashboard-load.js (if k6 available)
- [ ] Approve Phase 4 final package.

## Next steps after approval
- Produce full System Architecture Package (System_Architecture_Package.md) combining Phases 1–4 and remaining Faza 5/6 artifacts:
  - C4 diagrams (L1-L3) in final form (SVG)
  - ADRs (finalized)
  - OpenAPI (final)
  - DDL and migration scripts
  - DevOps runbook + CI pipeline
  - Roadmap to implementation handoff
- Handoff to AI Lead Developer for implementation sprints.

Prepared by: AI System Architect

Phase 4 is ready for your review and acceptance. Please confirm "Accept Phase 4" to finalize, or provide changes to apply.