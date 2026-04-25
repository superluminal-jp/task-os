#!/usr/bin/env bash
# audit-wip-after-edit.sh — PostToolUse/Edit hook
# Warns (advisory) when total Doing (対応中) count exceeds 3 after a task file edit.
# Always exits 0 — the edit already happened; blocking here causes confusion.

INPUT=$(cat)

# Extract file_path from tool result JSON
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

# Count Doing tasks (canonical or legacy)
TASKS_DIR="work/tasks"
DOING_COUNT=$( (grep -rl "^status: Doing" "$TASKS_DIR/" 2>/dev/null; grep -rl "^status: 対応中" "$TASKS_DIR/" 2>/dev/null) | sort -u | wc -l | tr -d ' ')

if [ "$DOING_COUNT" -gt 3 ]; then
  echo "WIP AUDIT: 対応中 (Doing) が $DOING_COUNT 件（上限3）。work/tasks/ を確認し3件以下にしてください。" >&2
fi

exit 0
