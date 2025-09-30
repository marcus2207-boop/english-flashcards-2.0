# Final Verified Requirements Document

Wersja: 1.0
Data: 2025-09-30
Autor: AI Senior Business Analyst (finalizacja fazy 3)
Standard referencyjny: inspirowane ISO/IEC/IEEE 29148

## 1. Podsumowanie Menedżerskie
Celem projektu jest dostarczenie lokalnie hostowanej aplikacji webowej do nauki słówek języka angielskiego, przygotowanej pierwotnie dla Laury (13 lat, 7 klasa). MVP ma działać w sieci LAN na homelabie (Docker Compose) i dostarczać spersonalizowane 15‑minutowe sesje (flashcards + TTS), panel administracyjny dla rodzica (admin) oraz minimalny zestaw funkcji zapewniających prywatność i prostotę utrzymania.

Kluczowe korzyści biznesowe:
- Zwiększenie efektywności nauki słówek i przekładanie tego na poprawę ocen szkolnych.
- Prosty monitoring postępów przez rodzica/admina.
- Niski koszt utrzymania (homelab + Docker) i wysoki poziom prywatności (dane lokalne).

Kryteria sukcesu MVP (Exit Criteria):
- Aplikacja uruchamiana przez `docker-compose` w LAN i osiągająca funkcjonalności MVP.
- Admin może zaimportować rozdział (~20+ słówek) i przypisać do Laury.
- Laura przeprowadza 15‑min sesję (flashcards + TTS) i wynik jest widoczny w panelu admina.
- Dokument zaakceptowany przez stakeholdera; manualne backupy realizowane przez Proxmox (operacyjne).

## 2. Cel Biznesowy i Problem (ulepszone)
Problem biznesowy: Laura ma trudności z zapamiętywaniem słówek oraz z utrzymaniem stałej, codziennej praktyki. Nauczyciele wymagają znajomości słownictwa z określonego podręcznika.

Rozwiązanie: Przyjazna, łatwa w użyciu aplikacja umożliwiająca szybkie budowanie zestawów słówek zgodnych z podręcznikiem (import CSV/JSON), krótkie sesje z TTS i quizami oraz prosty panel administracyjny dla rodzica, pozwalający monitorować postępy i konfigurować ustawienia.

Oczekiwany wpływ (6–12 miesięcy): codzienna praktyka ~15 min/dzień, mierzalne zwiększenie retention słówek w okresie 3 miesięcy, oraz gotowość architektury do rozbudowy poza klasę pojedynczego ucznia.

## 3. Profile Użytkowników i Persony (zaktualizowane)
- P-001 — Laura (Uczeń, primary)
  - Wiek: 13 lat, 7 klasa
  - Urządzenia: desktop w MVP
  - Cele: szybkie, angażujące sesje nauki, wymowa (UK), prosty dashboard
  - Uprawnienia: logowanie, uruchamianie sesji, tworzenie/edycja własnych lekcji

- P-002 — Rodzic / Admin
  - Rola: administracja systemu (tworzenie kont uczniów, import materiałów, monitorowanie, eksport)
  - Kontekst: homelab z dostępem do Internetu; dostęp do /admin wyłącznie z LAN 192.168.1.0/24

- P-003 — Nauczyciel (opcjonalna, przyszłość)
  - Rola przyszłościowa: read-only raporty klasowe, agregacja wyników

## 4. Wymagania Funkcjonalne (User Stories) — pełna lista RTM‑ready
Każda historia zawiera unikalny ID (ST-XXX), powiązanie z Personą, priorytet MoSCoW, kryteria akceptacji (AC), przypadki brzegowe i testy akceptacyjne. Poniżej skrócona, spójna lista — pełne, rozszerzone wersje historii zawarte są w dokumentacji backlogu.

Must (MVP):
- ST-001 — Authentication: logowanie email+hasło (P-001, P-002)
  - AC: walidacja email (podstawowa RFC), hasła minimalne 10 znaków; Argon2id hashowanie (params konfigurowalne); sesje via secure HttpOnly cookies; rate limit 10 prób/min/IP; testy jednostkowe.

- ST-002 — Admin: tworzenie kont uczniów (P-002)
  - AC: unikalny email, nickname, audit log; ostrzeżenie przy >20 kontach.

- ST-003 — Import słówek (CSV/JSON) (P-002)
  - AC: CSV UTF‑8 z nagłówkami english, polish (opcjonalnie example, tags); per-row error reporting; transactional reject przy >50% błędów; deduplikacja english+polish; performance: 20–200 rows <10s.

- ST-004 — CRUD lekcji/rozdziałów (P-001, P-002)
  - AC: ownership-based edits (owner/admin), soft-delete 30 dni, konflikt edycji last-write-wins + warning.

- ST-005a — Flashcards + TTS playback (P-001)
  - AC: 15‑min session default (configurable), autoplay audio (mutowalne), cache audio 90 dni, fallback do fonetyki, session stats saved.

- ST-005b — TTS config & test (P-002)
  - AC: wybór silnika (Coqui local preferred / espeak-ng fallback / external provider), akcent UK domyślny, test sound button, walidacja kluczy.

- ST-006 — Spaced repetition (P-001)
  - AC: 4‑stanowy algorytm (New, Learning, Review, Mastered), parametry konfigurowalne (initialInterval=1d, reviewInterval=7d, backToLearningDelay=10min), history log.

- ST-007 — Quizy: multiple-choice i wpisywanie (P-001)
  - AC: domyślnie 10 pytań, MCQ + short-text, case-insensitive matching, optional Levenshtein tolerance<=1, result stored and used to update SR.

- ST-008 — Uczeń dashboard (P-001)
  - AC: Mastered count, avg quiz score (7d), today session time; response <300ms for up to 20 users.

- ST-009 — Admin dashboard + eksport (P-002)
  - AC: weekly charts, per-session list, export CSV/PDF (<5s for 20 users), /admin only available from LAN 192.168.1.0/24 (app-level check X‑Forwarded‑For/RemoteAddr), audit logging for exports.

- ST-010 — Uczeń: zarządzanie własnymi lekcjami (P-001)
  - AC: owner-only edits, admin override, audit for deletions.

- ST-011 — Prywatność & lokalne przechowywanie (P-002)
  - AC: SQLite on host volume, only email/nickname stored, env sample, data deletion endpoint for admin, no PII sent externally by default.

- ST-012 — TTS akcent & test (P-002)
  - AC: settings UI for accent, test latency metrics display, validation of provider keys.

Should / Could:
- ST-013 — Backup/Export DB (operacyjne, realizowane przez Proxmox cron) — dokumentacja restore w README.
- ST-014 — Ustawienia sesji i przypomnienia (reminders deferred for MVP). 
- ST-015 — Teacher role scaffold (preparatory).

Każda historia jest zgodna z INVEST (Independent, Negotiable, Valuable, Estimable, Small, Testable) — historie krytyczne rozbite na mniejsze podtaski (np. ST-005 split na config/test i runtime session).

## 5. Wymagania Niefunkcjonalne (szczegóły)
- Architektura: jednowarstwowa aplikacja webowej uruchamiana w Docker Compose (app + wolumin DB). Przyrostowe rozdzielenie serwisów planowane w przyszłości.
- DB: SQLite (plikowy) na host volume w MVP; plan migracji do PostgreSQL po przekroczeniu triggerów skalowalności.
- Performance:
  - UI dashboard response <300 ms przy do 20 jednoczesnych użytkowników.
  - TTS external request average latency <1.5 s (10 prób), local TTS latency <0.5 s.
  - Import 20–200 rows completes <10 s.
- Security:
  - Hasła: Argon2id (default params: time=2, mem=64MB, parallelism=1); parametry konfigurowalne.
  - Sesje: secure, HttpOnly cookies, SameSite=Lax.
  - Rate limiting: logins 10/min/IP.
  - RBAC: roles admin/user; ownership checks enforced on resource operations.
  - /admin path restricted by network CIDR (192.168.1.0/24) with app-level verification of X‑Forwarded‑For/RemoteAddr; proxy assumed to be trusted (configurable whitelist of proxy IPs).
- Privacy / Compliance:
  - Minimal PII: tylko email i nickname; brak imienia, nazwiska.
  - Data deletion: admin-initiated erasure endpoint; audit log retained.
  - Backups: wykonywane operacyjnie poza aplikacją (Proxmox cron) — aplikacja dokumentuje restore steps.
- Operacje i Utrzymanie:
  - Backups: Proxmox cron, retention 30 dni (ops responsibility).
  - Audio cache retention: 90 dni (configurable).
  - Logging: audit log for admin actions; error logs for system ops.

## 6. Zidentyfikowane Ryzyka i Plan Ich Mitigacji
1. Ryzyko: niedostępność zewnętrznego TTS → Mitigacja: hybrydowy model (Coqui lokalny preferred; espeak-ng fallback) + cache audio + UX notify "audio niedostępne".
2. Ryzyko: wyciek kluczy API → Mitigacja: `.env` poza repo, sample file `.env.sample`, dokumentacja plik permissions 600, rotacja kluczy w docs.
3. Ryzyko: utrata danych → Mitigacja: operacyjne backupy Proxmox + dokumentacja restore; aplikacja oferuje manualny export CSV.
4. Ryzyko: RODO / prywatność dzieci → Mitigacja: minimalizacja danych, brak imienia/nazwiska, admin-controlled deletion, lokalne przechowywanie.
5. Ryzyko: przeciążenie SQLite przy wzroście → Mitigacja: monitor CPU/DB size; trigger migracji do PostgreSQL; migracja schematu i migrator planowane.
6. Ryzyko: dostęp admina spoza LAN (proxy spoofing) → Mitigacja: app-level CIDR checks + zaufany proxy whitelist.

## 7. Potwierdzone Założenia i Ograniczenia
Założenia (potwierdzone przez stakeholdera):
- Admin ma homelab z dostępem do internetu i zasoby do uruchomienia Coqui lokalnie (potwierdzone).
- Brak potrzeby zgody rodzica na przesyłanie pojedynczych słów do TTS (stakeholder potwierdził).
- Backupy realizowane zewnętrznie (Proxmox cron) — nie projektujemy backupu w aplikacji.
- Admin loguje się wyłącznie z sieci lokalnej 192.168.1.0/24.

Ograniczenia:
- MVP nie obejmuje resetu haseł przez SMTP (reset tylko przez admina).
- MVP nie zawiera zaawansowanej migracji DB (migrator przygotowany w backlogu).
- Brak wielojęzyczności UI — język polski w MVP.

## 8. Architektura Wysokiego Poziomu i Mapy Przepływów Użytkownika
- High-level: single web app (backend Python FastAPI lub Node Express — rekomendacja: FastAPI dla szybkiego rozwoju i dobrego wsparcia async dla TTS), SQLite on host volume, static files + JS client (SPA) w kontenerze.
- TTS flow (hybrydowy): session requests word -> check local cache -> if exists play -> else generate via local Coqui (if enabled) -> if fails and external provider configured -> call external provider -> store file in cache -> play -> on failure present phonetic hint.
- Admin flow: login from LAN -> /admin pages -> import CSV -> create lesson -> assign to user -> monitor reports -> export CSV.

Diagramy przepływów i wireframes dołączone w handoff package (dla AI UX/UI Designer).

## 9. Success Metrics i Monitorowanie
- Business KPIs:
  - Daily active use: target Laura ~1 session/day (15 min).
  - Retention: % słówek "mastered" po 3 miesiącach (target +20% vs baseline).
  - Average quiz score improvement over 3 months.
- System KPIs:
  - Dashboard response <300ms at <=20 concurrent users (smoke tests).
  - TTS success rate >=95% for local Coqui runs; external provider <1.5s latency avg.
  - Import time <10s for 200 rows.

## 10. Priorytetyzacja (MoSCoW) i Roadmapa MVP
MVP Must: ST-001, ST-002, ST-003, ST-004, ST-005a, ST-005b, ST-006, ST-007, ST-008, ST-009, ST-010, ST-011, ST-012
Should (deferred / ops): ST-013 (backup handled by Proxmox cron), ST-014 (reminders)
Could (future): ST-015 (teacher role)

Proponowana kolejność implementacji (pierwsze sprinty):
1. Sprint 1 (0–2 tyg.): repo skeleton, Dockerfile, Docker Compose, auth (ST-001), user management (ST-002), DB schema.
2. Sprint 2 (2–4 tyg.): import (ST-003), lesson CRUD (ST-004), admin list.
3. Sprint 3 (4–6 tyg.): flashcards session (ST-005a) + basic local TTS espeak-ng, audio cache.
4. Sprint 4 (6–8 tyg.): Coqui local integration (higher quality TTS) + TTS settings (ST-005b, ST-012).
5. Sprint 5 (8–10 tyg.): quiz engine (ST-007) + spaced repetition (ST-006).
6. Sprint 6 (10–12 tyg.): dashboards (ST-008, ST-009), export, polish, QA.

## 11. Traceability & RTM
- Każda historia ST-XXX ma przypisaną Personę ID (P-001..P-003), priorytet MoSCoW i kryteria akceptacji — dokument gotowy do włączenia do RTM w narzędziu do zarządzania wymaganiami.

## 12. Handoff Package (co jest dostarczone)
- Ten dokument `Final_Verified_Requirements_Document.md` (formalny, gotowy do handoff)
- `Post_MVP_Ideas.md` (lista 20+ pomysłów rozwojowych)
- Lista User Stories ST-001..ST-015 (RTM-ready) z AC (zawarta w tym dokumencie i backlogie)
- High-level user flows i wymagania techniczne do implementacji (w sekcji 8)
- `README.sample` i `env.sample` (do dodania w repo przy uruchomieniu projektu)

## 13. Dalsze kroki i rekomendacje operacyjne
- Przekazać pliki do AI UX/UI Designera: wireframes + constraints (UI po polsku, mobile future, dark/light neutral design).
- Przygotować skeleton repo i CI: unit tests + smoke tests dla TTS latency i import timings.
- Przygotować prosty plan migracji DB (skrypty dump/restore i migrator dla PostgreSQL).
- Zaplanować testy akceptacyjne z Laurą (stakeholder user testing) — scenariusze z checklisty QA.

