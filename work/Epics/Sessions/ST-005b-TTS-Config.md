# ST-005b — TTS configuration & test

Persona: P-002 (Rodzic / Admin)  
Priority: Must (MVP)  
Estimated size: S (1–2 days; split into atomics)

Summary
- Provide TTS configuration UI and backend support: select engine (coqui, espeak, external), set default accent (UK), run test-sound, and validate external provider keys.
- Ensure settings persist and are validated; surface latency metrics for test runs.

Acceptance Criteria (AC)
- Settings page allows selecting engine and accent; POST /api/tts/settings or equivalent persisted.
- Test sound button triggers POST /api/tts/generate with test payload and returns latency metrics.
- Validation for external provider credentials (test call without persisting wrong credentials).
- UI displays success/failure and measured latency (p50/p90 over N runs if requested).
- Unit/integration tests for settings persistence and test-sound endpoint.

Implementation Notes
- Backend: endpoints updating app config (stored in DB or config file) and a test endpoint that triggers TTS generation without caching or with temporary cache entry.
- Security: external provider keys stored in .env or secrets (do not store raw keys in DB unless encrypted).
- Use agreed Coqui resource defaults for local generation (cpu=2, ram=4G).

Atomic Tasks (0.5–2 days)
- Task 1: Add backend settings endpoints for TTS config (GET/POST) — 0.5 day
- Task 2: Implement test-sound endpoint that runs TTS generation and returns latency metrics — 1 day
- Task 3: UI scaffold for settings page and test button (frontend) — 1 day
- Task 4: Tests for settings persistence and test-sound behavior — 0.5 day

RTM / Traceability
- Linked RTM: ST-005b -> `/api/tts/generate` (test), settings endpoint (to be added)
- DB/Config: audio_cache, env variables for external providers

Notes for AI Agent
- Provide explicit instructions for transient test calls vs caching. Mark secure handling of provider keys and how to expose latency metrics in response object.