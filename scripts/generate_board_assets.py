#!/usr/bin/env python3
"""
Build work/board.html and work/tasks.csv from work/*.md (same role as /board-html).
Used by Claude Code PostToolUse hooks. Stdlib only.
"""
from __future__ import annotations

import csv
import io
import json
import re
from datetime import datetime, timezone
from pathlib import Path


def repo_root() -> Path:
    return Path(__file__).resolve().parent.parent


WI_TYPE_JA: dict[str, str] = {
    "Story": "ストーリー",
    "Investigation": "調査",
    "Decision": "意思決定",
    "Quality Item": "品質項目",
    "Incident Item": "インシデント項目",
}


def work_item_type_ja(en: str) -> str:
    key = (en or "").strip()
    return WI_TYPE_JA.get(key, key)


# Task `status` in markdown: canonical English. Legacy Japanese is normalized when reading.
STATUS_LEGACY_JA_TO_EN: dict[str, str] = {
    "未整理": "Inbox",
    "要件整理中": "Clarify",
    "着手待ち": "Ready",
    "対応中": "Doing",
    "自己検証中": "Review",
    "外部依存待ち": "Waiting",
    "完了": "Done",
    "中止": "Dropped",
}

TASK_STATUS_EN_JA: dict[str, str] = {
    "Inbox": "未整理",
    "Clarify": "要件整理中",
    "Ready": "着手待ち",
    "Doing": "対応中",
    "Review": "自己検証中",
    "Waiting": "外部依存待ち",
    "Done": "完了",
    "Dropped": "中止",
}

TASK_STATUS_CANONICAL_EN: frozenset[str] = frozenset(TASK_STATUS_EN_JA.keys())


def normalize_task_status(raw: str) -> str:
    s = (raw or "").strip()
    if s in STATUS_LEGACY_JA_TO_EN:
        return STATUS_LEGACY_JA_TO_EN[s]
    if s in TASK_STATUS_CANONICAL_EN:
        return s
    return s


def task_status_ja(en: str) -> str:
    key = (en or "").strip()
    return TASK_STATUS_EN_JA.get(key, key)


def read_text(p: Path) -> str:
    return p.read_text(encoding="utf-8")


def parse_simple_frontmatter(raw: str) -> tuple[dict[str, str], str]:
    """Parse ---\\n key: value \\n--- body. Values are single-line; empty -> ''."""
    if not raw.startswith("---"):
        return {}, raw
    parts = raw.split("---", 2)
    if len(parts) < 3:
        return {}, raw
    fm: dict[str, str] = {}
    for line in parts[1].splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if ":" in line:
            k, _, v = line.partition(":")
            fm[k.strip()] = v.strip()
    return fm, parts[2]


def section_body(content: str, heading: str) -> str:
    """First ## {heading} block body until next ##."""
    pat = rf"^##\s+{re.escape(heading)}\s*$(.*?)(?=^##\s|\Z)"
    m = re.search(pat, content, re.MULTILINE | re.DOTALL)
    return m.group(1).strip() if m else ""


def bullet_list(section: str) -> list[str]:
    out: list[str] = []
    for line in section.splitlines():
        line = line.strip()
        if line.startswith("- "):
            out.append(line[2:].strip())
    return out


def parse_focus_area(path: Path, content: str) -> dict:
    stem = path.stem
    m = re.search(r"^#\s+Focus Area:\s*(.+)$", content, re.MULTILINE)
    name = m.group(1).strip() if m else stem
    obj = section_body(content, "Objective").splitlines()
    objective = next((x.strip() for x in obj if x.strip()), "")
    why = section_body(content, "Why now")
    why_now = why.splitlines()[0].strip() if why else ""
    return {
        "id": stem,
        "name": name,
        "objective": objective[:2000],
        "whyNow": why_now[:2000],
        "rawMarkdown": content[:8000],
    }


def link_target_id(text: str, kind: str) -> str | None:
    """Extract stem from ../focus-areas/foo.md or ../projects/bar.md."""
    m = re.search(rf"\.\./{kind}/([^)\s]+\.md)", text)
    if m:
        return Path(m.group(1)).stem
    return None


def parse_project(path: Path, content: str) -> dict:
    stem = path.stem
    m = re.search(r"^#\s+Project:\s*(.+)$", content, re.MULTILINE)
    name = m.group(1).strip() if m else stem
    fa_line = section_body(content, "Focus Area")
    fa_id = link_target_id(fa_line, "focus-areas")
    st_sec = section_body(content, "Status")
    status = next((x.strip() for x in st_sec.splitlines() if x.strip() and not x.strip().startswith("<!--")), "Planned")
    goal = section_body(content, "Goal").splitlines()
    goal_txt = next((x.strip() for x in goal if x.strip()), "")
    dd = bullet_list(section_body(content, "Done Definition"))
    return {
        "id": stem,
        "name": name,
        "focusArea": fa_id or "",
        "status": status,
        "goal": goal_txt[:2000],
        "doneDefinition": dd[:50] or [],
        "rawMarkdown": content[:8000],
    }


def parse_work_item(path: Path, content: str) -> dict:
    m = re.search(r"^#\s+Work Item:\s*(.+)$", content, re.MULTILINE)
    title = m.group(1).strip() if m else path.stem
    wi_id = None
    m2 = re.match(r"^(WI-[A-Z0-9-]+)\s+", title)
    if m2:
        wi_id = m2.group(1)
    if not wi_id:
        m3 = re.search(r"^(WI-[A-Z0-9-]+)", path.stem)
        wi_id = m3.group(1) if m3 else path.stem
    name = title.replace(wi_id, "", 1).strip() if wi_id else title
    pj_line = section_body(content, "Project")
    fa_line = section_body(content, "Focus Area")
    project_id = link_target_id(pj_line, "projects")
    fa_id = link_target_id(fa_line, "focus-areas")
    typ_sec = section_body(content, "Type")
    type_val = next((x.strip() for x in typ_sec.splitlines() if x.strip()), "Story")
    st_sec = section_body(content, "Status")
    status = next((x.strip() for x in st_sec.splitlines() if x.strip()), "Open")
    pr_sec = section_body(content, "Priority")
    priority = next((x.strip() for x in pr_sec.splitlines() if x.strip()), "P2")
    sc = bullet_list(section_body(content, "Success"))
    return {
        "id": wi_id or path.stem,
        "name": name,
        "project": project_id or "",
        "focusArea": fa_id or "",
        "type": type_val,
        "status": status,
        "priority": priority,
        "successCriteria": sc[:30],
        "rawMarkdown": content[:8000],
    }


def task_title(body: str) -> str:
    m = re.search(r"^#\s+Task:\s*(.+)$", body, re.MULTILINE)
    return m.group(1).strip() if m else ""


def parse_waiting(body: str) -> dict:
    sec = section_body(body, "Waiting On")
    out = {"blocker": "none", "owner": "none", "followUp": "none"}
    for line in sec.splitlines():
        line = line.strip()
        if line.startswith("- blocker:"):
            out["blocker"] = line.split(":", 1)[1].strip() or "none"
        elif line.startswith("- owner:"):
            out["owner"] = line.split(":", 1)[1].strip() or "none"
        elif line.startswith("- follow-up:"):
            out["followUp"] = line.split(":", 1)[1].strip() or "none"
    return out


def resolve_fa_id(fas: list[dict], val: str) -> str:
    v = (val or "").strip()
    if not v:
        return ""
    for fa in fas:
        if v == fa["id"]:
            return fa["id"]
    for fa in fas:
        if v == fa["name"] or v in fa["name"] or fa["name"] in v:
            return fa["id"]
    return v


def resolve_project_id(projects: list[dict], val: str) -> str:
    v = (val or "").strip()
    if not v:
        return ""
    for p in projects:
        if v == p["id"]:
            return p["id"]
    for p in projects:
        if v == p["name"] or v in p["name"]:
            return p["id"]
    return v


def parse_task(path: Path, content: str, fas: list[dict], projects: list[dict], wis: list[dict]) -> dict | None:
    fm, body = parse_simple_frontmatter(content)
    if not fm.get("id"):
        return None
    tid = fm["id"]
    name = task_title(body) or tid
    status = normalize_task_status(fm.get("status", ""))
    priority = fm.get("priority", "")
    fa_raw = fm.get("focus_area", "")
    pj_raw = fm.get("project", "")
    wi_raw = fm.get("work_item", "")
    estimate = fm.get("estimate", "")
    due = fm.get("due", "")
    started = fm.get("started_at", "").strip() or None
    ended = fm.get("ended_at", "").strip() or None
    owner = fm.get("owner", "")

    purpose = section_body(body, "Purpose").replace("\n", " ").strip()[:2000]
    ac = bullet_list(section_body(body, "Acceptance Criteria"))
    dd = bullet_list(section_body(body, "Done Definition"))
    na = section_body(body, "Next Action").splitlines()
    next_line = next((x.strip() for x in na if x.strip()), "")
    if next_line.startswith("- "):
        next_line = next_line[2:].strip()
    next_action = next_line

    fa_id = resolve_fa_id(fas, fa_raw)
    pj_id = resolve_project_id(projects, pj_raw)

    wi_name = ""
    for w in wis:
        if w["id"] == wi_raw.strip():
            wi_name = w["name"]
            break

    t: dict = {
        "id": tid,
        "name": name,
        "status": status,
        "focusArea": fa_id,
        "project": pj_id,
        "workItem": wi_raw.strip(),
        "workItemName": wi_name,
    }
    if priority:
        t["priority"] = priority
    if estimate:
        t["estimate"] = estimate
    if due:
        t["due"] = due
    if started:
        t["startedAt"] = started
    else:
        t["startedAt"] = None
    if ended:
        t["endedAt"] = ended
    else:
        t["endedAt"] = None
    if owner:
        t["owner"] = owner
    if purpose:
        t["purpose"] = purpose
    if ac:
        t["acceptanceCriteria"] = ac
    if dd:
        t["doneDefinition"] = dd
    if next_action:
        t["nextAction"] = next_action
    wo = parse_waiting(body)
    t["waitingOn"] = wo
    t["rawMarkdown"] = content[:8000]
    return t


def inject_data_line(template: str, data: dict) -> str:
    line_json = json.dumps(data, ensure_ascii=False, separators=(",", ":"))
    new_line = "const DATA = " + line_json + ";"
    out_lines: list[str] = []
    replaced = False
    for line in template.splitlines():
        if line.strip().startswith("const DATA = "):
            out_lines.append(new_line)
            replaced = True
        else:
            out_lines.append(line)
    if not replaced:
        raise ValueError("templates/board-template.html: const DATA = line not found")
    return "\n".join(out_lines) + ("\n" if template.endswith("\n") else "")


def write_csv(tasks: list[dict], wis: list[dict], projects: list[dict], fas: list[dict], path: Path) -> None:
    wi_map = {w["id"]: w for w in wis}
    pj_map = {p["id"]: p for p in projects}
    fa_map = {f["id"]: f for f in fas}

    buf = io.StringIO()
    w = csv.writer(buf)
    w.writerow(
        ["ID", "タスク名", "ステータス", "優先度", "項目種別", "Work Item", "Project", "Focus Area", "見積", "開始日", "完了日"]
    )
    for t in sorted(tasks, key=lambda x: x["id"]):
        wi = wi_map.get(t.get("workItem", ""))
        pj = pj_map.get(t.get("project", ""))
        fa = fa_map.get(t.get("focusArea", ""))
        w.writerow(
            [
                t.get("id", ""),
                t.get("name", ""),
                t.get("status", ""),
                t.get("priority", ""),
                work_item_type_ja(wi.get("type", "")) if wi else "",
                t.get("workItemName") or t.get("workItem", ""),
                pj.get("name", t.get("project", "")) if pj else t.get("project", ""),
                fa.get("name", t.get("focusArea", "")) if fa else t.get("focusArea", ""),
                t.get("estimate", ""),
                t.get("startedAt") or "",
                t.get("endedAt") or "",
            ]
        )
    raw = "\ufeff" + buf.getvalue()
    path.write_text(raw, encoding="utf-8")


def main() -> int:
    root = repo_root()
    work = root / "work"
    tpl = root / "templates" / "board-template.html"
    out_html = work / "board.html"
    out_csv = work / "tasks.csv"

    if not tpl.is_file():
        print(f"Missing {tpl}", flush=True)
        return 1

    focus_areas: list[dict] = []
    for p in sorted((work / "focus-areas").glob("*.md")):
        if p.name.startswith("."):
            continue
        focus_areas.append(parse_focus_area(p, read_text(p)))

    projects: list[dict] = []
    for p in sorted((work / "projects").glob("*.md")):
        if p.name.startswith("."):
            continue
        projects.append(parse_project(p, read_text(p)))

    wis: list[dict] = []
    for p in sorted((work / "work-items").glob("*.md")):
        if p.name.startswith("."):
            continue
        wis.append(parse_work_item(p, read_text(p)))

    tasks: list[dict] = []
    for p in sorted((work / "tasks").glob("*.md")):
        if p.name.startswith(".") or p.name == ".gitkeep":
            continue
        t = parse_task(p, read_text(p), focus_areas, projects, wis)
        if t:
            tasks.append(t)

    # Detect duplicate task IDs and warn
    import sys
    from collections import Counter
    id_file_map: dict[str, list[str]] = {}
    for p in sorted((work / "tasks").glob("*.md")):
        if p.name.startswith(".") or p.name == ".gitkeep":
            continue
        raw = read_text(p)
        m = re.match(r"^---\n(.*?\n)---", raw, re.DOTALL)
        if m:
            for line in m.group(1).splitlines():
                if line.startswith("id:"):
                    tid = line.split(":", 1)[1].strip()
                    id_file_map.setdefault(tid, []).append(p.name)
    for dup_id, files in sorted(id_file_map.items()):
        if len(files) > 1:
            print(f"WARNING: 重複タスクID '{dup_id}' が {len(files)} 件 — {', '.join(files)}", file=sys.stderr, flush=True)

    data: dict = {
        "generatedAt": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "focusAreas": focus_areas,
        "projects": projects,
        "workItems": wis,
        "tasks": tasks,
    }

    hol = work / "calendar-holidays.json"
    if hol.is_file():
        try:
            raw_h = json.loads(read_text(hol))
            if isinstance(raw_h, dict):
                data["holidays"] = raw_h
        except json.JSONDecodeError:
            print("calendar-holidays.json invalid JSON, skipping holidays", flush=True)

    template = read_text(tpl)
    html = inject_data_line(template, data)
    out_html.write_text(html, encoding="utf-8")
    write_csv(tasks, wis, projects, focus_areas, out_csv)

    print(
        f"Wrote {out_html} ({len(focus_areas)} FA, {len(projects)} PJ, {len(wis)} WI, {len(tasks)} tasks)",
        flush=True,
    )
    print(f"Wrote {out_csv}", flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
