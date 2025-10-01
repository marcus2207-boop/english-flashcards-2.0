#!/usr/bin/env bash
# scripts/import_rtm.sh
# Simple SQL seed importer for RTM mapping CSV -> rtm_mapping table (SQLite)
# Usage:
#   ./scripts/import_rtm.sh [path-to-sqlite-db] [path-to-csv]
# Defaults:
#   DB: ./data/dev.sqlite3
#   CSV: architecture/rtm_mapping.csv
#
# Behaviour:
# - Idempotent for matching story_id + endpoint: it deletes existing rows that match story_id+endpoint before inserting.
# - Escapes single quotes in CSV fields.
# - Expects CSV with header: story_id,endpoint,table_name,columns,notes
# - Requires sqlite3 CLI available in PATH.
#
set -euo pipefail

DB_PATH="${1:-./data/dev.sqlite3}"
CSV_PATH="${2:-architecture/rtm_mapping.csv}"

if ! command -v sqlite3 >/dev/null 2>&1; then
  echo "Error: sqlite3 CLI not found in PATH. Install sqlite3 to proceed." >&2
  exit 2
fi

if [ ! -f "$CSV_PATH" ]; then
  echo "Error: CSV file not found at $CSV_PATH" >&2
  exit 2
fi

# Ensure DB dir exists
mkdir -p "$(dirname "$DB_PATH")"

# Temporary SQL file
TMP_SQL="$(mktemp)"
trap 'rm -f "$TMP_SQL"' EXIT

# Generate SQL from CSV (simple parser; assumes no complex quoting)
# CSV header: story_id,endpoint,table_name,columns,notes
# We'll join fields beyond 5 into notes if present.
{
  echo "BEGIN TRANSACTION;"
  tail -n +2 "$CSV_PATH" | while IFS= read -r line || [ -n "$line" ]; do
    # Use awk to split into 5 fields max (handles commas in notes by combining remaining)
    story=$(echo "$line" | awk -F',' '{print $1}')
    endpoint=$(echo "$line" | awk -F',' '{print $2}')
    table_name=$(echo "$line" | awk -F',' '{print $3}')
    # columns might be $4 but we don't insert it into rtm_mapping table (kept in CSV only)
    # notes = remaining fields after 4
    notes=$(echo "$line" | awk -F',' '{
      notes="";
      if (NF>4) {
        notes=$5;
        for (i=6;i<=NF;i++) notes = notes "," $i;
      }
      print notes;
    }')
    # SQL-escape single quotes by doubling them
    esc_story=$(printf "%s" "$story" | sed "s/'/''/g")
    esc_endpoint=$(printf "%s" "$endpoint" | sed "s/'/''/g")
    esc_table=$(printf "%s" "$table_name" | sed "s/'/''/g")
    esc_notes=$(printf "%s" "$notes" | sed "s/'/''/g")
    # Skip empty story ids
    if [ -z "$esc_story" ]; then
      continue
    fi
    # Delete existing matching row (story_id + endpoint) to keep idempotent
    printf "DELETE FROM rtm_mapping WHERE story_id = '%s' AND (endpoint = '%s' OR (endpoint IS NULL AND '%s'=''));\n" "$esc_story" "$esc_endpoint" "$esc_endpoint"
    printf "INSERT INTO rtm_mapping (story_id, endpoint, table_name, notes) VALUES ('%s','%s','%s','%s');\n" "$esc_story" "$esc_endpoint" "$esc_table" "$esc_notes"
  done
  echo "COMMIT;"
} > "$TMP_SQL"

# Ensure table exists
sqlite3 "$DB_PATH" <<'SQL'
CREATE TABLE IF NOT EXISTS rtm_mapping (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  story_id TEXT NOT NULL,
  endpoint TEXT,
  table_name TEXT,
  notes TEXT
);
PRAGMA foreign_keys = OFF;
SQL

# Execute generated SQL
sqlite3 "$DB_PATH" < "$TMP_SQL"

echo "RTM import completed into $DB_PATH"