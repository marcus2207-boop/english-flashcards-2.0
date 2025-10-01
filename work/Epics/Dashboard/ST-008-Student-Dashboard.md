# ST-008 — Student Dashboard

Persona: P-001 (Uczeń)  
Priority: Must (MVP)  
Estimated size: M (1–2 days; atomized)

Summary
- Implement student dashboard endpoints and UI providing quick metrics: mastered count, average quiz score (7d), today session time, recent lessons and sessions.
- Performance requirement: dashboard response <300 ms at ≤20 concurrent users (smoke-tests planned).

Acceptance Criteria (AC)
- GET /api/users/{userId}/lessons returns lesson list and dashboard metrics (mastered count, avg quiz score 7d, today session time).
- Dashboard aggregates computed efficiently (use indexed queries).
- Endpoint returns in under 300 ms in smoke-tests for target load.
- Unit/integration tests for aggregation correctness.

Implementation Notes
- Backend: implement aggregated queries using sessions, session_answers, spaced_repetition, lesson_items.
- DB: use indexes (idx_sessions_user exists) and avoid N+1 queries.
- Frontend: dashboard page with cards for key metrics; data polling optional.

Atomic Tasks (0.5–2 days)
- Task 1: Implement aggregation queries and API endpoint to return dashboard payload — 1 day
- Task 2: Implement frontend dashboard scaffold (cards + charts) — 1 day
- Task 3: Add smoke-test scenario (k6/wrk) for dashboard performance — 0.5 day
- Task 4: Tests for aggregation correctness — 0.5 day

RTM / Traceability
- Linked RTM: ST-008 -> `/api/users/{userId}/lessons`, `/api/sessions/{sessionId}/progress`
- DB: sessions, session_answers, spaced_repetition, lessons

Notes for AI Agent
- Provide sample SQL query for aggregated metrics and instructions to optimize with indexes.