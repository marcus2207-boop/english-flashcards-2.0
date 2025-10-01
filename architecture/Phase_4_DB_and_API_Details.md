# Phase 4 — Projektowanie Baz Danych i Architektury API (Plan i kickoff)

Wersja: 0.1  
Data: 2025-10-01

Status: Rozpoczynam Phase 4 na podstawie zatwierdzenia Phase 3.

## Cel fazy 4
- Dopracować schemat bazy (DDL) przygotowany dla SQLite i przygotować migracje Alembic kompatybilne z PostgreSQL.
- Uzupełnić OpenAPI (kontakty, schematy request/response), wygenerować szczegółowe modele Pydantic.
- Mapować kluczowe endpoints/events oraz tabele/DDL do ID historyjek (RTM) w pełnej formie (rozszerzyć `db/rtm_mapping`).
- Przygotować C4 Level 3 (Component) dla kluczowych kontenerów: App Backend (moduły), TTS Engine integration, Worker.
- Dodać kryteria weryfikacji implementacyjne (migration smoke tests, DB size checks, integrity tests).

## Zakres pracy (zadania wykonawcze)
1. Final SQL DDL (SQLite) — dopracowanie i Walidacja (z db/schema.sql)
2. Alembic skeleton + initial migration (generate migration script from DDL)
3. OpenAPI -> Pydantic models mapping (generate models for requests and responses)
4. API contract completion: add request/response schemas to `openapi/openapi.yaml`
5. Mapowanie Endpoint -> Table/Column -> ST-XXX (rozszerzyć `rtm_mapping` w DB i jako CSV)
6. C4 L3: napisać opis komponentów i interfejsów (backend modules: auth, import, session, sr, tts-adapter, audio-cache)
7. Test plan for DB and API (migration test, import performance test, TTS integration test)
8. Dokumentacja: `architecture/Phase_4_Database_and_API_Package.md` zawierająca wszystkie artefakty i instrukcje uruchomienia testów

## Deliverables (do umieszczenia w repo)
- `db/schema.sql` (finalized) — DONE (iteracja)
- `backend/alembic/` (env + versions with initial migration) — TO DO
- `backend/app/models/*.py` (SQLAlchemy models)
- `backend/app/schemas/*.py` (Pydantic request/response schemas) generated from OpenAPI
- `openapi/openapi.yaml` (completed with components/schemas)
- `architecture/c4/L3/` (C4 L3 component descriptions / PlantUML)
- `architecture/Phase_4_Database_and_API_Package.md` (final package)

## Plan działania (kolejność, wykonam automatycznie)
A. Wygeneruję alembic skeleton (backend/alembic/) i initial migration based on `db/schema.sql`.  
B. Wygeneruję podstawowe SQLAlchemy models i umieszczę w `backend/app/models/`.  
C. Wygeneruję Pydantic schemas (backend/app/schemas/) z mapowaniem do OpenAPI i poprawię `openapi/openapi.yaml` z components/schemas.  
D. Rozszerzę `db/rtm_mapping` (inserty) i przygotuję `architecture/rtm_mapping.csv` z pełnym przypisaniem Endpoint -> Table -> Column -> ST-XXX.  
E. Przygotuję C4 L3 tekstowo i PlantUML w `diagrams/c4-components.puml`.  
F. Przygotuję `architecture/Phase_4_Database_and_API_Package.md` i krótką instrukcję testów migracji (smoke-tests/db-migration.sh).

## Wyzwania / ryzyka do uwzględnienia
- Różnice typów SQLite vs Postgres — preferować typy kompatybilne i unikać SQLite-specyficznych funkcji.
- JSON columns: SQLite supports JSON functions, but migration to Postgres requires using JSONB. We'll keep `history` as TEXT/JSON and document migration mapping.
- Alembic autogenerate may require SQLAlchemy models in repo; we'll generate models first, then alembic migration.

## Prośba o potwierdzenie
Potwierdź, żebym rozpoczął Phase 4 i wykonał zadania A–F (na podstawie zaakceptowanych Phase 1–3).  
- Odpowiedź: "Tak — start Phase 4" aby rozpocząć.