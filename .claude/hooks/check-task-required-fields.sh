#!/usr/bin/env bash
# check-task-required-fields.sh — PreToolUse/Write+Edit hook
# Enforces Definition of Ready (DoR): when a task file's status is
# Ready / Doing / Review (or legacy JP equivalents), required fields
# must be present and non-empty.
# Inbox / Clarify / Waiting / Done / Dropped are exempt from this check
# (capture-first / terminal states).
# Bypass: HITL_BYPASS=1 (use only when user explicitly authorizes).

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

content = ti.get("content")
if content is None:
    old_string = ti.get("old_string") or ""
    new_string = ti.get("new_string") or ""
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            cur = f.read()
        content = cur.replace(old_string, new_string, 1)
    except FileNotFoundError:
        sys.exit(0)

if not content:
    sys.exit(0)

m = re.match(r"^---\n(.*?)\n---\n", content, re.DOTALL)
if not m:
    sys.exit(0)
fm = m.group(1)
body = content[m.end():]

def fm_value(key):
    mm = re.search(r"^" + re.escape(key) + r":\s*(.*?)\s*(?:#.*)?$", fm, re.MULTILINE)
    if not mm:
        return None
    return mm.group(1).strip()

status = fm_value("status") or ""
ENFORCED = {
    "Ready", "Doing", "Review",
    "着手待ち", "対応中", "自己検証中",
}
if status not in ENFORCED:
    sys.exit(0)

missing = []
for key in ("work_item", "estimate", "owner"):
    v = fm_value(key)
    if not v:
        missing.append("frontmatter." + key)

def section_has_content(heading):
    pat = re.compile(r"^##\s+" + re.escape(heading) + r"\s*$", re.MULTILINE)
    mm = pat.search(body)
    if not mm:
        return False
    rest = body[mm.end():]
    next_h = re.search(r"^##\s+", rest, re.MULTILINE)
    block = rest[:next_h.start()] if next_h else rest
    block = re.sub(r"<!--.*?-->", "", block, flags=re.DOTALL)
    for line in block.splitlines():
        s = line.strip()
        if s.startswith("-"):
            tail = s[1:].strip()
            if tail and tail not in ("TODO", "<...>", "<内容>"):
                return True
    return False

for heading in ("Done Definition", "Next Action"):
    if not section_has_content(heading):
        missing.append("body." + heading)

if missing:
    sys.stderr.write(
        "DoR ガード: status=" + status + " だが必須項目が不足しています: " + ", ".join(missing) + "\n"
    )
    sys.stderr.write(
        "→ ASK USER で値を確定してから書き込み直してください "
        "(docs/clarification-protocol.md Scene 1/2)。"
        " 緊急時のみ HITL_BYPASS=1 で迂回。\n"
    )
    sys.exit(1)

sys.exit(0)
'

printf '%s' "$INPUT" | python3 -c "$PY_SCRIPT"
