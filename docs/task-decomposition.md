# Task Decomposition

## 位置づけ

- Project -> Work Item: PM / planning
- Work Item -> Task: decomposition / execution design

## 準拠する標準

- **WBS 100% rule**: 子の合計＝親の範囲（足りなくても、はみ出してもいけない）
- **8/80 rule**: 1 work package は 8〜80 person-hours が目安。本リポジトリでは個人運用を想定して **30〜90分/Task** に絞る
- **INVEST**: Story の品質基準（Independent / Negotiable / Valuable / Estimable / Small / Testable）
- **Definition of Ready (DoR) / Definition of Done (DoD)**: Scrum Guide の概念。本リポジトリでは Task の必須フィールド = DoR、`Done Definition` = DoD

詳細は [standards-reference.md](standards-reference.md) を参照。

## 基本ルール

### 1. まず Work Item に分ける
Project をいきなり Task に落とさない。
まず次のいずれかに切る（Work Item の frontmatter / 本文では **この英語表記** を使う）。

- Story
- Investigation
- Decision
- Quality Item
- Incident Item

`work/board.html` の表・ツリーと `work/tasks.csv` では、上記は日本語ラベル（ストーリー、調査、…）に変換して表示されます。詳細は [operating-model.md](operating-model.md) の「種別の使い分け」を参照。

### 2. Task は前進の最小単位にする
Task は「作業名」ではなく「前進の最小単位」で切る。

### 3. 標準サイズは30〜90分
- 15分以下: タスク化しないか、チェックリスト化
- 30〜90分: 標準
- 2時間以上: 分割候補
- 半日以上: 原則分割

### 4. 1タスク1成果物または1論点
悪い例:
- 要件確認して設計して実装してレビューに出す

良い例:
- 未確定論点を3件に整理する
- バリデーション文言案を作る
- API修正を実装する
- 回帰テストを追加する

### 5. 完了条件を書けないものはまだ Task ではない
Task には最低限、次が必要です（= **Definition of Ready**。`done definition` は **Definition of Done** に相当）。
- purpose
- done definition
- next action
- estimate
- accountable owner（RACI **A** — 1名）

### 6. Story には INVEST と受入基準
Work Item が Story の場合、以下を満たすこと。
- **INVEST**: Independent / Negotiable / Valuable / Estimable / Small / Testable
- **Acceptance Criteria** を **Given / When / Then**（BDD）で記述

## 調査タスクのルール

調査は無限化しやすいため、必ず出口をつける。

悪い例:
- 原因を調べる

良い例:
- 原因候補を3件までに絞り、追加確認点を列挙する

## 判断タスクのルール

「考える」は Task 名にしない。

悪い例:
- 方針を考える

良い例:
- 方針案A/Bを比較表にまとめる

---

## 関連ドキュメント

- [ドキュメント索引](README.md)
- [運用モデル](operating-model.md)
- [CLAUDE.md](../CLAUDE.md)（Task の必須フィールド・ステータス表記）
