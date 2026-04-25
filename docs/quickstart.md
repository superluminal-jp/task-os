# Quickstart

このリポジトリを **最短で日次運用まで持っていく** 手順です。ここでは **実運用と同じスラッシュコマンド**（`.claude/skills/` に対応）を主に使います。レイヤー定義は [operating-model.md](operating-model.md)、**他ドキュメントの索引**は [README.md](README.md)（本フォルダ）、リポジトリ全体の概要は [README.md](../README.md) を参照してください。

## 前提

- リポジトリ直下に `CLAUDE.md` と `.claude/` がある
- **Claude Code** で作業する（スラッシュコマンドが使える状態）

## 0. コマンド一覧を確認する

チャットで次を実行し、利用可能なスキル（スラッシュコマンド）を把握します。

```text
/skills
```

このパッケージで日々使う主なコマンドは次のとおりです。

| コマンド            | 用途                                                                  |
| ------------------- | --------------------------------------------------------------------- |
| `/new-task`         | 新しい仕事・メモを Focus Area → Project → Work Item → Task へ取り込む |
| `/start-day`        | 朝の計画。WIP スナップショット・主案件の提案・長期 Doing の検出       |
| `/plan-work-item`   | Work Item を 30〜90 分粒度の Task に分解する（優先度・AC 付き）       |
| `/task-closeout`    | タスクを完了にする。Done Definition 確認・ended_at 記録・親 WI 更新 |
| `/end-day`          | 夜の振り返り。`Done` / `Waiting` / `Inbox` と学びを日次ログに残す   |
| `/weekly-review`    | 週次で Focus Area / Project / Work Item / フロー・サイクルタイムを見直す |
| `/board-html`       | `work/board.html` を生成・更新。Kanban/表/カレンダー/ツリーで確認     |

`/agents` でサブエージェント一覧も確認できます。

## 1. `work/` について

このリポジトリには **`work/` とサブフォルダが同梱**されています。クローン直後から **オンボーディング用**の Focus Area / Project / Work Item / Task が `work/` に入っており、すぐにスキルが `work/` 以下を読み書きできます。`daily/` など未使用のフォルダは `.gitkeep` のみのことがあります。

別リポジトリへこのパッケージだけ取り込む場合は、`work/` 一式（オンボーディング Markdown を含む）を同じ構成で置いてください。

以降の **ファイル作成・更新はスラッシュコマンドに任せる** のが本番運用と同じ手触りです。

## 2. 初回オンボーディング（任意・推奨）

**task-os の操作を、実務の題材なしで一周する** には、**すでに `work/` に入っている**オンボーディング用のチェーンを使います（[work/README.md](../work/README.md)）。Focus Area → Project → Work Item → Task がすべて **「このリポジトリの使い方を学ぶ」** というメタな内容です。[examples/onboarding/](../examples/onboarding/) は同一内容のバックアップです。

1. （任意）`python3 scripts/generate_board_assets.py` または `/board-html` で `work/board.html` を生成し、Kanban でタスクが並んでいることを確認する。
2. 最初の着手候補は `work/tasks/TASK-2026-04-01-001-read-quickstart-and-command-list.md`（`status: Ready`。タスク ID の日付は **2026-04-01 固定**）。`/start-day` から始めてもよい。
3. オンボーディングを飛ばす場合は、次節の `/new-task` から本番同様に始める。

テンプレートの「型」は [templates/](../templates/)。オンボーディングを **最初からやり直す** ときは [examples/onboarding/README.md](../examples/onboarding/README.md) の `cp` で `work/` に上書きしてください（[examples/README.md](../examples/README.md) も参照）。

## 3. 本番の仕事を `/new-task` で取り込む

親ファイルが無くても、`/new-task` が仮の Focus Area / Project まで提案して `work/` に置けます。**一文〜貼り付けで足りる**ことが多いです。

```text
/new-task サインアップの必須項目を整理したい
```

```text
/new-task 下に issue 抜粋を貼る。分類して work/ に反映して。

（ここに貼る）
```

補足の長い指示が必要なときは [setup-prompts.md](../prompts/setup-prompts.md) を `/new-task` の後ろに続けてもよいです。

## 4. 朝: `/start-day`

毎朝、本番と同じく次を実行します。`work/daily/YYYY-MM-DD.md` の作成・更新と、主案件・サブ・外部依存待ちフォローがスキル側の手順に沿って進みます。

```text
/start-day
```

## 5. 仕事が増えたら: また `/new-task`

```text
/new-task 本番で決済コールバックが二重処理される報告
```

```text
/new-task デザインから受け取った文言案を Inbox（未整理）に
```

## 6. Work Item を細かくするとき: `/plan-work-item`

```text
/plan-work-item work/work-items/WI-ONB-001-master-daily-rhythm.md
```

```text
/plan-work-item work/work-items/<あなたのWI>.md
```

```text
/plan-work-item 「初回プロジェクト作成」WI を45分粒度で
```

## 7. タスクを終えたら: `/task-closeout`

```text
/task-closeout work/tasks/TASK-YYYY-MM-DD-001.md
```

Done Definition を一項目ずつ確認して `status: Done`・`ended_at` を記録し、親 Work Item の Related Tasks も更新します。

## 8. 夜: `/end-day`

```text
/end-day
```

その日の `work/daily/` のファイルを更新し、明日の一歩までスキル手順に沿って整理します。

## 9. 週に一度: `/weekly-review`

```text
/weekly-review
```

`templates/weekly-review-template.md` に沿った週次メモの作成・更新と、ポートフォリオ視点の整理が行われます。

## 10. タスクボードを確認したいとき: `/board-html`

```text
/board-html
```

`work/board.html` を生成または更新します。生成後はブラウザで開いてください（サーバー不要）。

表ビューでは列名が日本語化され、**ステータス**（Task の `status`）と **項目種別**（親 Work Item の `type`）も日本語で表示されます。Markdown 上の `status` / `type` は英語の固定語にしてください。ブラウザの「CSV 出力」と `work/tasks.csv` も同じ日本語ラベルです。

| ビュー      | ショートカット | 内容                                     |
| ----------- | -------------- | ---------------------------------------- |
| Kanban      | K              | ステータス列別にタスクを表示             |
| 表          | T              | ソート・フィルタ可能なタスク一覧（CSV出力対応） |
| カレンダー  | C              | 締切（`due`）・内蔵の日本祝日（2024–2035）・任意の `work/calendar-holidays.json`（[例](../examples/work/calendar-holidays.example.json)） |
| ツリー      | R              | Focus Area → Project → Work Item → Task の階層 |

グローバルフィルタバーでテキスト検索・ステータス・優先度・Focus Area によるフィルタが可能です。

---

## 次の一歩

- 初回のメタ一周: `work/` のオンボーディングタスクから始め、`/start-day` や [work/README.md](../work/README.md) の一覧を参照（やり直しは [examples/onboarding/README.md](../examples/onboarding/README.md) の `cp`）
- 分解の粒度: [task-decomposition.md](task-decomposition.md)
- 朝夜の考え方: [daily-rhythm.md](daily-rhythm.md)
- 棚卸し用の自然文プロンプト: [setup-prompts.md](../prompts/setup-prompts.md)
- ドキュメント一覧: [README.md](README.md)

## 付録: 手動でテンプレだけ置きたい場合

エージェントを使わず `cp templates/... work/...` で置く手順は [README.md](../README.md) の「初期セットアップ」を参照してください。通常はオンボーディングサンプルまたは `/new-task` と `/start-day` で足ります。
