# SQLAlchemy models for English Flashcards MVP (SQLite-compatible)
# Location: backend/app/models.py
from sqlalchemy import (
    Column,
    Integer,
    String,
    Text,
    DateTime,
    ForeignKey,
    Boolean,
    UniqueConstraint,
    JSON,
)
from sqlalchemy.sql import func
from sqlalchemy.orm import declarative_base, relationship

Base = declarative_base()


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True)
    email = Column(String, nullable=False, unique=True)  # minimal PII
    nickname = Column(String, nullable=False)
    password_hash = Column(Text, nullable=False)
    role = Column(String, nullable=False, default="user")
    created_at = Column(DateTime, server_default=func.now())
    deleted_at = Column(DateTime, nullable=True)

    lessons = relationship("Lesson", back_populates="owner")


class Lesson(Base):
    __tablename__ = "lessons"

    id = Column(Integer, primary_key=True)
    owner_user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    title = Column(String, nullable=False)
    description = Column(Text)
    is_deleted = Column(Boolean, default=False)
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    owner = relationship("User", back_populates="lessons")
    items = relationship("LessonItem", back_populates="lesson")


class LessonItem(Base):
    __tablename__ = "lesson_items"
    __table_args__ = (UniqueConstraint("lesson_id", "english", "polish"),)

    id = Column(Integer, primary_key=True)
    lesson_id = Column(Integer, ForeignKey("lessons.id"), nullable=False)
    english = Column(String, nullable=False)
    polish = Column(String)
    example = Column(Text)
    tags = Column(String)  # CSV tags
    phonetic_hint = Column(String)
    created_at = Column(DateTime, server_default=func.now())

    lesson = relationship("Lesson", back_populates="items")


class Import(Base):
    __tablename__ = "imports"

    id = Column(Integer, primary_key=True)
    uploaded_by = Column(Integer, ForeignKey("users.id"), nullable=False)
    filename = Column(String)
    total_rows = Column(Integer)
    error_rows = Column(Integer)
    status = Column(String, nullable=False, default="uploaded")
    created_at = Column(DateTime, server_default=func.now())


class ImportRow(Base):
    __tablename__ = "import_rows"

    id = Column(Integer, primary_key=True)
    import_id = Column(Integer, ForeignKey("imports.id"), nullable=False)
    row_number = Column(Integer)
    english = Column(String)
    polish = Column(String)
    valid = Column(Boolean, default=False)
    error_message = Column(Text)
    processed_at = Column(DateTime)


class Session(Base):
    __tablename__ = "sessions"

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    lesson_id = Column(Integer, ForeignKey("lessons.id"))
    started_at = Column(DateTime, server_default=func.now())
    finished_at = Column(DateTime)
    duration_seconds = Column(Integer)
    score = Column(Integer)
    created_at = Column(DateTime, server_default=func.now())


class SessionAnswer(Base):
    __tablename__ = "session_answers"

    id = Column(Integer, primary_key=True)
    session_id = Column(Integer, ForeignKey("sessions.id"), nullable=False)
    question_id = Column(String)
    user_answer = Column(Text)
    is_correct = Column(Boolean, default=False)
    created_at = Column(DateTime, server_default=func.now())


class SpacedRepetition(Base):
    __tablename__ = "spaced_repetition"

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    lesson_item_id = Column(Integer, ForeignKey("lesson_items.id"), nullable=False)
    state = Column(String, nullable=False, default="new")
    last_reviewed_at = Column(DateTime)
    next_review_at = Column(DateTime)
    interval_days = Column(Integer, default=0)
    history = Column(Text)  # JSON stored as text for SQLite compatibility

    __table_args__ = (UniqueConstraint("user_id", "lesson_item_id"),)


class AudioCache(Base):
    __tablename__ = "audio_cache"

    id = Column(Integer, primary_key=True)
    hash = Column(String, nullable=False, unique=True)
    word = Column(String, nullable=False)
    engine = Column(String, nullable=False)
    accent = Column(String)
    path = Column(String, nullable=False)
    size_bytes = Column(Integer)
    created_at = Column(DateTime, server_default=func.now())
    last_accessed_at = Column(DateTime)


class Export(Base):
    __tablename__ = "exports"

    id = Column(Integer, primary_key=True)
    requested_by = Column(Integer, ForeignKey("users.id"), nullable=False)
    period = Column(String)
    format = Column(String, default="csv")
    status = Column(String, default="pending")
    file_path = Column(String)
    created_at = Column(DateTime, server_default=func.now())
    completed_at = Column(DateTime)


class AuditLog(Base):
    __tablename__ = "audit_logs"

    id = Column(Integer, primary_key=True)
    actor_user_id = Column(Integer, ForeignKey("users.id"))
    action = Column(String, nullable=False)
    target_table = Column(String)
    target_id = Column(Integer)
    details = Column(Text)
    created_at = Column(DateTime, server_default=func.now())


class RTMMapping(Base):
    __tablename__ = "rtm_mapping"

    id = Column(Integer, primary_key=True)
    story_id = Column(String, nullable=False)
    endpoint = Column(String)
    table_name = Column(String)
    notes = Column(Text)