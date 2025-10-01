# Phase 3 — Dobór Stosu Technologicznego, Dockerfile, docker-compose i CI/CD (Sprint 1)

Wersja: 0.1  
Data: 2025-10-01  
Powiązania: [`Phase_1_Analysis_and_Drivers.md`](Phase_1_Analysis_and_Drivers.md:1), [`Phase_2_HighLevel_Architecture.md`](Phase_2_HighLevel_Architecture.md:1), `architecture/Architecture_Package_Index.md`  
Status: Rozpoczęte (wg potwierdzeń stakeholdera: ADR-001..ADR-004 zaakceptowane; CIDR=192.168.1.0/24; Coqui domyślne; secrets via .env z perms 600; backups Proxmox potwierdzone; frontend = React/Vite)

Celem Phase 3 jest:
- Dostarczyć szczegółowy, uzasadniony stos technologiczny (wersje, biblioteki)
- Przykładowy Dockerfile dla backendu i prosty `docker-compose.yml` obejmujący: backend, frontend (static), opcjonalny Coqui, audio-cache volume, sqlite volume, reverse-proxy (opcjonalny)
- Propozycja CI (GitHub Actions): lint, tests, smoke-tests
- Lista zalecanych dependency i ich wersji oraz krótkie uzasadnienia
- Uwaga: pliki implementacyjne pełnego kodu wygeneruję w kolejnych krokach po akceptacji.

---

## 1) Rekomendowany stos technologiczny (MVP)

Frontend
- Framework: React + Vite
  - Rekomendowane: React 18 + Vite (vite 5+)
  - Uzasadnienie: szybkie budowanie SPA, łatwa integracja z istniejącym `UXUI/prototype` i komponentami; dobra dokumentacja
- Styl: CSS + design tokens (`UXUI/design-tokens.json`)
- Testy: vitest / @testing-library/react

Backend
- Framework: FastAPI (Python)
  - Python 3.11
  - FastAPI >= 0.100
  - Uvicorn (ASGI) server with gunicorn optional in production
  - Uzasadnienie: zgodnie z ADR-001 — async-first, pydantic, OpenAPI autogeneracja
- ORM / Migrations:
  - SQLAlchemy 2.x + Alembic
  - Uzasadnienie: ORM umożliwiający DDL kompatybilny z Postgres; alembic do migracji
- Hashing: argon2-cffi (Argon2id) — skonfigurować domyślnie: time=2, memory_cost=65536 (64MB), parallelism=1
- Task background:
  - FastAPI background tasks for MVP; lightweight worker pattern (rq or simple sqlite-backed job queue) as extension
- Tests:
  - pytest + httpx (async) + pytest-asyncio

TTS
- Coqui local (opcjonalnie domyślnie w compose) — obraz Coqui TTS (dopasować wersję zgodnie z dokumentacją Coqui)
- espeak-ng fallback (mniejsze zasoby)
- Adapter pattern w backend (CoquiAdapter, EspeakAdapter, ExternalAdapter)
- Audio cache: host volume `./data/audio-cache`

Database & Storage
- SQLite file on host volume: `./data/db.sqlite`
- Schema designed to be Postgres-compatible (avoid SQLite-only features)
- Backup: Proxmox cron (operational)

Reverse Proxy / Edge (optional)
- nginx or caddy (if TLS required)
- Responsible for trusted proxy headers; configure trusted proxies list in `.env`

Security & Secrets
- Secrets: .env with `.env.sample` in repo; file perms 600; document rotation
- Optionally: recommend Vault or other secrets manager for production expansions (doc)

Monitoring & Logging
- Structured logging to stdout (JSON optionally)
- Simple health endpoints: /health, /health/tts
- Application-level audit log for admin actions persisted in DB

Dev tooling
- Pre-commit hooks: black, isort, ruff (Python)
- Lint: ruff (Python), eslint (frontend)
- Container builds: multi-stage Dockerfiles

CI/CD (GitHub Actions)
- Workflows:
  - ci.yml: runs on push/PR to main
    - jobs: lint (frontend+backend), unit-tests, build (verify Dockerfile build), smoke-tests (optional against test environment)
  - release.yml (optional): build/publish images to private registry (if desired)
- Smoke-tests executed by workflow after `docker-compose up --build` in ephemeral runner (or use test image)

---

## 2) Przykładowy Dockerfile (backend) — szkielet

Opis: lekki wielostage build for FastAPI with Uvicorn.

(Implementować w repo gdy potwierdzisz — poniżej przykładowa treść do kopiowania)

Dockerfile (backend) — rekomendacja
- Base: python:3.11-slim
- Use Poetry or pip + constraints
- Create non-root user, mount volume for db & audio

Przykład (do wdrożenia):
FROM python:3.11-slim AS base
# install build deps, tzdata, git if needed
# create app dir, non-root user, copy pyproject/requirements, install
# copy source, expose 8000, run uvicorn

(Uwaga: pełny plik Dockerfile wygeneruję na żądanie jako oddzielny plik `docker/backend/Dockerfile`)

---

## 3) Prosty `docker-compose.yml` (MVP) — opis i zawartość przykładowa

Cel: uruchomienie lokalne w homelabie — backend, frontend, optional Coqui, volumes.

Składniki:
- backend: image build from ./backend, ports 8000:8000, mount ./data (for db & audio)
- frontend: build from ./frontend or serve static from nginx/container; port 3000 (dev)
- coqui: optional service (enabled by env)
- reverse-proxy: optional (nginx) for X-Forwarded-For handling
- volumes: ./data:/data (db + audio-cache)

Przykładowy (skrót):
version: '3.8'
services:
  backend:
    build: ./backend
    ports:
      - "8000:8000"
    env_file:
      - .env
    volumes:
      - ./data:/data
    depends_on:
      - tts
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
  tts:
    image: coqui/tts:latest
    restart: unless-stopped
    environment:
      - COQUI_CONFIG=...
    volumes:
      - ./data/audio-cache:/data/audio-cache
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: '1g'

(Uwaga: dokładny `docker-compose.yml` z kompletami env i healthchecks wygeneruję na żądanie jako `docker-compose.yml` w repo root)

---

## 4) Propozycja GitHub Actions (CI) — skrót

Workflow: .github/workflows/ci.yml
- jobs:
  - lint:
    - steps: checkout, setup-node, setup-python, run eslint (frontend), run ruff (backend)
  - tests:
    - steps: checkout, setup-python, install deps, run pytest
  - build:
    - steps: checkout, build Docker images (backend), optionally run docker-compose up --build and run smoke-tests
  - smoke-tests (optional):
    - run smoke-tests scripts (k6 or bash) against ephemeral environment

(Utworzę przykładowe workflow po akceptacji)

---

## 5) Zalecane biblioteki (wersje wskazane jako punkt wyjścia)

Backend (Python)
- Python 3.11
- fastapi >= 0.95
- uvicorn[standard] >= 0.22
- sqlalchemy >= 2.0
- alembic >= 1.11
- pydantic >= 1.10 (lub pydantic v2 jeśli kompatybilne)
- argon2-cffi >= 21.3
- httpx >= 0.24 (testing/clients)
- pytest, pytest-asyncio, pytest-cov
- python-dotenv (for .env in dev)

Frontend
- node 18+
- vite 5+
- react 18+
- @testing-library/react, vitest, eslint

TTS
- Coqui TTS (container) — follow Coqui docs for recommended image & resources
- espeak-ng package (small image)

Devops / other
- k6 (for load tests)
- jq (CLI)
- Docker 24+, docker-compose v2+

---

## 6) Dalsze kroki (co wygeneruję następnie po Twoim potwierdzeniu)
- Pełne pliki:
  - `docker/backend/Dockerfile`
  - `docker/frontend/Dockerfile` (or static serve)
  - `docker-compose.yml` (root)
  - `.github/workflows/ci.yml` (sketch)
  - `README.sample` i `.env.sample` z wymaganymi zmiennymi (TTS, trusted proxies, Argon2 params)
- Przykładowe skrypty smoke-tests w `smoke-tests/` (jeśli chcesz)
- OpenAPI skeleton (openapi.yml / FastAPI routes skeleton) z mapowaniem do ST-XXX (Phase 4 will finalize endpoints + DB DDL mapping)

---

Potwierdź:
- Czy mam wygenerować teraz pełne pliki Dockerfile, docker-compose.yml oraz `.github/workflows/ci.yml` i `.env.sample` w katalogu repo (tak/nie)?
- Czy chcesz, aby Coqui w compose miał uprzednio zdefiniowane limits (CPU 1, mem 1GB) czy inną konfigurację?
