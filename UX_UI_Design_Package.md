# UX/UI Design Package — Kompletny pakiet dla handoff

Wersja: 1.0
Data: 2025-09-30
Powiązanie: `Final_Verified_Requirements_Document.md`, `Phase_1_Research_and_Empathy.md`, `Phase_2_IA_and_LowFi.md`, `Phase_3_HiFi_Spec.md`

Cel: uporządkowany, kompletny pakiet projektowy do przekazania zespołowi deweloperskiemu i AI System Architect (kolejna rola). Zawiera IA, user flows, makiety Lo‑Fi, specyfikację Hi‑Fi (streszczenie), design tokens, bibliotekę komponentów i checklisty QA/A11y.

## Krótka zawartość (spis treści)
1. Executive summary
2. Architektura informacji (sitemap + ścieżki)
3. User flows i User Journey Maps
4. Lo‑Fi wireframes (referencje)
5. Hi‑Fi spec — streszczenie (kolory, typografia, tokeny)
6. Component library (opis i mapping do ST)
7. Interakcje krytyczne i reguły UX
8. A11y / Nielsen heurystyki — checklisty
9. QA / acceptance tests (mapping do RTM)
10. Assety i pliki do eksportu
11. Handoff notes dla dewelopera / architekta

---

## 1. Executive summary
MVP: lokalna aplikacja do nauki słówek (desktop-first), 15‑min sesje z TTS, panel admina do importu i monitoringu. Pakiet jest zgodny z wymaganiami ST-001..ST-015 i gotowy do przekazania do implementacji. UX ma być prosty dla Laury (P-001) i bezpieczny dla admina (P-002).

## 2. Architektura informacji (IA)
Sitemap (skrót):
- /login (ST-001)
- /dashboard (student) (ST-008)
  - /session/:id (ST-005a, ST-006, ST-007)
  - /lessons (ST-004, ST-010)
- /admin (ST-009)
  - /admin/dashboard (ST-009)
  - /admin/import (ST-003)
  - /admin/users (ST-002)
  - /admin/exports (ST-009)
- /settings (ST-005b, ST-012)

Access control: RBAC enforced; /admin visible/callable only for users with admin role and originating from allowed CIDR at app-level check.

## 3. User Flows i Journey Maps (skróty operacyjne)
Zestaw flow A/B/C przygotowanych w Faza 1 — gotowe do zaimplementowania w frontendzie wraz z automatycznymi komunikatami i fallbackami (np. no-audio fallback). Szczegóły w `Phase_1_Research_and_Empathy.md`.

## 4. Lo‑Fi wireframes
- Referencje: `Phase_2_IA_and_LowFi.md` — zawiera ASCII wireframes dla: Login, Student Dashboard, Session UI, Admin Import, Admin Dashboard, Users, Exports, Settings.
- Przy implementacji użyć tych layoutów jako podstawy strukturalnej.

## 5. Hi‑Fi spec — streszczenie (wyciąg najważniejszych tokenów)
Kolory:
- Primary: #4F46E5
- Primary hover: #6366F1
- Success: #16A34A
- Warning: #F59E0B
- Error: #DC2626
- Text primary: #0F172A
- Surface: #FFFFFF

Typography:
- Font: Inter (fallback system sans)
- Body: 16px, H1: 28px, H2: 22px

Spacing & grid:
- 12‑column desktop grid; container max-width 1200px; gutter 16px; baseline 8px.

Pełna specyfikacja: `Phase_3_HiFi_Spec.md` (ten plik zawiera szczegóły komponentów i motion).

## 6. Component Library (kluczowe komponenty + mapping do ST)
Poniższa lista to minimalna biblioteka do startu; komponenty muszą mieć warianty i a11y attributes.

- Button (Primary / Secondary / Ghost) — używany w: Login (ST-001), Dashboard CTA (ST-008), Import commit (ST-003)
- Flashcard (Large) — Session UI (ST-005a, ST-006)
- Audio Control — Session UI (ST-005a, ST-005b)
- Timer + Progress Bar — Session UI (ST-005a)
- MCQ / Short-text Input — Session UI (ST-007)
- Table (Import Preview) — Import (ST-003)
- Modal (Import Preview / End Session) — Import (ST-003), Session (ST-005a)
- Toast / Notification — Exports (ST-009), Import (ST-003)
- Admin Left Nav — Admin Dashboard (ST-009)

Każdy komponent powinien mieć: HTML snapshot, ARIA roles, keyboard interactions, error states.

## 7. Interakcje krytyczne i logika UX (do implementacji)
- TTS flow: check cache -> if exists play -> else trigger Coqui local -> fallback to espeak -> update cache. UI must show loading/aria-busy state. (ST-005a, ST-005b)
- Import: per-row validation, show preview, transactional rollback if >50% errors; inline edit for <=10 errors. (ST-003)
- Session: autosave answer after each question, resume last session on relogin. SR state update per SR algorithm (ST-006).
- Admin CIDR check: app-level verification using X‑Forwarded‑For / RemoteAddr and a trusted proxy whitelist. (ST-009, ST-011)

## 8. A11y i Nielsen heurystyki — checklisty implementacyjne
A11y (minimum): keyboard nav, focus visible, color contrast AA, aria-labels for icons, screen-reader friendly live regions for timer/events.
Nielsen: visibility of system status (timer), error prevention (import validation), recognition over recall (lesson lists), minimalist session UI.

## 9. QA / Acceptance tests (mapped to RTM)
Wybrane testy (do przekazania do QA):
- ST-001: Authentication — testy: invalid email, bad password, rate-limit.
- ST-003: Import — success path, >50% failure rollback, per-row errors shown, encoding error handling.
- ST-005a/b: Session/TTS — no-audio fallback, local Coqui latency <0.5s, cache behavior.
- ST-006: Spaced repetition — SR states transitions tests.
- ST-009: Admin dashboard/export — export latency <5s for 20 users, CIDR enforcement.

DoD check: wszystkie kryteria acceptance w Final Requirements muszą być zielone.

## 10. Assety i pliki do eksportu
Rekomendowane assety do przygotowania przez designera (lub dev):
- Ikony SVG (actions: play, pause, export, import, user, settings)
- Logo (SVG + raster 2x)
- Design tokens JSON (colors, spacing, radii) — mogę wygenerować na żądanie.

## 11. Handoff notes dla dewelopera / System Architect
API / Endpoints rekomendowane (przykładowe nazwy):
- POST /api/auth/login — body: {email,password}
- GET /api/users/:id/lessons
- POST /api/imports — multipart/form-data file upload -> returns importId
- GET /api/imports/:id/preview
- POST /api/imports/:id/commit
- POST /api/sessions/:id/answer
- GET /api/sessions/:id/progress
- POST /api/tts/generate — body: {word,engine,accent} -> returns url
- GET /api/tts/cache/:hash
- GET /api/admin/exports?period=... -> returns exportId; GET /api/admin/exports/:id/download

Security/ops notes:
- DB: SQLite on host volume, file path must be writable by container; include migration plan to Postgres when triggered.
- Config: .env (sample) for TTS provider keys, proxy whitelist, Argon2id params.

Architecture components references:
- TTS Engine Service (Coqui local or espeak fallback)
- Audio Cache (file store, 90-day retention)
- App Backend (FastAPI recommended) + SPA frontend

## 12. Handoff deliverables (files dołączone do repo)
- `Phase_1_Research_and_Empathy.md`
- `Phase_2_IA_and_LowFi.md`
- `Phase_3_HiFi_Spec.md`
- `UX_UI_Design_Package.md` (ten plik)
- `AI_Handoff_Issue.md` (wygenerowany obok)

---

## 13. Rekomendowane next steps (dla zespołu)
1. Dev: utworzyć repo-skeleton + Dockerfile + Docker Compose wg Sprint 1 planu.
2. Dev: implementować auth + user management + DB schema (ST-001, ST-002).
3. UX: review Hi‑Fi spec with stakeholder (Laura & Parent) — drobne poprawki microcopy.
4. Ops: przygotować Proxmox backup plan i health checks.

---

Jeśli wszystko OK, zatwierdź: "Zatwierdzam — generuj AI Handoff Issue" (wtedy plik `AI_Handoff_Issue.md` jest również gotowy - już teraz wygenerowany).