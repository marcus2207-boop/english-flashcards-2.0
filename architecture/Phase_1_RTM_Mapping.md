# Phase 1 — RTM Mapping (NFR / Acceptance -> ST-XXX)

Wersja: 0.1  
Data: 2025-10-01

Cel: jawne powiązanie wymagań niefunkcjonalnych, kryteriów weryfikacji i kluczowych artefaktów z identyfikatorami historyjek ST-XXX (Traceability).

## Zasady mapowania
- Każdy NFR ma przypisane ST-XXX (gdzie dotyczy) oraz sposób weryfikacji (smoke test / endpoint / skrypt).
- Mapowanie obejmuje także powiązane endpointy API i komponenty (np. TTS, DB, import).

---

## Mapa

1) Dashboard response <300 ms @ ≤20 users
   - Powiązanie: ST-008 (Uczeń dashboard)
   - API / Endpointy: GET /api/users/:id/lessons, GET /api/sessions/:id/progress
   - Weryfikacja: load test k6/wrk; scenariusz: 20 concurrent virtual users, mierzyć p50/p90/p99; akceptacja p90 < 300 ms.
   - Plik testowy: smoke-tests/dashboard-load.js (proponowany)

2) TTS latency (local <0.5s, external avg <1.5s)
   - Powiązanie: ST-005a (Flashcards + TTS), ST-005b (TTS config), ST-012 (TTS accent & test)
   - Komponenty: TTS Engine (Coqui container), espeak-ng fallback, Audio Cache
   - Endpointy: POST /api/tts/generate, GET /api/tts/cache/:hash
   - Weryfikacja: skrypt POST -> measure time to URL ready; testy: cached-play, generate-local, generate-external (10 prób), akceptacja p90 lokal <0.5s, avg external <1.5s.
   - Plik testowy: smoke-tests/tts-latency.sh

3) Import throughput <10s for 20–200 rows
   - Powiązanie: ST-003 (Import CSV/JSON)
   - Endpointy: POST /api/imports (file upload) -> GET /api/imports/:id/preview -> POST /api/imports/:id/commit
   - Weryfikacja: e2e upload CSV 200 rows; full path time <10s; transactional tests for >50% errors.
   - Plik testowy: smoke-tests/import-e2e.sh

4) Audio cache retention 90 days
   - Powiązanie: ST-005a
   - Komponenty: Audio Cache storage (host volume)
   - Weryfikacja: policy doc + operational script to purge older than 90 days; manual verification.
   - Dokument operacyjny: docs/audio-cache.md

5) Auth & security (Argon2id params, cookies, rate limit)
   - Powiązanie: ST-001 (Authentication)
   - Endpointy: POST /api/auth/login
   - Weryfikacja:
     - unit test dla Argon2id (params default time=2, mem=64MB, parallelism=1)
     - integration test for cookie flags (Secure, HttpOnly, SameSite=Lax)
     - rate-limit test (>10 attempts/min/IP)
   - Plik testowy: smoke-tests/auth-tests.sh

6) SQLite on host volume & privacy
   - Powiązanie: ST-011 (Prywatność & lokalne przechowywanie)
   - Komponenty: DB layer (SQLite), .env sample
   - Weryfikacja: container start with mounted volume, write/read DB; schema review ensuring only email/nickname stored; data deletion endpoint test.
   - Dokument: docs/db-and-privacy.md

7) Admin CIDR restriction (192.168.1.0/24)
   - Powiązanie: ST-009 (Admin dashboard + eksport), ST-011
   - Endpointy: /admin/*, GET /api/admin/exports
   - Weryfikacja: integration test sending requests with different X-Forwarded-For; enforce allowlist and proxy whitelist.
   - Plik testowy: smoke-tests/admin-cidr-test.sh

8) Export latency <5s for 20 users
   - Powiązanie: ST-009
   - Endpointy: GET /api/admin/exports?period=..., GET /api/admin/exports/:id/download
   - Weryfikacja: simulate 20 users requesting export; measure response and generation time <5s.
   - Plik testowy: smoke-tests/admin-export-load.js

9) Spaced Repetition correctness
   - Powiązanie: ST-006
   - Komponenty: SR engine (service logic), history log
   - Weryfikacja: unit tests for state transitions (New -> Learning -> Review -> Mastered) and interval parameters (initialInterval, reviewInterval, backToLearningDelay).
   - Plik testowy: tests/unit/sr-algorithm.test.py

---

## Uwagi końcowe
Po implementacji skeletonu repo utworzę szkielet smoke-tests w katalogu `smoke-tests/` oraz pliki testowe wymienione powyżej. Mapowanie może być rozszerzone do poziomu endpoint->konkretna tabela/DDL w fazie 4 (DB design) — wtedy dodam kolumny z ID tabeli i nazwy kolumn powiązane z ST-XXX.