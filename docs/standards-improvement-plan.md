# 標準準拠改善プラン（メモリ）

このドキュメントは、task-os に **国際標準・業界ベストプラクティス** を当てる改善計画の単一参照ソースです。実装タスクは下記順で進めます。完了済みは `[x]` を付けます。

---

## 採用する標準・参照

| 略称 | 正式名称 | 役割 |
|---|---|---|
| **ISO 21502** | ISO 21502:2020 — Project, programme and portfolio management — Guidance on project management | 上位プロジェクト管理ガイダンス |
| **PMBOK 8** | PMI A Guide to the Project Management Body of Knowledge, 8th Edition (2025) / The Standard for Project Management | 知識体系 |
| **PRINCE2 7** | PRINCE2 7th Edition (2023) | ステージ管理・役割責任 |
| **ISO 31000** | ISO 31000:2018 — Risk management — Guidelines | リスク管理 |
| **ISO 9001 / PDCA** | ISO 9001 / Deming Cycle | 継続的改善 |
| **ISO/IEC 25010** | Software quality model | 品質特性 |
| **Kanban Method** | Kanban Method (D. J. Anderson) | フロー・WIP・カデンス |
| **Scrum** | Scrum Guide (2020) | DoR / DoD / Increment |
| **INVEST** | I-N-V-E-S-T criteria for stories | Story 品質 |
| **WBS 100% rule** | PMI Practice Standard for WBS (incl. 8/80 rule) | 分解 |
| **ITIL 4** | ITIL 4 Incident Management | 障害対応 |
| **NIST SP 800-61r2** | Computer Security Incident Handling Guide | セキュリティ障害対応 |
| **SRE Workbook** | Google SRE Workbook (Postmortems) | 振り返り |
| **ADR / MADR** | Architecture Decision Records / Markdown Any Decision Records | 決定の記録 |
| **RACI** | Responsibility Assignment Matrix | 役割分担 |
| **RAID Log** | Risks / Assumptions / Issues / Dependencies | プロジェクト統制 |
| **BDD** | Given / When / Then 受入基準 | Story 受入 |

---

## 標準 → 現行構成のマッピング

| 現行要素 | 主参照 | 補参照 |
|---|---|---|
| 5層階層（Focus → Project → Work Item → Task → Daily） | ISO 21502 §6, PMBOK 8 The Standard | Scrum |
| Project の `Done Definition` | PMBOK 8 *Delivery* | Scrum DoD |
| Work Item の `Success` | INVEST, BDD | PMBOK *Stakeholders* |
| Task サイズ 30–90分 | WBS 100% / 8-80 rule | XP Task Slicing |
| Status 流（Inbox→…→Done） | Kanban Method | PMBOK *Delivery* |
| WIP 上限 3 | Kanban Method (Limit WIP), Little's Law | — |
| Waiting (blocker/owner/follow-up) | RAID Log, ISO 31000 | PRINCE2 7 *Issues* |
| Story | INVEST, Scrum | — |
| Investigation | XP/Scrum **Spike** | — |
| Decision | ADR / MADR | PMBOK *Planning* |
| Quality Item | ISO/IEC 25010 | ISO 9001 PDCA |
| Incident Item | ITIL 4, NIST SP 800-61r2 | SRE Postmortem |
| 朝/夜ルーチン | PDCA | Daily Standup |
| Weekly Review | Kanban Cadences | PMBOK *Performance Measurement* |
| Owner 1名固定 | RACI (A は1人) | PRINCE2 7 |

---

## 実装ステップ（優先度順）

### High（参照付与・軽微編集）

- [x] CLAUDE.md に "Standards reference" ブロック追加
- [x] CLAUDE.md "Status rules" 冒頭に Kanban Method 4原則
- [x] CLAUDE.md "Sizing rules" に WBS 100% / 8-80 rule
- [x] CLAUDE.md "Work Item types" 各種別に標準参照1行
- [x] CLAUDE.md "Incident response bypass" に ITIL 4 / NIST 800-61 / SRE Postmortem
- [x] CLAUDE.md 新節 "Risk & Issue management"（ISO 31000 + RAID）
- [x] docs/operating-model.md に「対応する国際標準」表 + フロー指標説明
- [x] docs/task-decomposition.md に WBS / INVEST / DoR / DoD
- [x] docs/daily-rhythm.md を PDCA にマッピング
- [x] templates/weekly-review-template.md にフロー4指標表 + Kaizen
- [x] templates/task-template.md `owner` を RACI Accountable と注記

### Medium（テンプレート構造拡張）

- [x] templates/work-item-template.md に DoR / DoD / Acceptance Criteria (BDD) / Dependencies
- [x] templates/project-template.md に Stakeholders (RACI) / RAID Log / Stage Gates

### New artifacts（新規型）

- [x] templates/raid-log-template.md
- [x] templates/adr-template.md (MADR 準拠)
- [x] templates/postmortem-template.md (SRE 準拠)
- [x] docs/standards-reference.md（本書とは別の "標準そのもの" の出典一覧）

### 配線

- [x] docs/README.md に新規ドキュメント追記
- [x] templates/README.md に新規テンプレ追記
- [x] CLAUDE.md 冒頭の `@docs/...` 参照に新規分を追加

---

## 設計方針（軽量運用の維持）

- 個人〜小規模チーム前提のため、**標準を "参照" として明示しつつ、運用は軽量(WBS+RACI+RAID+Kanban+Weekly Review)に留める**
- 既存の WIP=3 / 5層 / Kanban状態は Kanban Method と整合済み → **破壊的変更は行わない**
- 新規追加するテンプレはすべて **任意採用** とし、「使うべき場面」を本文に明記する

---

## 関連ドキュメント

- [CLAUDE.md](../CLAUDE.md)
- [docs/operating-model.md](operating-model.md)
- [docs/standards-reference.md](standards-reference.md)（実装後）
