# ST-012 — TTS accent & test

Persona: P-002 (Rodzic / Admin)  
Priority: Must (MVP)  
Estimated size: S (1 day)

Summary
- Provide settings and tests specific to TTS accent selection and validation, including UI to select accent and measure latency across providers.

Acceptance Criteria (AC)
- UI for selecting default accent (e.g., 'uk', 'us') persisted in TTS settings.
- Test-sound endpoint returns measured latency and status.
- Integration with ST-005b test flow to show p50/p90 metrics on demand.
- Unit/integration tests for metrics collection and persistence of accent setting.

Implementation Notes
- Store accent in TTS settings (DB table or config).
- Provide helper endpoint that runs N repeated test calls and returns aggregated latency metrics.
- Ensure test runs do not pollute audio_cache unless specified (use a transient flag).

Atomic Tasks (0.5–2 days)
- Task 1: Persist accent setting in TTS settings (backend) — 0.5 day
- Task 2: Implement test-run endpoint returning latency aggregates (p50/p90/p99) — 0.5 day
- Task 3: UI to set accent and trigger test-run with display of metrics — 1 day
- Task 4: Tests for metrics collection and non-polluting test runs — 0.5 day

RTM / Traceability
- Linked RTM: ST-012 -> `/api/tts/generate`, TTS settings endpoint (to be added)
- DB/Config: tts settings storage, audio_cache (transient test flag)

Notes for AI Agent
- Provide example aggregation code for latency (use numpy or simple sort+percentile computation).
- Ensure that test-run endpoint can be limited (max N runs) and secured (admin-only).