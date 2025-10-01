# System Architecture Package — English Flashcards MVP

Wersja: 1.0  
Data: 2025-10-01

Autor: AI System Architect

Spis treści
1. Wprowadzenie i Drivery Architektoniczne
2. Architektura Systemu (C4)
   - Diagram Kontekstu (L1)
   - Diagram Kontenerów (L2)
   - Diagram Komponentów (L3)
   - Diagram Deployment (infrastruktura homelab)
3. Specyfikacja Stosu Technologicznego
4. Specyfikacje Implementacyjne
   - Schemat Bazy Danych (DDL) — [`db/schema.sql`](db/schema.sql)
   - API Spec (OpenAPI) — [`openapi/openapi.yaml`](openapi/openapi.yaml)
   - Mapowanie RTM (Endpoint -> Table/Column -> ST-XXX)
5. Architektura Operacyjna (DevOps)
   - Docker Compose
   - CI/CD (GitHub Actions)
   - Monitoring i Observability
   - Backup & Restore (Proxmox ops)
6. Roadmapa Implementacyjna i Sprint Plan
7. Rejestr Decyzji Architektonicznych (ADR)
8. Artefakty i Lokalizacje w repo
9. Checklisty akceptacyjne i instrukcje uruchomienia

---

## 1. Wprowadzenie i Drivery Architektoniczne
Zobacz szczegóły w: [`Phase_1_Analysis_and_Drivers.md`](Phase_1_Analysis_and_Drivers.md:1)

Główne drivery:
- Prywatność i lokalne przechowywanie (DB na hoście, minimalne PII) — ST-011
- Uruchomienie w homelabie (Docker Compose)
- Niskie opóźnienia TTS (Coqui lokalne, fallback espeak)
- Prostota utrzymania (modular monolith)

---

## 2. Architektura Systemu (C4)

C4 diagramy (tekst/PlantUML w repo):
- L1 System Context: `diagrams/c4-system-context.puml`
- L2 Containers: `diagrams/c4-containers.puml`
- L3 Components: `diagrams/c4-components.puml`
- Deployment (homelab): `diagrams/deployment-homelab.puml`

Przejrzyj diagramy powyżej (PlantUML) i wygeneruj SVG/PNG przy pomocy lokalnego narzędzia.

---

## 3. Specyfikacja Stosu Technologicznego
Szczegóły: `architecture/Phase_3_Technology_Selection_and_Infra.md`
- Backend: FastAPI, Python 3.11, SQLAlchemy, Alembic, Argon2id
- Frontend: React 18 + Vite
- DB: SQLite on host volume (MVP), migracja do Postgres planowana
- TTS: Coqui (default), espeak-ng fallback
- CI: GitHub Actions (lint, tests, build, smoke-tests)
- Monitoring: Prometheus (+Grafana optional), structured logs

---

## 4. Specyfikacje Implementacyjne

4.1 Schemat DB (DDL)
- Zobacz: `db/schema.sql`
- Zawiera tabele: users, lessons, lesson_items, imports, import_rows, sessions, session_answers, spaced_repetition, audio_cache, exports, audit_logs, rtm_mapping
- RTM seed: rtm_mapping inserts zmapowane do ST-XXX

4.2 API Spec
- OpenAPI skeleton: `openapi/openapi.yaml`
- Endpoints przykładowe:
  - POST /api/auth/login — ST-001
  - POST /api/imports — ST-003
  - POST /api/tts/generate — ST-005a / ST-005b
  - etc.

4.3 RTM Mapping
- Endpoint-level: `architecture/rtm_mapping.csv`
- Column-level: `architecture/rtm_mapping_columns.csv`
- DB rtm_mapping table seeded in `db/schema.sql`

---

## 5. Architektura Operacyjna (DevOps)

5.1 Docker Compose
- `docker-compose.yml` includes services: backend, frontend, tts (coqui), proxy, volumes
- Coqui default limits: cpu=1.0, memory=1g

5.2 CI/CD
- Workflow: `.github/workflows/ci.yml` (lint, tests, build, smoke-tests)
- Deploy: manual deploy script recommended (pull + compose up)

5.3 Monitoring & Health
- Health endpoints: /health, /health/tts
- Recommend instrumenting FastAPI with Prometheus metrics

5.4 Backup & Restore
- Backups handled by Proxmox snapshots (ops)
- Runbook includes backup & restore snippets in `architecture/Phase_4_Package_and_Runbook.md`

---

## 6. Roadmapa Implementacyjna
Sprints (12-week plan compressed):
- Sprint 1 (0–2w): repo skeleton, Dockerfile, Docker Compose, auth (ST-001), user mgmt (ST-002), DB schema & migrations
- Sprint 2 (2–4w): import pipeline (ST-003), lesson CRUD (ST-004)
- Sprint 3 (4–6w): flashcards session (ST-005a), basic TTS espeak, audio cache
- Sprint 4 (6–8w): Coqui integration, TTS settings (ST-005b, ST-012)
- Sprint 5 (8–10w): quiz engine (ST-007), spaced repetition (ST-006)
- Sprint 6 (10–12w): dashboards & exports (ST-008, ST-009), polish & QA

---

## 7. ADR (Architectural Decisions)
ADRs available in `docs/adr/`:
- ADR-001-FastAPI.md
- ADR-002-Modular-Monolith.md
- ADR-003-TTS-Hybrid.md
- ADR-004-DB-SQLite-Postgres.md

---

## 8. Artefakty i Lokalizacje w repo
See `architecture/Architecture_Package_Index.md` for full list and links.

---

## 9. Checklista akceptacyjna (przed handoff)
- [ ] All ADRs accepted
- [ ] Phase 1..5 artifacts reviewed and accepted
- [ ] RTM mapping validated
- [ ] Smoke-tests pass in CI or locally
- [ ] Migration tested (alembic upgrade/downgrade)

---

System Architecture Package is ready. Please review `System_Architecture_Package.md` and the linked artifacts in the repository. Confirm acceptance to close Phase 6 and produce any handoff artefacts you need (e.g., packaging to a single zip, creating AI_Handoff_Issue.md, or publishing to internal docs).