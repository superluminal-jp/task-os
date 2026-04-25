#!/usr/bin/env bash
# check-task-id-unique.sh — PreToolUse/Write hook
# Blocks writing a task file whose `id:` frontmatter already exists in another task file.
# Suggests the next available ID for that date.
# Exits 2 (blocking with feedback) on duplicate; exits 0 otherwise.

INPUT=$(cat)

# Only act on task files
FILE_PATH=$(python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    ti = d.get('tool_input', d)
    print(ti.get('file_path', ''))
except Exception:
    pass
" 2>/dev/null <<< "$INPUT" || echo "")

if [[ "$FILE_PATH" != */work/tasks/* ]] && [[ "$FILE_PATH" != work/tasks/* ]]; then
  exit 0
fi

# Extract `id:` from the content being written
CONTENT=$(python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    ti = d.get('tool_input', d)
    print(ti.get('content', ''))
except Exception:
    pass
" 2>/dev/null <<< "$INPUT" || echo "")

NEW_ID=$(echo "$CONTENT" | grep -m1 "^id:" | sed 's/^id:[[:space:]]*//' | tr -d '[:space:]')

if [[ -z "$NEW_ID" ]]; then
  exit 0
fi

# Resolve TASKS_DIR relative to project root
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TASKS_DIR="$ROOT/work/tasks"

# Normalize FILE_PATH to absolute for comparison
ABS_FILE_PATH="$FILE_PATH"
if [[ "$FILE_PATH" != /* ]]; then
  ABS_FILE_PATH="$ROOT/$FILE_PATH"
fi

# Search for the same id in other task files
CONFLICT=$(grep -rl "^id: ${NEW_ID}$" "$TASKS_DIR/" 2>/dev/null | grep -v "^${ABS_FILE_PATH}$" | head -1)

if [[ -z "$CONFLICT" ]]; then
  exit 0
fi

# Suggest the next available sequential ID (macOS-compatible)
DATE_PART=$(echo "$NEW_ID" | python3 -c "
import sys, re
m = re.match(r'(TASK-\d{4}-\d{2}-\d{2})', sys.stdin.read().strip())
print(m.group(1) if m else '')
")
NEXT_ID=""
if [[ -n "$DATE_PART" ]]; then
  for SEQ in $(seq -f "%03g" 1 99); do
    CANDIDATE="${DATE_PART}-${SEQ}"
    if ! grep -qrl "^id: ${CANDIDATE}$" "$TASKS_DIR/" 2>/dev/null; then
      NEXT_ID="$CANDIDATE"
      break
    fi
  done
fi

SUGGESTION=""
if [[ -n "$NEXT_ID" ]]; then
  SUGGESTION=" 次に使えるID: ${NEXT_ID}"
fi

echo "TASK ID 重複: '${NEW_ID}' はすでに $(basename "$CONFLICT") で使用されています。${SUGGESTION}" >&2
exit 2
