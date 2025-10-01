from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="English Flashcards API (MVP)")

# CORS - allow local frontend during development
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health", tags=["health"])
async def health():
    return {"status": "ok"}


# Stub endpoints (skeleton) mapped from OpenAPI (implementations are placeholders)
@app.post("/api/auth/login", tags=["auth"])
async def auth_login(payload: dict):
    """
    ST-001: Authentication (email+password)
    TODO: implement Argon2id verification, session cookie issuance
    """
    return {"status": "ok"}


@app.get("/api/users/{user_id}/lessons", tags=["lessons"])
async def get_user_lessons(user_id: int):
    """
    ST-008 / ST-004: Return user's lessons for dashboard
    TODO: implement DB access and response model
    """
    return {"user_id": user_id, "lessons": []}


@app.post("/api/imports", tags=["imports"])
async def upload_import():
    """
    ST-003: Upload import file (multipart)
    TODO: handle multipart upload, create import job, return importId
    """
    return {"importId": "stub"}


@app.get("/api/imports/{import_id}/preview", tags=["imports"])
async def import_preview(import_id: str):
    """
    ST-003: Import preview
    """
    return {"importId": import_id, "preview": {}}


@app.post("/api/imports/{import_id}/commit", tags=["imports"])
async def import_commit(import_id: str):
    """
    ST-003: Commit import
    """
    return {"importId": import_id, "status": "committed"}


@app.post("/api/tts/generate", tags=["tts"])
async def tts_generate(payload: dict):
    """
    ST-005a / ST-005b / ST-012: Generate TTS audio (adapter to local Coqui / espeak / external)
    """
    return {"status": "queued", "url": None}


@app.get("/api/tts/cache/{hash}", tags=["tts"])
async def tts_cache(hash: str):
    """
    ST-005a: Retrieve cached audio metadata / URL
    """
    return {"hash": hash, "url": None}


@app.post("/api/sessions/{session_id}/answer", tags=["sessions"])
async def session_answer(session_id: str, payload: dict):
    """
    ST-005a / ST-006 / ST-007: Submit answer
    """
    return {"sessionId": session_id, "accepted": True}


@app.get("/api/sessions/{session_id}/progress", tags=["sessions"])
async def session_progress(session_id: str):
    """
    ST-005a: Get session progress
    """
    return {"sessionId": session_id, "progress": {}}


@app.get("/api/admin/exports", tags=["admin"])
async def admin_exports(period: str = "7d"):
    """
    ST-009: List / trigger exports (admin-only, CIDR protected)
    """
    return {"period": period, "exports": []}


@app.get("/api/admin/exports/{export_id}/download", tags=["admin"])
async def admin_export_download(export_id: str):
    """
    ST-009: Download export file
    """
    return {"exportId": export_id, "file": None}


@app.delete("/api/users/{user_id}", tags=["admin"])
async def admin_delete_user(user_id: int):
    """
    ST-011: Admin-initiated data deletion (GDPR)
    """
    return {"userId": user_id, "deleted": True}