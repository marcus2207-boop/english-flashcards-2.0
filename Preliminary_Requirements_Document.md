# Preliminary Requirements Document

## 1. Podsumowanie Menedżerskie

Celem projektu jest dostarczenie prostej, lokalnie hostowanej aplikacji webowej do nauki słówek języka angielskiego przeznaczonej pierwotnie dla Laury (13 lat, 7 klasa). Aplikacja ma poprawić wyniki Laury w szkole poprzez spersonalizowane sesje (flashcards + quizy) dopasowane do używanego podręcznika oraz zapewnić rodzicowi (adminowi) możliwość monitorowania postępów. MVP będzie działać w LAN na homelabie w Dockerze, z interfejsem po polsku i TTS dla wymowy (akcent brytyjski preferowany). Dane użytkowników będą minimalne (email, nickname), przechowywane lokalnie; hasła będą hash'owane.

Kluczowe cele biznesowe:
- Zwiększyć skuteczność nauki słówek Laury i przełożyć to na lepsze oceny szkolne.
- Umożliwić rodzicowi monitorowanie i szybkie dostosowanie materiału (admin panel).
- Zapewnić prywatność i prostotę utrzymania (Docker, homelab).

Kryteria sukcesu MVP:
- Działająca aplikacja uruchamiana przez Docker Compose w LAN.
- Admin może zaimportować jeden rozdział (~20+ słówek) i przypisać do Laury.
- Laura wykonuje sesję 15 min (flashcards + TTS) i wynik jest widoczny w panelu admina.

---

## 2. Cel Biznesowy i Problem

Problem:
- Laura ma trudności z zapamiętywaniem słówek i ocenami z angielskiego. Brakuje spersonalizowanego narzędzia dopasowanego do podręcznika i wymagań nauczyciela.

Proponowane rozwiązanie:
- Lekcje/rozdziały dopasowane do podręcznika (ręczny import z książki), sesje flashcards z TTS (UK), krótkie quizy, oraz panel admina do monitoringu i zarządzania materiałem.

Kluczowe cele (6–12 miesięcy):
- Wprowadzenie MVP dostępnego w LAN dla Laury.
- Regularne korzystanie (ok. 15 min/dzień), widoczna poprawa wyników szkolnych w 3 miesiące.
- Przygotowanie architektury, która umożliwi ewentualne rozszerzenie do klasy.

---

## 3. Profile Użytkowników (Persony)

1) Uczeń — "Laura" (Primary)
- Wiek: 13 lat, 7 klasa.
- Zachowanie: krótkie sesje ~15 min/dzień, desktop (MVP), w przyszłości mobile.
- Cele: opanować słówka z podręcznika, poprawić oceny.
- Uprawnienia: logowanie, sesje flashcards+TTS, quizy, uproszczony dashboard, tworzenie/edycja/usuwanie tylko własnych lekcji.

2) Rodzic / Administrator
- Rola: admin systemu, zarządza kontami, importuje słówka, przypisuje lekcje, monitoruje statystyki, wykonuje eksporty/backup.
- Techniczny kontekst: homelab, Docker, zgoda na użycie zewnętrznego TTS (ale darmowego lub free-tier jeśli możliwe).

3) Nauczyciel (opcjonalna)
- Futuristic persona: później możliwość read-only raportów klasowych; nie w MVP.

---

## 4. Wymagania Funkcjonalne (User Stories)

Każda historia ma unikalne ID ST-XXX. Priorytety: Must / Should / Could.

ST-001 — Authentication: logowanie email + hasło (Must)
- Jako użytkownik chcę logować się email+hasło.
- Kryteria akceptacji: poprawne sesje, walidacja email, hasła w DB jako hash.

ST-002 — Admin: tworzenie kont uczniów (Must)
- Admin tworzy konto (email, nickname). Konto widoczne w liście.

ST-003 — Import słówek (CSV/JSON) (Must)
- Admin importuje plik z kolumnami: english, polish (opcjonalnie example, tags); możliwość mapowania do rozdziału.
- Akceptacja: parsowanie, raport błędów, utworzenie rozdziału.

ST-004 — Tworzenie i edycja lekcji/rozdziałów (Must)
- Admin i uczeń (dla własnych) mogą tworzyć/edytować/usunąć lekcje i przypisywać słówka.

ST-005 — Flashcards z TTS (UK) (Must)
- Uczeń uruchamia sesję flashcards; TTS odtwarza wymowę (UK), pokazane PL znaczenie; sesja trwająca ~15 min.

ST-006 — Prosty spaced repetition (Should)
- System priorytetyzuje powtórki słówek źle zapamiętanych.

ST-007 — Quizy: multiple-choice i wpisywanie (Must)
- Krótkie quizy po sesji; wynik zapisywany.

ST-008 — Uproszczony dashboard ucznia (Must)
- Widok: liczba opanowanych słówek, średni wynik quizów, czas dzisiejszy.

ST-009 — Szczegółowy dashboard admina + eksport (Must)
- Wykresy tygodniowe, lista wyników per sesja, eksport CSV/PDF.

ST-010 — Uczeń: zarządzanie własnymi lekcjami (Must)
- Uczeń może tworzyć/edytować/usunąć tylko własne lekcje.

ST-011 — Prywatność & przechowywanie lokalne (Must)
- DB lokalne (SQLite), hasła hash, brak wysyłania PII na zewnątrz.

ST-012 — TTS: wybór akcentu i test dźwięku (Must)
- Admin ustawia akcent (domyślnie UK) i testuje głos.

ST-013 — Backup / Export DB (Should)
- Eksport bazy / backup nightly, pliki przechowywane na host volume.

ST-014 — Ustawienia sesji i przypomnienia (Should)
- Admin ustawia domyślną długość sesji (15 min) i ewentualne przypomnienia (odłożone do później w MVP).

ST-015 — Teacher role (Could)
- Architektura przygotowana do dodania roli nauczyciela w przyszłości.

MVP obejmuje ST-001..ST-005, ST-007..ST-012, ST-010, ST-009; Should/Can do w kolejnych iteracjach.

---

## 5. Wymagania Niefunkcjonalne

Środowisko:
- Docker Compose (app + wolumin DB), host w LAN na homelabie.
- DB MVP: SQLite (plikowy); plan migracji do PostgreSQL przy wzroście użytkowników.

Performance:
- UI < 300 ms dla dashboard przy do 20 jednoczesnych użytkowników.
- TTS (zewnętrzne API): czas odpowiedzi < 1.5 s (średnio, 10 prób).
- Import 20–200 wierszy < 10 s.

Bezpieczeństwo:
- Hasła: argon2id/bcrypt (zalecane argon2id), wymuszenie silnych haseł (min 10 znaków + mieszanka).
- Role-based access control (admin/user), owner-checks.
- API keys (TTS) w `.env` (plik hosta), nie w repo; uprawnienia pliku 600.
- Logowanie audytowe dla działań admina (tworzenia kont, import, eksport).

Scalability & Availability:
- MVP: obsługa do ~20 aktywnych użytkowników; do ~50 bez zmiany architektury.
- Migracja DB do PostgreSQL i rozdzielenie serwisów gdy użytkowników przybędzie.

Backup/Restore:
- Nightly backup SQLite (host volume), retention 30 dni (zgoda użytkownika).
- Procedura restore opisana w README.

Prywatność (RODO):
- Minimalizacja danych — tylko email i nickname; możliwość eksportu i usunięcia danych użytkownika.
- Brak publicznego hostingu w MVP.

Technologie rekomendowane:
- Backend: Python (Flask/FastAPI) lub Node (Express) — proste do uruchomienia w Dockerze.
- TTS: zewnętrzne API; preferowane darmowe / free-tier opcje lub alternatywnie lokalne Coqui/ESpeak.
- DB: SQLite (MVP), PostgreSQL później.

---

## 6. Założenia, Ograniczenia i Zidentyfikowane Ryzyka

Założenia:
- Admin ma homelab z dostępem do internetu (potwierdzone).
- TTS ma być zewnętrzne, ale darmowe lub free-tier (wybrano wymóg — "darmowe").
- Interfejs w MVP: desktop (po polsku).
- Max 20 kont uczniów w MVP.

Ograniczenia:
- Brak SMTP w MVP (reset hasła przez admina).
- Jakość TTS może zależeć od wybranej darmowej usługi.
- SQLite ma ograniczenia przy intensywnych zapisach równoległych.

Ryzyka i mitigacje:
- Ryzyko: bez internetu brak TTS → Fallback: lokalne wskazówki fonetyczne, lub offline TTS (espeak-ng).
- Ryzyko: wysyłanie słówek do zewnętrznego TTS → Mitigacja: cache wygenerowanych plików audio i wysyłanie minimalnych danych (pojedyncze słowa).
- Ryzyko: wyciek kluczy API → Mitigacja: `.env` poza repo, uprawnienia 600, dokumentacja rotacji kluczy.

---

## 7. Otwarte Pytania i Dalsze Kroki

Otwarte pytania (wdrożone decyzje):
- TTS: użytkownik wymaga darmowego zewnętrznego API lub alternatywy; w rękach admina jest decyzja o providera (opcje: darmowy/free-tier AWS Polly/Google TTS, lub lokalne Coqui/ESpeak). Zalecane: na początek wypróbować darmowy/free-tier dostawcy z cache audio. (Użytkownik: preferuje "darmowe" i "UK".)
- Import format: CSV z kolumnami `english, polish` zaakceptowany.
- Backup retention: 30 dni potwierdzone.

Dalsze kroki przed implementacją (krótka lista):
1. Zatwierdzenie dokumentu przez stakeholdera (Ty).
2. Wybranie konkretnego stacku technologicznego (np. FastAPI + SQLite + Docker) i TTS providera.
3. Przygotowanie repozytorium projektowego (skeleton), Dockerfile i docker-compose.
4. Implementacja MVP według priorytetów (ST-001..ST-012) w iteracjach 2-3 tygodniowych.
5. Testy akceptacyjne: funkcjonalne + niefunkcjonalne (performance + TTS latency) + backup/restore.

Proponowany wstępny harmonogram (szacunki):
- Tydzień 0: finalne zatwierdzenie wymagań, wybór stacku i providera TTS.
- Tydzień 1–2: setup repo, Docker Compose, auth, model użytkownika, admin user management, import CSV.
- Tydzień 3–4: flashcards + TTS integracja + quizy + prosty uczeń dashboard.
- Tydzień 5: admin dashboard, eksport/backup, tests and polish.
- Tydzień 6: QA, deploy na homelabzie, dokumentacja README i handoff.

Handoff package (co zostanie przekazane przy zakończeniu):
- Ten pojedynczy dokument `Preliminary_Requirements_Document.md`.
- Repozytorium z implementacją (kod źródłowy).
- `docker-compose.yml`, `Dockerfile`, `README.md` z instrukcją uruchomienia i restore/backup.
- Przykładowy CSV importu (lista słówek z dostarczonym przykładem).
- Lista konfiguracji `.env.sample` z opisem wymaganych kluczy (np. TTS_API_KEY).
- Testy jednostkowe/integracyjne (podstawowe happy-pathy).

Kryteria zamknięcia projektu (Exit Criteria):
- MVP uruchamiany w Docker Compose na homelabie i spełniający kryteria sukcesu.
- Dokument zaakceptowany przez stakeholdera.
- README z instrukcją uruchomienia i backup/restore.
- Podstawowe testy przechodzące (auth, import, sesja flashcards, export CSV).

---

## Załączniki / Przykładowe dane (lista słówek dostarczona)

(Źródło: ręcznie przepisana lista słówek z podręcznika dostarczona przez stakeholdera.)

Przykładowy fragment CSV (eng,pol):
```
bat,nietoperz
beaver,bóbr
camel,wielbłąd
chimpanzee,szympans
crab,krab
kangaroo,kangur
...
```

---

## Szybkie checklisty do testów (QA)

- [ ] Admin tworzy konto ucznia (max 20).
- [ ] Admin importuje CSV ~20 słówek -> tworzy rozdział.
- [ ] Uczeń loguje się i wykonuje sesję flashcards (TTS UK pracuje), wynik zapisany.
- [ ] Admin widzi tygodniowy raport i może wyeksportować CSV.
- [ ] Backup nightly działa i restore z 7 dni jest udany.
- [ ] Hasła w DB są hash'owane i plik `.env` nie zawiera kluczy w repo.

---
