# Faza 2 — Architektura Informacji (IA) i Makiety Lo‑Fi

Data: 2025-09-30
Powiązanie: wyjściowe wymagania w `Final_Verified_Requirements_Document.md`, wyniki Fazy 1 w `Phase_1_Research_and_Empathy.md`.

Krótko: Ten dokument opisuje sitemapę, strukturę ekranów, reguły layoutu (siatka, gęstość), inwentaryzację komponentów oraz niskowiernościowe makiety (Lo‑Fi) dla MVP. Każdy ekran ma jawne powiązanie z ID historii (ST-XXX) i Personą (P-001/P-002).

## Co zrobię dalej (zakres Faza 2)
- Przygotować sitemapę i listę ekranów z mapowaniem do ST i Person.
- Określić reguły layoutu (12‑kolumnowa siatka, spacing, density) i akcesoryjne wymagania A11y.
- Zaproponować komponenty UI i ich stany (priorytety: sesja ucznia, import admina, dashboardy).
- Sporządzić Lo‑Fi wireframes (ASCII + proste schematy), flow interakcji dla najważniejszych ekranów.
- Dostarczyć kryteria akceptacji dla Fazy 2 i krótką listę testów do zaplanowania.

---

## 1. Sitemap (struktura aplikacji)
Mermaid-style sitemap (lo-fi):

sequence of pages:

- Home (/)
  - Login (/login) [ST-001]
  - Student Dashboard (/dashboard) [ST-008] (P-001)
    - Session View (/session/:id) [ST-005a, ST-006, ST-007] (P-001)
    - My Lessons (/lessons) [ST-004, ST-010] (P-001)
  - Admin (/admin) [ST-009] (P-002)
    - Admin Dashboard (/admin/dashboard) [ST-009]
    - Import (/admin/import) [ST-003]
      - Import Preview/Error Modal [ST-003]
    - Users (/admin/users) [ST-002]
    - Exports (/admin/exports) [ST-009]
  - Settings (/settings) [ST-005b, ST-012] (P-002)
  - Health & Ops (/health) (internal checks; not public)

Każda ścieżka powinna wymuszać RBAC: zwykły user nie widzi /admin.

---

## 2. Główne ekrany (nazwy, rola, powiązane ST, główne elementy)
- Login (/login)
  - Rola: uwierzytelnianie email+hasło (P-001, P-002)
  - Powiązane: ST-001
  - Elementy: email, password, submit, help link, error area, LAN check for /admin link visibility.

- Student Dashboard (/dashboard)
  - Rola: start sesji, podsumowanie, quick stats (P-001)
  - Powiązane: ST-008, ST-006
  - Elementy: Today session CTA, Next due cards, Mastered count, Recent session list (timestamp)

- Session UI (/session/:id)
  - Rola: główny ekran nauki z flashcards, audio, timer (P-001)
  - Powiązane: ST-005a, ST-006, ST-007
  - Elementy: large card, play/pause, answer input (MCQ / short-text), timer (15:00), progress bar, skip, undo, end session summary.

- Lessons (/lessons)
  - Rola: lista lekcji, create/edit (P-001, P-002)
  - Powiązane: ST-004, ST-010
  - Elementy: lesson list, create lesson CTA, ownership indicator, soft-delete action.

- Admin Dashboard (/admin/dashboard)
  - Rola: charts, quick filters, recent imports (P-002)
  - Powiązane: ST-009
  - Elementy: weekly chart, top users, recent sessions, export CTA.

- Import (/admin/import)
  - Rola: import CSV/JSON, per-row validation (P-002)
  - Powiązane: ST-003
  - Elementy: drag&drop area, sample CSV link, mapping preview, errors table, transactional warning, start/cancel buttons.

- Import Preview/Error Modal
  - Rola: prezentuje walidację, per-row errors, deduplikację sugestie
  - Kryteria: reject if >50% errors, allow manual fix for small sets.

- Users (/admin/users)
  - Rola: create/manage students (P-002)
  - Powiązane: ST-002
  - Elementy: create user form, list, audit log link, warning when >20 users.

- Exports (/admin/exports)
  - Rola: generowanie raportów CSV/PDF (P-002)
  - Powiązane: ST-009
  - Elementy: period picker, generate button, audit confirmation.

- Settings (/settings)
  - Rola: TTS engine selection, accents, test sound (P-002)
  - Powiązane: ST-005b, ST-012
  - Elementy: engine select, test button, credentials entry (masked), latency metric.

---

## 3. Layout i Reguły Wizualne (IA)
- Siatka: 12‑kolumnowa siatka responsywna (desktop‑first, MVP desktop). Gutter: 16px; container max-width: 1200px.
- Marginesy: container padding 24px.
- Baseline: 8px unit for spacing.
- Typografia (Lo‑Fi spec): użyj domyślnego fontu systemowego na razie; w Faza 3 wybierz Sans: Inter/Roboto.
- Gęstość: optymalna dla 13‑latki — medium spacing; listy z 8–12px row‑padding, cards with 16px internal padding.
- Kontrast: target AA for text; CTA high-contrast.
- Nawigacja:
  - Top nav: logo (left), page title, user menu (right).
  - Admin has left-side vertical nav for quick access (dashboard/import/users/exports/settings).
  - Student dashboard uses hero CTA "Start 15‑min session" centered.

Keyboard shortcuts (accessibility & efficiency):
- Space = play/pause audio (when card focused)
- Enter = submit answer in short-text
- ArrowRight = next card (skip)
- Ctrl+Z / Cmd+Z = undo last answer

A11y checks (minimum for Faza 2):
- All interactive controls reachable by keyboard and have visible focus state.
- Images/icons must have aria-label or role=img with accessible name.
- Color contrast AA; font-size at least 16px for body.

---

## 4. Component Inventory (priorytetowane)
Komponenty bazowe i ich stany — zrobimy prostą wersję w Lo‑Fi:

1. Button (primary, secondary, ghost) — states: default, hover, pressed, disabled.
2. Card (flashcard large, lesson card small) — front/back, loading state.
3. Audio control — play, pause, replay, mute; loading spinner for TTS generation.
4. Timer + progress bar — countdown, visual progress + numeric.
5. Input types: MCQ buttons, short-text input, keyboard submit.
6. Table — import validation table with per-row status (OK, warning, error).
7. Modal — overlay, confirm/cancel, large content for import preview.
8. Chart placeholder (weekly chart) — Lo‑Fi block with hover details.
9. File uploader — drag&drop + fallback browse.
10. Notification/Toast — success, warning, error; persistent for export audit.
11. Audit log view (simple list with timestamp, user, action).

Każdy komponent powinien mieć a11y attributes (role, aria-labels) i clear error states.

---

## 5. Low‑fidelity Wireframes (ASCII + brief interaction notes)
Poniżej prosty Lo‑Fi dla kluczowych ekranów. To wystarczy deweloperom i projektantowi wizualnemu jako podstawa.

A) Login (/login)

+-------------------------------------------+
| LOGO         |         Login              |
+-------------------------------------------+
| Email: [________________________]         |
| Password: [_____________________] [show]  |
| [Login (primary)]    [Need help?]         |
|                                            |
+--------------------------------------------+

Notes:
- Show human-friendly errors under inputs.
- If user in admin CIDR, show link to /admin after login.

B) Student Dashboard (/dashboard)

+-------------------------------------------------------------+
| LOGO    |   Today: 15m session CTA  [Start Session]        |
+-------------------------------------------------------------+
| Mastered: 12   | Avg quiz (7d): 82%   | Next due: 5 cards    |
+-------------------------------------------------------------+
| Recent sessions:                                          |
| - 2025-09-29 15:00  |  Score: 8/10 | Repeat mistakes [CTA] |
| - ...                                                    |
+-------------------------------------------------------------+

Notes:
- Start Session triggers /session/:id with lesson selection modal if multiple.

C) Session UI (/session/:id)

+-------------------------------------------------------------+
| TIMER [15:00]   Progress: [■■■■□□□□□]   Pause | End Session   |
+-------------------------------------------------------------+
| CARD (large):                                             |
|   ENGLISH WORD                                           |
|   [Play audio]  [Phonetic hint]                          |
|                                                          |
|  Answer area:                                             |
|  (MCQ buttons) or [___________]  [Submit]                 |
|  [Undo] [Skip]                                             |
+-------------------------------------------------------------+
| Footer: current streak / mastered / quick access to lessons |
+-------------------------------------------------------------+

Interaction notes:
- Autoplay configurable; if TTS generating show spinner and disable Submit until ready.
- If no audio, show phonetic transcription and highlight fallback.

D) Admin Import (/admin/import)

+-------------------------------------------------------------+
| Admin / Import                                              |
+-------------------------------------------------------------+
| Drag & drop file here  [or Browse]   [Sample CSV] [Template] |
|                                                              |
| Mapping: english -> english, polish -> polish                |
| [Start Import] [Cancel]                                      |
+-------------------------------------------------------------+
| Preview:                                                      |
| Row | english | polish | status                               |
| 1   | cat     | kot    | OK                                   |
| 2   | dog     |       | ERROR: missing polish                |
| ...                                                           |
+-------------------------------------------------------------+
| Errors: 2 of 20 rows. Transactional = YES -> proceed? [Yes]   |
+-------------------------------------------------------------+

E) Admin Dashboard (/admin/dashboard)

+-------------------------------------------------------------+
| LeftNav: Dashboard | Import | Users | Exports | Settings       |
+-------------------------------------------------------------+
| Weekly chart (placeholder)   | Top users list                 |
| Recent imports (list)        | Quick export [CSV/PDF]          |
+-------------------------------------------------------------+

---

## 6. Interaction patterns & rules (micro‑interactions)
- Import: show per-row inline edits in Preview modal; user can fix small number (<10) directly and re-validate.
- Session: answers saved locally every question and synced; in case of sudden tab close show "Resume last session" on login.
- TTS generation: optimistic UI — show placeholder wave + spinner; play when asset available.
- Exports: generate in background and notify user when ready; keep entry in audit log.

---

## 7. Accessibility & Heurystyki Nielsena — co sprawdzamy w Lo‑Fi
(krótkie checklisty na sprint designerski)
- Keyboard navigation for all flows (session, import, user create).
- Visible focus on all buttons and inputs.
- Clear, non-technical error messages for import problems.
- Minimal info density on Session UI: only necessary controls visible.
- Provide "Help" tooltip on import mapping and TTS settings.

---

## 8. Acceptance Criteria (Faza 2 — DoD)
- Dostarczona sitemap i lista ekranów z powiązaniem ST ID i Person.
- Lo‑Fi wireframes dla: Login, Student Dashboard, Session UI, Lessons, Admin Import (preview modal), Admin Dashboard, Users, Exports, Settings.
- Komponent inventory i layout rules (12‑col grid) zapisane.
- Lista A11y i Nielsen heurystyk powiązana z ekranami.
- Dwa krótkie testy użytkownika przygotowane (Laura first-session, Admin import).

Po spełnieniu powyższych kryteriów oznaczę Fazę 2 jako zakończoną i poproszę o zgodę na przejście do Faza 3 (Prototyp Hi‑Fi i specyfikacja wizualna).

---

## 9. Szybkie test‑case'y do przeprowadzenia z Laurą i Adminem (dołączać do backlogu)
1) Laura — First session happy path
- Start: account assigned and logged in.
- Steps: click Start Session -> audio plays -> answer 10 items -> see summary.
- Expected: session lasts 15 min (or ends when completed), audio plays or phonetic hint shown, results saved to dashboard.

2) Admin — Import CSV with some errors
- Start: admin logged in on LAN.
- Steps: upload CSV with 20 rows where 2 rows have missing polish; preview shows errors; fix inline; commit import.
- Expected: import completes, audit log entry, lesson created and assignable.

---

## 10. Deliverables (co dodaję do repo teraz)
- `Phase_2_IA_and_LowFi.md` (ten plik) — sitemap, screens, wireframes, AC.

---

Jeżeli akceptujesz wynik Fazy 2, napisz: "Zatwierdzam — przejdź do Faza 3" albo podaj listę zmian do wprowadzenia w tej fazie.
