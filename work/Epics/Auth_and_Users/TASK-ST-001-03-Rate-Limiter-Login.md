# TASK-ST-001-03: Implement rate-limiting middleware for login endpoint

Identity
- TITLE (TK-ID): Implement rate-limiting middleware for login endpoint (TASK-ST-001-03)

Goal
- GOAL AND RESULT: Deliver a robust rate-limiter protecting POST /api/auth/login to enforce max 10 attempts per minute per IP, with unit tests and clear failure response. Result: middleware/dependency that rejects excessive attempts with 429 and logs events for audit.

Context (INPUTS)
- Story: ST-001 (Authentication) — atomic task list requires rate-limiting
- API Contract: `openapi/openapi.yaml` — POST /api/auth/login
- RTM: ST-001
- Notes: Use X-Forwarded-For header when behind proxy; trusted proxy list from env.

Plan (SCOPE AND IMPLEMENTATION STEPS)
1. Decide on strategy: in-memory token bucket for MVP (per-process) or Redis-backed sliding window for multi-process.
   - MVP: implement in-memory per-IP sliding window counter with configurable limit (10/min) — document migration to Redis if scaling needed.
2. Implement middleware or FastAPI dependency `login_rate_limiter` located in `backend/app/middleware/rate_limit.py`:
   - Read env vars: RATE_LIMIT_LOGIN=10, RATE_LIMIT_WINDOW_SECONDS=60, TRUSTED_PROXIES (optional)
   - Determine client IP using X-Forwarded-For with trusted proxies fallback to remote addr.
   - Maintain a small in-memory store (dict) mapping ip -> deque[timestamps] or counter with TTL.
   - On each request:
     - prune timestamps older than window
     - if count >= limit -> return 429 with body {detail: "Too many login attempts. Try again in X seconds"}
     - else record timestamp and continue
3. Hook dependency into auth login route (`backend/app/routes/auth.py`) by adding dependency parameter `Depends(login_rate_limiter)`.
4. Add unit tests in `backend/tests/test_rate_limit.py`:
   - Test that 10 requests succeed and 11th returns 429.
   - Test that after window passes, requests allowed again.
   - Test X-Forwarded-For parsing with trusted proxy list.
5. Add logging: when rejecting, emit audit_logs entry or application log with warning level (do not expose internal details).
6. Document in README or `docs/security.md` the rate-limiter behavior and migration plan for distributed stores.

Files (FILES TO CREATE/CHANGE)
- Create: `backend/app/middleware/rate_limit.py`
- Create: `backend/tests/test_rate_limit.py`
- Modify: `backend/app/routes/auth.py` to add dependency (if present)
- Modify: `.env.sample` to include RATE_LIMIT_LOGIN, RATE_LIMIT_WINDOW_SECONDS, TRUSTED_PROXIES

Quality (REQUIRED TESTS)
- Unit tests covering rate-limit threshold behavior and window expiry
- Lint and static checks
- Security: ensure no sensitive info leaked in error messages

Budget (NFR TARGETS)
- Low memory footprint (store only recent timestamps per active IP)
- Fast operation — lookups O(1) amortized

DoD (DEFINITION OF DONE)
- [ ] rate_limit middleware implemented and imported
- [ ] login route protected with rate limiter
- [ ] Unit tests added and passing
- [ ] README updated documenting env vars and migration recommendation

Metadata (TIME AND RISKS)
- Estimated time: 1 day
- Risks: in-memory approach not suitable for multi-process; mitigation documented (use Redis for production)