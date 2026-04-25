---
name: end-day
description: Run the evening shutdown routine for this task system
disable-model-invocation: true
context: fork
agent: daily-operator
effort: medium
---

Run the evening review routine for this repository.

## HITL gates (during the routine)

- **Unfinished item triage**: For each unfinished item, do not auto-decide between `Ready` / `Waiting` / `Dropped`. Batch as one `AskUserQuestion` (1 question per ambiguous item, max 3 items per batch). Use Scene 4 template in [docs/clarification-protocol.md](../../../docs/clarification-protocol.md) for any item idle ≥ 2 days.
- **Empty learnings**: If `Learnings` ends up empty, fire Scene 9 ("詰まった瞬間 / 想定外だったこと を 1 つだけ"). Accept "特になし + 理由 1 行" as a valid answer.
- **Confirmation gates** apply: do **not** archive without first showing the dry-run target list (see CLAUDE.md "Confirmation gates").

## Steps

1. Read today's daily log and active task files.
2. Identify what moved to `Done` today.
3. Identify unfinished items. **Run the HITL gate** before deciding `Ready` / `Waiting` / `Dropped` for any ambiguous item.
4. Convert any newly discovered work into `Inbox` or `Clarify` tasks.
5. Write 1 to 3 short learning notes (run Scene 9 prompt if empty).
6. Record the first step for tomorrow.
7. Update today's daily log in place, filling in the `## Evening` section.
8. Confirm the log was written: verify `## Evening` section exists with non-empty content.
   - If the log was not written, write the minimal Evening section before finishing.
9. Run the archive check by executing: `python3 scripts/archive-tasks.py --days 7 --dry-run` first.
   - Report dry-run candidates and ask the user before running without `--dry-run` (Confirmation gate).
   - Archiving also runs automatically: Claude PostToolUse after task edits, and Claude Stop (`archive-tasks-on-stop.sh` then `refresh-board-on-stop.sh`). After a manual run, refresh the board if needed: `python3 scripts/generate_board_assets.py`.

## Output sections

- 本日の完了
- Still open (with HITL-resolved disposition)
- 新規の未整理
- Learnings
- First step for tomorrow
- Suggested file updates
- **Assumptions made (verify before proceeding)**
- **Open questions for you**
