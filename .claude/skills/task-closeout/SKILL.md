---
name: task-closeout
description: Close out a task — verify done definition, set status to Done, record ended_at, and update the parent Work Item. Use when the main work on a task is complete and ready to close.
argument-hint: "[task file path or task ID]"
disable-model-invocation: true
context: fork
agent: artifact-maintainer
effort: low
---

Close out this task:

$ARGUMENTS

Steps:
1. Read the task file.
2. Show the Done Definition items and ask the user to confirm each one is satisfied.
   - If any item is unmet, stop and describe what remains.
3. Verify `ended_at` can be set (task must be in `Doing` or `Review` status).
4. Update the task file:
   - Set `status: Done`
   - Set `ended_at: <today's date>`
   - Append a dated completion note under `## Notes`
5. Read the parent Work Item linked in the task's `work_item` field.
6. Update the Work Item's `## Related Tasks` list to mark this task as done (e.g. `Done` or strikethrough consistent with repo style).
7. Check whether all Related Tasks in the Work Item are now `Done`.
   - If yes: prompt the user to consider moving the Work Item to Done as well.
   - If no: list remaining open tasks.

Output sections:
- Done Definition check
- Files updated
- Work Item status
- Next suggested action
