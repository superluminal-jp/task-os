---
name: update-artifacts
description: Update task-system markdown artifacts consistently after planning or execution changes
argument-hint: "[what to update and why]"
disable-model-invocation: true
context: fork
agent: artifact-maintainer
effort: low
---

Update markdown artifacts for the task system.

Request:
$ARGUMENTS

Rules:
1. Preserve IDs and history.
2. Prefer minimal edits.
3. Keep layer labels and framework-role labels intact.
4. If moving a task across statuses, update only the necessary fields and notes.
5. If creating a new file, start from the closest template.
6. Keep links between Focus Area, Project, Work Item, and Task consistent.

Output sections:
- Files updated
- Link consistency check
- Any unresolved ambiguity
