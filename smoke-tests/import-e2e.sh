#!/usr/bin/env bash
# smoke-tests/import-e2e.sh
# End-to-end import test: uploads CSV with 200 rows and measures total time (upload -> preview -> commit)
# Usage: BASE_URL=http://localhost:8000 ./smoke-tests/import-e2e.sh tests/data/import_200.csv

set -euo pipefail

BASE_URL="${BASE_URL:-http://localhost:8000}"
FILE="${1:-tests/data/import_200.csv}"

if [ ! -f "$FILE" ]; then
  echo "Test CSV not found: $FILE"
  exit 2
fi

echo "Import E2E test against ${BASE_URL} with file ${FILE}"

START_MS=$(date +%s%3N)

# 1) Upload file
RESP=$(curl -s -w "\n%{http_code}" -X POST "${BASE_URL}/api/imports" \
  -F "file=@${FILE}")
HTTP_CODE=$(echo "$RESP" | tail -n1)
BODY=$(echo "$RESP" | sed '$d')

if [ "$HTTP_CODE" != "202" ] && [ "$HTTP_CODE" != "200" ]; then
  echo "Upload failed: HTTP $HTTP_CODE"
  echo "$BODY"
  exit 3
fi

# try to extract importId (best-effort)
IMPORT_ID=$(echo "$BODY" | grep -oE '"importId"[[:space:]]*:[[:space:]]*"[0-9a-zA-Z_-]+' | sed -E 's/.*"importId"[[:space:]]*:[[:space:]]*"(.*)/\1/' || true)
if [ -z "$IMPORT_ID" ]; then
  # fallback: try to parse from JSON using jq if available
  if command -v jq >/dev/null 2>&1; then
    IMPORT_ID=$(echo "$BODY" | jq -r '.importId // empty')
  fi
fi

if [ -z "$IMPORT_ID" ]; then
  echo "Cannot determine importId from response. Response body:"
  echo "$BODY" | head -n 50
  exit 4
fi

echo "Import uploaded. importId=${IMPORT_ID}"

# 2) Poll preview until available (GET /api/imports/:id/preview)
for i in $(seq 1 20); do
  PREV_RESP=$(curl -s -w "\n%{http_code}" "${BASE_URL}/api/imports/${IMPORT_ID}/preview")
  PREV_CODE=$(echo "$PREV_RESP" | tail -n1)
  PREV_BODY=$(echo "$PREV_RESP" | sed '$d')
  if [ "$PREV_CODE" = "200" ]; then
    echo "Preview ready."
    break
  fi
  echo "Preview not ready yet (HTTP $PREV_CODE). Retrying..."
  sleep 1
done

if [ "$PREV_CODE" != "200" ]; then
  echo "Preview did not become ready in time."
  exit 5
fi

# 3) Commit import
COM_RESP=$(curl -s -w "\n%{http_code}" -X POST "${BASE_URL}/api/imports/${IMPORT_ID}/commit")
COM_CODE=$(echo "$COM_RESP" | tail -n1)
COM_BODY=$(echo "$COM_RESP" | sed '$d')

if [ "$COM_CODE" != "200" ] && [ "$COM_CODE" != "202" ]; then
  echo "Commit failed: HTTP $COM_CODE"
  echo "$COM_BODY"
  exit 6
fi

END_MS=$(date +%s%3N)
DURATION_MS=$((END_MS-START_MS))
echo "Import E2E completed: ${DURATION_MS} ms total (upload -> preview -> commit)"
echo "Response: HTTP $COM_CODE"
echo "$COM_BODY" | head -n 50

# Evaluate pass/fail: success if duration < 10000 ms (10s) as per NFR
if [ "$DURATION_MS" -le 10000 ]; then
  echo "PASS: import completed within 10s"
  exit 0
else
  echo "FAIL: import exceeded 10s threshold"
  exit 7
fi