---
name: board-html
description: Generate or refresh work/board.html — a static Kanban/Table/Calendar/Tree task board.
user-invocable: true
---

# /board-html

Generate (or refresh) `work/board.html` from all files under `work/`.

## What this does

1. Reads `work/focus-areas/`, `work/projects/`, `work/work-items/`, `work/tasks/`
2. Optionally reads `work/calendar-holidays.json` (会社休業などの追加祝日・内蔵日本祝日のオン/オフ) and passes it as `DATA.holidays`
3. Extracts YAML frontmatter and key markdown sections
4. Injects the data into `templates/board-template.html` (only the `const DATA = {...};` line is replaced; built-in JP holidays stay in the template)
5. Writes the result to `work/board.html`
6. Writes `work/tasks.csv` (全タスクのフラットなCSVエクスポート)

The board supports four views (switchable via tabs or keyboard shortcuts):

| View | Shows |
|------|-------|
| Kanban | Tasks in status columns |
| Table | Sortable/filterable task list with CSV export; **ステータス** / **項目種別** show Japanese labels (markdown uses English `status` / `type`) |
| Calendar | Tasks by `due` (締切) on a monthly grid; Japanese national holidays (2024–2035) + optional `work/calendar-holidays.json` |
| Tree | Focus Area → Project → Work Item → Task hierarchy |

A global filter bar lets you search by text and filter by status, priority, and Focus Area.

## Usage

```text
/board-html
```

After running, open `work/board.html` in any browser — no server required.

## Refresh cadence

`PostToolUse` hooks (see `CLAUDE.md`) run `scripts/generate_board_assets.py` after **Edit**/**Write** under `work/focus-areas/`, `work/projects/`, `work/work-items/`, `work/tasks/`, or `work/calendar-holidays.json`, updating **`work/board.html`** and **`work/tasks.csv`** automatically.

A `Stop` hook also refreshes the board at the end of every session as a safety net.

Run `/board-html` for an explicit refresh at any time.

## Procedure

Run the generator script directly via Bash — do NOT delegate to the board-generator agent (the board.html file is too large for the agent to handle reliably):

```bash
python3 scripts/generate_board_assets.py
```

Report the output lines from the script to the user (entity counts and output paths).
