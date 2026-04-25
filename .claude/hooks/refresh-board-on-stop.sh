#!/usr/bin/env bash
# Stop hook — regenerate work/board.html and work/tasks.csv at the end of every session.
# This acts as a safety net for cases where PostToolUse hooks did not fire
# (e.g., subagent edits inside forked-context skills like /start-day, /end-day).
# Always exits 0 (non-blocking).

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
python3 "$ROOT/scripts/generate_board_assets.py" 2>&1 \
  | tail -3 \
  || echo "[refresh-board-on-stop] generate_board_assets.py failed (ignored)" >&2
exit 0
