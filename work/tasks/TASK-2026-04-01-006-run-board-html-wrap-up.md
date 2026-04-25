---
id: TASK-2026-04-01-006
status: Inbox
priority: P3
focus_area: task-os 運用の習得
project: task-os を日次で回せるようにする
work_item: WI-ONB-001
estimate: 30m
started_at:
ended_at:
owner: self
---

# Task: /board-html で board を開きオンボーディングを締める

## Layer
Task

## Framework role
Kanban execution

## Purpose
静的な `work/board.html` でタスクを俯瞰する流れを一通り試し、オンボーディング Work Item を完了に近づける。

## Parent work item
[WI-ONB-001 task-os の日次リズムを体で覚える](../work-items/WI-ONB-001-master-daily-rhythm.md)

## Acceptance Criteria
- `/board-html` を実行し、`work/board.html` が生成または更新された
- ブラウザで `work/board.html` を開き、Kanban または表ビューでオンボーディング用タスクが見えることを確認した
- [WI-ONB-001](../work-items/WI-ONB-001-master-daily-rhythm.md) の Related Tasks がすべて `完了` になった（本タスク含む）

## Done Definition
- Acceptance Criteria をすべて満たした
- 親 Project の Done Definition を読み、必要なら Project / Work Item の `status` を更新した

## Next Action
- `/board-html` を実行し、生成物を開く

## Waiting On
- blocker: none
- owner: none
- follow-up: none

## Notes
- 最後のタスクなので `/task-closeout` で閉じると、Related Tasks と親の更新が一貫しやすい。
- タスク ID の日付はオンボーディング用に **2026-04-01 固定**。
