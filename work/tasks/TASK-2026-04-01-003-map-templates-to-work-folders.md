---
id: TASK-2026-04-01-003
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

# Task: テンプレ・work・examples/onboarding の関係を説明できるようにする

## Layer
Task

## Framework role
Kanban execution

## Purpose
`templates/` の「型」、`work/` の「実体」、`examples/onboarding/` の「再オンボーディング用の同一チェーン」を区別できるようにする。

## Parent work item
[WI-ONB-001 task-os の日次リズムを体で覚える](../work-items/WI-ONB-001-master-daily-rhythm.md)

## Acceptance Criteria
- [templates/task-template.md](../../templates/task-template.md) を開き、フロントマターに `status` / `work_item` などがあることを確認した
- [work/README.md](../README.md) を読み、クローン直後からオンボーディング用の階層が `work/` に入っていることを理解した
- [examples/README.md](../../examples/README.md) と [examples/onboarding/README.md](../../examples/onboarding/README.md) を読み、`cp` で `work/` に上書きコピーして再体験できることを確認した

## Done Definition
- 一文で「テンプレはコピー元、`work/` は運用の置き場、`examples/onboarding/` はオンボーディング一式のバックアップ（再体験はここからコピー）」と説明できる

## Next Action
- `templates/` ディレクトリのファイル一覧を眺め、`work/` のサブフォルダ名との対応をメモする

## Waiting On
- blocker: none
- owner: none
- follow-up: none

## Notes
- このタスク自体がメタ: ファイル配置の理解がゴール。
- タスク ID の日付はオンボーディング用に **2026-04-01 固定**。
