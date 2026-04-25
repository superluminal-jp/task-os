# Claude Code タスク運用パッケージ

このパッケージは、開発者が **PM視点を持ちながら** 日々のタスクを回すための、Claude Code 向けの最小構成です。

**最短で回し始める**: [docs/quickstart.md](docs/quickstart.md) · **ドキュメント索引**: [docs/README.md](docs/README.md)

## 目的

この運用は、次の5層を一貫してつなぎます。

```text
Focus Area = 何のために進めるか
Project    = 何を終わらせるか
Work Item  = どの単位で前進させるか
Task       = 今日・今やる実行単位
Daily Log  = 毎朝・毎晩の判断と記録
```

## 何が入っているか

- `CLAUDE.md`
  - Claude Code に毎回読ませる運用ルール
- `.claude/agents/`
  - 専門サブエージェント
- `.claude/skills/`
  - 朝・夜・未整理の整理・分解・クローズ・週次レビュー用スキル
- `.claude/hooks/` + `.claude/settings.json`
  - WIP 上限ガード・セッション終了リマインダー・タスクアーカイブ・ボード再生成のトリガー
- [.claude/README.md](.claude/README.md)
  - 上記 `.claude/` 配下のスキル・エージェント・hooks の案内
- `docs/`
  - 運用ルールの説明（[クイックスタート](docs/quickstart.md)、[索引](docs/README.md)）
- `prompts/`
  - チャット用の短文プロンプト（[prompts/README.md](prompts/README.md)）
- `templates/`
  - Markdown / ボード用テンプレート（[templates/README.md](templates/README.md)）
- `scripts/`
  - `work/board.html` と `work/tasks.csv` の再生成（[scripts/README.md](scripts/README.md)）
- `examples/`
  - **オンボーディング一式**: デフォルトで [`work/`](work/README.md) に同梱。同一内容のバックアップが [`examples/onboarding/`](examples/onboarding/) にあり、`cp` で再体験可能（[examples/README.md](examples/README.md)）
- `work/`
  - 運用ファイル置き場。**初回オンボーディング用**の Focus Area / Project / Work Item / Task をクローン直後から同梱（[docs/quickstart.md](docs/quickstart.md) の「2」）

## 推奨ディレクトリ構成

```text
repo/
  CLAUDE.md
  .claude/
    agents/
    skills/
    hooks/          # WIP ガード・ボード更新など（settings.json から起動）
    settings.json
  scripts/
    generate_board_assets.py   # work/board.html と work/tasks.csv を再生成（hooks からも実行）
  work/
    focus-areas/
    projects/
    work-items/
    tasks/
    daily/
    weekly/
    archive/
    board.html      # 生成物（hooks または /board-html）
    tasks.csv       # 生成物（表ビュー用・同上）
    calendar-holidays.json   # 任意。会社休業日などをボードカレンダーに足す
  docs/
  templates/        # board-template.html など
```

このパッケージではテンプレートを `templates/` に置いています。実運用では `work/` 以下に複製して使います。`board.html` / `tasks.csv` は編集せず、タスクや階層ファイルの更新に合わせて hooks か `python3 scripts/generate_board_assets.py`、または `/board-html` で再生成します。ボードの表・`tasks.csv` の **ステータス**・**項目種別** は日本語ラベルで出ます。Task の `status` と Work Item の `type` は Markdown では **英語の固定語**（[docs/operating-model.md](docs/operating-model.md)、[CLAUDE.md](CLAUDE.md)）。

## 初期セットアップ

1. このパッケージをリポジトリ直下へ配置
2. `CLAUDE.md` を必要に応じてプロジェクト事情に合わせて調整
3. `work/` は同梱済み。別リポジトリへ取り込む場合のみ、同じサブフォルダ構成を用意する
4. `work/` に同梱のオンボーディングで一周するか、必要なら `templates/` を複製して独自の Focus Area / Project / Work Item を作成（または `/new-task` で起こす）
5. Claude Code で `/agents` と `/skills` の一覧を確認

## 基本運用

### 朝

- `/start-day`
- 今日の `Doing`（対応中）を最大3件に絞る
- 主案件を1件決める
- `Waiting`（外部依存待ち）のフォロー対象を確認する

### 日中

- 新しい依頼や思いつきは `/new-task`
- 大きい作業は `/plan-work-item`
- `Doing` タスクは `tasks/` の `status` を更新（WIP > 3 は hooks がブロック）
- タスクが完了したら `/task-closeout`
- 全体を俯瞰したいときは `/board-html` → `work/board.html` をブラウザで開く

### 夜

- `/end-day`
- `Done` と `Waiting` を更新
- 新しく見つかった論点を `Inbox` に入れる
- 明日の最初の一歩を `daily/` に残す

### 週次

- `/weekly-review`
- Focus Area と Project の整合を確認
- Work Item の渋滞とタスク粒度を見直す

## 運用思想

- **PM**: Focus Area / Project / Work Item で上位意図から日々の作業につなぐ
- **Scrum**: Project と Work Item を通じて、何を今スプリント相当で前進させるかを明確にする
- **Kanban**: Task の `status`（YAML では `Inbox` … `Dropped` の英語固定値）を流し、ボード・CSV では日本語表示
- **タスク分解**: Project を Work Item に、Work Item を 30〜90分程度の Task に落とす

## ステータス定義

タスク YAML の `status:` には次の **英語** だけを使う（表記ゆれ禁止）。ボード・`work/tasks.csv` では日本語に変換して表示します（[CLAUDE.md](CLAUDE.md) の `TASK_STATUS_EN_JA` / `scripts/generate_board_assets.py` の `TASK_STATUS_EN_JA`）。

| status（YAML） | 日本語ラベル | この状態でやること                       |
| -------------- | ------------ | ---------------------------------------- |
| Inbox          | 未整理       | まだ整理しない。取りこぼさないことを優先 |
| Clarify        | 要件整理中   | 目的・対象・完了条件・次アクションを定義 |
| Ready          | 着手待ち     | 今日・近日で着手候補。並び順を明確にする |
| Doing          | 対応中       | 集中して進める。最大3件                  |
| Review         | 自己検証中   | テスト・レビュー対応・受入れ確認を進める（相手の返事待ちだけなら Waiting） |
| Waiting        | 外部依存待ち | 誰待ちか、いつ再確認するかを記録         |
| Done           | 完了         | 実装・確認・リリースまたは提出完了       |
| Dropped        | 中止         | 意図的に捨てた仕事を残す                 |

## 使い分けの原則

### Focus Area

- 上位の重点領域
- 3〜5件程度に絞る
- 例: 初回体験の改善、信頼性向上、開発生産性の改善

### Project

- 一定期間で終わらせるまとまり
- 完了条件を持つ
- 例: 初回登録フローの簡素化

### Work Item

- Project を前進させる中間単位
- **ユーザーストーリーはここに置く**
- Story / Investigation / Decision / Quality Item / Incident Item を使い分ける

### Task

- 30〜90分程度を標準とする実行単位
- 1カード1成果物または1論点
- 完了条件が1文で書けること

## Claude Code でのおすすめ呼び方

- 「`/new-task 〇〇を Inbox に`」（一文でよい）
- 「`/plan-work-item work/work-items/<WI>.md を45分粒度で`」
- 「`/task-closeout work/tasks/TASK-YYYY-MM-DD-001.md`」
- 「`@pm-operator この Project の渋滞を整理して`」
- 「`/start-day 最重要1件だけ提案`」
- 「`/end-day 今日のメモで Done・Waiting まで`」
- 「`/board-html`」（`work/board.html` を生成してブラウザで開く）

## まず最初に作るべき3ファイル

1. `work/focus-areas/<focus-area>.md`
2. `work/projects/<project>.md`
3. `work/work-items/<work-item>.md`

その後、Work Item から Task を切ります。
