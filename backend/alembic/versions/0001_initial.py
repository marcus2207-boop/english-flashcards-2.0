"""initial schema

Revision ID: 0001_initial
Revises: 
Create Date: 2025-10-01

"""
from alembic import op
import sqlalchemy as sa
import os

# revision identifiers, used by Alembic.
revision = '0001_initial'
down_revision = None
branch_labels = None
depends_on = None

def upgrade() -> None:
    """
    This migration applies the SQL from db/schema.sql to initialize the database.
    It reads the schema file relative to the repository root and executes it as a batch.
    """
    repo_root = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
    schema_path = os.path.join(repo_root, "db", "schema.sql")
    if not os.path.exists(schema_path):
        raise FileNotFoundError(f"schema.sql not found at {schema_path}")
    with open(schema_path, "r", encoding="utf-8") as f:
        sql = f.read()
    conn = op.get_bind()
    # SQLite requires executescript, but SQLAlchemy connection can execute multiple statements.
    # We'll split on semicolon for safety and execute non-empty statements.
    statements = [s.strip() for s in sql.split(";") if s.strip()]
    for stmt in statements:
        conn.execute(sa.text(stmt))

def downgrade() -> None:
    """
    Downgrade by dropping all created tables. This is a best-effort reverse.
    """
    conn = op.get_bind()
    # Drop tables in order with foreign keys considered
    tables = [
        "rtm_mapping", "audit_logs", "exports", "audio_cache", "spaced_repetition",
        "session_answers", "sessions", "import_rows", "imports",
        "lesson_items", "lessons", "users"
    ]
    for t in tables:
        conn.execute(sa.text(f"DROP TABLE IF EXISTS {t}"))