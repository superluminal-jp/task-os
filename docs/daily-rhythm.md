# Daily Rhythm

## Claude Code での実行

- **朝**: `/start-day`（`work/daily/YYYY-MM-DD.md` の更新と、WIP・外部依存待ち・主案件の整理がスキル手順に沿って進む）
- **夜**: `/end-day`（完了・外部依存待ち・未整理・学び・明日の一歩を日次ログに残す）

**Hooks**（`.claude/settings.json`）は次を補助します。詳細は [CLAUDE.md](../CLAUDE.md) の「Hooks」を参照してください。

- 新規タスクを `status: Doing` で書き込むとき、既に **Doing が 3 件**なら作成をブロック（WIP 上限。旧 `対応中` も hooks で同扱い）
- セッション終了時、**Doing があるのに夜のログが空**に近い場合、`/end-day` の実行を促すリマインダー

タスクや `work/` 階層のファイルを編集すると、PostToolUse で `work/board.html` と `work/tasks.csv` が更新されることがあります（手動は `python3 scripts/generate_board_assets.py` または `/board-html`）。表・CSV の **ステータス**・**項目種別** は日本語ラベルで出ます（Task の `status` / Work Item の `type` は Markdown で英語のまま）。

## PDCA との対応

朝夜サイクルは **PDCA (Plan-Do-Check-Act)** に対応します（ISO 9001 / Deming Cycle）。

| 時間 | PDCA | 主な動作 |
|---|---|---|
| 朝 | **Plan** + Do の起動 | 主案件・補助・余白を決め、Doing に1件流す |
| 日中 | **Do** | Kanban フローで Task を進める |
| 夜 | **Check** | 完了/未完了/学びを記録、フロー指標を眺める |
| 夜 | **Act** | 翌日の first step、必要なら方針調整 |

週次（Weekly Review）はこのループの上位 PDCA で、Kanban *Replenishment / Delivery Planning / Retrospective* の各カデンスに相当します。

## 朝にやること

### この時間の位置づけ
- レイヤー: Task / Daily Log
- 考え方: Kanban execution + daily planning（PDCA: Plan）

### 手順
1. `外部依存待ち` を確認する — `follow-up` 日付が今日以前のものは、解除できるか・`中止` にするかを即断する（**RAID Issue review** に相当）
2. `対応中` を確認する
3. `着手待ち` から今日の主案件を1件決める
4. 補助タスクを1〜2件だけ選ぶ
5. 今日新しく入ってきそうな割り込みを見越して余白を残す

### 判断基準
- ユーザー影響
- 事業影響
- 緊急性
- 学習価値
- 実装効率

### 朝に残すもの
- 今日の主案件
- 軽作業
- リスク
- 先に確認すべきこと

## 夜にやること

### この時間の位置づけ
- レイヤー: Task / Daily Log
- 考え方: reflection + flow control（PDCA: Check / Act）

### 手順
1. `完了` に動いたものを確定する
2. 未完了を `着手待ち` か `外部依存待ち` に戻す
3. 新しい論点を `未整理` に入れる
4. 学びを1〜3行で残す
5. 明日の最初の一歩を決める

### 夜に残すもの
- 今日終わったこと
- 残っていること
- 新しい未整理
- 学び
- 明日の first step

---

## 関連ドキュメント

- [ドキュメント索引](README.md)
- [クイックスタート](quickstart.md)
- [CLAUDE.md](../CLAUDE.md)（Hooks・朝夜のエージェント挙動）
