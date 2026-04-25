# Daily Prompt Pack for Claude Code

## 朝

### 最短版

```text
/start-day
```

### 主案件を絞りたい

```text
/start-day 最重要1件だけ、親レイヤー付きで提案して
```

### WIP を整理したい

```text
@daily-operator InProgress（対応中）/ Ready（着手待ち）を今日3件以内に。深い作業は1件。
```

### 待ち案件を先に処理したい

```text
@daily-operator Blocked（外部依存待ち）を今日フォロー順に。誰待ち・再開条件・次の一手つきで
```

## 日中

### 新しい依頼を受けた

```text
/new-task 〈依頼を一文か貼り付け〉
```

### 大きい仕事を分解したい

```text
/plan-work-item work/work-items/<WIファイル>.md を45分粒度で
```

### いまの粒度が適切か確認したい

```text
@task-breaker この WI の Task 粒度をチェック。修正案つきで
```

### PM視点で優先順位を見たい

```text
@pm-operator Ready（着手待ち）を影響度・緊急度で並べ替えて
```

## 夜

### 最短版

```text
/end-day
```

### メモから整理したい

```text
/end-day 今日のメモで Done・Blocked・Inbox（完了・外部依存待ち・未整理）と明日の一歩まで
```

### 学びを残したい

```text
@daily-operator 今日の学びを3行以内で Daily Log に。要フォローなら別 Task で
```

## 週次

### 最短版

```text
/weekly-review
```

### Focus Area と Project の整合を見たい

```text
@pm-operator 今週の Task が Focus Area に偏ってないか。薄い/厚い所と Done Definition 曖昧な Project を指摘
```

### 渋滞箇所を見たい

```text
/weekly-review Clarifying・InReview・Blocked・InProgress（要件整理中・自己検証中・外部依存待ち・対応中）の渋滞と解消案
```
