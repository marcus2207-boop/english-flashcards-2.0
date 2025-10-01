# Stakeholder Checkpoint — Phase 1 & Phase 2 (podsumowanie dla zatwierdzenia)

Wersja: 0.1  
Data: 2025-10-01

Adresaci: Tech Lead / CTO / Product Owner

Cel: Krótkie, skondensowane podsumowanie wyników Phase 1 (Analiza wymagań technicznych) oraz Phase 2 (Projektowanie wysokopoziomowe — C4 L1/L2 + ADR). Prośba o zatwierdzenie kluczowych decyzji i potwierdzenie otwartych punktów przed przejściem do Phase 3.

---

## 1) Co zostało dostarczone (artefakty w repo)
- Phase 1:
  - [`Phase_1_Analysis_and_Drivers.md`](Phase_1_Analysis_and_Drivers.md:1) — skwantyfikowane NFRy, drivery architektoniczne, kryteria weryfikacji
  - [`Phase_1_RTM_Mapping.md`](Phase_1_RTM_Mapping.md:1) — mapowanie NFR/Endpoints -> ST-XXX
  - [`smoke-tests/README.md`](smoke-tests/README.md:1) — instrukcja uruchomienia smoke-tests i checklista
  - szkice testów: `smoke-tests/dashboard-load.js`, `smoke-tests/tts-latency.sh` (szkielety)
- Phase 2:
  - [`Phase_2_HighLevel_Architecture.md`](Phase_2_HighLevel_Architecture.md:1) — opis C4 L1/L2, proponowane wzorce, ATAM skrót
  - ADRs:
    - `docs/adr/ADR-001-FastAPI.md` — wybór FastAPI jako backend
    - `docs/adr/ADR-002-Modular-Monolith.md` — modular monolith + Docker Compose
    - `docs/adr/ADR-003-TTS-Hybrid.md` — hybrydowy model TTS (Coqui local preferred, espeak fallback)
    - `docs/adr/ADR-004-DB-SQLite-Postgres.md` — SQLite dla MVP + migracja do Postgres
  - PlantUML (tekstowe) diagramy C4:
    - `diagrams/c4-system-context.puml`
    - `diagrams/c4-containers.puml`

Pliki są dostępne w repo i gotowe do review.

---

## 2) Kluczowe decyzje do zatwierdzenia (prośba o akceptację)
Proszę potwierdzić lub zgłosić sprzeciw do poniższych decyzji:

1. Wybór backendu: FastAPI (Python) — ADR-001  
   - Powód: async-first, pydantic, szybki development, zgodność z wymaganiami TTS.  
2. Architektura: Modular Monolith uruchamiany przez Docker Compose — ADR-002  
   - Powód: prostota uruchomienia w homelabie, niskie wymagania operacyjne.  
3. TTS: Hybrydowy model (Coqui opcjonalny, espeak-ng fallback, external provider optional) — ADR-003  
   - Powód: prywatność + niska latencja + fallback.  
4. DB: SQLite na host volume w MVP z planem migracji do PostgreSQL — ADR-004  
   - Powód: prostota, backup operacyjny przez Proxmox; konieczność migratora w przyszłości.

Akceptacja powyższych decyzji jest wymagana by przejść do Phase 3 (Dobór stosu technologicznego i detali implementacyjnych).

---

## 3) Otwarty backlog pytań / założeń (wymaga potwierdzenia)

Priorytet Wysoki
- Potwierdź CIDR admina: domyślnie 192.168.1.0/24 — czy to finalne? (wymagane do skonfigurowania middleware i .env)  
- Czy Coqui ma być instalowane i uruchamiane domyślnie w MVP czy opcjonalnie (deferred do Sprint 4)? (wpływa na wymagania zasobowe kontenera)

Priorytet Średni
- Potwierdź politykę zarządzania kluczami API: czy wystarczy `.env` + docs perms 600, czy wolisz wskazać Vault / secrets manager?  
- Harmonogram backupów Proxmox (np. codziennie 02:00, retention 30 dni) — czy potwierdzasz?

Priorytet Niski
- Czy preferowany frontend stack to React (Vite) czy inna lekka alternatywa (Svelte)? (WPŁYW: dev-time, bundle size)

Proszę potwierdzić odpowiedzi lub wskazać osoby odpowiedzialne za decyzje.

---

## 4) Proponowana checklista akceptacyjna przed przejściem do Phase 3
- [ ] Potwierdzenie ADR-001..ADR-004 (akceptacja stakeholdera)
- [ ] Potwierdzenie CIDR admina i trusted proxy list
- [ ] Decyzja dot. Coqui: default ON / optional
- [ ] Potwierdzenie polityki sekretów (.env vs Vault)
- [ ] Zgoda na szkielet deploymentu Docker Compose (repo skeleton + przykładowy docker-compose.yml przygotuję w Phase 3)

---

## 5) Rekomendowane następne kroki po zatwierdzeniu
- Jeśli zatwierdzone: rozpocznę Phase 3 (Dobór stosu technologicznego) i wygeneruję:
  - Szczegółowy stack (wersje, rekomendowane biblioteki, przykładowy Dockerfile + docker-compose.yml)
  - Wstępny CI (GitHub Actions) z jobami: lint, unit tests, smoke-tests (opcjonalnie)
  - Szczegółową specyfikację endpointów (OpenAPI skeleton) i mapowanie do ST-XXX
- Jeśli potrzebne: mogę przygotować krótkie spotkanie sync (15 min) z CTO/TechLead aby omówić ADRy i otwarte punkty.

---

## 6) Prośba o decyzję (wybierz jedną)
- "Zatwierdzam ADR-001..ADR-004 i potwierdzam otwarte pytania" — przechodzimy do Phase 3.
- "Akceptuję częściowo — zobowiązuję się dostarczyć odpowiedzi na pytania: [wpisz które]" — przygotuję Phase 3 po uzupełnieniu.
- "Odrzucam — proszę zmodyfikować: [wpisz zmiany]" — naniosę poprawki.

Po Twojej odpowiedzi zaktualizuję todo listę i przystąpię do Phase 3 lub wprowadzę poprawki.
