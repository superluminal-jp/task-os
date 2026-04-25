# Standards Reference

このリポジトリが参照する **国際標準・業界ベストプラクティス** の一覧と出典です。
運用への当て方は [standards-improvement-plan.md](standards-improvement-plan.md)、
日々の規約は [CLAUDE.md](../CLAUDE.md) を参照してください。

---

## プロジェクト管理

### ISO 21502:2020
- 正式名: ISO 21502:2020 — *Project, programme and portfolio management — Guidance on project management*
- 役割: プロジェクト管理の上位ガイダンス（汎用・あらゆる開発手法に対応）
- 当てている箇所: 5層階層（Focus → Project → Work Item → Task → Daily）、Project ライフサイクル

### PMBOK Guide 8th Edition (2025)
- 正式名: PMI *A Guide to the Project Management Body of Knowledge, 8th Edition* / *The Standard for Project Management*
- 役割: 知識体系（原則 + パフォーマンス領域）
- 当てている箇所: Project の Done Definition（Delivery 領域）、Weekly Review（Performance Measurement 領域）

### PRINCE2 7th Edition (2023)
- 役割: 構造化されたプロジェクト管理方法論。役割責任・ステージ管理に強い
- 当てている箇所: project-template.md の `Stage Gates`、RACI による役割定義、`Issues` テーマ → RAID Log

---

## リスク・課題管理

### ISO 31000:2018
- 正式名: ISO 31000:2018 — *Risk management — Guidelines*
- 役割: リスク管理原則
- 当てている箇所: RAID Log の R / A、CLAUDE.md "Risk & Issue management" 節

### RAID Log
- 構成要素: **R**isks / **A**ssumptions / **I**ssues / **D**ependencies
- 当てている箇所: project-template.md と raid-log-template.md

---

## フロー・カデンス

### Kanban Method (David J. Anderson)
- 中核プラクティス: Visualize / Limit WIP / Manage Flow / Make Policies Explicit / Implement Feedback Loops / Improve Collaboratively
- 当てている箇所: Task ステータス流、WIP 上限 3、Weekly Review のカデンス
- 関連法則: **Little's Law** — `Lead time = WIP / Throughput`

### Kanban Cadences
- Replenishment / Delivery Planning / Risk Review / Retrospective
- 当てている箇所: Weekly Review

---

## 計画・分解

### WBS 100% rule
- 出典: PMI *Practice Standard for Work Breakdown Structures*
- 内容: 子の合計が親の範囲と一致する（不足も超過もない）
- 当てている箇所: docs/task-decomposition.md

### 8/80 rule
- 内容: 1 work package は 8〜80 person-hours が目安
- 本リポジトリでの調整: 個人運用前提のため **30〜90分/Task** に縮小

### INVEST
- Independent / Negotiable / Valuable / Estimable / Small / Testable
- 当てている箇所: Story 種別の Work Item 品質基準

---

## アジャイル

### Scrum Guide (2020)
- Definition of Ready (DoR) / Definition of Done (DoD) / Increment
- 当てている箇所: work-item-template.md の DoR / DoD、Project の Done Definition

### XP / Scrum Spike
- 内容: タイムボックス付きの調査
- 当てている箇所: Investigation 種別の Work Item

---

## 決定の記録

### ADR (Architecture Decision Records)
- 提案者: Michael Nygard (2011)
- 当てている箇所: Decision 種別の Work Item の成果物

### MADR (Markdown Any Decision Records)
- ADR の Markdown テンプレート規約
- 当てている箇所: templates/adr-template.md

---

## 品質

### ISO/IEC 25010
- 正式名: *Systems and software Quality Requirements and Evaluation (SQuaRE) — Software product quality model*
- 品質特性: Functional Suitability / Performance Efficiency / Compatibility / Usability / Reliability / Security / Maintainability / Portability
- 当てている箇所: Quality Item 種別

### ISO 9001 / Deming Cycle (PDCA)
- Plan-Do-Check-Act
- 当てている箇所: 朝/夜ルーチン、Weekly Review の Kaizen

### BDD (Behavior-Driven Development)
- Given / When / Then による受入基準
- 当てている箇所: Work Item の Acceptance Criteria

---

## インシデント対応

### ITIL 4 Incident Management
- 目的: サービス回復を最優先（根本原因解析は別プロセス）
- 当てている箇所: Incident Item 種別

### NIST SP 800-61r2
- 正式名: *Computer Security Incident Handling Guide*
- フェーズ: Preparation → Detection & Analysis → Containment, Eradication & Recovery → Post-Incident Activity
- 当てている箇所: セキュリティ系インシデントの手順

### Google SRE Workbook (Postmortems)
- 原則: **Blameless** postmortem
- 当てている箇所: templates/postmortem-template.md

---

## 役割・責任

### RACI
- **R**esponsible (実行) / **A**ccountable (説明責任、1名のみ) / **C**onsulted / **I**nformed
- 当てている箇所: project-template.md の Stakeholders、task-template.md の `owner`、raid-log-template.md

---

## 関連ドキュメント

- [CLAUDE.md](../CLAUDE.md)
- [standards-improvement-plan.md](standards-improvement-plan.md)
- [operating-model.md](operating-model.md)
- [task-decomposition.md](task-decomposition.md)
- [daily-rhythm.md](daily-rhythm.md)
