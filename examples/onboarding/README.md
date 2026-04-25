# オンボーディング一式（再体験・上書き用）

**クローン直後の `work/`** に、ここと同じ Focus Area / Project / Work Item / Task が **すでに同梱**されています（[work/README.md](../../work/README.md)）。このフォルダは **同一チェーンのバックアップ**であり、オンボーディングを最初からやり直したり、空の `work/` に戻したあとで **復元コピー**するときに使います。

このフォルダの Markdown を `work/` に **上書きコピー** したあとも、`docs/`・`templates/`・`CLAUDE.md` への相対リンクはそのまま機能します。

## `work/` へコピーする（再体験・復元時）

既存の本番用ファイルがある場合はバックアップを取ってから実行してください。

```bash
# リポジトリ直下で実行
cp examples/onboarding/focus-areas/*.md work/focus-areas/
cp examples/onboarding/projects/*.md work/projects/
cp examples/onboarding/work-items/*.md work/work-items/
cp examples/onboarding/tasks/*.md work/tasks/
```

## 含まれるもの

| 層 | ファイル |
| --- | --- |
| Focus Area | [`focus-areas/task-os-onboarding.md`](focus-areas/task-os-onboarding.md) |
| Project | [`projects/learn-task-os-daily.md`](projects/learn-task-os-daily.md) |
| Work Item | [`work-items/WI-ONB-001-master-daily-rhythm.md`](work-items/WI-ONB-001-master-daily-rhythm.md) |
| 最初の Task | [`tasks/TASK-2026-04-01-001-read-quickstart-and-command-list.md`](tasks/TASK-2026-04-01-001-read-quickstart-and-command-list.md)（`status: Ready`） |

タスク ID の日付は **2026-04-01 固定**（`TASK-2026-04-01-001` … `006`）。

手順の全体像は [docs/quickstart.md](../../docs/quickstart.md) の「2. 初回オンボーディング」を参照してください。

コピー後、`work/board.html` をすぐ合わせたい場合はリポジトリ直下で `python3 scripts/generate_board_assets.py` を実行してください（[scripts/README.md](../../scripts/README.md)）。Claude Code の hooks が有効なら、続く編集で自動更新されることもあります。
