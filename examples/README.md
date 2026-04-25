# examples/

**オンボーディング用**の Focus Area / Project / Work Item / Task は、**デフォルトで [`work/`](../work/README.md) に同梱**されています。[`onboarding/`](onboarding/) には同一内容のバックアップがあり、`work/` に置いたときと同じ相対パスで [`docs/`](../docs/README.md) や [`templates/`](../templates/README.md) に届きます。

| 内容 | 場所 |
| --- | --- |
| オンボーディングのコピー手順 | [`onboarding/README.md`](onboarding/README.md) |
| 日次ログのサンプル（別題材） | [`daily/2026-03-29.md`](daily/2026-03-29.md) |
| カレンダー祝日の例 | [`work/calendar-holidays.example.json`](work/calendar-holidays.example.json) → `work/calendar-holidays.json` にコピーして編集 |

- **再体験**: [`onboarding/README.md`](onboarding/README.md) の `cp` で `work/` に上書きしたあと、必要ならリポジトリ直下で `python3 scripts/generate_board_assets.py` を実行してボードを更新（hooks が有効な環境では編集時に自動更新されることもあります）。
- **タスク ID**: `TASK-2026-04-01-001` … の日付 **2026-04-01 は固定**（再コピーしても同じ ID で揃います）。

関連: [README.md](../README.md)（リポジトリ概要）、[prompts/README.md](../prompts/README.md)（チャット用プロンプト）。
