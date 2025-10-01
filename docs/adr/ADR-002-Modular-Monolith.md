# ADR-002: Modular Monolith + Docker Compose for MVP

Status: proposed  
Data: 2025-10-01

## Kontekst
Aplikacja ma być prosta do uruchomienia w homelabie, niskokosztowa w utrzymaniu i łatwa do szybkiego rozwoju. Homelab target i Docker Compose wskazują na prostą architekturę deploymentu.

## Decyzja
Zastosować modular monolith architecture uruchamiany przez Docker Compose jako model deploymentu dla MVP.

## Uzasadnienie
- Prostota deployu: pojedynczy obraz backendowy + frontend + opcjonalne kontenery TTS.
- Łatwość debugowania i iteracji: jeden proces backendu ułatwia lokalne debugowanie.
- Minimalne wymagania infrastrukturalne: zgodne z homelabem (brak potrzeby k8s).
- Umożliwia prostą ścieżkę migracji do rozdzielenia komponentów w przyszłości.

## Konsekwencje
- Należy dbać o modularny kod (clear module boundaries) by ułatwić przyszłe rozdzielenie na serwisy.
- Wprowadzić testy integracyjne i CI by zmniejszyć ryzyko regresji przy rozwoju monolitu.
- Przy wzroście ruchu przewidzieć migrację do microservices lub serwisów dedykowanych dla TTS/workers.

## Next steps
- Stworzyć repo skeleton z docker-compose, jednym serwisem backend i wolumenami.
- Dodać guidelines do modularnego projektowania (module boundaries, contracts).