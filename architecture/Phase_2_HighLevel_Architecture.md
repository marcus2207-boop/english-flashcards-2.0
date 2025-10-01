# Phase 2 — Projektowanie wysokopoziomowe i wzorce architektoniczne

Wersja: 0.1  
Data: 2025-10-01  
Powiązania: [`Phase_1_Analysis_and_Drivers.md`](Phase_1_Analysis_and_Drivers.md:1), [`Phase_1_RTM_Mapping.md`](Phase_1_RTM_Mapping.md:1), [`Final_Verified_Requirements_Document.md`](Final_Verified_Requirements_Document.md:1), [`UX_UI_Design_Package.md`](UX_UI_Design_Package.md:1)

Uwaga: Pracuję wyłącznie w ramach Fazy 2 — poniżej znajdują się: opis C4 Level 1 (Context) i C4 Level 2 (Containers), proponowane wzorce architektoniczne, analiza kompromisów (skrót ATAM) oraz pierwsze wpisy ADR (Architecture Decision Records).

---

## 1. Cel Fazy 2
- Zaprojektować architekturę wysokiego poziomu zgodną z wymaganiami z fazy 1.
- Dostarczyć opisy diagramów C4: L1 (System Context) i L2 (Containers) — tekstowo i z listą komponentów/kontraktów.
- Wybrać i uzasadnić wzorce architektoniczne (monolith modularny, async workers dla TTS) oraz zapisać początkowe ADR.

Checkpoint Fazy 2: Użytkownik (Tech Lead / CTO / Product Owner) zatwierdza diagramy C4 L1 i L2 oraz pierwsze ADR.

---

## 2. C4 — Level 1: System Context (opis tekstowy)

System: English Flashcards (MVP) — lokalna aplikacja webowa do nauki słówek.

Aktorzy zewnętrzni:
- P-001 — Laura (Uczeń) — korzysta z UI (desktop), inicjuje sesje, odpowiada na quizy. (see: [`Final_Verified_Requirements_Document.md`](Final_Verified_Requirements_Document.md:29))
- P-002 — Rodzic / Admin — zarządza użytkownikami, importuje słówka, eksporter raportów; dostęp do /admin tylko z LAN 192.168.1.0/24. (see: [`Final_Verified_Requirements_Document.md`](Final_Verified_Requirements_Document.md:36))
- Optional external TTS provider — tylko jeśli admin skonfiguruje klucz (zewnętrzne API).
- Ops (Proxmox) — zewnętrzny mechanizm backupów (operacyjny, poza aplikacją).

Granice systemu:
- System hostowany jako zestaw kontenerów uruchamianych przez Docker Compose w sieci LAN homelab.
- DB: SQLite na wolumenie hosta; audio cache jako pliki w wolumenie.

Główne interakcje:
- Uczeń loguje się -> uruchamia sesję flashcards -> backend zwraca ćwiczenia, generuje/serwuje audio -> postęp zapisywany.
- Admin loguje się z LAN -> importuje CSV/JSON -> przegląda/commituje import -> eksportuje raporty.

C4 L1 — Krótka lista elementów:
- System: English Flashcards (Web App)
- Actor: Laura (P-001)
- Actor: Parent/Admin (P-002)
- Actor: External TTS Provider (optional)
- Actor: Ops (Proxmox backup)
- Data stores at boundary: Host volume (SQLite file + audio cache)

---

## 3. C4 — Level 2: Containers (opis tekstowy)

Cel: zdefiniować kontenery (procesy/uruchamialne jednostki) wewnątrz systemu.

Proponowane kontenery (MVP, Docker Compose):

1) Web Client (SPA) — kontener serwujący statyczne pliki + assets
   - Technologia: React / Vite lub SvelteKit (SPA) — rekomendacja: lekkie SPA z vanilla JS minimalnym stackiem
   - Odpowiedzialność: UI (login, dashboard, session, admin views), komunikacja z backendem przez REST API
   - Mapowanie ST: ST-001, ST-005a, ST-008, ST-009

2) App Backend (API) — jeden proces aplikacyjny (modular monolith)
   - Technologia rekomendowana: FastAPI (Python) (asynchroniczne), lub Node + Express jako alternatywa
   - Odpowiedzialność:
     - Autoryzacja i sesje (ST-001)
     - Endpoints REST (ST-002..ST-012)
     - Import processing (synchronous preview + transactional commit)
     - Spaced repetition logic (SR engine) — moduł serwisowy w monolicie
     - Business rules, RBAC, admin CIDR middleware
   - Wymagania niefunkcjonalne: p90 dashboard endpoints <300ms przy ≤20 jednoczesnych
   - Mapowanie ST: ST-001..ST-012

3) TTS Engine container (local)
   - Komponent(y):
     - Coqui TTS (preferowane) — kontener opcjonalny uruchamiany jeżeli admin zainstaluje
     - espeak-ng fallback (mniejszy kontener)
   - Odpowiedzialność: generowanie plików audio na żądanie; lokalny endpoint; health-checks
   - Interakcja: App Backend -> TTS Engine (HTTP/gRPC/CLI)
   - Mapowanie ST: ST-005a, ST-005b, ST-012

4) Audio Cache (host volume — pliki)
   - Odpowiedzialność: przechowywanie wygenerowanych plików audio, polityka retencji 90 dni
   - Dostęp: zarówno z backendu jak i TTS containeru
   - Mapowanie ST: ST-005a

5) Data Volume (Host) — SQLite file + backups managed externally
   - Odpowiedzialność: przechowywanie minimalnego PII (email, nickname), lesson/lesson_items, SR history, import audit
   - Mapowanie ST: ST-011

6) Optional Worker (Background Task runner)
   - Odpowiedzialność: długotrwałe/async zadania (batch imports, background TTS generation, export generation)
   - Technologia: celery/redis w przyszłości (na MVP może być wbudowany w backend jako background task)
   - Mapowanie ST: ST-003 (import), ST-009 (export)

7) Reverse Proxy / Edge (optional in compose)
   - Odpowiedzialność: TLS termination (if exposed), trusted proxy headers handling, X-Forwarded-For
   - Konfiguracja: trusted proxy whitelist (env)
   - Mapowanie ST: ST-009 (admin CIDR enforcement)

Sieć i wolumeny:
- Docker Compose network — backend+frontend+tts share network; host mounts for DB and audio cache.
- Volumes: ./data/db.sqlite, ./data/audio-cache/*

Diagram L2 (tekstowy, container -> responsibilities)
- Web Client -> REST -> App Backend
- App Backend -> uses -> SQLite (host volume)
- App Backend -> HTTP -> TTS Engine (local) -> writes -> Audio Cache (host volume)
- App Backend -> spawn background tasks -> Worker (optional)
- Admin requests via Web Client -> App Backend (Admin routes enforce CIDR via middleware)
- Ops (Proxmox) -> backup host volume externally

---

## 4. Proponowane wzorce architektoniczne i ich uzasadnienie

1) Modular Monolith (MVP)
   - Opis: jeden deployowalny proces backendowy podzielony na moduły (auth, import, sessions, tts, sr)
   - Zalety: prostszy deployment dla Docker Compose, niższa złożoność, łatwość debugowania, niższy koszt utrzymania
   - Wady: przyrostowy koszt skalowania — konieczność migracji do mikroserwisów przy dużym ruchu
   - Związek z wymaganiami: spełnia wymóg uruchomienia w homelabie i prostoty utrzymania (ST-011, Faza 1)

2) Async Background Workers dla TTS i długich zadań
   - Opis: generowanie audio offloaded do background jobów (synchronously for small ops; async for heavy)
   - Zalety: minimalizuje latency dla user flows, lepsze retry/queue handling
   - Wady: konieczność dodatkowego komponentu (queue, worker)
   - MVP: use FastAPI background tasks lub lightweight queue (sqlite-backed job queue) — worker jako opcjonalny kontener

3) Adapter Pattern dla TTS Engines
   - Opis: abstrakcja warstwy TTS w backendzie, implementacje: CoquiLocalAdapter, EspeakAdapter, ExternalProviderAdapter
   - Zalety: łatwa wymiana providerów, testowalność, fallback
   - Wady: niewielkie narzuty na implementację
   - Związek: bezpośrednio spełnia ST-005b wymagania

4) Data Access Layer z migracjami kompatybilnymi z Postgres
   - Opis: projekt DDL i ORM (alembic/SQLAlchemy) tak, aby migracja do Postgres była wykonalna
   - Zalety: pozwala migrację przy triggerach skalowalności (z Phase 1)
   - Wady: pewne ograniczenia SQLite (np. typy) — testy migracji wymagane

5) Security Middleware for Admin CIDR
   - Opis: middleware sprawdzające X-Forwarded-For/RemoteAddr oraz whitelistę trusted proxies z .env
   - Zalety: spełnia ST-009 wymóg
   - Wady: wymaga dobrej dokumentacji trusted proxies dla operacji

---

## 5. ATAM — analiza kompromisów (skrót)

Cel: zidentyfikować jak proponowane wzorce wpływają na NFRy.

- Prywatność & lokalność: Modular Monolith + host volumes minimalizuje ryzyko przesyłu PII na zewnątrz. (+)
- TTS latency: lokalny Coqui + async workers + audio cache — bardzo korzystne dla latency. (+)
- Performance (dashboard <300ms): monolith z FastAPI i SQLite spełni wymaganie przy ≤20 users; jednak import i eksport mogą wymagać background tasks by nie blokować głównych requestów.
- Maintainability: modular monolith zapewnia szybsze iteracje; ADRs i adapter pattern ułatwią przyszłą rozbudowę.
- Scalability: kiedy ruch > triggers, migracja do Postgres i rozdzielenie workerów/serwisów będzie konieczna — plan migracji jest rekomendowany.

---

## 6. Początkowe ADR (Architecture Decision Records)

ADR-001: Wybór backendu — FastAPI (Python)
- Status: Proposed
- Kontekst: potrzeba asynchronicznych endpointów (TTS), szybki development, bogaty ekosystem (pydantic, alembic)
- Decyzja: Prefer FastAPI jako primary backend framework. Alternatywa: Node/Express. Wybrano FastAPI ze względu na async-first, dobry ekosystem testów i szybkość developmentu.
- Konsekwencje: projekt w Python -> pydantic models, alembic migrations, uvicorn/gunicorn workers. Dokument: `docs/adr/ADR-001-FastAPI.md` (utworzę na żądanie).

ADR-002: Modular Monolith + Docker Compose MVP
- Status: Proposed
- Kontekst: prostota uruchomienia w homelabie, ograniczone zasoby.
- Decyzja: Wdrożyć modular monolith uruchamiany przez Docker Compose. Rozdzielenie na mikroserwisy zostanie zaplanowane po przekroczeniu triggerów skalowalności.
- Konsekwencje: jeden service image dla backendu; plan migracji i listy refactorów.

ADR-003: TTS Architecture — Hybryd (Coqui local preferred, espeak-ng fallback, external optional)
- Status: Proposed
- Kontekst: wymagania ST-005a/b; offline-first; privacy
- Decyzja: Implement adapter layer w backendzie; provide optional Coqui container; espeak-ng fallback; cache audio on host volume with 90-day retention.
- Konsekwencje: need to document Coqui resource requirements and provide default config to disable Coqui.

ADR-004: Database choice — SQLite on host volume with migration path to Postgres
- Status: Proposed
- Kontekst: MVP runs in homelab; migration plan required per Phase 1 risks.
- Decyzja: Use SQLite file on host volume for MVP. Provide DDL compatible with Postgres and migrator (alembic or equivalent).
- Konsekwencje: implement schema and migration scripts; include tests for dump/restore.

(Jeśli zaakceptujesz, zapiszę ADRs jako oddzielne pliki w `docs/adr/`.)

---

## 7. Deliverables Fazy 2 (co utworzę i gdzie)

- [`Phase_2_HighLevel_Architecture.md`](Phase_2_HighLevel_Architecture.md:1) — ten dokument (iteracja 0.1)
- C4 textual diagrams L1 + L2 (tu zawarte) — następnie mogę wygenerować obrazki SVG/PlantUML na żądanie
- Pierwsze ADRs (utworzone jako wpisy w `docs/adr/ADR-00X-*.md`) — na żądanie
- ATAM summary (rozszerzyć jeśli chcesz pełny raport)

---

## 8. Propozycja następnych kroków i opcje do zatwierdzenia

Wybierz jedną z opcji:
- "Zatwierdzam Phase 2 (kontynuuj)" — wówczas utworzę ADR pliki w `docs/adr/` i, jeśli chcesz, wygeneruję PlantUML/SVG dla C4 L1 i L2.
- "Proszę o edycję" — wskaż, co poprawić w C4 L1/L2 lub ADRach.
- "Wróć do stakeholder checkpoint" — wygeneruję krótkie podsumowanie do zatwierdzenia przez stakeholdera przed dalszą pracą.

Po Twojej decyzji zaktualizuję todo listę i przystąpię do wybranego działania.