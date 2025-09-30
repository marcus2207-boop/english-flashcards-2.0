# Faza 1 — Badanie i Empatia

Data: 2025-09-30
Źródło: `Final_Verified_Requirements_Document.md`

Krótko: w tej fazie zebrano i ustrukturyzowano wiedzę o użytkownikach, przygotowano rozszerzone persony, kluczowe user flows oraz mapy podróży użytkownika (user journey). Materiał służy jako podstawa do projektowania IA i makiet Lo‑Fi (Faza 2).

## Zakres działań wykonanych teraz
- Analiza dokumentu wymagań finalnych.
- Rozszerzenie i uściślenie person (P-001..P-003).
- Stworzenie 3 kluczowych user flows (Uczeń — sesja, Admin — import i przypisanie, Admin — eksport/monitoring).
- User journey mapy dla Laury (Uczeń) i Rodzica (Admin).
- Lista krytycznych przypadków brzegowych i heurystyk Nielsena przypisanych do obszarów ryzyka.

---

## 1. Rozszerzone persony (UCD)

P-001 — Laura (Uczeń — primary)
- Wiek: 13 lat, 7 klasa.
- Urządzenia: desktop (MVP), klawiatura, słuchawki/speakers; korzysta z aplikacji w domu po lekcjach.
- Kompetencje cyfrowe: podstawowe — potrafi logować się, klikać elementy, ale nie czyta skomplikowanych instrukcji.
- Cele:
  - Szybko i przyjemnie uczyć się słówek 15 min/dzień.
  - Usłyszeć poprawną wymowę (UK) i szybko powtarzać.
  - Widzieć prosty, motywujący feedback (np. liczba mastered).
- Frustracje:
  - Długie, skomplikowane ustawienia.
  - Przerwy w audio lub wolne generowanie dźwięku.
  - Gubienie postępów po błędach importu/konfliktach.
- Potrzeby dostępności: czytelny UI (kontrast), przycisk „play” duży, możliwość przyspieszenia/wyciszenia audio.
- Preferencje motywacyjne: krótkie cele, natychmiastowy feedback, licznik czasu sesji.
- Powiązane ST: ST-001 (auth), ST-004 (lekcje), ST-005a (flashcards+TTS), ST-006 (SR), ST-007 (quizy), ST-008 (dashboard ucznia).

P-002 — Rodzic / Admin
- Rola: zarządzanie kontami uczniów, import materiałów, monitorowanie postępów, operacje (uruchomienie na homelabie).
- Urządzenia: desktop, dostęp do LAN 192.168.1.0/24.
- Kompetencje techniczne: umiarkowane — potrafi pracować z Docker Compose, uploadem CSV, ale potrzebuje jasnej dokumentacji.
- Cele:
  - Szybkie zaimportowanie rozdziału oraz przypisanie go do Laury.
  - Monitorować sesje i pobierać raporty (CSV/PDF).
  - Zarządzać TTS (wybrać Coqui lub espeak), zabezpieczyć klucze (env).
- Frustracje:
  - Niejasne komunikaty błędów przy imporcie.
  - Brak kontroli dostępu lub dostęp spoza LAN.
- Potrzeby: szczegółowe logi importu (per-row), prosta konfiguracja TTS, zabezpieczenia (CIDR), eksporty w <5s (20 users).
- Powiązane ST: ST-002, ST-003, ST-005b, ST-009, ST-011, ST-012.

P-003 — Nauczyciel (przyszłość)
- Rola: read-only raporty klasowe, agregacja wyników; nie priorytet w MVP.

---

## 2. Kluczowe User Flows
Dla każdego flow podaję: cel, kroki, warunki wstępne, kryteria sukcesu, edge cases, powiązane ST.

Flow A — "Laura: Uruchom 15‑min sesję flashcards + TTS"
- Cel: Umożliwić Laurze wykonanie sesji 15 min z natychmiastowym audio i zapisaniem wyników do dashboardu.
- Wstępne warunki: konto utworzone i przypisane do lesson; audio engine (Coqui/espeak) skonfigurowany lub fallback przygotowany; cache audio dostępne/empty.
- Kroki użytkownika:
  1. Loguje się (ST-001).
  2. Wybiera przypisaną lekcję / "Start Session" (domyślnie 15 min) (ST-004).
  3. Sesja pokazuje flashcard: słowo angielskie + przycisk "play" (autoplay opcjonalne) (ST-005a).
  4. Laura słucha i powtarza / odpowiada (quizy w trakcie sesji zgodnie ST-007).
  5. System zapisuje odpowiedzi, aktualizuje spaced repetition status (ST-006).
  6. Po 15 minutach pokazuje podsumowanie (mastered, score) i zapisuje to do profilu (ST-008).
- Kryteria sukcesu:
  - Audio odtworzone w <0.5s kiedy Coqui lokalny, lub odtwarzanie z cache.
  - Sesja kończy się po 15 min i wyniki widoczne w dashboardzie.
- Edge cases:
  - Brak audio lokalnego → fallback do espeak lub fonetyka (ST-005b).
  - Sieć przerwana → sesja działa offline jeśli audio jest zcache'owane; jeśli nie, pokaż czytelny komunikat i kontynuuj bez audio.
- Powiązane ST: ST-001, ST-004, ST-005a, ST-005b, ST-006, ST-007, ST-008.

Flow B — "Admin: Import CSV/JSON i przypisanie rozdziału uczniowi"
- Cel: Pozwoli adminowi szybko zaimportować rozdział (20+ słówek), poprawić błędy i przypisać go do Laury.
- Wstępne warunki: admin zalogowany i znajdujący się w LAN (aplikacja sprawdza CIDR) (ST-001, ST-009).
- Kroki:
  1. Admin przechodzi do /admin -> Import (ST-003).
  2. Wybiera plik CSV/JSON i klika "Start Import".
  3. System waliduje per-row; wyświetla preview i listę błędów (duplikaty, brakujące pola).
  4. Jeśli błędów <=50%: importujemy transaksiowo; w przeciwnym razie rollback i szczegółowy raport.
  5. Po imporcie admin tworzy lesson/rozdział i przypisuje do Laury (ST-004).
  6. System rejestruje audit log i wyświetla skrócony raport (rows accepted, rows rejected, time) (ST-003, ST-009).
- Kryteria sukcesu:
  - Import 20–200 w <10s (perf. target).
  - Per-row błędy widoczne; transactional reject przy >50% błędów.
- Edge cases:
  - Upload pliku w złym kodowaniu (nie-UTF8) -> pokaż instrukcję konwersji + przykład.
  - Admin spoza LAN -> blokada z komunikatem, log i instrukcja jak dodać proxy do whitelist.
- Powiązane ST: ST-002, ST-003, ST-004, ST-009.

Flow C — "Admin: Monitorowanie postępów i eksport raportu"
- Cel: Szybkie sprawdzenie postępów Laury i pobranie CSV/PDF z listą sesji.
- Kroki:
  1. Admin loguje się na /admin (CIDR check).
  2. Otwiera Dashboard -> wybiera użytkownika (Laura) -> widzi weekly charts, mastered count, avg quiz score (7d).
  3. Klik "Export CSV/PDF" -> system generuje plik (<5s dla 20 users) i zapisuje audit log.
- Kryteria sukcesu:
  - Eksport <5s przy 20 użytkownikach.
  - Eksport zawiera wystarczające dane do odtworzenia sesji (timestamp, lesson id, score, change to SR state).
- Edge cases:
  - Brak danych -> wyświetl "No data for period" i przycisk "Generate sample report".
- Powiązane ST: ST-009, ST-008, ST-011.

---

## 3. User Journey Map — Laura (Uczeń)
Format: fazy / emocje / potrzeby / okazje do ulepszenia

Fazy: Discover → Onboarding → Practice (Session) → Post‑session Review → Repeat/Retention

1) Discover
- Akcja: Laura dostaje konto od rodzica, loguje się.
- Myśli/Emocje: ciekawość, lekka niepewność.
- Needs: prosty login, wyraźna informacja co robić.
- Opportunities: onboarding 1‑screen z "Start 15‑min" i big CTA.
- Heurystyka: Visibility of system status, Match between system and real world.

2) Onboarding
- Akcja: Przegląd krótkiego tutorialu „Jak działa sesja".
- Emocje: odprężenie jeśli proste; zniechęcenie jeśli długie.
- Needs: minimalny, step-by-step tutorial (3 kroki max), skip option.
- Opportunities: interaktywny pierwszy testowy card z audio "Play".
- Heurystyka: User control and freedom, Recognition rather than recall.

3) Practice (Session)
- Akcja: Faza aktywnego uczenia.
- Emocje: zaangażowanie, frustacja jeśli audio nie działa.
- Needs: szybkie audio, jasne przyciski, timer 15 min, łatwa odpowiedź.
- Opportunities: progress bar, micro‑rewards (streak, mastered count), undo last answer.
- Heurystyka: Error prevention, Feedback & visibility of system status.

4) Post-session Review
- Akcja: Podsumowanie wyników, zapis do dashboardu.
- Emocje: satysfakcja lub motywacja do poprawy.
- Needs: proste, wizualne podsumowanie; actionable next step ("Repeat weaker words").
- Opportunities: CTA „Repeat mistakes” albo „Share results with parent”.
- Heurystyka: Help users recognize/diagnose issues, Minimalist design.

5) Repeat/Retention
- Akcja: Powrót do aplikacji, kolejne sesje.
- Emocje: rutyna, przywiązanie jeśli UX nagradza.
- Needs: przypomnienie (poza MVP), przewidywalność.
- Opportunities: gamifikacja w przyszłości, możliwość ustawienia przypomnień (post-MVP).
- Heurystyka: Flexibility and efficiency of use.

---

## 4. User Journey Map — Rodzic / Admin
Fazy: Setup → Import & Assign → Monitor → Export & Ops

1) Setup
- Akcja: Deploy aplikacji via Docker Compose; skonfigurowanie Coqui/espeak (opcjonalnie).
- Emocje: umiarkowana pewność siebie / obawa przed błędami.
- Needs: klarowny `README.sample`, `.env.sample`, kroki uruchomienia.
- Opportunities: dodanie sanity-check script (docker-compose up -> healthcheck TTS + DB mount) i checklist w UI.
- Heurystyka: Help & documentation, Error prevention.

2) Import & Assign
- Akcja: Import CSV/JSON, naprawa błędów, utworzenie lesson i przypisanie ucznia.
- Emocje: ulga jeśli import działa; frustracja przy błędach.
- Needs: per-row validation, preview, rollback on >50% errors.
- Opportunities: drag‑and‑drop CSV, sample CSV generator, inline help for encoding.
- Heurystyka: Error prevention, Visibility of system status.

3) Monitor
- Akcja: Oglądanie charts i list sesji.
- Emocje: satysfakcja lub zaniepokojenie w razie regresji.
- Needs: szybkie, czytelne wykresy i filtry.
- Opportunities: presety filtrów (last 7d, last 30d), porównania.
- Heurystyka: Recognition rather than recall, Flexibility and efficiency.

4) Export & Ops
- Akcja: Export CSV/PDF; backup DB via Proxmox (operacyjne).
- Emocje: odpowiedzialność, chęć kontrolowania danych.
- Needs: szybkie, bezpieczne eksporty i audyt.
- Opportunities: predefiniowane raporty i guziki „Restore instructions”.
- Heurystyka: Help users recognize/diagnose issues, Aesthetic and minimalist design.

---

## 5. Krytyczne przypadki brzegowe (Edge cases)
1. Import >50% rows failed -> transactional rollback + jasny raport (ST-003).
2. Admin loguje się spoza LAN -> blokada + instrukcja whitelist proxy (ST-009).
3. TTS lokalny niedostępny -> fallback do espeak-ng lub phonetic hint (ST-005a, ST-005b).
4. Duplikacja słówek -> deduplikacja (english+polish) + opcja manual merge (ST-003).
5. SQLite file locked / corrupted -> instrukcja restore + „read-only” mode warning (ops).

---

## 6. Heurystyki Nielsena — szybka weryfikacja zgodności
Dla każdej heurystyki wskazuję miejsca do sprawdzenia/zaimplementowania:
- Visibility of system status: session timer, audio state, import progress.
- Match between system and real world: terminy znane uczniowi (flashcards, session), język polski w UI.
- User control & freedom: undo last answer, skip card, stop session.
- Consistency & standards: jednolite CTA (Start/Stop), format daty, langs.
- Error prevention: pre-validation CSV, rate limits, CIDR checks.
- Recognition rather than recall: prefilled lesson list, repeat mistakes CTA.
- Flexibility & efficiency: keyboard shortcuts (space=play), presety dla admina.
- Aesthetic & minimalist design: minimal on-screen elements podczas sesji.
- Help users recognize/diagnose: human-friendly import error messages, TTS diagnostics.
- Help & documentation: README.sample, in‑app "How to import" modal.

Każdy ekran i flow na etapie projektowania Lo‑Fi powinien być sprawdzony pod kątem tych heurystyk i zaplanować testy z Laurą.

---

## 7. Assumptions (potwierdzone / do potwierdzenia)
- Potwierdzone: Admin działa w LAN 192.168.1.0/24; backupy operacyjne; Coqui lokalny dostępny na homelabie.
- Do potwierdzenia z stakeholderem/testami użytkownika: preferowany voice rate (tempo), poziom tolerancji Levenshtein w quizach (domyślnie <=1), dokładne zasady gamifikacji.

## 8. Rekomendowane next steps (co zrobię po potwierdzeniu tej fazy)
- Przejść do Faza 2 (IA i makiety Lo‑Fi) — przygotuję sitemapę, główne ekrany (Login, Student Dashboard, Session UI, Admin Import, Admin Dashboard) i low-fidelity wireframes.
- Przygotować krótką listę zadań do testów z Laurą (3 test cases): pierwsze logowanie + pierwsza sesja + reakcja na brak audio.
- Opcjonalne: zebrać 3 krótkie próbki CSV do testów importu.

---

## 9. Krótkie podsumowanie wymagań powiązanych z deliverables Phase 1
- Persony: P-001..P-003 — Done (rozwinięte)
- Kluczowe user flows: A/B/C — Done
- User journey maps: Laura, Rodzic — Done
- Heurystyki Nielsena: mapped to flows — Done

---

Jeśli potwierdzasz ten rezultat, przejdę do Faza 2 — Architektura Informacji i Makiety Lo‑Fi. Proszę o jedną z opcji: "Zatwierdzam — przejdź do Faza 2" albo "Wprowadź zmiany" z listą poprawek.
