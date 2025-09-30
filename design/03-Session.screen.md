# Session UI Screen Specification

**Route:** `/session/:id`  
**Related Stories:** ST-005a, ST-006, ST-007  
**User Persona:** P-001 (Student - Laura)

## Overview

The session screen is where students practice flashcards with TTS audio, answer questions (MCQ or short-text), and track their progress with spaced repetition.

## Layout Structure

### Desktop (>1024px)
```
┌──────────────────────────────────────────────────────────────┐
│ Timer: 14:23 ████████████░░░░  [Pause] [End Session]        │
├──────────────────────────────────────────────────────────────┤
│  ┌─────────────────────┐    ┌──────────────────────┐        │
│  │   FLASHCARD         │    │ Session Stats         │        │
│  │                     │    │ Done: 5/20           │        │
│  │     [WORD]          │    │ Mastered: 2 🟢       │        │
│  │                     │    │ Learning: 3 🔵       │        │
│  │   /phonetic/        │    │                      │        │
│  │                     │    │ Next Cards:          │        │
│  │   [🔊 Audio]        │    │ • apple              │        │
│  │                     │    │ • banana             │        │
│  │   [Answer UI]       │    │ • orange             │        │
│  │                     │    │                      │        │
│  │   [Skip] [Undo]     │    │                      │        │
│  └─────────────────────┘    └──────────────────────┘        │
└──────────────────────────────────────────────────────────────┘
```

## Components

1. **Timer** (with progress bar)
2. **Flashcard** (word + phonetic + audio)
3. **Audio Control** (TTS with states)
4. **Answer UI** (MCQ or Short Text)
5. **Session Stats**
6. **End Session Modal**

## Key Features

- 15-minute default session with visual timer
- TTS audio with generation states (cache-check → generating → playable → failure)
- Spaced repetition states updated after each answer
- Keyboard shortcuts (Space=audio, Enter=submit, Ctrl+Z=undo)
- End session summary with mastered/learning counts

See Phase_3_HiFi_Spec.md for complete component specifications.
