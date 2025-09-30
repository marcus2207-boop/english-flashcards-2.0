# Faza 3 — Prototyp Hi‑Fi i Specyfikacja Wizualna

Data: 2025-09-30
Powiązanie: wynik Fazy 1 (`Phase_1_Research_and_Empathy.md`) i Fazy 2 (`Phase_2_IA_and_LowFi.md`).

Cel Fazy 3: dostarczyć kompletną, gotową do implementacji specyfikację Hi‑Fi (kolory, typografia, design tokens, komponenty z wariantami i stanami), opis ekranów w wysokiej wierności oraz instrukcję utworzenia interaktywnego prototypu (Figma/HTML). Ten dokument zawiera wszystko, co potrzebne, by stworzyć UI/Frontend zgodny z wymaganiami MVP i przygotować bezbłędny handoff do deweloperów.

Checkpoint: interaktywny prototyp (Figma/Framer/HTML) przez Ciebie zatwierdzony.

---

## 1. Kontrakt Phase 3 (krótkie warunki sukcesu)
- Inputs: wymagania ST-001..ST-015, Lo‑Fi wireframes, persony.
- Outputs: `Phase_3_HiFi_Spec.md` (ten plik), zestaw design tokens, przygotowany plan plików prototypu (Figma), gotowe assety do eksportu (opis).
- Kryteria sukcesu: wszystkie ekrany kluczowe HF opisane, style i komponenty zdefiniowane, checklist A11y i Nielsen powiązana z ekranami, interaktywny prototyp do recenzji.

Edge cases, które pokrywamy:
- Brak audio: stan „no-audio” i fallbacky wizualne.
- Import z błędami: widoczne stany błędu/warning w tabeli i modalach.
- Admin poza LAN: komunikat informacyjny i instrukcja dodania proxy.

---

## 2. Paleta kolorów (wersja Hi‑Fi, dostępność AA)
Paleta zaprojektowana pod kątem czytelności dla 13‑latki i zgodności z AA.

- Primary (CTA): Indigo 600 — #4F46E5
- Primary hover: Indigo 500 — #6366F1
- Primary active: Indigo 700 — #4338CA
- Accent (success): Green 600 — #16A34A
- Accent (warning): Amber 500 — #F59E0B
- Accent (error): Red 600 — #DC2626
- Neutral 900 (text primary): #0F172A
- Neutral 700 (text secondary): #374151
- Neutral 400 (borders / disabled): #9CA3AF
- Neutral 200 (background panels): #E5E7EB
- Surface / background: #FFFFFF

Dodatkowe:
- Focus ring: Indigo 300 — #A78BFA with 2px outline (prefers-reduced-motion respects)
- Phonetic hint background: #F3F4F6 (soft neutral)

Kontrast: Primary text on Surface = #0F172A on #FFFFFF (AA+). CTA white on Primary = #FFFFFF on #4F46E5 (sufficient). Wszystkie kombinacje button/background do przetestowania podczas implementacji.

---

## 3. Typografia i tokeny typograficzne
- Primary UI font: Inter (variable) — alternatives system sans: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial.
- Font weights used: 400 (regular), 500 (medium), 600 (semibold), 700 (bold).

Design tokens (CSS var names suggestion):
- --font-base: 'Inter', system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', Arial;
- --font-size-base: 16px
- --line-height-base: 1.5
- --fs-h1: 28px; --lh-h1: 1.2
- --fs-h2: 22px; --lh-h2: 1.25
- --fs-body: 16px; --lh-body: 1.5
- --fs-caption: 13px
- Spacing: --space-xxs:4px; --space-xs:8px; --space-sm:12px; --space-md:16px; --space-lg:24px; --space-xl:32px

Notes:
- Body minimum 16px for accessibility.
- Large CTA on student session should use semibold 600 and fs 18–20px to be tappable and prominent.

---

## 4. Design Tokens (kolory, spacing, radii, shadows)
- --color-primary: #4F46E5
- --color-primary-500: #6366F1
- --color-success: #16A34A
- --color-warning: #F59E0B
- --color-error: #DC2626
- --color-bg: #FFFFFF
- --color-surface: #F8FAFC
- --radius-sm: 6px
- --radius-md: 10px
- --radius-lg: 14px
- --shadow-sm: 0 1px 2px rgba(15,23,42,0.04)
- --shadow-md: 0 4px 12px rgba(15,23,42,0.08)

---

## 5. Komponenty Hi‑Fi (specyfikacja dla deweloperów)
Każdy komponent zawiera: warianty, states, accessibility notes, token mapping.

1) Button (Primary / Secondary / Ghost)
- Primary: background --color-primary, color: #FFF, padding: 12px 20px, border-radius --radius-md, font-weight 600.
- States: hover (primary-500), active (primary-700), disabled (opacity 0.5, pointer-events none).
- Accessibility: aria-pressed for toggle; focus-visible: 2px outline using focus ring.

2) Flashcard — Large
- Structure: header (phonetic + small meta), main word (H1 style), controls row (Play | Phonetic | Progress)
- Sizes: card width 720px max, padding --space-lg, border radius --radius-lg.
- States: default, loading (skeleton), no-audio (info chip), answered-correct (success border + tick), answered-wrong (error border + hint).
- Accessibility: card role="group" with aria-label="Flashcard: [word]"; controls reachable by keyboard.

3) Audio Control
- Icon button large (48x48) circular, primary icon color neutral 900; playing state animates icon; loading spinner overlay when generating.
- When generating: aria-busy=true, audio button disabled with title "Generating audio..."
- Provide accessible text "Play pronunciation for [word]".

4) Timer + Progress Bar
- Timer numeric large left; progress bar full-width under header; animate from right-to-left as time elapses (reduced motion respects).
- When <1min left, progress bar turns --color-warning (amber) and pulse small glow.

5) MCQ & Short-text Input
- MCQ: 3–4 buttons stacked vertically, each full width, hover & focus states, selected state (primary outline). Keyboard accessible.
- Short-text: input with placeholder, submit button; on wrong answers show inline hint with Levenshtein suggestion (if enabled).

6) Import Table
- Columns: row#, english, polish, tags, status
- Status chip variants: OK (green), Warning (amber), Error (red)
- Editable cells: for small error count, inline edit with save/cancel. Provide per-row aria-describedby to error.

7) Modal (Import Preview)
- Full-screen on mobile, centered dialog on desktop. Max-width 1000px, scrollable body, strong primary action "Commit Import" with transactional warning.

8) Admin Charts
- Simple bars/lines with hover tooltip; show skeleton while loading.

9) Toast / Notifications
- Top-right stack, autoshow 6s, persistent for export ready until dismissed; include small action button to open exports list.

10) Left-side Admin Nav
- Collapsible, icons + label; active item highlight; sticky.

---

## 6. High‑Fidelity Screen Specs (annotated)
Poniżej opisuję 5 kluczowych ekranów z anotacjami pixel-level where needed. Implementacja powinna odwoływać się do design tokens i komponentów powyżej.

1) Login (/login)
- Layout: center card (max-width 420px), logo above, title "Zaloguj się", email & password fields, primary button.
- States: invalid email (text red under field), invalid password length (show hint "min 10 znaków"), request error (toast). 
- Accessibility: labels associated with inputs, remember me optional checkbox (aria-checked), show/hide password toggle.
- Related ST: ST-001

2) Student Dashboard (/dashboard)
- Hero: centered CTA big button "Start 15‑min session" (primary). Under CTA three small cards with Mastered, Avg Quiz (7d), Next due.
- Recent sessions list: each item shows timestamp, score, and quick link "Repeat mistakes".
- Related ST: ST-008, ST-006

3) Session UI (/session/:id)
- Main container: left area (card + controls), right area (session stats + upcoming cards list) — responsive: stack vertical on small widths.
- Card: large H1 word, below phonetic hint chip and audio control; below answer UI (MCQ or short-text). Timer top-right with progress bar.
- End session modal: summary with mastered counts, accuracy, options: "Repeat mistakes" (quick start) or "Return to dashboard".
- Error states: if TTS generation fails, show unobtrusive banner "Audio niedostępne — pokazuję fonetykę" with action "Retry".
- Related ST: ST-005a, ST-006, ST-007

4) Admin Import (/admin/import)
- Upper panel: drag&drop area with sample CSV, mapping fields auto-detected.
- Lower panel: preview table (paginated), filter for errors only, knob to switch transactional mode on/off (but default ON for >50% rule).
- Modal flow: on Start Import -> show Import Preview modal with counts and actions to fix inline.
- Related ST: ST-003

5) Admin Dashboard (/admin/dashboard)
- Two-column layout: charts and lists; quick export button top-right; recent imports list with link to preview.
- Exports panel: show status, time to generate, and download link; audit log entry accessible.
- Related ST: ST-009

---

## 7. Motion & Interaction Spec
- Duration defaults: 120ms for micro interactions (buttons), 220–320ms for larger transitions (modals), easing: cubic-bezier(0.2,0.8,0.2,1).
- Progress bar: linear animation; when pausing/resuming, animation pauses.
- Focus states: 2px outline fade-in 80ms.
- Reduced Motion: respect user prefers-reduced-motion — disable non-essential animations (e.g., subtle pulsing).

---

## 8. Accessibility (A11y) Requirements
- WCAG target: AA for color contrast; keyboard navigation full coverage.
- Text alternatives: all icons have accessible names; audio player includes captions/transcript option (phonetic hint) for users who cannot hear audio.
- Screen reader flows: flashcard announced with role=dialog/region; announce timer updates every full minute, and final 10-second countdown announced.
- Focus management: after modal open focus goes to first actionable control; after modal close focus returns to element that opened modal.

Testing notes: run Axe (or Lighthouse) test during implementation and aim for zero critical issues on Desktop.

---

## 9. Content & Microcopy (kluczowe stringi)
- Login errors: "Nieprawidłowy email"; "Hasło musi mieć minimum 10 znaków".
- Import messages: "Import zakończony: X zaakceptowanych, Y odrzuconych"; "Transakcyjny rollback (więcej niż 50% błędów)".
- Session messages: "Audio generowane..."; "Audio niedostępne — pokazuję fonetykę".
- Export messages: "Raport gotowy — pobierz".

Tone: prosty, empatyczny, dostosowany dla rodzica i ucznia — unikać technicznego żargonu przy komunikatach dla P‑001.

---

## 10. Prototyp (NOT REQUESTED)
Na podstawie wytycznych stakeholdere'a — prototypy interaktywne NIE SĄ wymogiem tej fazy.
Ten dokument dostarcza wyłącznie kompletnej specyfikacji Hi‑Fi: kolory, typografia, design tokens, szczegółowe opisy komponentów, stany, motion i pełne anotowane opisy ekranów.
Wszelkie instrukcje tworzenia prototypu pozostają dostępne jako referencja wewnętrzna, ale nie będą realizowane automatycznie w repo. Jeżeli później zajdzie potrzeba prototypu (Figma/HTML), mogę go przygotować na osobne żądanie.

---

## 11. QA & Test Cases (Hi‑Fi specific)
Dla każdego testu podaję oczekiwany rezultat.

1) Laura — Hi‑Fi session visual and audio check
- Przygotowanie: zalogowana Laura, lekcja przypisana, audio cache empty, Coqui lokalny dostępny.
- Steps: Start Session -> audio plays (<=0.5s) -> answer questions -> end session -> summary shows mastered.
- Expected: audio latency ok, UI responsive, session summary correct.

2) Admin — Import + inline fix
- Przygotowanie: admin on LAN, CSV with 20 rows 2 zawiera błędy.
- Steps: Upload -> preview -> inline fix 2 rows -> Commit -> import success and audit log created.
- Expected: transaction passes, lesson created, exported report shows correct counts.

3) Accessibility keyboard flow — Session UI
- Steps: tab through controls, space plays audio, Enter submits, Ctrl+Z undo.
- Expected: all controls reachable, focus visible and announced by screen reader.

4) Export generation smoke
- Steps: Admin click Export -> backend mock returns file -> toast appears with link.
- Expected: toast persistent, audit log entry exists.

---

## 12. Acceptance Criteria (Faza 3 — DoD)
- Hi‑Fi spec document (ten plik) zawierający kolory, typografię, design tokens, komponenty, motion, A11y i content microcopy — Done.
- Gotowe anotowane ekrany Hi‑Fi (opis) dla Login, Dashboard, Session, Admin Import, Admin Dashboard — Done.
- Prototypy interaktywne NIE SĄ częścią tego DoD (specyfikacja tylko). Jeśli prototyp będzie potrzebny, zostanie wyprodukowany na osobne żądanie.
- A11y checklist passed in manual smoke tests and automated Axe run (zero critical issues).

---

## 13. Artefakty do repo i proponowane pliki do wygenerowania (opcjonalne)
- `Phase_3_HiFi_Spec.md` (ten plik)
- `design-tokens.json` (JSON export — zawiera kolory, spacing, radii) — mogę wygenerować jeśli chcesz.
- `figma-setup.md` — krok po kroku import do Figma (mogę wygenerować jako dokument referencyjny).

Uwaga: nie zostanie wygenerowany żaden `prototype/` folder ani plik prototypu bez wyraźnego żądania — zgodnie z Twoją preferencją.

---

## 14. Next steps i propozycja do zatwierdzenia
- Jeśli akceptujesz specyfikację Hi‑Fi (ten dokument), napisz: "Zatwierdzam — przejdź do Faza 4".
- Jeżeli chcesz dodatkowo wygenerować `design-tokens.json` (tylko tokensy) lub referencyjny `figma-setup.md`, napisz: "Wygeneruj tokens" lub "Wygeneruj figma-setup".

Uwaga: prototypy interaktywne nie będą tworzone automatycznie; przygotuję je tylko na osobne żądanie.

---

Na kolejny krok potrzebuję Twojego potwierdzenia, żeby przejść do Faza 4.