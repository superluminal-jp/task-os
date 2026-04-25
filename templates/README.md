# templates/

`work/` に新規ファイルを作るときの **型** です。コピーしてリネームするか、`/new-task` や各スキルに任せます。

**参照実装（初期チェーン）**: クローン直後の [`work/`](../work/README.md) には、これらテンプレの形に沿った **オンボーディング用**の Focus Area / Project / Work Item / Task が入っています（再体験用のコピー元は [`examples/onboarding/`](../examples/onboarding/README.md)）。

## Markdown（運用エンティティ）

| ファイル | 用途 |
| --- | --- |
| [focus-area-template.md](focus-area-template.md) | Focus Area |
| [project-template.md](project-template.md) | Project |
| [work-item-template.md](work-item-template.md) | Work Item |
| [task-template.md](task-template.md) | Task（frontmatter の `status` は英語固定値。 [CLAUDE.md](../CLAUDE.md) の `Inbox` … `Dropped`） |
| [daily-log-template.md](daily-log-template.md) | 日次ログ |
| [weekly-review-template.md](weekly-review-template.md) | 週次レビュー（フロー4指標 + RAID review + Kaizen を含む） |
| [raid-log-template.md](raid-log-template.md) | RAID Log（Risks / Assumptions / Issues / Dependencies）。Project が大きいとき分離 |
| [adr-template.md](adr-template.md) | Architecture Decision Record（MADR 形式）。Decision 種別 Work Item の成果物 |
| [postmortem-template.md](postmortem-template.md) | Blameless Postmortem（Google SRE 形式）。Incident Item 収束後 |

## ボード・祝日データ

| ファイル | 用途 |
| --- | --- |
| [board-template.html](board-template.html) | `work/board.html` の骨格。`/board-html` または `scripts/generate_board_assets.py` が `DATA` を注入。表の「項目種別」列・種別バッジ・ブラウザ CSV 出力で Work Item `type`（英語）を `WI_TYPE_LABEL` で日本語表示 |
| [jp-national-holidays-2024-2035.json](jp-national-holidays-2024-2035.json) | ボードテンプレートに埋め込む日本の祝日データ（カレンダービュー） |

任意の会社休業日などは [work/README.md](../work/README.md) のとおり `work/calendar-holidays.json` で足します（例: [`examples/work/calendar-holidays.example.json`](../examples/work/calendar-holidays.example.json)）。
