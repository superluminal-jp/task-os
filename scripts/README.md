# scripts/

リポジトリ直下から実行することを想定した補助スクリプトです。

## `generate_board_assets.py`

- **役割**: `work/focus-areas/`、`projects/`、`work-items/`、`tasks/`（および任意の `work/calendar-holidays.json`）を読み、**`work/board.html`** と **`work/tasks.csv`** を再生成する（標準ライブラリのみ）。
- **`tasks.csv` の列**: 1 行目は `ID`, `タスク名`, `ステータス`, `優先度`, **`項目種別`**, `Work Item`, `Project`, …。**ステータス**は Task の `status`（YAML では `Inbox` … `Dropped` の英語）を **`TASK_STATUS_EN_JA`** で日本語化した値。**項目種別**は `WI_TYPE_JA`。いずれもテンプレート側の `STATUS_JA` / `WI_TYPE_LABEL` と対応。
- **いつ動くか**: `.claude/hooks/refresh-board-assets.sh` から PostToolUse（Edit/Write）後に起動されることが多い。手動ではリポジトリ直下で次を実行する。

```bash
python3 scripts/generate_board_assets.py
```

- **補足**: `/board-html` は board-generator エージェント経由で同種の HTML を整える用途。hooks の自動更新は本スクリプトと同じ出力を前提にしています（詳細は [CLAUDE.md](../CLAUDE.md) の「Hooks」）。
