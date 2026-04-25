# Operating Model

## 全体像

この運用は、上位の意図から日々の実行までを次の5層でつなぎます。

```text
Focus Area -> Project -> Work Item -> Task -> Daily Log
```

## 対応する国際標準・ベストプラクティス

各層・各仕組みは次の標準と整合させています。詳細は [standards-reference.md](standards-reference.md) と [standards-improvement-plan.md](standards-improvement-plan.md) を参照。

| 現行要素 | 主参照 | 補参照 |
|---|---|---|
| 5層階層 | ISO 21502:2020 / PMBOK Guide 8th | Scrum Guide |
| Project の `Done Definition` | PMBOK 8 *Delivery* | Scrum Definition of Done |
| Work Item (Story) | INVEST / BDD (Given-When-Then) | Scrum Guide |
| Work Item (Investigation) | XP/Scrum **Spike** | — |
| Work Item (Decision) | ADR / MADR | PMBOK *Planning* |
| Work Item (Quality Item) | ISO/IEC 25010 | ISO 9001 PDCA |
| Work Item (Incident Item) | ITIL 4 / NIST SP 800-61r2 | Google SRE Postmortem |
| Task サイズ 30〜90分 | WBS 100% rule / 8-80 rule | XP Task Slicing |
| ステータス流 | Kanban Method | PMBOK *Delivery* |
| WIP 上限 3 | Kanban Method (Limit WIP) / Little's Law | — |
| Waiting (blocker/owner/follow-up) | RAID Log / ISO 31000:2018 | PRINCE2 7 *Issues* |
| Owner 1名固定 | RACI (Accountable は1人) | PRINCE2 7 役割責任 |
| 朝/夜ルーチン | PDCA (ISO 9001 lineage) | Daily Standup |
| Weekly Review | Kanban Cadences | PMBOK *Performance Measurement* |

## どの考え方に対応しているか

### Focus Area
- 役割: 重点領域、投資先、上位意図
- 対応する考え方: Product management
- 問い: 何のために進めるか

### Project
- 役割: 終わりのある実行単位
- 対応する考え方: Product planning / Scrum-like increment planning
- 問い: 何を終わらせるか

### Work Item
- 役割: Project を前進させる中間単位
- 対応する考え方: Story / Investigation / Decision / Quality / Incident
- 問い: どの単位で前進させるか

### Task
- 役割: 実行単位
- 対応する考え方: Kanban execution
- 問い: 今日・今なにをやるか

### Daily Log
- 役割: 朝晩の判断記録
- 対応する考え方: Daily planning / reflection
- 問い: 今日は何に集中し、何が進み、何が残ったか

## Focus Area と Project の違い

### Focus Area
- 複数の案件を束ねる上位目的
- 例: 初回体験の改善、信頼性向上、開発生産性の改善

### Project
- Focus Area に紐づく具体案件
- 完了条件を持つ
- 例: 初回登録フローの簡素化、非同期ジョブ失敗率の改善

## Work Item の役割

Work Item は Project を直接 Task に落とす前の中間層です。

### 重要原則
- **ユーザーストーリーは Work Item レイヤーに置く**
- Task は具体作業にする
- Focus Area にユーザーストーリーは置かない

---

### 種別の使い分け

Work Item の **`type` は Markdown では英語の固定語**（`Story` / `Investigation` / `Decision` / `Quality Item` / `Incident Item`）を書きます。`work/board.html` の表・ツリー、`work/tasks.csv`、ブラウザからの表 CSV 出力では、同じ値を **日本語ラベル**（例: `Quality Item` → `品質項目`）に変換して表示します。対応表は `templates/board-template.html` の `WI_TYPE_LABEL` と `scripts/generate_board_assets.py` の `WI_TYPE_JA` で共通です。

Task の **`status` も YAML では英語の固定語**（`Inbox` / `Clarify` / `Ready` / `Doing` / `Review` / `Waiting` / `Done` / `Dropped`）を書きます。ボード・CSV・フィルタチップの表示は **日本語**（`STATUS_JA` / `TASK_STATUS_EN_JA`）。旧ファイルの日本語ステータスは `generate_board_assets.py` が読み取り時に英語へ正規化します。

#### Story
**いつ使うか**: ユーザーが体験する価値や変化を起点にするとき。「〜として、〜したい」の形で書ける。

**タスク分解の考え方**:
1. ユーザー向けの成果物（画面・機能・文言の変更）
2. それを実現するための実装
3. 計測・検証

**例**: 新規ユーザーとして、最小限の入力で登録を完了したい

---

#### Investigation
**いつ使うか**: 原因・実態・規模が不明で、まず調べることが必要なとき。答えが出るまで実装に進めない。

**タスク分解の考え方**:
1. 問いを立てる（何を明らかにするか）
2. 情報源ごとに調査タスクを作る
3. 調査結果をまとめ、次の判断または Story につなげる

**例**: 登録離脱がどのステップで起きているか調べる

---

#### Decision
**いつ使うか**: 複数の選択肢があり、どれを選ぶかを決めることそのものが成果物になるとき。

**タスク分解の考え方**:
1. 選択肢の整理
2. 判断基準の定義
3. 比較・評価
4. 決定メモの作成

**例**: 認証方式を JWT にするか Session にするか決める

---

#### Quality Item
**いつ使うか**: 既知の不具合・技術的負債・テスト不足など、品質を改善する必要があるとき。ユーザー価値より安定性・信頼性が主目的。

**タスク分解の考え方**:
1. 診断・再現確認
2. 修正
3. 検証・回帰テスト

**例**: 特定条件でバリデーションが二重送信を防げない

---

#### Incident Item
**いつ使うか**: 本番環境で問題が発生しており、即時対応が必要なとき。

**タスク分解の考え方**:
1. 影響範囲の確認
2. 暫定対処（封じ込め）
3. 根本原因の特定
4. 恒久対応

**緊急時の運用**: Task を先に作り、Work Item は収束後に遡及作成してよい。

**例**: 決済フローでエラーレートが急上昇している

---

## Task の基本原則

Task は「前進が観測できる最小単位」です。

### 条件
- 1成果物または1論点
- 完了条件が1文で書ける
- 次アクションが明確
- 標準は30〜90分

### 避けるもの
- 〜改善
- 〜検討
- 〜対応
- 〜考える

上記のような曖昧な名前は、そのままだと粒度が粗いことが多いです。

## ステータス設計

Task は次の Kanban 状態で流します。**Kanban Method** の中核プラクティス（Visualize / Limit WIP / Manage Flow / Make Policies Explicit / Implement Feedback Loops）に整合します。

```text
Inbox -> Clarify -> Ready -> Doing -> Review -> Done（日本語ラベル: 未整理 → … → 完了）
                                 \-> Waiting（外部依存待ち）
                                 \-> Dropped（中止）
```

### フロー指標（週次で確認）

| 指標 | 定義 | 目標の置き方 |
|---|---|---|
| **Lead time** | Inbox 投入から Done までの経過時間 | 短く・分布の裾を減らす |
| **Cycle time** | Doing 開始から Done までの時間（`started_at` 基準） | 主案件で 3 営業日以内を目安 |
| **Throughput** | 単位期間に Done に至った件数 | 安定（ばらつきが小さい）が望ましい |
| **WIP** | 同時 Doing 件数 | 上限 3（Little's Law: Lead time = WIP / Throughput） |

## どこで何を考えるか

### PM視点
- Focus Area
- Project
- Work Item

### スクラム的な前進単位
- Project
- Work Item

### カンバン的な流れの管理
- Task status

### 分解設計
- Project -> Work Item
- Work Item -> Task

## 実務上の要点

- 上位の意図は Focus Area で持つ
- 日々の仕事のまとまりは Project で持つ
- ユーザー価値や判断論点は Work Item で持つ
- 実行は Task で持つ
- 朝晩の制御は Daily Log で行う

## ボードと CSV（俯瞰）

- **`work/board.html`**: Kanban / 表 / カレンダー / ツリーで Task 階層を一覧する静的ファイル。`/board-html` で再生成するか、編集後に hooks 経由で `scripts/generate_board_assets.py` が走ると更新されます。表ビューでは列名・**ステータス**・Work Item 種別など **UI 文言は日本語**（注入データの Task `status` / WI `type` は英語を想定し、テンプレートで表示変換します）。
- **`work/tasks.csv`**: 表ビュー用のエクスポート相当。同じく hooks またはスクリプトで更新されます。**ステータス**・**項目種別** の値は日本語ラベルです。
- **祝日・休業日**: テンプレート内蔵の日本の祝日（2024–2035）に加え、任意で `work/calendar-holidays.json` を置くとカレンダーにマージされます（例は [`examples/work/calendar-holidays.example.json`](../examples/work/calendar-holidays.example.json)）。

運用ルールと hooks の一覧は [CLAUDE.md](../CLAUDE.md) を参照してください。

---

## 関連ドキュメント

- [ドキュメント索引](README.md)
- [クイックスタート](quickstart.md)
- [タスク分解](task-decomposition.md)
