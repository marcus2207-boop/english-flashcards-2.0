# ST-009 — Admin Dashboard + Exports

Persona: P-002 (Rodzic / Admin)  
Priority: Must (MVP)  
Estimated size: L (2–3 days total; atomized)

Summary
- Implement admin dashboard features: per-session lists, weekly charts, admin import monitoring, and exports (CSV/PDF).
- Admin endpoints restricted to CIDR 192.168.1.0/24 (app-level check using X-Forwarded-For / RemoteAddr and trusted proxy whitelist).
- Export generation should be asynchronous/queued where necessary and downloadable via secure URL.

Acceptance Criteria (AC)
- GET /api/admin/exports returns list of export jobs with status and metadata.
- POST /api/admin/exports triggers export generation for given period and format, creates exports row and returns exportId.
- GET /api/admin/exports/{exportId}/download streams the generated file when ready.
- Exports for 20 concurrent users produce generation time <5s (measurement via smoke-test).
- Audit log entries created for export requests and downloads.
- Admin endpoints enforce role-based access and CIDR restriction.
- Unit/integration tests for export creation, status transitions, security (CIDR and RBAC), and download.

Implementation Notes
- Storage: exports table (see `db/schema.sql`) holds metadata and file_path.
- Export generation: generate CSV on server into ./data/exports/ with unique filename; update exports row with status=ready and file_path.
- Consider background worker or synchronous generation for small datasets (MVP); ensure response returns job id with 202 when generating.
- Implement pagination for admin lists and basic charts using aggregated queries.
- Ensure download endpoint sets appropriate content-disposition header and streams file.

Atomic Tasks (0.5–2 days)
- Task 1: Implement POST /api/admin/exports to create export job and persist exports row — 0.5 day
- Task 2: Implement export generation worker or sync generator and update exports.status/file_path — 1 day
- Task 3: Implement GET /api/admin/exports and GET /api/admin/exports/{exportId}/download with role + CIDR checks — 0.5 day
- Task 4: Audit log hooks and tests for security + export flow — 0.5 day
- Task 5: Smoke-test script for export latency measurement (reuse admin-export-load.js) — 0.5 day

RTM / Traceability
- Linked RTM: ST-009 -> `/api/admin/exports`, `/api/admin/exports/{exportId}/download`
- DB: exports, audit_logs

Notes for AI Agent
- Provide middleware example for CIDR enforcement using X-Forwarded-For and trusted proxy list from env.
- Ensure file cleanup policy documented (e.g., remove exports older than 30 days) and implement retention as a follow-up task.