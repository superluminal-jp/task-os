---
id: TASK-2026-04-01-004
status: Inbox
priority: P2
focus_area: task-os 運用の習得
project: task-os を日次で回せるようにする
work_item: WI-ONB-001
estimate: 60m
started_at:
ended_at:
owner: self
---

# Task: タスクを 未整理→着手待ち→対応中→完了 まで動かし WIP を体験する

## Layer
Task

## Framework role
Kanban execution

## Purpose
[CLAUDE.md](../../CLAUDE.md) のステータスフローと「対応中 は最大 3 件」を、ファイル編集またはスキルで体感する。

## Parent work item
[WI-ONB-001 task-os の日次リズムを体で覚える](../work-items/WI-ONB-001-master-daily-rhythm.md)

## Acceptance Criteria
- オンボーディング用タスクのうち少なくとも 1 件を `対応中` にし、`started_at` に日付を入れた（該当する場合）
- 同じタスクを `/task-closeout` または手順に沿った編集で `完了` にし、`ended_at` を記録した
- WIP 上限: `対応中` を 4 件にしようとしたとき、hooks またはルールでブロック・警告されることを確認した **または** ドキュメント上の制約を読み、試さずに「最大 3」と言える

## Done Definition
- 少なくとも 1 タスクが `完了` になり、親 Work Item の Related Tasks の表現を必要なら更新した

## Next Action
- 着手中にするタスクを 1 件選び、フロントマターで `status: 対応中` と `started_at` を設定する

## Waiting On
- blocker: none
- owner: none
- follow-up: none

## Notes
- 既に `完了` のタスクは [CLAUDE.md](../../CLAUDE.md) の通り再オープンせず、別タスクで試す。
- タスク ID の日付はオンボーディング用に **2026-04-01 固定**。
