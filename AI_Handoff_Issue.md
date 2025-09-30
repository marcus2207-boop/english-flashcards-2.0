# AI_Handoff_Issue.md

Wersja: 1.0
Data: 2025-09-30
Autor: AI UX/UI Designer

UWAGA: To jest specjalistyczne Issue/Task przeznaczone dla AI Agenta (Copilot) lub innego autonomicznego kreatora UI/Frontendu. Zawiera wszystkie dane niezbędne do automatycznego wygenerowania Hi‑Fi ekranów oraz frontend‑ready komponentów i assetów. Każdy ekran ma jawne powiązania z ID historii (ST-XXX) i z kluczowymi komponentami architektury.

---

## 1) Kontekst Produktu
System: Lokalna aplikacja webowa do nauki słówek (MVP) uruchamiana via Docker Compose na homelabie. Docelowe role użytkowników:
- P-001: Uczeń (Laura) — główny użytkownik konsumencki.
- P-002: Rodzic / Admin — zarządzanie kontami, import materiałów, monitoring.

Środowisko uruchomieniowe: LAN 192.168.1.0/24; SQLite na woluminie hosta; opcjonalny Coqui lokalny dla TTS; backupy realizowane operacyjnie (Proxmox).

Powiązania RTM: implementacja musi spełniać wymagania ST-001..ST-015 (patrz Final_Verified_Requirements_Document.md).

---

## 2) Zakres UX do Wykonania (precyzyjna lista artefaktów)
AI Agent ma wygenerować (artifacty gotowe do bezpośredniego zaimportowania do repo/design system):

A. High‑Fidelity screens (annotated)
- Login (/login) — ST-001
- Student Dashboard (/dashboard) — ST-008
- Session UI (/session/:id) — ST-005a, ST-006, ST-007
- Lessons list & lesson editor (/lessons) — ST-004, ST-010
- Admin Dashboard (/admin/dashboard) — ST-009
- Admin Import (/admin/import) including Import Preview Modal — ST-003
- Admin Users (/admin/users) — ST-002
- Exports view (/admin/exports) — ST-009
- Settings -> TTS settings (/settings) — ST-005b, ST-012

B. Component library (coded tokens + component snapshots)
- Design tokens JSON (colors, spacing, radii, typography)
- Button variants, Card variants, Modal, Table rows (import), Audio control, Timer, MCQ/Short input
- Accessible attributes and keyboard interactions documented per component

C. Anotated Interaction Specs (micro‑interactions)
- TTS generation flow with states: cache-check -> generating -> playable -> failure
- Session timer behaviour (15min default), pause/resume, end-summary flows
- Import preview: inline edit, transactional commit rule (>50% rollback)

D. Exportable assets
- Icons (SVG), logo (SVG + raster), token JSON, README for design tokens

E. QA checklist and A11y report items (axe/lighthouse targets and expected fixes)

Deliverables format: HTML/CSS component sandbox or Storybook stories + annotated PNG/SVG screens and a JSON tokens file. (Note: user asked earlier not to create interactive prototypes; produce only static Hi‑Fi assets and machine-readable tokens and component specs.)

NOTE FOR GITHUB COPILOT AGENT (background PR workflow)
- The repository's GitHub Copilot agent is authorized to act on this Issue and *must* generate clickable/interactable artifacts (Storybook stories and/or a lightweight HTML prototype) as a follow-up automated task.
- Upon generating the interactive artifacts the Copilot agent should create a branch `feat/ui-handoff/<ticket>` and open a Pull Request against `main` containing:
  - `design-tokens.json` in repo root
  - `storybook/` or `prototype/` skeleton with static HTML/JS (clickable flows) and a README describing how to run locally
  - annotated Hi‑Fi PNG/SVGs in `design/` and machine-readable component specs in `components/specs/`
  - an `a11y-report.html` (axe results) and short QA checklist
- The PR description must reference this file `AI_Handoff_Issue.md` and include a short summary of artifacts and any remaining manual steps.

This Issue therefore acts as the trigger: produce static Hi‑Fi assets in repo AND interactive mockups via Copilot background agent PR.

---

## 3) Wymagania Wizualne i Branding (dokładne specyfikacje)
Kolory (HEX):
- --color-primary: #4F46E5
- --color-primary-500: #6366F1
- --color-primary-700: #4338CA
- --color-success: #16A34A
- --color-warning: #F59E0B
- --color-error: #DC2626
- --neutral-900: #0F172A
- --neutral-700: #374151
- --neutral-400: #9CA3AF
- --neutral-200: #E5E7EB
- --bg-surface: #FFFFFF

Typography tokens:
- Font family: Inter variable, fallbacks system sans
- Base: 16px / line-height 1.5
- H1: 28px / 600
- H2: 22px / 600
- Caption: 13px

Grid & layout:
- Desktop-first 12-column grid; container max-width 1200px; gutter: 16px; baseline 8px; spacing tokens as in `Phase_3_HiFi_Spec.md`.

Accessibility:
- Contrast AA; focus ring 2px using #A78BFA; keyboard nav and ARIA labels mandatory.

Language: UI in Polish (primary), microcopy tone: simple and empathetic (see content strings in `Phase_3_HiFi_Spec.md`).

---

## 4) Reguły i Logika UX krytycznych funkcji
Dla AI Agent podajemy szczegółową logikę, aby wygenerowany frontend był gotowy do podłączenia backendu.

A. TTS flow (priority)
- Input: {word, preferredEngine (coqui|espeak|external), accent}
- Steps:
  1. Hash key = sha256(engine + word + accent + voiceParams)
  2. Check GET /api/tts/cache/:hash -> if 200 return url
  3. Else POST /api/tts/generate -> returns taskId
  4. Poll GET /api/tts/generate/:taskId status until success or timeout (5s for local Coqui target)
  5. On success, GET /api/tts/cache/:hash and play
  6. On failure fallback to espeak phonetic rendering and show toast "Audio niedostępne — pokazuję fonetykę"
- UI rules: while generating aria-busy=true, disable submit of answer where audio required, show spinner overlay on Play button.

B. Import logic (priority)
- Upload file -> backend returns validation report with per-row statuses and suggested dedup actions.
- UI must present: acceptedCount, rejectedCount, list of errors with inline editable cells for small fixes.
- Transaction rule: if rejectedCount / total > 0.5 -> show explicit rollback warning and disable Commit; allow admin to toggle force-commit only with secondary confirmation.
- Encoding rule: detect BOM and encoding; if not UTF-8, show instructions to convert + sample command (icon link).

C. Session & Spaced Repetition (priority)
- Session default length 15min (configurable per session in settings)
- After each answer POST /api/sessions/:id/answer -> backend updates SR state and returns updated card status
- SR algorithm: 4 states (New, Learning, Review, Mastered). Use returned intervals from backend. UI must display SR state and next due date.

D. Admin CIDR rule
- On admin routes, frontend must call /api/me which returns {role, ipOrigin} and UI must hide/show admin nav based on role and ipOrigin validation; final enforcement at backend.

---

## 5) Zasady Layoutu i Gęstości (developer-ready)
- Desktop: 12 columns, 1200px container
- Tablet breakpoint: 768px -> 8 columns
- Mobile breakpoint: 420px -> 4 columns
- Baseline spacing unit: 8px; gutters 16px; component paddings map to spacing tokens.
- Session card preferred width 720px (centered) on desktop.

---

## 6) Kryteria Akceptacji (QA) — testowalne warunki
Lista testów które AI Agent powinien wygenerować razem z artefaktami:
- Visual: pixel‑approx match between Hi‑Fi screens and provided specs (colors, typography, spacing)
- Accessibility: keyboard nav works; focus order sensible; contrast checks pass (AA)
- Functional: import preview shows per-row statuses; transactional rollback behavior shown; TTS states reachable in UI flows
- Performance: mock local TTS generation latency show target values (<0.5s in local mode) in dev sandbox

---

## 7) Dodatkowe Wskazówki dla Copilot (konkretne instrukcje)
- Zacznij od siatki 12‑kolumn i tokenów (colors + spacing) — wygeneruj `design-tokens.json` w repo root.
- Dla komponentów generuj Storybook stories (CSF v3) z przyjaznymi knobs for states (loading, error, success).
- Zadbaj o role/aria attributes w każdym komponencie. Dodaj keyboard shortcuts mapping file `shortcuts.md`.
- W import preview wygeneruj helper "Fix all simple errors" który automatycznie uzupełnia brakujące pola jeżeli można (np. missing polish -> empty placeholder) — wymaga admin confirmation.
- W Session UI wygeneruj local mock mode to test without backend (mock TTS, mock sessions) and toggled by DEBUG=true env.

---

## 8) Definition of Done (DoD)
Praca uznana za ukończoną kiedy:
1. Wygenerowane statyczne Hi‑Fi screeny (PNG/SVG annotated) dla wszystkich ekranów z punktu 2.
2. Wygenerowany `design-tokens.json` zawierający wszystkie tokeny z sekcji 3.
3. Component library (Storybook) z podstawowymi komponentami i ich wariantami.
4. Machine-readable component spec (prop signatures, aria attributes) i README jak integrować z backendem.
5. QA checklist i A11y report (axe) z maksymalnie 0 krytycznymi problemami.
6. Plik `AI_Handoff_Issue.md` w repo z powiązaniami RTM (ten dokument).

---

## 9) ELEMENT RTM — powiązania Story ↔ Ekran ↔ Komponenty Architektoniczne
Tabela mappingu (wybrane elementy):

- ST-001 — Login
  - Ekran: /login
  - Komponenty: Button, Input, Toast
  - Architektura: /api/auth/login (Backend), Session cookie (HttpOnly), Argon2id hash params storage

- ST-002 — Admin create users
  - Ekran: /admin/users
  - Komponenty: Form, Table, Audit Log
  - Architektura: /api/admin/users, Audit logging service

- ST-003 — Import CSV/JSON
  - Ekran: /admin/import + import preview modal
  - Komponenty: FileUploader, Table(Row), Modal
  - Architektura: /api/imports (upload), import validator worker, transactional commit endpoint

- ST-004 — Lesson CRUD
  - Ekran: /lessons (list + editor)
  - Komponenty: Card, Editor, Soft-delete control
  - Architektura: /api/lessons

- ST-005a/b — Flashcards & TTS
  - Ekran: /session/:id, /settings (TTS)
  - Komponenty: Flashcard, AudioControl, Timer
  - Architektura: TTS service (local coqui or espeak), /api/tts/generate, audio cache storage

- ST-006 — Spaced repetition
  - Ekran: session + dashboard
  - Komponenty: SR badge, Schedule indicator
  - Architektura: SR algorithm (backend), /api/sessions/:id/answer

- ST-007 — Quiz engine
  - Ekran: /session
  - Komponenty: MCQ, Short-text input
  - Architektura: /api/sessions

- ST-008 — Student dashboard
  - Ekran: /dashboard
  - Komponenty: Cards, Recent sessions list
  - Architektura: /api/users/:id/summary

- ST-009 — Admin dashboard & exports
  - Ekran: /admin/dashboard, /admin/exports
  - Komponenty: Charts, Export job queue
  - Architektura: /api/admin/exports, export worker, audit log

- ST-010 — Student lesson management
  - Ekran: /lessons
  - Komponenty: Editor, Ownership controls
  - Architektura: /api/lessons

- ST-011 — Privacy & local storage
  - Ekran: settings / admin
  - Komponenty: Data deletion control, Audit log
  - Architektura: DB (SQLite), deletion endpoint

- ST-012 — TTS settings & test
  - Ekran: /settings
  - Komponenty: Engine select, Test sound
  - Architektura: /api/tts/test, config env

- ST-013..ST-015 — backlog / future
  - Ekrany: dokumentacja / ops pages

---

## Zadania dodatkowe (opcjonalne do automatyzacji)
- Wygenerować `design-tokens.json` (kolory, spacing, radii) — rekomendowane pierwszy task dla AI Agent.
- Wygenerować Storybook skeleton z podstawowymi komponentami.

---

End of Issue. Implement according to the DoD and report status with artifacts: `design-tokens.json`, annotated screens, Storybook build URL, and A11y report.
