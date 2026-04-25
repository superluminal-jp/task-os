# work/

運用ファイル（Focus Area / Project / Work Item / Task / Daily / Weekly）を置くデフォルトの場所です。未使用のサブフォルダは `.gitkeep` でリポジトリに含めていることがあります。

## サブディレクトリ

| パス | 用途 |
| --- | --- |
| `focus-areas/` | Focus Area |
| `projects/` | Project |
| `work-items/` | Work Item |
| `tasks/` | Task |
| `daily/` | 日次ログ（`YYYY-MM-DD.md`） |
| `weekly/` | 週次レビュー |
| `archive/` | 完了・ドロップ・古い日次の退避（[CLAUDE.md](../CLAUDE.md) の Archiving） |

## 生成物（ソースではない）

次は **手で編集しない** でください。`work/` 内の Markdown を更新したあと、hooks、`python3 scripts/generate_board_assets.py`、または `/board-html` で再生成されます（詳細は [scripts/README.md](../scripts/README.md)、[CLAUDE.md](../CLAUDE.md) の Hooks）。

| ファイル | 用途 |
| --- | --- |
| `board.html` | Kanban / 表 / カレンダー / ツリー（ブラウザで開く）。表・ツリーでは Work Item 種別を日本語バッジ表示（ソースの `type` は英語のまま） |
| `tasks.csv` | 表ビュー・エクスポート用。`項目種別` 列は種別の日本語ラベル |

### カレンダー用の祝日（任意）

`/board-html` で生成する `work/board.html` のカレンダーは、テンプレート内蔵の**日本の祝日（2024–2035）**に加え、`calendar-holidays.json` があればその内容をマージします。

- 置き場所: **`work/calendar-holidays.json`**
- 形式: `YYYY-MM-DD` キーに祝日名（文字列）。任意で `__meta.japanNational: false` で内蔵の日本祝日を使わず、ファイル内の日付だけ表示。
- 例: [`examples/work/calendar-holidays.example.json`](../examples/work/calendar-holidays.example.json) をコピーして編集。

## 初回オンボーディング（クローン直後から同梱）

**task-os の使い方を学ぶ** メタなチェーンが最初から入っています（実務の題材ではありません）。

| 層 | ファイル |
| --- | --- |
| Focus Area | [`focus-areas/task-os-onboarding.md`](focus-areas/task-os-onboarding.md) |
| Project | [`projects/learn-task-os-daily.md`](projects/learn-task-os-daily.md) |
| Work Item | [`work-items/WI-ONB-001-master-daily-rhythm.md`](work-items/WI-ONB-001-master-daily-rhythm.md) |
| 最初の Task | [`tasks/TASK-2026-04-01-001-read-quickstart-and-command-list.md`](tasks/TASK-2026-04-01-001-read-quickstart-and-command-list.md)（`status: Ready`。ID 日付は **2026-04-01 固定**） |

手順は [docs/quickstart.md](../docs/quickstart.md) の「2. 初回オンボーディング」を参照してください。完了後は [CLAUDE.md](../CLAUDE.md) の Archiving に従い `archive/` へ移すか、不要ファイルを削除してかまいません。オンボーディングを **再適用** するときは [examples/onboarding/README.md](../examples/onboarding/README.md) から同じファイルを `work/` に上書きコピーしてください。

---

完了・ドロップしたファイルの退避先は [CLAUDE.md](../CLAUDE.md) の Archiving に従い、`archive/` 以下へ移します。
