# ADR-001: Wybór backendu — FastAPI

Status: proposed  
Data: 2025-10-01

## Kontekst
MVP musi być rozwinięte szybko, obsługiwać asynchroniczne scenariusze (TTS, I/O), działać wydajnie w homelabie pod Docker Compose oraz umożliwiać łatwe testowanie i rozwój. Alternatywy rozważone: Node.js + Express, Django (sync), Flask (sync/async w ograniczonym stopniu).

Źródła wymagań:
- NFR: TTS latency, async tasks (Phase 1) — [`Phase_1_Analysis_and_Drivers.md`](Phase_1_Analysis_and_Drivers.md:1)
- Rekomendacja w wymaganiach: FastAPI (Final Verified Requirements) — [`Final_Verified_Requirements_Document.md`](Final_Verified_Requirements_Document.md:136)

## Decyzja
Wybrać FastAPI jako primary backend framework dla MVP.

## Uzasadnienie
- Async-first: natywne wsparcie dla asynchronicznych endpointów (uvicorn/asyncio), co ułatwia integrację z TTS oraz background tasks.
- Szybki development: pydantic zapewnia silne walidacje modeli i szybki development API.
- Ekosystem: bogata biblioteka narzędzi (alembic, SQLAlchemy, pytest, starlette middleware).
- Wydajność: przy małym-średnim ruchu FastAPI + uvicorn daje niskie opóźnienia (spójne z celem <300ms).
- Dokumentacja automatyczna (OpenAPI) przyspiesza implementację frontend-backend contract.
- Silne wsparcie testów jednostkowych i integracyjnych.

## Konsekwencje / Implkacje
- Kod serwera zostanie napisany w Pythonie; wykorzystanie pydantic dla modeli, SQLAlchemy + alembic dla migracji.
- Standard warstwy asynchronicznej (uvicorn/gunicorn with uvicorn workers) w Docker Compose.
- Potrzeba zapewnienia środowiska developerskiego z Python 3.11+ i menadżerem zależności (pip/poetry).
- Dokumentacja ADR i repo should include a developer bootstrap (venv/poetry, readme).

## Alternatywy rozważone
- Node.js + Express: szybszy ekosystem JS (fullstack team), ale mniej natywnego async modelu z typed validation porównywalnego do pydantic.
- Django: pełny framework, ale heavier i sync-first (choć Django async rośnie).
- Flask: lekki, ale wymaga większej konfiguracji do osiągnięcia jakości FastAPI.

## Next steps
- Zainicjować szkielet FastAPI w repo (app/, tests/, alembic/).
- Dodać example `docker-compose` service dla backendu.
- Zdefiniować standardy pydantic modelowania i wyjątki HTTP.