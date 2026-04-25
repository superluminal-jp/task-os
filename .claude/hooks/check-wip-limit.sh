#!/usr/bin/env bash
# check-wip-limit.sh — PreToolUse/Write hook
# Blocks creating a new task file with status: Doing when the WIP limit (3) is reached (legacy 対応中 still triggers).
# Exits 1 (blocking) only when limit is already at or above 3.

INPUT=$(cat)

# Extract file_path from tool input JSON
FILE_PATH=$(python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    ti = d.get('tool_input', d)
    print(ti.get('file_path', ''))
except Exception:
    pass
" 2>/dev/null <<< "$INPUT" || echo "")

# Only act on task files
if [[ "$FILE_PATH" != */work/tasks/* ]] && [[ "$FILE_PATH" != work/tasks/* ]]; then
  exit 0
fi

# Extract content
CONTENT=$(python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    ti = d.get('tool_input', d)
    print(ti.get('content', ''))
except Exception:
    pass
" 2>/dev/null <<< "$INPUT" || echo "")

# Only act if the file sets status to Doing or legacy 対応中
if ! echo "$CONTENT" | grep -qE "^status: (Doing|対応中)$"; then
  exit 0
fi

# Count existing Doing tasks (canonical or legacy)
TASKS_DIR="work/tasks"
DOING_COUNT=$( (grep -rl "^status: Doing" "$TASKS_DIR/" 2>/dev/null; grep -rl "^status: 対応中" "$TASKS_DIR/" 2>/dev/null) | sort -u | wc -l | tr -d ' ')

if [ "$DOING_COUNT" -ge 3 ]; then
  echo "WIP LIMIT: 対応中 (Doing) が $DOING_COUNT 件（上限3）。新規に Doing を増やす前に、いずれかを Ready・Waiting・Done へ移してください。" >&2
  exit 1
fi

exit 0
