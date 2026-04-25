#!/usr/bin/env bash
# check-session-end.sh — Stop hook
# Reminds to run /end-day when Doing (対応中) tasks exist but the evening log is incomplete.
# Always exits 0 (advisory only — never blocks session end).

TASKS_DIR="work/tasks"
LOG="work/daily/$(date +%Y-%m-%d).md"

# Only act if there are Doing tasks (canonical English or legacy Japanese)
DOING_COUNT=$( (grep -rl "^status: Doing" "$TASKS_DIR/" 2>/dev/null; grep -rl "^status: 対応中" "$TASKS_DIR/" 2>/dev/null) | sort -u | wc -l | tr -d ' ')
if [ "$DOING_COUNT" -eq 0 ]; then
  exit 0
fi

# Check if today's log has a filled Evening section
if [ ! -f "$LOG" ]; then
  echo "REMINDER (対応中 $DOING_COUNT 件): 今日の日次ログがありません。セッションを締める前に /end-day を実行してください。" >&2
  exit 0
fi

EVENING_CONTENT=$(awk '/^## Evening/{found=1; next} found && /^## /{exit} found{print}' "$LOG" \
  | grep -v '^[[:space:]]*$' \
  | grep -v '^-[[:space:]]*$')

if [ -z "$EVENING_CONTENT" ]; then
  echo "REMINDER (対応中 $DOING_COUNT 件): Evening が空です。今日の作業を終える前に /end-day を実行してください。" >&2
fi

exit 0
