# QA Checklist - English Flashcards 2.0

This checklist validates the UX/UI implementation against requirements from AI_Handoff_Issue.md.

## Design Tokens ✅

- [x] design-tokens.json created with all color tokens
- [x] Spacing tokens defined (xxs through xxl, 8px baseline)
- [x] Typography tokens (Inter font family, sizes, weights, line heights)
- [x] Border radius tokens (sm, md, lg, full)
- [x] Shadow tokens (sm, md, lg)
- [x] Motion tokens (duration, easing)
- [x] Layout tokens (grid columns, breakpoints, container max-width)
- [x] Focus ring specification (2px width, Indigo 300 color)

## Component Specifications ✅

### Button Component
- [x] Primary, secondary, ghost variants specified
- [x] States: default, hover, focus, active, disabled, loading
- [x] Size variants: small, medium, large
- [x] Accessibility attributes documented (role, aria-labels, keyboard interactions)
- [x] Design token mappings complete
- [x] Implementation examples provided

### Audio Control Component
- [x] TTS flow documented (cache-check → generating → playable → failure)
- [x] All states specified with visual changes and ARIA attributes
- [x] Polling mechanism defined (500ms interval, 5s timeout)
- [x] Fallback behavior (phonetic transcription + toast)
- [x] Size variants (small, medium, large)
- [x] Keyboard interaction (Space bar)
- [x] Backend endpoint integration documented

### Modal Component
- [x] Size variants (small, medium, large, fullscreen)
- [x] Focus trap implementation specified
- [x] Keyboard interactions (Esc, Tab, Shift+Tab)
- [x] Import Preview Modal detailed specification
- [x] Inline editing behavior documented
- [x] Transactional rollback rules (>50% errors)
- [x] Accessibility requirements (aria-modal, focus management)

### Timer Component
- [x] States: idle, running, paused, warning, complete
- [x] Progress bar animation specified
- [x] Warning threshold behavior (< 1 minute)
- [x] Screen reader announcements defined
- [x] Pause/resume functionality
- [x] Final countdown (last 10 seconds)
- [x] Reduced motion support

## High-Fidelity Screen Specs ✅

### Login Screen (ST-001)
- [x] Layout specified (centered card, 420px max-width)
- [x] Component breakdown provided
- [x] Validation states documented
- [x] Error messages in Polish
- [x] Accessibility attributes
- [x] Backend integration endpoints
- [x] Responsive behavior
- [x] Security considerations (HttpOnly cookies, rate limiting)

### Session UI (ST-005a, ST-006, ST-007)
- [x] Two-column layout (desktop) / single column (mobile)
- [x] Flashcard specifications
- [x] Audio control integration
- [x] Answer UI (MCQ and short text) variants
- [x] Timer with progress bar
- [x] Session stats display
- [x] End session modal
- [x] Keyboard shortcuts mapped
- [x] Screen reader announcements
- [x] SR state updates after answers

### Additional Screens
- [ ] Student Dashboard (ST-008) - Created placeholder
- [ ] Lessons list & editor (ST-004, ST-010) - Created placeholder
- [ ] Admin Dashboard (ST-009) - Created placeholder
- [ ] Admin Import (ST-003) - Created placeholder
- [ ] Admin Users (ST-002) - Created placeholder
- [ ] Exports view (ST-009) - Created placeholder
- [ ] Settings/TTS (ST-005b, ST-012) - Created placeholder

**Note:** Placeholder specs created; detailed specifications follow same pattern as Login and Session screens.

## Keyboard Shortcuts ✅

- [x] shortcuts.md created with complete mapping
- [x] Global shortcuts documented (Tab, Esc, /)
- [x] Session shortcuts (Space, Enter, ArrowKeys, Ctrl+Z)
- [x] Admin shortcuts (Alt+I, Alt+U, Alt+E, Alt+D)
- [x] Import preview shortcuts
- [x] Accessibility features documented
- [x] Focus management rules
- [x] Screen reader announcements
- [x] Implementation notes and code examples

## Accessibility (A11y) ✅

### Keyboard Navigation
- [x] All interactive elements reachable via Tab
- [x] Focus order logical (left-to-right, top-to-bottom)
- [x] Focus indicators visible (2px outline, Indigo 300)
- [x] No keyboard traps
- [x] Modal focus management (trap and return)

### Screen Reader Support
- [x] ARIA roles defined for all components
- [x] ARIA labels documented
- [x] ARIA live regions for dynamic updates
- [x] State changes announced
- [x] Timer announcements specified
- [x] TTS state announcements

### Color Contrast
- [x] Primary text on surface: AA+ compliant
- [x] Button colors meet AA standard
- [x] Focus ring contrast: 3:1 minimum
- [x] Error states use color + icon (not color alone)

### Motion
- [x] prefers-reduced-motion media query support
- [x] Essential animations remain functional
- [x] Decorative animations disabled

## Design System Integration

### Token Usage
- [x] All components reference design tokens
- [x] CSS custom properties pattern documented
- [x] Token naming follows convention
- [x] No hard-coded values in component specs

### Component Library
- [x] Components organized by category (atoms, molecules, organisms)
- [x] Prop signatures defined
- [x] State variants documented
- [x] Usage guidelines (dos and donts)
- [x] Integration examples provided

## Backend Integration ✅

### API Endpoints Documented
- [x] TTS flow endpoints (cache, generate, poll)
- [x] Session endpoints (get, answer, end)
- [x] Import endpoints (upload, validate, commit)
- [x] Authentication endpoints (login)

### Request/Response Formats
- [x] TTS generate request/response
- [x] Session answer request/response
- [x] Import validation report structure
- [x] Error response formats

### State Management
- [x] SR algorithm integration points
- [x] Session state updates
- [x] Import transaction rules
- [x] Audio cache strategy

## Responsive Design ✅

### Breakpoints
- [x] Mobile: 420px
- [x] Tablet: 768px
- [x] Desktop: 1024px

### Grid System
- [x] 12 columns (desktop)
- [x] 8 columns (tablet)
- [x] 4 columns (mobile)
- [x] 1200px container max-width
- [x] 16px gutters

### Component Responsiveness
- [x] Login card: 420px → 90% width
- [x] Session layout: 2-column → single column
- [x] Modal: large → fullscreen on mobile
- [x] Touch targets: 48px minimum on mobile

## Content & Microcopy ✅

### Polish Language
- [x] All UI strings in Polish
- [x] Error messages translated
- [x] Button labels in Polish
- [x] Validation hints in Polish

### Tone & Voice
- [x] Simple, empathetic language
- [x] Appropriate for 13-year-old student
- [x] Technical jargon avoided for P-001
- [x] Clear, actionable error messages

## Testing Requirements

### Visual Testing
- [ ] Pixel-approximate match to specifications
- [ ] Color accuracy validated
- [ ] Typography matches tokens
- [ ] Spacing follows 8px baseline

### Functional Testing
- [ ] TTS states reachable and functional
- [ ] Import preview shows row statuses
- [ ] Transactional rollback behavior works
- [ ] Session timer counts down correctly
- [ ] SR states update after answers

### Performance Testing
- [ ] Local TTS generation < 5s target
- [ ] UI remains responsive during TTS generation
- [ ] Modal animations smooth (60fps)
- [ ] No layout shifts during loading

## Deliverables Status

### Core Artifacts
- [x] design-tokens.json - Complete
- [x] shortcuts.md - Complete
- [x] components/specs/README.md - Complete
- [x] components/specs/Button.component.json - Complete
- [x] components/specs/AudioControl.component.json - Complete
- [x] components/specs/Modal.component.json - Complete
- [x] components/specs/Timer.component.json - Complete
- [x] design/01-Login.screen.md - Complete
- [x] design/03-Session.screen.md - Complete
- [ ] prototype/ - In progress
- [ ] a11y-report.html - To be generated

### Additional Components Needed
- [ ] Card.component.json (flashcard, lesson card)
- [ ] Input.component.json (text input, validation)
- [ ] Table.component.json (import preview)
- [ ] Toast.component.json (notifications)
- [ ] Navigation.component.json (admin sidebar)

### Screen Specs Needed
- [ ] Detailed specs for remaining 7 screens
- [ ] Interaction flow diagrams
- [ ] State transition diagrams

### Prototype
- [ ] HTML/CSS component sandbox
- [ ] Interactive mockup with clickable flows
- [ ] Mock data for testing
- [ ] Local run instructions (README)
- [ ] DEBUG=true mode for testing without backend

## Known Issues / Remaining Work

1. **Screen Specifications:** Detailed specs for 7 additional screens (placeholders created)
2. **Component Specs:** 5 additional component specs needed (listed above)
3. **Prototype:** HTML/CSS prototype implementation in progress
4. **A11y Report:** Automated axe-core report to be generated
5. **Visual Assets:** SVG icons and logo to be created

## Sign-Off Criteria

For this PR to be considered complete:
- [x] design-tokens.json contains all required tokens
- [x] Core component specifications complete (Button, Audio, Modal, Timer)
- [x] Key screen specifications (Login, Session) complete
- [x] Keyboard shortcuts documented
- [x] Accessibility requirements specified
- [x] Backend integration points documented
- [ ] Interactive prototype or Storybook functional
- [ ] A11y report shows 0 critical issues
- [ ] All critical components specified
- [ ] QA checklist reviewed

## Notes

This QA checklist follows the Definition of Done from AI_Handoff_Issue.md section 8.

**Review Status:** In Progress  
**Last Updated:** 2025-09-30  
**Reviewer:** GitHub Copilot Agent
