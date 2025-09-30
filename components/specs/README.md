# Component Specifications

This directory contains machine-readable specifications for all UI components in the English Flashcards 2.0 application. Each component file includes prop signatures, state variants, accessibility attributes, and integration guidelines.

## Component Overview

### Core Components
1. **Button** - Primary, secondary, and ghost variants with all interaction states
2. **Card** - Flashcard and lesson card variants
3. **Modal** - Overlay dialogs for import preview and session summary
4. **Input** - Text inputs and text areas with validation states
5. **Audio Control** - TTS audio player with generation states
6. **Timer** - Session countdown timer with progress bar
7. **MCQ** - Multiple choice question buttons
8. **Toast** - Notification system for feedback
9. **Table** - Import preview table with inline editing
10. **Navigation** - Admin sidebar navigation

## File Naming Convention

All component specs follow the pattern: `{ComponentName}.component.json`

Example: `Button.component.json`, `AudioControl.component.json`

## Component Spec Schema

Each component specification includes:

```json
{
  "name": "ComponentName",
  "description": "Brief description of the component",
  "category": "atoms | molecules | organisms",
  "relatedStories": ["ST-XXX"],
  "props": {
    "propName": {
      "type": "string | number | boolean | enum | object",
      "required": true | false,
      "default": "defaultValue",
      "description": "Prop description",
      "options": ["option1", "option2"]
    }
  },
  "states": {
    "stateName": {
      "description": "State description",
      "visualChanges": "Description of visual changes",
      "ariaAttributes": {
        "aria-*": "value"
      }
    }
  },
  "accessibility": {
    "role": "button | dialog | etc.",
    "keyboardInteractions": {
      "key": "action"
    },
    "ariaLabels": ["required aria attributes"],
    "focusManagement": "focus behavior description"
  },
  "tokens": {
    "colors": ["token references"],
    "spacing": ["token references"],
    "typography": ["token references"]
  },
  "usage": {
    "dos": ["best practices"],
    "donts": ["anti-patterns"]
  },
  "examples": [
    {
      "name": "Example name",
      "props": {},
      "description": "Example description"
    }
  ]
}
```

## Integration with Backend

### TTS Audio Flow
```
Frontend Component: AudioControl
Backend Endpoints:
  - GET /api/tts/cache/:hash - Check for cached audio
  - POST /api/tts/generate - Generate new audio (returns taskId)
  - GET /api/tts/generate/:taskId - Poll for generation status
  
Integration Steps:
1. Compute hash: sha256(engine + word + accent + voiceParams)
2. Check cache via GET /api/tts/cache/:hash
3. If miss, POST to /api/tts/generate
4. Poll status until success/failure
5. On success, play audio; on failure, show phonetic fallback
```

### Session Answer Flow
```
Frontend Component: MCQ, ShortTextInput
Backend Endpoint: POST /api/sessions/:id/answer

Request:
{
  "cardId": "uuid",
  "answer": "user answer",
  "timeSpent": 15.5
}

Response:
{
  "correct": true,
  "srState": "Learning",
  "nextInterval": "1d",
  "feedback": "Great job!"
}
```

### Import Preview Flow
```
Frontend Component: ImportTable, Modal
Backend Endpoints:
  - POST /api/imports/upload - Upload file (returns validation report)
  - PATCH /api/imports/:id/row/:rowNum - Update single row
  - POST /api/imports/:id/commit - Commit import transaction
  
Validation Report Structure:
{
  "importId": "uuid",
  "totalRows": 100,
  "acceptedCount": 95,
  "rejectedCount": 5,
  "rows": [
    {
      "rowNum": 1,
      "status": "OK" | "WARNING" | "ERROR",
      "english": "cat",
      "polish": "kot",
      "errors": []
    }
  ],
  "canCommit": true,
  "transactionalRollback": false
}
```

## Design Token Integration

All components reference tokens from `design-tokens.json`. Use CSS custom properties:

```css
.button--primary {
  background-color: var(--color-primary);
  color: var(--color-surface);
  padding: var(--spacing-sm) var(--spacing-lg);
  border-radius: var(--radius-md);
  font-weight: var(--font-weight-semibold);
  transition: background-color var(--duration-micro) var(--easing-standard);
}

.button--primary:hover {
  background-color: var(--color-primary-500);
}

.button--primary:focus-visible {
  outline: var(--focus-ring-width) solid var(--color-focus);
  outline-offset: var(--focus-ring-offset);
}
```

## Component States Map

### Common States
- **default** - Initial resting state
- **hover** - Mouse over (desktop only)
- **focus** - Keyboard focus
- **active** - Being clicked/pressed
- **disabled** - Non-interactive state
- **loading** - Async operation in progress
- **error** - Validation error or failure
- **success** - Successful action

### TTS-Specific States
- **cache-check** - Checking for cached audio
- **generating** - TTS generation in progress
- **playable** - Audio ready to play
- **playing** - Audio currently playing
- **failure** - TTS generation failed

## Accessibility Requirements

### Keyboard Navigation
All components must support:
- Tab/Shift+Tab for focus navigation
- Enter/Space for activation (buttons, controls)
- Arrow keys for selection (MCQ, navigation)
- Esc for dismissal (modals, dropdowns)

### Screen Reader Support
- Meaningful labels via `aria-label` or `aria-labelledby`
- State changes announced via `aria-live` regions
- Relationships indicated via `aria-describedby`
- Current state via `aria-current`, `aria-selected`, etc.

### Focus Management
- Focus indicators must have 3:1 contrast ratio minimum
- Focus order must be logical (left-to-right, top-to-bottom)
- Focus must be trapped in modals
- Focus must return after modal close

## Testing Components

### Unit Tests
Each component should have tests for:
- Prop validation
- State transitions
- Event handlers
- Accessibility attributes
- Token application

### Integration Tests
Test component interaction with:
- Backend API endpoints
- Other components
- Global state management
- Routing

### Accessibility Tests
Run automated tests using:
- axe-core for WCAG violations
- jest-axe for unit test integration
- pa11y for page-level scanning

Example test:
```javascript
import { render } from '@testing-library/react';
import { axe, toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

test('Button should have no accessibility violations', async () => {
  const { container } = render(<Button>Click me</Button>);
  const results = await axe(container);
  expect(results).toHaveNoViolations();
});
```

## Component Usage Examples

See individual component spec files for detailed usage examples and props documentation.

## Contributing

When adding new components:
1. Create component spec JSON file
2. Document all props and states
3. Include accessibility attributes
4. Map to design tokens
5. Provide usage examples
6. Add to this README

## Related Documents
- `design-tokens.json` - Design system tokens
- `shortcuts.md` - Keyboard shortcuts
- `Phase_3_HiFi_Spec.md` - Visual specifications
- `AI_Handoff_Issue.md` - Requirements and RTM mapping
