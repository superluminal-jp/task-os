#!/usr/bin/env python3
"""
Archive Done/Dropped tasks to work/archive/tasks/.

A task is eligible when:
  - status is Done or Dropped  AND
  - ended_at is set and older than --days ago
    (fallback: file mtime older than --days if ended_at is absent)

Usage:
  python3 scripts/archive-tasks.py            # archive tasks older than 7 days
  python3 scripts/archive-tasks.py --days 14  # use 14-day threshold
  python3 scripts/archive-tasks.py --dry-run  # preview without moving

Archived tasks are moved to work/archive/tasks/ and removed from work/tasks/.
generate_board_assets.py only reads work/tasks/, so archived tasks are
automatically excluded from board.html and tasks.csv.
"""
from __future__ import annotations

import argparse
import re
import shutil
import sys
from datetime import datetime, timezone, timedelta
from pathlib import Path


DONE_STATUSES = {"Done", "Dropped", "完了", "中止"}


def repo_root() -> Path:
    return Path(__file__).resolve().parent.parent


def parse_frontmatter(text: str) -> dict[str, str]:
    if not text.startswith("---"):
        return {}
    parts = text.split("---", 2)
    if len(parts) < 3:
        return {}
    fm: dict[str, str] = {}
    for line in parts[1].splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if ":" in line:
            k, _, v = line.partition(":")
            fm[k.strip()] = v.strip()
    return fm


def parse_date(s: str) -> datetime | None:
    """Parse YYYY-MM-DD or ISO 8601 string to UTC-aware datetime."""
    s = (s or "").strip()
    if not s or s in ("none", "null", ""):
        return None
    for fmt in ("%Y-%m-%d", "%Y-%m-%dT%H:%M:%SZ", "%Y-%m-%dT%H:%M:%S"):
        try:
            dt = datetime.strptime(s, fmt)
            return dt.replace(tzinfo=timezone.utc)
        except ValueError:
            continue
    return None


def is_archivable(path: Path, threshold: datetime) -> bool:
    """Return True if the task should be archived."""
    text = path.read_text(encoding="utf-8")
    fm = parse_frontmatter(text)
    status = fm.get("status", "").strip()
    if status not in DONE_STATUSES:
        return False

    # Try ended_at first
    ended_raw = fm.get("ended_at", "")
    ended = parse_date(ended_raw)
    if ended:
        return ended < threshold

    # Fallback: file mtime
    mtime = datetime.fromtimestamp(path.stat().st_mtime, tz=timezone.utc)
    return mtime < threshold


def main() -> int:
    parser = argparse.ArgumentParser(description="Archive old Done/Dropped tasks.")
    parser.add_argument("--days", type=int, default=7, help="Age threshold in days (default: 7)")
    parser.add_argument("--dry-run", action="store_true", help="Preview without moving files")
    args = parser.parse_args()

    root = repo_root()
    tasks_dir = root / "work" / "tasks"
    archive_dir = root / "work" / "archive" / "tasks"
    archive_dir.mkdir(parents=True, exist_ok=True)

    now = datetime.now(timezone.utc)
    threshold = now - timedelta(days=args.days)

    candidates = sorted(p for p in tasks_dir.glob("*.md") if not p.name.startswith("."))
    archived: list[str] = []
    skipped: list[str] = []

    for path in candidates:
        try:
            if is_archivable(path, threshold):
                dest = archive_dir / path.name
                if dest.exists():
                    # Avoid overwrite: append suffix
                    dest = archive_dir / (path.stem + "_dup" + path.suffix)
                if args.dry_run:
                    print(f"[dry-run] would archive: {path.name} → archive/tasks/{dest.name}")
                else:
                    shutil.move(str(path), str(dest))
                    print(f"archived: {path.name} → work/archive/tasks/{dest.name}")
                archived.append(path.name)
            else:
                skipped.append(path.name)
        except Exception as e:
            print(f"ERROR processing {path.name}: {e}", file=sys.stderr)

    label = "[dry-run] " if args.dry_run else ""
    print(f"\n{label}archived {len(archived)} task(s), skipped {len(skipped)} active task(s).")
    if archived:
        print("Re-run /board-html or let the PostToolUse hook regenerate board.html.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
