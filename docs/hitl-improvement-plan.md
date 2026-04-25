# Human-in-the-Loop (HITL) 改善プラン（メモリ）

このドキュメントは、task-os の HITL（人間への確認・質問・前提共有）強化計画の単一参照ソースです。
完了済みは `[x]` を付けます。詳細は [clarification-protocol.md](clarification-protocol.md) も参照。

---

## 課題

| 弱点 | 影響 |
|---|---|
| 「聞くべき条件」が CLAUDE.md にない | 自己判断で空欄を埋めてしまう |
| 必須フィールド欠落でも書き込みが通る | DoR 不充足の Task が `Ready` に流れる |
| Inbox→Clarify 移行時に質問生成がない | Clarify がジャンクドロワー化 |
| Skills に preconditions check がない | 入力不足→修正の往復 |
| WIP 上限以外に Block する hook がない | 逆行ステータス遷移を検出できない |
| assumption が見えない | 暗黙前提が事故化 |
| 質問が小出し | ユーザー集中を細切れにする |

---

## 設計原則

1. **狭く厳密な ask-first triggers** — 過剰質問を避ける
2. **proceed-with-assumption がデフォルト** — 進めるが前提を明示
3. **質問は 1 ターンに最大 3 件 / 必ず選択肢付き / "わからない" を含む**
4. **破壊的操作は常に確認** — reversible でない判断
5. **既存 hook (WIP=3 / Stop reminder) と整合 + bypass 必須**

---

## 実装ステップ（優先度順）

### High（ポリシー・規約・テンプレ）

- [ ] CLAUDE.md 新節 "Clarification policy (HITL)" 追加（Ask-first / Proceed-with-assumption / バジェット / labeling）
- [ ] CLAUDE.md "Editing policy" 拡張（破壊操作の事前確認）
- [ ] CLAUDE.md "Output regulation" 追加（Assumptions / Open questions セクション）
- [ ] テンプレに `<!-- ASK USER: ... -->` マーカー導入
  - postmortem-template.md (Severity)
  - adr-template.md (Decision Drivers, Decision)
  - work-item-template.md (Acceptance Criteria for Story)
  - task-template.md (estimate, owner)

### Medium（スキル・プロトコル文書）

- [ ] docs/clarification-protocol.md 新設（シーン別質問テンプレ）
- [ ] .claude/skills/new-task/SKILL.md に preconditions check 追加
- [ ] .claude/skills/start-day/SKILL.md にエネルギー/時間確認ステップ追加
- [ ] .claude/skills/end-day/SKILL.md に学び欄プロンプト追加
- [ ] .claude/skills/weekly-review/SKILL.md に stale 項目の DROP/HOLD/CONTINUE ラジオ追加
- [ ] templates/work-item-template.md `## Open Questions` を **DoR ゲート** と明示（規約レベル）

### New（Hooks）

- [ ] .claude/hooks/check-task-required-fields.sh — DoR フィールド欠落で書き込み拒否
- [ ] .claude/hooks/check-status-transition.sh — Done/Dropped から戻す編集を拒否（Forward-only 強制）
- [ ] .claude/hooks/check-ambiguous-prompt.sh — UserPromptSubmit で曖昧プロンプトに確認注入
- [ ] .claude/settings.json に上記 hooks を配線

### 配線

- [ ] CLAUDE.md 冒頭の `@docs/...` に hitl-improvement-plan.md / clarification-protocol.md 追加
- [ ] docs/README.md に新規ドキュメント追記

---

## Ask-first triggers（CLAUDE.md に転記する確定リスト）

必ずユーザーに聞く:

1. Task の必須フィールド（purpose / done definition / next action / estimate / owner / parent work item）が **2 つ以上** 欠けている
2. Work Item の `type` が文脈から一意に決まらない
3. Project / Focus Area の親が未指定で、新規作成が必要
4. Decision Work Item で **Decision Drivers** が空
5. Incident Item で **Severity** が未確定
6. Story で Acceptance Criteria を 2 試行しても確定できない
7. 既存ファイルを **書き換える / アーカイブする / Dropped にする** 操作（reversible でない）
8. スコープが曖昧な指示（"片付けて" / "改善して" / "整理して"）

---

## Proceed-with-assumption rules

- 上記以外 + 影響範囲が単一ファイルで reversible
- 出力末尾に `## Assumptions` で前提を列挙
- 暗黙判断は `[assumption]` プレフィックス

---

## Question batching rules

- 1 ターンで **最大 3 件**
- AskUserQuestion 使用時は **選択肢 + デフォルト案** を必ず提示
- "わかりません / 後で決める" を選択肢に含める

---

## 関連
- [CLAUDE.md](../CLAUDE.md)
- [docs/clarification-protocol.md](clarification-protocol.md)（実装後）
- [docs/standards-improvement-plan.md](standards-improvement-plan.md)
