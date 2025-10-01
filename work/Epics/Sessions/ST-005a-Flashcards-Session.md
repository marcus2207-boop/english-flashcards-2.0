# ST-005a — Flashcards Session + TTS playback

Persona: P-001 (Uczeń)  
Priority: Must (MVP)  
Estimated size: L (3–5 days; split into atomics)

Summary
- Implement the flashcards session runtime: present cards, autosave answers, integrate TTS playback with audio cache, collect session stats and save session results.
- Requirements: autosave per answer, audio playback using audio_cache (check cache -> generate local Coqui -> fallback to espeak/external provider), cache retention 90 days.

Acceptance Criteria (AC)
- Session runtime endpoint(s):
  - POST /api/sessions/{sessionId}/answer — accept answer, save in session_answers, update spaced_repetition state and session metrics.
  - GET /api/sessions/{sessionId}/progress — return session metrics (score, duration, progress).
- TTS integration:
  - POST /api/tts/generate to request audio generation (sync/async as per OpenAPI); cache check returns immediate URL if cached.
  - GET /api/tts/cache/{hash} returns cached metadata/URL.
- Audio cache retention policy documented and configurable (90 days default).
- Autosave behavior: each answer produces a session_answers row; concurrent writes safe.
- Unit/integration tests for session flow, autosave, SR updates, and audio cache usage.

Implementation Notes
- Backend: FastAPI endpoints; background task for TTS generation (queue/small worker) — MVP can be synchronous for local Coqui if resources suffice.
- DB: session_answers, sessions, spaced_repetition, audio_cache.
- Audio cache file storage path: ./data/audio-cache/ with metadata in audio_cache table.
- Use consistent hash function for cache key (e.g., sha256(word|engine|accent)).

Atomic Tasks (0.5–2 days)
- Task 1: Implement POST /api/sessions/{sessionId}/answer to store session_answers and update sessions.score — 1 day
- Task 2: Integrate spaced_repetition update logic within answer handler (call SR service) — 1 day
- Task 3: Implement GET /api/sessions/{sessionId}/progress endpoint returning required metrics — 0.5 day
- Task 4: Implement TTS generate/check flow calling local Coqui or fallback and storing audio_cache metadata — 1–2 days
- Task 5: Tests for session flow and TTS caching behavior — 1 day

RTM / Traceability
- Linked RTM: ST-005a -> `/api/sessions/{sessionId}/answer`, `/api/sessions/{sessionId}/progress`, `/api/tts/generate`, `/api/tts/cache/{hash}`
- DB: sessions, session_answers, spaced_repetition, audio_cache

Notes for AI Agent
- Provide exact command/instructions to run Coqui container for local integration (docker-compose service stub).
- For MVP, synchronous generation is acceptable if Coqui is local and within resource limits (we agreed cpu=2, ram=4G).
- Use background task or simple thread pool for non-blocking generation when possible; ensure request returns 202 queued when generation is needed.