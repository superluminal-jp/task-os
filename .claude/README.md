# .claude/

Claude Code 用の **スキル（スラッシュコマンド）**、**サブエージェント**、**hooks**、**設定** を置くフォルダです。運用ルールの正本はリポジトリ直下の [CLAUDE.md](../CLAUDE.md) です。

## レイアウト

| パス | 内容 |
| --- | --- |
| [skills/](skills/) | ユーザーが `/start-day` などで呼ぶ手順（各 `SKILL.md`） |
| [agents/](agents/) | `@daily-operator` などのサブエージェント定義 |
| [hooks/](hooks/) | WIP チェック、セッション終了リマインダー、タスクアーカイブ、ボード再生成のシェルスクリプト |
| [settings.json](settings.json) | hooks の登録（コミット対象） |
| `settings.local.json` | 任意。ローカル上書き用（チーム方針に従いコミットするか判断） |
| [launch.json](launch.json) | エディタ／起動補助用（任意） |

## スキル（名前 = 一般的なスラッシュコマンド）

| スキル | ざっくりした役割 |
| --- | --- |
| `new-task` | 仕事を Focus Area → Task まで取り込む |
| `start-day` | 朝の計画・日次ログ |
| `end-day` | 夜の振り返り |
| `plan-work-item` | Work Item のタスク分解 |
| `task-closeout` | タスク完了・親 WI 更新 |
| `weekly-review` | 週次レビュー |
| `board-html` | `work/board.html` の生成・更新 |
| `update-artifacts` | 計画変更後の Markdown 整合（内部向け設定のスキルあり） |

一覧は Claude Code で `/skills` を実行して確認してください。

## エージェント（例）

| エージェント | 用途の目安 |
| --- | --- |
| `daily-operator` | 朝夜・日次の整理 |
| `pm-operator` | ポートフォリオ・渋滞 |
| `pm-triage` | 取り込み・分類 |
| `task-breaker` | 粒度チェック |
| `board-generator` | `/board-html` 時のボード組み立て |
| `artifact-maintainer` | 成果物の一括更新 |

`/agents` で一覧できます。

## hooks

`.claude/settings.json` から `bash .claude/hooks/…` が呼ばれます。挙動の説明は [CLAUDE.md](../CLAUDE.md) の「Hooks」にまとめています。
