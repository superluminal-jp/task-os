#!/usr/bin/env bash
# PostToolUse: Notify when a task reaches Done or Dropped
set -euo pipefail

INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only check task files
echo "$FILE" | grep -q 'work/tasks/TASK-' || exit 0
[ -f "$FILE" ] || exit 0

STAT=$(grep '^status:' "$FILE" 2>/dev/null | head -1 | sed 's/status: //' | tr -d ' \r')

if [ "$STAT" = "Done" ] || [ "$STAT" = "Dropped" ]; then
  BASENAME=$(basename "$FILE" .md)
  echo "{\"systemMessage\": \"${BASENAME} が ${STAT} になりました → 週次レビュー時に work/archive/ へ移動してください。\"}"
fi
