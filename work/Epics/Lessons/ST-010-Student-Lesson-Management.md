# ST-010 — Student: zarządzanie własnymi lekcjami

Persona: P-001 (Uczeń)  
Priority: Must (MVP)  
Estimated size: S (1–1.5 days; atomized)

Summary
- Allow students to manage their own lessons: view, create, edit, and delete (soft-delete) lessons they own. Admin retains override privileges.
- Integrate with lesson import and session flows.

Acceptance Criteria (AC)
- Students can create a lesson (POST /api/users/{userId}/lessons) and become the owner_user_id.
- Students can edit and soft-delete their own lessons (PUT/DELETE /api/lessons/{id}).
- Students cannot edit lessons they do not own (403).
- Deleted lessons set is_deleted flag and excluded from normal lists; admin can restore within 30 days.
- Unit/integration tests for ownership checks and CRUD behavior.

Implementation Notes
- Reuse lessons endpoints; enforce owner checks in route dependencies.
- Frontend: provide 'My lessons' view with create/edit/delete actions and confirmation modals.
- Ensure audit logs for deletions and admin overrides.

Atomic Tasks (0.5–2 days)
- Task 1: Implement ownership checks for lesson create/edit/delete routes — 0.5 day
- Task 2: Implement frontend 'My lessons' list and create/edit flows — 1 day
- Task 3: Tests for ownership enforcement and soft-delete behavior — 0.5 day

RTM / Traceability
- Linked RTM: ST-010 -> `/api/users/{userId}/lessons`
- DB: lessons table

Notes for AI Agent
- Use role + ownership dependency in FastAPI (e.g., get_current_user and check owner_user_id).
- Provide sample test fixtures to create users and lessons for authorization tests.