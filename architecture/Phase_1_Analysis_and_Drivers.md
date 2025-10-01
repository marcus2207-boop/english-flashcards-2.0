# Phase 1 — Analiza i Synteza Wymagań Technicznych

Wersja: 0.1  
Data: 2025-10-01  
Powiązane pliki: [`Final_Verified_Requirements_Document.md`](Final_Verified_Requirements_Document.md:1), [`UX_UI_Design_Package.md`](UX_UI_Design_Package.md:1), [`UXUI/design-tokens.json`](UXUI/design-tokens.json:1)

## Cel fazy 1
Kwantyfikacja wymagań niefunkcjonalnych (NFR) i identyfikacja ograniczeń / driverów architektonicznych na potrzeby projektowania architektury (kolejne fazy). Wynikami tej fazy są:
- Zestaw mierzalnych NFR z kryteriami weryfikacji
- Priorytetyzowane drivery architektoniczne i ograniczenia
- Lista otwartych pytań i założeń wymagających potwierdzenia
- Krótka propozycja planu pomiarowego / smoke tests

Pracuję wyłącznie w tej fazie dopóki nie potwierdzisz akceptacji wyników.

---

## 1) Wyekstrahowane i skwantyfikowane NFR (z odniesieniami liniowymi)

1. Dashboard response time
   - Źródło: [`Final_Verified_Requirements_Document.md`](Final_Verified_Requirements_Document.md:1) linia 72, 148
   - Cel: odpowiedź UI dashboard < 300 ms przy do 20 jednoczesnych użytkowników
   - Weryfikacja: end-to-end smoke test (SPA request -> backend API GET /api/users/:id/lessons + render) średnia i p95 <300 ms przy 20 jednoczesnych wątpliwościach testowych.

2. TTS latency
   - Źródło: linie 98-99 w [`Final_Verified_Requirements_Document.md`](Final_Verified_Requirements_Document.md:1)
   - Cele:
     - Lokalny TTS (Coqui) latency < 0.5 s (p50/p90) — dla pojedynczego requestu generacji audio
     - Zewnętrzny provider average latency < 1.5 s (10 prób)
   - Weryfikacja: skrypt testujący lokalny Coqui i zewnętrznego providera, mierząc p50/p90/p99.

3. Import performance
   - Źródło: linia 54 i powtórzenia w UX spec
   - Cel: Import 20–200 wierszy completes < 10 s
   - Weryfikacja: automatyczny test integracyjny wykonujący POST /api/imports z plikiem CSV 200 wierszy i mierzący pełny przebieg (preview/commit) <10s.

4. Audio cache retention
   - Źródło: linia 60-61, 112
   - Cel: Cache audio retention 90 dni (konfigurowalne)
   - Weryfikacja: polityka przechowywania plików i test manualny/operacyjny przy usuwaniu plików po zadanym czasie.

5. Auth & security parameters
   - Źródło: linia 48, 101-105
   - Cele:
     - Hasła minimum 10 znaków, Argon2id z domyślnymi parametrami: time=2, mem=64MB, parallelism=1 (parametry konfigurowalne)
     - Sesje via secure HttpOnly cookies, SameSite=Lax
     - Rate limiting: loginy 10 prób/min/IP
   - Weryfikacja: unit/integration tests dla hashowania; security test dla cookie flags; pen-test prosty symulujący >10 prób/min.

6. DB & storage constraints
   - Źródło: linia 95, 81
   - Cele:
     - DB: SQLite file on host volume (w kontenerze Docker Compose). Ścieżka zapisu musi mieć prawa zapisu.
     - Migracja planowana do PostgreSQL przy triggerach skalowalności
   - Weryfikacja: sprawdzenie uprawnień wolumenu i backup/restore manual test (dokumentacja restore).

7. Admin access restriction
   - Źródło: linia 38, 75, 105
   - Cel: /admin dostępne tylko z LAN 192.168.1.0/24 (aplikacyjna weryfikacja X-Forwarded-For/RemoteAddr z whitelistą proxy)
   - Weryfikacja: integracyjny test requestów z nagłówkami symulującymi różne IP; policy enforcement test.

8. Concurrency / scale target
   - Źródło: linia 97, 148
   - Cel: obsługa do 20 równoczesnych użytkowników bez degradacji NFR powyżej.
   - Weryfikacja: load test symulujący 20 jednoczesnych sesji i walidacja KPI.

9. Import transactional correctness
   - Źródło: linia 54, 85
   - Cel: per-row error reporting; transactional reject przy >50% błędów; deduplikacja english+polish
   - Weryfikacja: testy zachowania na plikach z błędami — rollback i raport błędów.

10. Privacy & PII minimization
    - Źródło: linia 80-81, 106-109
    - Cel: przechowywać tylko email i nickname; brak imienia/nazwiska; data deletion endpoint dla admina; audit log retention
    - Weryfikacja: przegląd schematu DB oraz test usuwania konta (admin-initiated erasure) z walidacją audit log.

---

## 2) Architektoniczne Drivery i Ograniczenia (priorytetowane)

(Każdy driver zawiera krótkie uzasadnienie i implikacje projektowe)

P1 — Prywatność i lokalne przechowywanie (ST-011)
- Opis: Dane lokalne; minimalne PII.
- Implikacje: żadnych zewnętrznych agregatorów danych domyślnie; projekt offline-first dla TTS hybrydowego; wymóg hostowania DB na wolumenie hosta.

P2 — Uruchomienie w LAN + prostota utrzymania (Docker Compose)
- Opis: MVP ma działać w homelabie przez docker-compose.
- Implikacje: proste kontenery; unikanie pełnej orkiestracji (k8s) na MVP; konfiguracja wolumenów i network.

P3 — Wysoka dostępność TTS lokalnie (Coqui preferred) i fallback
- Opis: lokalny Coqui lub espeak-ng fallback, cache audio.
- Implikacje: asynchroniczne kolejkowanie generacji audio; lokalny serwis TTS w kontenerze; polityka cache.

P4 — Ograniczenia bezpieczeństwa / sieci (admin CIDR + proxy whitelist)
- Opis: /admin tylko z 192.168.1.0/24 z app-level check.
- Implikacje: implementacja w middleware; testy z X-Forwarded-For; dokumentacja trusted proxies w .env.

P5 — Lightweight stack wybór (FastAPI rekomendowane)
- Opis: rekomendacja FastAPI dla szybkiego rozwoju i async (linia 136).
- Implikacje: asynchroniczne endpoints (TTS), pydantic models, łatwy test harness.

P6 — Storage SQLite + migrator na Postgres
- Opis: SQLite na host volume; migracja programowa planowana.
- Implikacje: projekt DDL uwzględniający kompatybilność z Postgres; prosty migrator i dump/restore pattern.

P7 — Operacje & backup poza aplikacją (Proxmox cron)
- Opis: backupy realizowane operacyjnie; aplikacja dokumentuje restore.
- Implikacje: konieczność udokumentowania dump/restore i przygotowania README operacyjnego.

---

## 3) Kryteria weryfikacji (dla każdego NFR krótkie testy/smoke)

- Dashboard <300ms @20 users:
  - Narzędzie: k6 lub wrk; test scenariusza GET /api/users/:id/lessons + page asset; raport p50/p90.
- TTS local <0.5s:
  - Narzędzie: prosty skrypt (curl/HTTP) do POST /api/tts/generate, mierzenie czasu od request -> when cached vs on-generate.
- Import <10s:
  - Narzędzie: e2e test upload CSV 200 rows; capture total time.
- Rate limit:
  - Narzędzie: test wysyłający >10 prób/min z tej samej IP, ocena blokady.
- Admin CIDR:
  - Narzędzie: integracyjny test wywołujący /admin endpoints z różnymi X-Forwarded-For values.
- Argon2id:
  - Narzędzie: unit test sprawdzający, że zapisany hash jest zgodny z parametrami konfigurowalnymi.
- SQLite write permissions:
  - Narzędzie: test kontenera uruchomionego z volume, próba zapisu pliku DB i odczytu.

---

## 4) Mapowanie NFR -> ID historyjek (wstępne, RTM mapping)

- Dashboard response <300ms -> ST-008 (Uczeń dashboard) [`Final_Verified_Requirements_Document.md`](Final_Verified_Requirements_Document.md:1) linia 71-73
- TTS latency -> ST-005a / ST-005b / ST-012 (Flashcards/TTS config) linie 59-64, 82-84
- Import throughput <10s -> ST-003 linia 53-55
- Argon2id + rate limit -> ST-001 linia 46-49
- SQLite on host volume + privacy -> ST-011 linia 80-81
- Admin CIDR restriction -> ST-009 linia 74-75
- Audio cache retention 90 dni -> ST-005a linia 60, 112
- Spaced repetition correctness -> ST-006 linia 65-66
- Export latency <5s -> ST-009 linia 74-75

(Uwaga: pełne RTM z przypisaniem wszystkich subtasków zostanie wygenerowane w `Phase_1_RTM_Mapping.md` po akceptacji tej fazy.)

---

## 5) Plan pomiarowy / smoke tests — skrót

1. Przygotować repo-skeleton + docker-compose (Sprint 1). Uruchomić lokalnie środowisko.
2. Uruchomić prosty load test (k6) symulujący 20 rówoczesnych użytkowników (scenariusz login + dashboard load).
3. Wykonać test TTS:
   - a) gdy plik w cache: GET /api/tts/cache/:hash (latency expect <50ms)
   - b) generowanie lokalne: POST /api/tts/generate (latency <0.5s)
   - c) fallback path (espeak) wykonany i zarejestrowany.
4. Test importu CSV (200 rows) — zmierzyć end-to-end <10s.
5. Test rate-limiting dla endpointu /api/auth/login.
6. Test admin CIDR enforcement (różne nagłówki X-Forwarded-For).

---

## 6) Otwarte pytania i założenia do potwierdzenia (priorytet)

1. Czy akceptujesz rekomendację FastAPI jako stack backendowy (P1‑P5 wpływ)? (Wysoki priorytet)
2. Czy wymagane jest lokalne uruchomienie Coqui w MVP czy wystarczy espeak-ng i opcjonalne Coqui (miejsce na sprint 4)? (Wysoki)
3. Czy istnieje preferencja dotycząca sposobu rotacji/zarządzania kluczami w homelabie (Vault / .env + docs)? (Średni)
4. Potwierdź dokładny CIDR dla admina (domyślnie 192.168.1.0/24) oraz lista zaufanych proxy (adresy) — wymagane do implementacji middleware. (Wysoki)
5. Czy operacyjne backupy Proxmox są wykonywane na harmonogramie, który powinniśmy uwzględnić w dokumentacji (np. codziennie 02:00, retention 30 dni)? Jeśli tak — proszę potwierdzić harmonogram. (Średni)
6. Czy istnieją ograniczenia licencyjne lub zasobowe na uruchomienie Coqui w homelabie (CPU/RAM minimalne)? (Wysoki — wpływa na dobór konfiguracji kontenera)

---

## 7) Artefakty które utworzę jako wynik Phase 1 (do review)

- [`Phase_1_Analysis_and_Drivers.md`](Phase_1_Analysis_and_Drivers.md:1) — ten dokument (iteracja 0.1)
- [`Phase_1_RTM_Mapping.md`](Phase_1_RTM_Mapping.md:1) — pełne mapowanie NFR/Endpoints/DDL -> ST-XXX (po akceptacji)
- Smoke tests / measurement checklist (skrypty i instrukcja uruchomienia)
- Krótki stakeholder checkpoint summary (do akceptacji)

---

## 8) Propozycja następnego kroku (prośba o decyzję)
Proszę potwierdź jedną z opcji:
- "Akceptuję Phase 1 — kontynuuj" — wówczas wygeneruję `Phase_1_RTM_Mapping.md` i pełny pakiet weryfikacyjny.
- "Proszę poprawić/uzupełnić" — podaj, co zmienić (np. inne wartości NFR, inne priorytety).
- "Zatrzymaj — omówmy" — wymień konkretne wątpliwości.

Po Twojej akceptacji zaktualizuję todo listę i przejdę do utworzenia mapowania RTM i skryptów smoke-tests.