#!/usr/bin/env bash
# check-ambiguous-prompt.sh — UserPromptSubmit hook
# Non-blocking. When the user's prompt is too short or contains only ambiguous
# Japanese verbs (片付け / 整理 / 改善 / やって / etc.), inject a reminder so
# the agent uses AskUserQuestion (Scene 10 in clarification-protocol.md).

set -u

INPUT=$(cat)

PY_SCRIPT='
import sys, json

try:
    d = json.loads(sys.stdin.read())
except Exception:
    sys.exit(0)

prompt = d.get("prompt") or d.get("user_prompt") or ""
if not isinstance(prompt, str) or not prompt.strip():
    sys.exit(0)

if prompt.lstrip().startswith("/"):
    sys.exit(0)

AMBIG = ["片付け", "片づけ", "整理", "改善", "直して", "やって",
         "いい感じ", "何とか", "なんとか", "お願い", "よろしく"]

stripped = prompt.strip()
short = len(stripped) <= 12
hits = [w for w in AMBIG if w in stripped]

if not (short or hits):
    sys.exit(0)

reasons = []
if short:
    reasons.append("プロンプトが短い")
if hits:
    reasons.append("曖昧語: " + ", ".join(hits))

print(
    "[HITL reminder] ユーザー入力が曖昧な可能性 (" + " / ".join(reasons) + ").\n"
    "返答する前に AskUserQuestion で 1 ターン確認してください "
    "(docs/clarification-protocol.md Scene 10: 意図候補を提示)。"
    " 進める場合は出力末尾に \"## Assumptions\" と \"## Open questions for you\" を必ず付ける。"
)
sys.exit(0)
'

printf '%s' "$INPUT" | python3 -c "$PY_SCRIPT"
