#!/usr/bin/env bash
# PostToolUse/Write | PostToolUse/Edit — regenerate work/board.html and work/tasks.csv
# when files under work/ (focus-areas, projects, work-items, tasks) or
# work/calendar-holidays.json change. Always exits 0 (non-blocking).

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

case "$FILE_PATH" in
  *work/focus-areas/*|*work/projects/*|*work/work-items/*|*work/tasks/*|*work/calendar-holidays.json) ;;
  work/focus-areas/*|work/projects/*|work/work-items/*|work/tasks/*|work/calendar-holidays.json) ;;
  *) exit 0 ;;
esac

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
python3 "$ROOT/scripts/generate_board_assets.py" 2>&1 || echo "[refresh-board-assets] python failed (ignored)" >&2
exit 0
