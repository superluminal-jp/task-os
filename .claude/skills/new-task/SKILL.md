---
name: new-task
description: Add new work from an idea, request, bug, or note — create or attach Focus Area, Project, Work Item, and Task
argument-hint: "[idea, request, bug, or note]"
disable-model-invocation: true
context: fork
agent: pm-triage
effort: medium
---

Existing focus areas: !`ls work/focus-areas/ 2>/dev/null`
Existing projects: !`ls work/projects/ 2>/dev/null`

Take the following input and place it into the operating model (Focus Area through Task):

$ARGUMENTS

## Preconditions check (HITL)

Before writing any file, evaluate the **Ask-first triggers** in [CLAUDE.md](../../../CLAUDE.md) and the templates in [docs/clarification-protocol.md](../../../docs/clarification-protocol.md).

If **any** of the following hold, batch the questions (max 3) into a single `AskUserQuestion` call and STOP before writing:

- Work Item `type` cannot be unambiguously inferred (use Triage template — Scene 1)
- No matching Focus Area / Project exists AND a new parent would be needed
- Estimate cannot be inferred to one of {30m, 60m, 90m, 2h+} (use Sizing template — Scene 2)
- Owner is ambiguous (more than one plausible person, or none)
- Input contains broad words like "片付ける / 整理 / 改善" without a concrete target (use Scene 10 disambiguation)

If everything is clear, proceed and append a `## Assumptions` section in the response.

## Steps

1. Identify whether this belongs to an existing Focus Area and Project.
2. If no clear match exists, propose a provisional Focus Area or Project (and ask if creating a new parent — Ask-first trigger #3).
3. Decide the right Work Item type:
   - Story
   - Investigation
   - Decision
   - Quality Item
   - Incident Item
4. Create or update the relevant Work Item.
5. Create a Task with `status: Inbox` or `status: Clarify`.
6. Keep the task small enough for later decomposition.
7. If the request is already task-sized, still attach it to a Work Item.

## Output sections

- Proposed Focus Area
- Proposed Project
- Proposed Work Item type
- New or updated files
- **Assumptions made (verify before proceeding)** — list every default the agent picked
- **Open questions for you** — questions that block further progress (max 3, with options)
