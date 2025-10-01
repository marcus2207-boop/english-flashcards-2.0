# ST-007 — Quiz Engine (MCQ + Short-text)

Persona: P-001 (Uczeń)  
Priority: Must (MVP)  
Estimated size: M (2 days total; atomized)

Summary
- Implement quiz functionality used inside sessions: multiple-choice questions and short-text input, answer evaluation, scoring, and integration with spaced repetition updates.

Acceptance Criteria (AC)
- Quiz generation: default 10 questions per quiz; questions drawn from lesson_items with configurable selection strategy (random / due-for-review).
- POST /api/sessions/{sessionId}/answer accepts questionId and answer, stores session_answers, evaluates correctness (case-insensitive for text; MCQ direct match), updates score and SR state.
- Support Levenshtein tolerance <=1 for short-text answers (configurable).
- Results summary stored and available (session stats) to update dashboard metrics.
- Unit tests for evaluation logic, MCQ handling, Levenshtein tolerance, and integration tests that verify SR updates and scoring.

Implementation Notes
- Question model: represent questionId referencing lesson_item id and question type (mcq/text).
- For MCQ generation, choose distractors from same lesson (avoid duplicates).
- Use a deterministic Levenshtein implementation for tolerance checks (python-levenshtein or difflib.SequenceMatcher fallback).
- Ensure realtime autosave behavior consistent with session answers endpoint.

Atomic Tasks (0.5–2 days)
- Task 1: Implement quiz question generation function and endpoint to start quiz (session creation) — 0.5 day
- Task 2: Implement answer evaluation logic (MCQ & short-text with Levenshtein) — 1 day
- Task 3: Integrate answer evaluation with session_answers persistence and scoring update — 0.5 day
- Task 4: Tests for evaluation logic, scoring, and SR integration — 1 day

RTM / Traceability
- Linked RTM: ST-007 -> `/api/sessions/{sessionId}/answer`
- DB: session_answers, sessions

Notes for AI Agent
- Provide sample question generator code with clear interfaces.
- Use config flags for tolerance and question count.