---
name: weekly-review
description: Review Focus Areas, Projects, Work Items, and flow health for the week
disable-model-invocation: true
context: fork
agent: pm-operator
effort: high
---

Focus Areas: !`ls work/focus-areas/ 2>/dev/null`
Projects: !`ls work/projects/ 2>/dev/null`
Active tasks: !`ls work/tasks/ 2>/dev/null`

Run a weekly review for this repository.

## HITL gates (before mutating anything)

- **Stale items**: For each Project / Work Item idle ≥ 2 weeks, run Scene 4 prompt in [docs/clarification-protocol.md](../../../docs/clarification-protocol.md): **DROP / HOLD / CONTINUE / わからない**. Batch up to 3 items per `AskUserQuestion` call.
- **Focus for next week**: After listing candidates, ask the user to pick **1 main + up to 2 supporting** at the Focus Area / Project / Work Item layer (do not auto-pick).
- **Confirmation gates**: Any de-prioritization (mass move to On Hold / Dropped) requires showing the dry-run target list and getting explicit "yes" first.

## Steps

1. Read Focus Areas, active Projects, active Work Items, and active Tasks.
2. Summarize current work by Focus Area.
3. Flag Projects without active Work Items.
4. Flag Work Items without executable Tasks.
5. Flag Tasks that are too large, ambiguous, or unparented.
6. Review flow health:
   - too many `Doing` (> 3)
   - stale `Waiting` (follow-up date past)
   - overloaded `Clarify` (> 2 days)
   - many `Dropped` in same area (signals systemic problem)
7. Review cycle time + flow metrics:
   - List tasks with `started_at` more than 3 days ago still in `Doing`.
   - List tasks with `started_at` more than 2 days ago still in `Clarify`.
   - Compute Lead time / Cycle time / Throughput / WIP for the week (see [docs/operating-model.md](../../../docs/operating-model.md) "フロー指標").
   - Fill the `### Cycle time check` and `### Flow metrics（4指標）` tables in the weekly review template.
8. Run the **Stale items** HITL gate above and record dispositions.
9. Run the **Focus for next week** HITL gate and record selections.
10. Update or create a weekly review note using `templates/weekly-review-template.md`.

## Output sections

- Focus Area review
- Project review
- Work Item review
- Flow review (incl. Lead/Cycle/Throughput/WIP)
- Cycle time check
- RAID review (skim each Project's RAID Log)
- Suggested de-prioritizations (with HITL-confirmed dispositions)
- Focus for next week (with HITL-confirmed selection)
- Kaizen action (1 thing to try next cycle)
- **Assumptions made (verify before proceeding)**
- **Open questions for you**
