# ST-006 — Spaced Repetition Engine

Persona: P-001 (Uczeń)  
Priority: Must (MVP)  
Estimated size: M (2–3 days total; atomized)

Summary
- Implement the spaced repetition (SR) engine and persistence for each user+lesson_item.
- Maintain SR state transitions (New → Learning → Review → Mastered) and schedule next_review_at according to configurable parameters.

Acceptance Criteria (AC)
- SR state machine implemented and exercised by unit tests.
- On answer submission (POST /api/sessions/{sessionId}/answer) SR state updates according to correctness and timing rules.
- Configurable parameters: initialInterval (days), reviewInterval (days), backToLearningDelay (minutes).
- next_review_at and interval_days persisted in spaced_repetition table.
- History log updated with each review (store event, previous state, result).
- Integration tests cover multiple review cycles and boundary conditions (back-to-learning, immediate repeats).

Implementation Notes
- Use deterministic SR policy for MVP (simple algorithm with parameters in config). Keep algorithm isolated as a service/class for easier testing and future tuning.
- Store history as JSON/text in spaced_repetition.history (SQLite compatible).
- Ensure uniqueness constraint (user_id, lesson_item_id) and safe concurrent updates (use DB transactions).

Atomic Tasks (0.5–2 days)
- Task 1: Implement SR service/class with state transitions and parameterized rules — 1 day
- Task 2: Hook SR update into POST /api/sessions/{sessionId}/answer handler (call SR service) — 0.5 day
- Task 3: Persist history events and add unit tests for state transitions — 1 day
- Task 4: Integration tests simulating multiple reviews and edge cases — 1 day

RTM / Traceability
- Linked RTM: ST-006 -> `/api/sessions/{sessionId}/answer`, spaced_repetition table
- DB: spaced_repetition (fields: state, last_reviewed_at, next_review_at, interval_days, history)

Notes for AI Agent
- Provide functions to compute next interval given current state and correctness bool.
- Use timezone-aware timestamps (store as ISO strings) and ensure tests use fixed times for determinism.