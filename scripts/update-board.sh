#!/usr/bin/env bash
# Update work/board.csv with latest task status
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TASKS_DIR="$REPO_ROOT/work/tasks"
BOARD="$REPO_ROOT/work/board.csv"

{
  printf '\xEF\xBB\xBF'  # UTF-8 BOM (required for Excel)
  echo "Name,Task ID,Created,Due,Focus Area,Project,Work Item,Status"

  for f in "$TASKS_DIR"/TASK-*.md; do
    [[ -f "$f" ]] || continue
    tid=$(awk '/^id:/{print substr($0, index($0,$2))}' "$f")
    tstat=$(awk '/^status:/{print substr($0, index($0,$2))}' "$f")
    tfocus=$(awk '/^focus_area:/{print substr($0, index($0,$2))}' "$f")
    tproject=$(awk '/^project:/{print substr($0, index($0,$2))}' "$f")
    twi=$(awk '/^work_item:/{print substr($0, index($0,$2))}' "$f")
    ttitle=$(grep "^# Task:" "$f" | sed 's/^# Task: //')
    tdate=$(echo "$tid" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}')
    tdue=$(awk '/^due:/{if (NF >= 2) print $2}' "$f")
    echo "\"$ttitle\",\"$tid\",\"$tdate\",\"$tdue\",\"$tfocus\",\"$tproject\",\"$twi\",\"$tstat\""
  done | sort
} > "$BOARD"

echo "Updated: $BOARD"
