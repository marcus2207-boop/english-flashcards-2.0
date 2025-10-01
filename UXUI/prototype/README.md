# English Flashcards 2.0 - UI Prototype

This directory contains a lightweight HTML/CSS/JavaScript prototype demonstrating the key UI components and screens for the English Flashcards 2.0 application.

## Purpose

This prototype serves as:
- A visual reference for the design system
- A testbed for component interactions
- A demonstration of accessibility features
- A handoff artifact for developers

## Structure

```
prototype/
├── README.md                     # This file
├── index.html                   # Main prototype entry point
├── assets/
│   └── styles/
│       ├── tokens.css           # Design tokens as CSS custom properties
│       ├── components.css       # Component styles
│       └── screens.css          # Screen-specific styles
└── screens/                     # All screen prototypes (9 screens)
    ├── login.html               # Login screen (01)
    ├── student-dashboard.html   # Student Dashboard (02)
    ├── session.html             # Session/Learning UI (03)
    ├── lessons.html             # Lessons Management (04)
    ├── admin-dashboard.html     # Admin Dashboard (05)
    ├── admin-import.html        # Admin Import (06)
    ├── admin-users.html         # Admin Users Management (07)
    ├── admin-exports.html       # Admin Exports (08)
    └── settings.html            # Settings & TTS Config (09)
```

## Available Screens

All screens are fully navigable, clickable prototypes based on design specifications in `../design/` directory:

### Student Screens
1. **Login** (`screens/login.html`) - Authentication with email/password
2. **Student Dashboard** (`screens/student-dashboard.html`) - Main dashboard with stats and recent sessions
3. **Session** (`screens/session.html`) - Interactive learning session with flashcards
4. **Lessons** (`screens/lessons.html`) - Browse and manage lesson collections
5. **Settings** (`screens/settings.html`) - User profile, TTS, and learning preferences

### Admin Screens
6. **Admin Dashboard** (`screens/admin-dashboard.html`) - System overview and quick actions
7. **Admin Import** (`screens/admin-import.html`) - Import vocabulary data (CSV/JSON/Excel)
8. **Admin Users** (`screens/admin-users.html`) - User management table
9. **Admin Exports** (`screens/admin-exports.html`) - Export system data

## Running Locally

### Option 1: Simple HTTP Server (Recommended)

Using Python 3:
```bash
cd prototype
python3 -m http.server 8000
```

Then open: http://localhost:8000

### Option 2: Node.js HTTP Server

```bash
npm install -g http-server
cd prototype
http-server -p 8000
```

### Option 3: VS Code Live Server

1. Install "Live Server" extension in VS Code
2. Right-click `index.html`
3. Select "Open with Live Server"

## Features

### Design Tokens Integration
All styles use CSS custom properties from `design-tokens.json`:
```css
.button--primary {
  background-color: var(--color-primary);
  padding: var(--spacing-sm) var(--spacing-lg);
  border-radius: var(--radius-md);
}
```

### Component States
Each component demonstrates all states:
- Button: default, hover, focus, active, disabled, loading
- Audio Control: cache-check, generating, playable, playing, failure
- Modal: closed, opening, open, closing
- Timer: idle, running, paused, warning, complete

### Accessibility Testing
All components include:
- Proper ARIA attributes
- Keyboard navigation
- Focus indicators
- Screen reader announcements (via aria-live)

### Mock Mode
Set `DEBUG=true` in URL to enable mock mode:
```
http://localhost:8000/screens/session.html?DEBUG=true
```

Mock mode provides:
- Simulated TTS generation (2s delay)
- Mock session data
- No backend required

## Component Examples

### Button
```html
<button class="btn btn--primary btn--large" type="button">
  Start Session
</button>
```

### Audio Control
```html
<div class="audio-control" data-word="cat" data-engine="coqui">
  <button class="audio-control__button" aria-label="Play pronunciation for cat">
    <svg><!-- Play icon --></svg>
  </button>
</div>
```

### Modal
```html
<div class="modal-overlay" aria-hidden="true">
  <div class="modal modal--medium" role="dialog" aria-modal="true">
    <div class="modal__header">
      <h2 id="modal-title">Modal Title</h2>
      <button class="modal__close" aria-label="Close modal">×</button>
    </div>
    <div class="modal__body">
      <!-- Content -->
    </div>
    <div class="modal__footer">
      <button class="btn btn--secondary">Cancel</button>
      <button class="btn btn--primary">Confirm</button>
    </div>
  </div>
</div>
```

## Keyboard Shortcuts

The prototype implements all shortcuts from `shortcuts.md`:

### Global
- `Tab` - Navigate forward
- `Shift+Tab` - Navigate backward
- `Esc` - Close modal/Cancel

### Session Screen
- `Space` - Play/pause audio
- `Enter` - Submit answer
- `1-4` - Select MCQ option
- `Ctrl+Z` - Undo last answer
- `R` - Retry audio generation

## Testing Checklist

When testing the prototype:

### Visual
- [ ] Colors match design tokens
- [ ] Spacing follows 8px baseline
- [ ] Typography matches specifications
- [ ] Layout responsive at all breakpoints

### Functional
- [ ] All buttons clickable
- [ ] Forms submit correctly
- [ ] Modals open/close
- [ ] TTS states transition properly
- [ ] Timer counts down

### Accessibility
- [ ] All elements keyboard accessible
- [ ] Focus indicators visible
- [ ] Screen reader announcements work
- [ ] ARIA attributes present
- [ ] No keyboard traps

### Performance
- [ ] Animations smooth (60fps)
- [ ] No layout shifts
- [ ] Fast load times (<2s)

## Browser Support

Tested and working in:
- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## Limitations

This is a **static prototype** for design review, not a production application:

- No real backend integration
- Mock data only
- Limited error handling
- No state persistence
- No routing (separate HTML files)

For production implementation, integrate with backend API and use appropriate framework (React, Vue, Svelte, etc.).

## Integration with Backend

The prototype demonstrates UI/UX flows. For backend integration:

1. **Replace mock data** in `mock-data.js` with API calls
2. **Implement TTS flow** per AudioControl component spec
3. **Add session management** per Session screen spec
4. **Implement import validation** per Admin Import spec

See component specs in `components/specs/` for detailed integration instructions.

## Development Workflow

### Adding New Components

1. Create component HTML in `components/`
2. Add styles to `assets/styles/components.css`
3. Reference design tokens from `tokens.css`
4. Document ARIA attributes
5. Test keyboard navigation
6. Update this README

### Adding New Screens

1. Create screen HTML in `screens/`
2. Add screen-specific styles to `screens.css`
3. Use existing components
4. Test responsive layout
5. Add to navigation in `index.html`

## Related Documents

- `../design-tokens.json` - Design system tokens
- `../components/specs/` - Component specifications
- `../design/` - Screen specifications
- `../shortcuts.md` - Keyboard shortcuts
- `../qa-checklist.md` - QA requirements
- `../a11y-report.html` - Accessibility report

## Notes

- All strings in Polish as per requirements
- Designed for Laura (13 years old, student) and Admin (parent)
- Follows WCAG 2.1 Level AA standards
- Desktop-first with mobile responsive design
- Uses Inter font family

## Feedback & Questions

For questions or feedback on the prototype, refer to:
- `AI_Handoff_Issue.md` for requirements
- `Phase_3_HiFi_Spec.md` for visual specifications
- Component spec files for detailed behavior

## Version

**Version:** 1.0.0  
**Date:** 2025-09-30  
**Status:** Initial prototype for design review
