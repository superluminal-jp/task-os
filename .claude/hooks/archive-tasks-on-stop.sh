#!/usr/bin/env bash
# Stop hook — archive Done/Dropped tasks whose ended_at (or mtime) is older than 7 days.
# Pairs with refresh-board-on-stop.sh: run this first so board.html reflects archived tasks.
# Safety net when PostToolUse did not fire (manual edits, subagents, external tools).
# Always exits 0 (non-blocking).

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
python3 "$ROOT/scripts/archive-tasks.py" --days 7 2>&1 \
  | grep -E "^(archived|ERROR|\[dry)" \
  || true
exit 0
