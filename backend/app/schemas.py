# Pydantic schemas (request/response models) for English Flashcards MVP
# Location: backend/app/schemas.py

from typing import List, Optional
from pydantic import BaseModel, EmailStr


# Auth
class AuthLoginRequest(BaseModel):
    email: EmailStr
    password: str


class AuthLoginResponse(BaseModel):
    user_id: int
    nickname: str
    message: Optional[str] = "authenticated"


# Users / Lessons
class LessonSummary(BaseModel):
    id: int
    title: str
    description: Optional[str]
    mastered_count: Optional[int] = 0


class LessonsResponse(BaseModel):
    user_id: int
    lessons: List[LessonSummary] = []


# Import
class ImportUploadResponse(BaseModel):
    importId: str


class ImportPreviewRow(BaseModel):
    row_number: int
    english: Optional[str]
    polish: Optional[str]
    valid: bool
    error_message: Optional[str]


class ImportPreviewResponse(BaseModel):
    importId: str
    total_rows: int
    valid_rows: int
    invalid_rows: int
    preview: List[ImportPreviewRow] = []


class ImportCommitResponse(BaseModel):
    importId: str
    status: str


# Sessions / Answers
class SessionAnswerRequest(BaseModel):
    questionId: str
    answer: str


class SessionAnswerResponse(BaseModel):
    sessionId: str
    accepted: bool


class SessionProgressResponse(BaseModel):
    sessionId: str
    progress: dict


# TTS
class TTSGenerateRequest(BaseModel):
    word: str
    engine: Optional[str] = "coqui"
    accent: Optional[str] = "uk"


class TTSGenerateResponse(BaseModel):
    status: str
    url: Optional[str] = None


class TTScacheResponse(BaseModel):
    hash: str
    url: Optional[str] = None


# Admin / Exports
class ExportItem(BaseModel):
    id: int
    period: Optional[str]
    status: Optional[str]


class AdminExportsResponse(BaseModel):
    period: str
    exports: List[ExportItem] = []


class ExportDownloadResponse(BaseModel):
    exportId: str
    file: Optional[str]


# GDPR / Deletion
class AdminDeleteUserResponse(BaseModel):
    userId: int
    deleted: bool


# Generic
class HealthResponse(BaseModel):
    status: str = "ok"