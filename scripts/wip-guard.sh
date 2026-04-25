#!/usr/bin/env bash
# PreToolUse: Block setting a task to Doing when WIP limit (3) is reached
set -euo pipefail

INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only check task files
echo "$FILE" | grep -q 'work/tasks/TASK-' || exit 0

# Extract new content depending on tool type
TOOL=$(echo "$INPUT" | jq -r '.tool_name')
if [ "$TOOL" = "Write" ]; then
  NEW_CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // empty')
elif [ "$TOOL" = "Edit" ]; then
  NEW_CONTENT=$(echo "$INPUT" | jq -r '.tool_input.new_string // empty')
else
  exit 0
fi

# Only proceed if new content sets status to Doing
echo "$NEW_CONTENT" | grep -q 'status: Doing' || exit 0

# Count current Doing tasks (excluding the file being edited)
ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
COUNT=$(grep -rl '^status: Doing' "$ROOT/work/tasks/" 2>/dev/null | grep -v "$(basename "$FILE")" | wc -l | tr -d ' ')

if [ "$COUNT" -ge 3 ]; then
  echo "{\"decision\": \"block\", \"reason\": \"WIP上限（3件）に達しています。現在の Doing タスク数: ${COUNT}件。先にいずれかを完了させてください。\"}"
fi
