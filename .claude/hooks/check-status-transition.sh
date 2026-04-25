#!/usr/bin/env bash
# check-status-transition.sh — PreToolUse/Edit+Write hook
# Enforces "Forward only for Done and Dropped": once a task is Done or Dropped,
# its status cannot move backward or sideways. Re-do ⇒ create a new task.
# Bypass: HITL_BYPASS=1 (use only when user has explicitly authorized).

set -u

if [[ "${HITL_BYPASS:-0}" == "1" ]]; then
  exit 0
fi

INPUT=$(cat)

PY_SCRIPT='
import sys, json, re

raw = sys.stdin.read()
try:
    d = json.loads(raw)
except Exception:
    sys.exit(0)

ti = d.get("tool_input", d)
file_path = ti.get("file_path", "") or ""
if "/work/tasks/" not in file_path and not file_path.lstrip("/").startswith("work/tasks/"):
    sys.exit(0)

old_string = ti.get("old_string")
new_string = ti.get("new_string")
content = ti.get("content")

def extract_status(text):
    if not text:
        return None
    m = re.search(r"^status:\s*(\S+)", text, re.MULTILINE)
    return m.group(1) if m else None

old_status = None
new_status = None

if old_string is not None and new_string is not None:
    old_status = extract_status(old_string)
    new_status = extract_status(new_string)
    if old_status is None and new_status is None:
        sys.exit(0)
    if old_status is None:
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                old_status = extract_status(f.read())
        except FileNotFoundError:
            pass
elif content is not None:
    new_status = extract_status(content)
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            old_status = extract_status(f.read())
    except FileNotFoundError:
        sys.exit(0)
else:
    sys.exit(0)

JP_TO_EN = {
    "未整理": "Inbox", "要件整理中": "Clarify", "着手待ち": "Ready",
    "対応中": "Doing", "自己検証中": "Review", "外部依存待ち": "Waiting",
    "完了": "Done", "中止": "Dropped",
}
old_status = JP_TO_EN.get(old_status, old_status)
new_status = JP_TO_EN.get(new_status, new_status)

TERMINAL = {"Done", "Dropped"}

if old_status in TERMINAL and new_status and new_status != old_status:
    sys.stderr.write(
        "Forward-only ガード: status を " + old_status + " から " + new_status + " に変更できません。\n"
        "→ 再作業が必要なら新しい Task を作成してください "
        "(CLAUDE.md \"Transition rules\")。\n"
        "緊急時のみ HITL_BYPASS=1 で迂回。\n"
    )
    sys.exit(1)

sys.exit(0)
'

printf '%s' "$INPUT" | python3 -c "$PY_SCRIPT"
