---
id: TASK-2026-04-01-001
status: Ready
priority: P2
focus_area: task-os 運用の習得
project: task-os を日次で回せるようにする
work_item: WI-ONB-001
estimate: 45m
started_at:
ended_at:
owner: self
---

# Task: クイックスタートとコマンド一覧を読み、/skills を試す

## Layer
Task

## Framework role
Kanban execution

## Purpose
task-os の最短ルートと、日々使うスラッシュコマンドの名前を頭に入れる（オンボーディングの土台）。

## Parent work item
[WI-ONB-001 task-os の日次リズムを体で覚える](../work-items/WI-ONB-001-master-daily-rhythm.md)

## Acceptance Criteria
- [docs/quickstart.md](../../docs/quickstart.md) を通読し、セクション 0〜2 の流れが言える
- [templates/](../../templates/) に task / work-item / daily などのテンプレートがあることを確認した
- チャットで `/skills`（または環境に応じたスキル一覧）を実行し、表にある主要コマンド名を目で追った

## Done Definition
- 上記 Acceptance Criteria をすべて満たした
- 次に取るタスクとして「`/start-day` を試す」を選べる状態になった

## Next Action
- `docs/quickstart.md` を開き、「0. コマンド一覧」と「1. work/ について」を読む

## Waiting On
- blocker: none
- owner: none
- follow-up: none

## Notes
- メタタスク: 実装ではなく **このリポジトリの使い方** の習得が目的。
- タスク ID の日付はオンボーディング用に **2026-04-01 固定**。
