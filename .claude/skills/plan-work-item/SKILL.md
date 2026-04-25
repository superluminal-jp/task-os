---
name: plan-work-item
description: Break a Work Item into executable tasks with controlled granularity
argument-hint: "[work item file path or description]"
disable-model-invocation: true
context: fork
agent: task-breaker
effort: medium
---

Existing focus areas: !`ls work/focus-areas/ 2>/dev/null`
Existing projects: !`ls work/projects/ 2>/dev/null`

Plan this Work Item:

$ARGUMENTS

Steps:
1. Read the referenced Work Item.
2. Determine whether it is a Story, Investigation, Decision, Quality Item, or Incident Item.
3. Break it into Tasks sized for roughly 30 to 90 minutes unless there is a strong reason not to.
4. For each Task, write:
   - purpose
   - acceptance criteria (Given/When/Then for Story tasks; plain conditions for other types)
   - done definition
   - next action
   - estimate
   - priority (P1 = must-do today / P2 = should-do this week / P3 = backlog)
   - initial status (`Inbox` or `Ready`)
5. Avoid vague task names like "improve", "handle", or "think about".
6. Prefer one outcome or one decision per task.
7. Create task files under `work/tasks/` using `templates/task-template.md`.

Output sections:
- Decomposition rationale
- Proposed task list
- Risks in task sizing
- New files created
