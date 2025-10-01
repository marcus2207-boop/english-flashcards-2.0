# ST-011 — Privacy & local data retention (Data deletion)

Persona: P-002 (Rodzic / Admin)  
Priority: Must (MVP)  
Estimated size: S (1–1.5 days; atomized)

Summary
- Implement admin-initiated data deletion endpoint and privacy safeguards: only email and nickname stored, ensure no extra PII, implement soft/hard-delete logic and audit logging.

Acceptance Criteria (AC)
- DELETE /api/users/{userId} performs admin-initiated erasure: nullify or remove PII fields, set deleted_at, and create audit_logs entry.
- Confirm only email and nickname stored in DB schema (review schema) — no additional PII stored by default.
- Implement verification step (confirmation modal in UI) before deletion.
- Unit/integration tests for deletion, audit log creation, and verification of data removal.

Implementation Notes
- Data deletion should not delete lesson_items owned by user immediately; optional cascade handled by admin later (policy decision).
- Record audit_logs for deletion events with actor_user_id and action details.
- Ensure backups (Proxmox) are out of app scope but document steps to restore deleted data if needed.

Atomic Tasks (0.5–2 days)
- Task 1: Implement DELETE /api/users/{userId} endpoint restricted to admin + CIDR check — 0.5 day
- Task 2: Implement data erasure process: nullify PII fields and set deleted_at + audit log — 0.5 day
- Task 3: Tests for privacy deletion behavior and audit logs — 0.5 day

RTM / Traceability
- Linked RTM: ST-011 -> `/api/users/{userId}`, users table, audit_logs

Notes for AI Agent
- Provide sample SQL to nullify sensitive fields and ensure referential integrity with FK constraints.