---
id: TASK-2026-04-01-002
status: Inbox
priority: P2
focus_area: task-os 運用の習得
project: task-os を日次で回せるようにする
work_item: WI-ONB-001
estimate: 45m
started_at:
ended_at:
owner: self
---

# Task: /start-day を実行し daily ログを確認する

## Layer
Task

## Framework role
Kanban execution

## Purpose
朝のルーティンが `work/daily/` にどう反映されるかを体験する。

## Parent work item
[WI-ONB-001 task-os の日次リズムを体で覚える](../work-items/WI-ONB-001-master-daily-rhythm.md)

## Acceptance Criteria
- チャットで `/start-day` を実行した（スキル手順に任せてよい）
- 当日の `work/daily/YYYY-MM-DD.md` が作成または更新されている
- ログ内に「主案件」「外部依存待ち」「対応中」のいずれかに関する記述がある

## Done Definition
- 上記を満たし、日次ログのファイルパスを自分で開いて中身を確認した

## Next Action
- `/start-day` を実行する

## Waiting On
- blocker: none
- owner: none
- follow-up: none

## Notes
- 日付は環境の「今日」に合わせてスキルがファイル名を決める。オンボーディング中は空のログでも問題ない。
- タスク ID の日付はオンボーディング用に **2026-04-01 固定**。
