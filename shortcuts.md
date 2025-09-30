# Keyboard Shortcuts

This document defines keyboard shortcuts for the English Flashcards 2.0 application to enhance accessibility and efficiency for both students and administrators.

## Global Shortcuts

| Key Combination | Action | Context | Accessibility |
|----------------|--------|---------|---------------|
| `Tab` | Navigate to next interactive element | All screens | WCAG 2.1 AA - Keyboard accessible |
| `Shift + Tab` | Navigate to previous interactive element | All screens | WCAG 2.1 AA - Keyboard accessible |
| `Esc` | Close modal / Cancel action | Modals, overlays | Standard escape behavior |
| `/` | Focus search (if available) | Dashboard, Lists | Quick access |

## Session UI Shortcuts

| Key Combination | Action | Context | Notes |
|----------------|--------|---------|-------|
| `Space` | Play/Pause audio | When flashcard focused | Primary audio control |
| `Enter` | Submit answer | Short-text input mode | Confirms user input |
| `ArrowRight` or `N` | Skip to next card | Session active | Quick navigation |
| `ArrowLeft` or `P` | Previous card (if enabled) | Session active | Review previous |
| `Ctrl+Z` (Win) / `Cmd+Z` (Mac) | Undo last answer | Session active | Mistake recovery |
| `1`, `2`, `3`, `4` | Select MCQ option | MCQ mode | Numeric selection |
| `R` | Retry audio generation | Audio failed state | Fallback action |

## Admin Shortcuts

| Key Combination | Action | Context | Notes |
|----------------|--------|---------|-------|
| `Ctrl+S` / `Cmd+S` | Save current form | Forms, editors | Standard save |
| `Ctrl+K` / `Cmd+K` | Quick command palette (future) | All admin screens | Power user feature |
| `Alt+I` | Navigate to Import | Admin navigation | Quick access |
| `Alt+U` | Navigate to Users | Admin navigation | Quick access |
| `Alt+E` | Navigate to Exports | Admin navigation | Quick access |
| `Alt+D` | Navigate to Dashboard | Admin navigation | Quick access |

## Import Preview Modal

| Key Combination | Action | Context | Notes |
|----------------|--------|---------|-------|
| `Tab` | Navigate between editable cells | Import preview table | Cell-by-cell editing |
| `Enter` | Edit current cell | Table cell focused | Inline edit mode |
| `Esc` | Cancel cell edit | Editing mode | Restore original value |
| `Ctrl+Enter` / `Cmd+Enter` | Commit import | Preview modal | Quick commit |
| `Ctrl+A` / `Cmd+A` | Select all rows (future) | Import preview | Bulk actions |

## Accessibility Features

### Focus Management
- All interactive elements are reachable via keyboard
- Focus indicator uses 2px outline with color `#A78BFA` (Indigo 300)
- Focus order follows logical reading order (left-to-right, top-to-bottom)
- After modal opens, focus moves to first actionable control
- After modal closes, focus returns to triggering element

### Screen Reader Announcements
- **Timer Updates**: Announced every full minute during session
- **Final Countdown**: Last 10 seconds announced for urgency
- **Card Status**: "Correct" or "Incorrect" announced after answer
- **TTS Status**: "Generating audio..." / "Audio ready" / "Audio unavailable" announced
- **Import Status**: Row counts and validation results announced

### Reduced Motion Support
- `prefers-reduced-motion: reduce` media query respected
- Animations disabled or simplified for users who prefer reduced motion
- Essential animations (progress bar) remain functional but simplified

## Implementation Notes

### Event Handling
```javascript
// Example: Global keyboard handler
document.addEventListener('keydown', (e) => {
  // Prevent shortcuts when typing in input fields
  if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') {
    return;
  }
  
  // Handle shortcuts based on context
  switch(e.key) {
    case ' ':
      if (isSessionActive) {
        e.preventDefault();
        toggleAudioPlayback();
      }
      break;
    case 'Escape':
      if (isModalOpen) {
        closeModal();
      }
      break;
    // ... other shortcuts
  }
});
```

### Accessibility Attributes
All keyboard-interactive elements should include:
- `tabindex="0"` for custom interactive elements
- `aria-label` or `aria-labelledby` for screen reader context
- `aria-pressed` for toggle buttons
- `aria-expanded` for expandable sections
- `aria-busy="true"` during async operations

### Testing Checklist
- [ ] All interactive elements reachable via Tab
- [ ] Focus order is logical and intuitive
- [ ] Focus indicator visible on all interactive elements
- [ ] Shortcuts work without mouse
- [ ] Screen reader announces actions correctly
- [ ] No keyboard traps (user can always navigate away)
- [ ] Modal focus management working correctly
- [ ] Shortcuts documented in help section

## Future Enhancements
- Command palette (Ctrl/Cmd+K) for power users
- Customizable shortcuts in Settings
- Visual keyboard shortcut hints on hover
- Practice mode with keyboard-only navigation tutorial
