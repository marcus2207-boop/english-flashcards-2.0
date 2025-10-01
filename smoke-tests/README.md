# Smoke Tests — instrukcja uruchomienia i checklista (Phase 1)

Wersja: 0.1  
Powiązane: [`Phase_1_Analysis_and_Drivers.md`](Phase_1_Analysis_and_Drivers.md:1), [`Phase_1_RTM_Mapping.md`](Phase_1_RTM_Mapping.md:1)

Ten plik dokumentuje zestaw prostych smoke-tests do weryfikacji kluczowych NFR z Phase 1. Zgodnie z decyzją, tu znajdują się tylko instrukcje uruchomienia i lista komend — skrypty mogą zostać wygenerowane później na żądanie.

Kroki wstępne
1. Uruchom aplikację lokalnie: docker-compose up --build
2. Upewnij się, że API jest dostępne pod: http://localhost:8000 (zmień BASE_URL jeśli inne)
3. Narzędzia rekomendowane:
   - curl (bash scripts)
   - k6 (dla load tests) — https://k6.io
   - jq (opcjonalnie do parsowania JSON w skryptach)

Lista testów (co wykonać ręcznie / komendy przykładowe)

1) Dashboard load (weryfikacja: p90 < 300 ms przy 20 VUs)
- Cel: sprawdzić szybkość odpowiedzi endpointów używanych przez dashboard
- Rekomendacja (k6): przygotować skrypt `dashboard-load.js`
- Ręczna symulacja (jednorazowa):
  - curl -sS http://localhost:8000/api/users/1/lessons -o /dev/null -w "%{time_total}s\n"
- K6 (przykład):
  - k6 run --vus 20 --duration 30s smoke-tests/dashboard-load.js

2) TTS latency (local <0.5s, external avg <1.5s)
- Cel: zmierzyć czas generowania pliku audio przez POST /api/tts/generate oraz czas pobrania z cache
- Ręczna test command:
  - curl -s -X POST http://localhost:8000/api/tts/generate -H "Content-Type: application/json" -d '{"word":"example","engine":"coqui","accent":"uk"}' -w "\n%{time_total}s\n"
- Oczekiwanie: p90 lokal <0.5s (dla generate); avg external <1.5s (dla provider)
- Uwaga: endpoint powinien zwracać od razu URL do pliku lub status job+URL; dopracować zgodnie z implementacją.

3) Import E2E (20–200 rows <10s)
- Cel: sprawdzić upload i commit CSV 200 wierszy <10s
- Ręczna sekwencja:
  - curl -F "file=@tests/data/import_200.csv" http://localhost:8000/api/imports
  - Odczytać importId z odpowiedzi -> GET /api/imports/:id/preview -> POST /api/imports/:id/commit
- Mierzyć całkowity czas od upload do commit.

4) Auth & rate limit (loginy 10/min/IP) + cookie flags
- Cel: zweryfikować parametry Argon2id, rate limiting i cookie flags
- Tests:
  - Unit test: sprawdzić hash Argon2id z parametrami time=2, mem=64MB, parallelism=1
  - Manual rate-limit check: wysłać 11 prób logowania z tym samym IP w ciągu 60s i oczekiwać blokady na 11. próbie
  - Cookie flags: po udanym loginie sprawdzić, że cookie ma Secure; HttpOnly; SameSite=Lax

5) Admin CIDR enforcement (192.168.1.0/24)
- Cel: sprawdzić że /admin jest dostępne tylko z dopuszczonego CIDR (aplikacyjna weryfikacja X-Forwarded-For/RemoteAddr)
- Ręczna sekwencja:
  - curl -H "X-Forwarded-For: 192.168.1.10" http://localhost:8000/admin - expect 200 (dla admin user)
  - curl -H "X-Forwarded-For: 8.8.8.8" http://localhost:8000/admin - expect 403/401
- Dostosować test do sposobu autoryzacji (session cookie / token).

6) Admin export latency (<5s for 20 users)
- Cel: zmierzyć czas generowania eksportu (CSV/PDF) przy obciążeniu 20 users
- Przykład (k6): przygotować skrypt `admin-export-load.js` który wywołuje GET /api/admin/exports?period=...
- Ręczna check:
  - curl -s "http://localhost:8000/api/admin/exports?period=7d" -w "\n%{time_total}s\n"

7) Spaced Repetition correctness (unit tests)
- Cel: sprawdzić przejścia stanów SR i parametry (initialInterval=1d, reviewInterval=7d, backToLearningDelay=10min)
- Testy jednostkowe: sprawdzić logikę SR w kodzie (tests/unit/sr-algorithm.test.*)

Operacyjna checklist (przed i po teście)
- Upewnij się, że kontener ma przydzielone wolumeny i że SQLite plik jest zapisywalny (chmod i ownership)
- Upewnij się, że .env jest poprawnie skonfigurowany (trusted proxies, Argon2 params, TTS config)
- Zbierz logi aplikacji (stdout kontenera) przy każdym teście dla analizy błędów

Co dalej
- Na żądanie mogę wygenerować szkielety skryptów (k6, bash) odpowiadających powyższym testom.
- Po wygenerowaniu skryptów możemy dodać je do CI (GitHub Actions) jako smoke stage dla pull requests.

Kontakt / Uwagi
- Jeżeli chcesz, bym teraz wygenerował konkretne skrypty do repo (k6 + bash), zatwierdź które z nich mam wygenerować (możliwość: wszystkie / tylko k6 / tylko bash).