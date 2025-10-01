# Phase 4 — Database & API Package, Migration and Test Runbook

Wersja: 0.1  
Data: 2025-10-01

Zawartość: komplet artefaktów Phase 4, instrukcje migracji (alembic), testów smoke oraz checklista akceptacyjna.

## Artefakty (w repo)
- DB DDL (SQLite): `db/schema.sql`
- RTM mapping:
  - Endpoint-level: `architecture/rtm_mapping.csv`
  - Column-level: `architecture/rtm_mapping_columns.csv`
- SQLAlchemy models: `backend/app/models.py`
- Pydantic schemas: `backend/app/schemas.py`
- Alembic skeleton + initial migration:
  - `backend/alembic/env.py`
  - `backend/alembic/versions/0001_initial.py`
- OpenAPI: `openapi/openapi.yaml`
- C4 Component diagram: `diagrams/c4-components.puml`
- Smoke-tests:
  - `smoke-tests/import-e2e.sh`
  - `smoke-tests/tts-latency.sh`
  - `smoke-tests/dashboard-load.js`
- CI workflow with smoke-tests: `.github/workflows/ci.yml`
- Architecture docs:
  - `architecture/Phase_4_SQLAlchemy_Model_Documentation.md`
  - `architecture/rtm_mapping_columns.csv`
  - `architecture/Phase_4_Database_and_API_Details.md`

## Runbook — Local verification (dev machine / CI runner)

Prerequisites:
- Docker & Docker Compose (v2+)
- Python 3.11 (for local scripts)
- k6 (optional for load tests)
- jq (optional)

Steps:

1) Start environment
- Ensure `.env` exists (copy `.env.sample`) and set secrets (permissions 600)
- Start:
  - docker compose up --build -d

2) Apply migrations (Alembic)
- In container or locally with env:
  - export DATABASE_URL=sqlite:////data/db.sqlite
  - cd backend
  - poetry install (or pip install -r requirements)
  - alembic upgrade head
- Note: initial migration `0001_initial.py` executes `db/schema.sql` to seed schema.

3) Smoke-tests (sanity)
- Import E2E:
  - BASE_URL=http://localhost:8000 ./smoke-tests/import-e2e.sh tests/data/import_200.csv
- TTS latency:
  - BASE_URL=http://localhost:8000 ./smoke-tests/tts-latency.sh "example" "coqui" "uk"
- Dashboard load (k6):
  - k6 run --vus 20 --duration 30s smoke-tests/dashboard-load.js

4) Migration verification
- After alembic upgrade, run simple integrity checks:
  - sqlite3 ./data/db.sqlite "SELECT count(1) FROM users;"
  - sqlite3 ./data/db.sqlite "SELECT count(1) FROM rtm_mapping;"
- Validate rtm_mapping entries align with `architecture/rtm_mapping.csv`

5) Rollback (downgrade)
- alembic downgrade -1
- Verify tables dropped per downgrade script

## Migration notes (SQLite -> Postgres)
- Use compatible types (avoid SQLite-specific constraints).
- history column stored as TEXT in SQLite; map to JSONB in Postgres migration step.
- Export sqlite dump and import to Postgres using a migration script or pgloader.
- Test migration by:
  - Export schema/data from SQLite
  - Import into Postgres instance
  - Run a smoke test suite (import, tts generate, dashboard endpoints)

## Test matrix & acceptance criteria
- Import: 200 rows < 10s (smoke)
- TTS generate (local Coqui): p90 < 0.5s
- Dashboard endpoints: p90 < 300ms under 20 VUs (k6)
- Rate-limit: login endpoint blocks >10 attempts/min per IP
- Admin CIDR: /admin endpoints accessible only from 192.168.1.0/24

## Handoff checklist (Phase 4)
- [ ] Alembic migrations verified (upgrade/downgrade test)
- [ ] OpenAPI components enriched with schemas (request/response)
- [ ] SQLAlchemy models reviewed and synced with DDL
- [ ] RTM column-level CSV validated and uploaded to RM tool (if any)
- [ ] C4 L3 diagram reviewed and accepted
- [ ] Smoke-tests pass locally and in CI
- [ ] Phase 4 summary document accepted by stakeholder

## Next steps after Phase 4 acceptance
- Produce full System Architecture Package (C4 L1-L3 diagrams, ADRs, OpenAPI, DDL with RTM mappings)
- Hand off to AI Lead Developer for implementation sprints and CI integration
- Plan Sprint 1 tasks per roadmap (repo skeleton, auth, user mgmt, DB migrations)

---

Prepared by: AI System Architect  
Status: In progress — awaiting acceptance and final smoke-test runs.
