---
name: start-day
description: Run the morning planning routine for this task system
disable-model-invocation: true
context: fork
agent: daily-operator
effort: medium
---

Run the morning planning routine for this repository.

## HITL gate (before proposing today's plan)

Issue ONE batched `AskUserQuestion` (Scene 3 in [docs/clarification-protocol.md](../../../docs/clarification-protocol.md)) with up to 3 questions:

1. 利用可能時間: **フル / 半日 / 細切れ / わからない**
2. 主案件の候補（A/B/C を提示し、1 件選ばせる。"自分で決める" を含める）
3. 補助タスクを 2 件まで入れるか（**はい / 主案件のみ**）

The proposed main / supporting tasks below MUST reflect the user's selection. If the user picks "自分で決める" or "わからない", proceed with assumption and label it `[assumption]` in the daily log.

## Steps

1. Read the latest file in `work/daily/` if it exists.
2. Read active task files in `work/tasks/`.
3. Group tasks by status (`Waiting`, `Doing`, `Ready`, `Clarify`, `Inbox` — use Japanese labels in the log prose if helpful).
   - Record counts in `### WIP snapshot` of today's log.
4. Flag WIP violations:
   - If `Doing` > 3: stop and ask the user to choose which task(s) to move to `Ready` or `Waiting` before proceeding.
   - If `Doing` = 3: note the limit is reached; propose only `Ready` or `Waiting` items.
5. Flag stale `Doing` tasks: surface any task with `started_at` more than 2 days ago as an early cycle-time warning.
6. Run the HITL gate above to capture today's capacity and main-task preference.
7. Propose exactly:
   - one main task for today (the one the user picked, or the agent's recommendation labeled `[assumption]`)
   - one or two supporting tasks (only if the user chose to include them)
   - the top waiting item to follow up (follow-up date today or earlier)
   - the main risk or ambiguity
8. Update or create today's daily log using `templates/daily-log-template.md` structure.
9. Keep the output tied to Focus Area / Project / Work Item / Task.

## Output sections

- WIP snapshot
- Capacity (from HITL gate)
- Today main task
- Supporting tasks
- `Waiting` follow-up
- Stale `Doing` (if any)
- Risks
- Suggested file updates
- **Assumptions made (verify before proceeding)**
- **Open questions for you**
