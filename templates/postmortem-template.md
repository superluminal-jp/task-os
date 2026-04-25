# Postmortem: <incident-title>

## Layer
Incident Item の事後成果物

## Framework role
Blameless postmortem (Google **SRE Workbook** 形式)。
インシデントは **ITIL 4 Incident Management** に従って収束させ、収束後にこのファイルを書く。
セキュリティインシデントの場合は **NIST SP 800-61r2** Post-Incident Activity に対応。

## Status
<!-- Draft | Final -->
Draft

## Date / Author
- Incident date: YYYY-MM-DD
- Author (RACI A): 
- Reviewers:

## Severity
<!-- ASK USER: 確定する前にユーザーに必ず確認する。選択肢: SEV-1 (重大/即時) / SEV-2 (大/数時間) / SEV-3 (小/翌営業日) -->
SEV-

## Summary
<!-- 1 段落で: 何が起きたか / どの程度の影響か / どう収束したか -->

## Impact
- ユーザー影響:
- 事業影響（金銭・信頼）:
- 影響範囲（地域・テナント・機能）:
- 継続時間: <検知から収束まで>

## Timeline (UTC / JST どちらかに統一)

| Time | Event |
|------|-------|
| HH:MM |  |
| HH:MM | 検知 |
| HH:MM | 暫定対処 |
| HH:MM | 収束確認 |

## Detection
- 検知方法（アラート / ユーザー報告 / 自分で気づいた）:
- 検知遅延の有無と原因:

## Root Cause
<!-- 直接原因と根本原因を分ける。**5 Whys** で深掘りしてもよい -->
- 直接原因:
- 根本原因:
- 5 Whys:
  1. Why ... → ...
  2. Why ... → ...
  3. Why ... → ...
  4. Why ... → ...
  5. Why ... → ...

## What went well
- 

## What went poorly
- 

## Where we got lucky
- 

## Action Items
<!-- 必ず Task 化する。完了基準と Owner (RACI A) を明記 -->

| ID | Action | Type (Prevent / Detect / Mitigate) | Owner | Due | Linked Task |
|----|--------|-----------------------------------|-------|-----|-------------|
| AI-1 |  |  |  |  | [TASK-...](../tasks/<filename>.md) |

## Lessons learned
- 

## Links
- 親 Work Item: [<WI-ID> Incident Item](../work-items/<filename>.md)
- 関連 ADR / 設計資料:
- アラート / ログ / グラフ:

---

> **Blameless principle**: 個人を責めず、システム・プロセスを責める。
> 名前は事実の記述に必要な範囲で書き、評価的な表現は避ける。
