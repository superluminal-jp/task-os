#!/usr/bin/env bash
# PostToolUse/Edit — after a task file is edited, check if any Done/Dropped tasks
# are old enough to archive (>= 7 days). Runs archive-tasks.py non-interactively.
# Always exits 0 (non-blocking).

INPUT=$(cat)

FILE_PATH=$(python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    ti = d.get('tool_input', d)
    print(ti.get('file_path', '') or ti.get('path', ''))
except Exception:
    pass
" 2>/dev/null <<< "$INPUT" || echo "")

# Only run when a task file was edited
case "$FILE_PATH" in
  *work/tasks/*.md) ;;
  work/tasks/*.md) ;;
  *) exit 0 ;;
esac

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
python3 "$ROOT/scripts/archive-tasks.py" --days 7 2>&1 \
  | grep -E "^(archived|ERROR|\[dry)" \
  || true
exit 0
