# Architecture Package — Index (Phase 1 & Phase 2)

Wersja: 0.1  
Data: 2025-10-01

Ten katalog zbiera wszystkie artefakty architektoniczne wygenerowane podczas Phase 1 i Phase 2. Pliki poniżej powstały na podstawie dokumentów wejściowych i decyzji stakeholdera (zatwierdzono ADR-001..ADR-004; CIDR i Coqui potwierdzone).

## Artefakty (lokalizacje w repo)

Phase 1 — Analysis & Drivers
- Phase_1_Analysis_and_Drivers.md
- Phase_1_RTM_Mapping.md
- smoke-tests/README.md
- smoke-tests/dashboard-load.js (sketch)
- smoke-tests/tts-latency.sh (sketch)

Phase 2 — High-level Architecture & ADRs
- Phase_2_HighLevel_Architecture.md
- docs/adr/ADR-001-FastAPI.md
- docs/adr/ADR-002-Modular-Monolith.md
- docs/adr/ADR-003-TTS-Hybrid.md
- docs/adr/ADR-004-DB-SQLite-Postgres.md
- diagrams/c4-system-context.puml
- diagrams/c4-containers.puml

Stakeholder checkpoint
- stakeholder_checkpoint_summary.md

## Potwierdzenia od stakeholdera (zgodnie z ostatnim komunikatem)
- Akceptacja ADR-001..ADR-004: TAK
- CIDR admina: 192.168.1.0/24 — POTWIERDZONE
- Coqui: domyślne w MVP, dodane do docker-compose — POTWIERDZONE
- Secrets strategy: .env + file permissions 600 — POTWIERDZONE
- Backups: Proxmox cron, retention 30 dni — POTWIERDZONE
- Frontend: React / zobaczyć UXUI prototype — POTWIERDZONE

## Co zrobię następnie (Phase 3 — po Twoim potwierdzeniu)
- Wygeneruję szczegółowy stos technologiczny (wersje, biblioteki)
- Przygotuję przykładowy `Dockerfile` dla backendu i `docker-compose.yml` z opcjonalnym Coqui containerem oraz wolumenami
- Przygotuję propozycję CI (GitHub Actions) z jobami: lint, tests, smoke-tests
- Utworzę katalog `architecture/` jako centralne miejsce (ten plik jest pierwszym elementem)

Jeśli chcesz, żebym przeniósł również oryginalne pliki do katalogu `architecture/` zamiast zostawiać je w korzeniu, potwierdź to w następnym kroku — wykonać automatyczne przeniesienie (copy) czy pozostawić pliki w miejscach źródłowych i tylko zlinkować tutaj.
