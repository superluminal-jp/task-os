---
name: board-generator
description: Generate work/board.html from all work/ markdown files. Use when the user runs /board-html or asks to refresh the task board. Reads YAML frontmatter from task files, markdown sections from Focus Area/Project/Work Item files, builds a JSON data payload, and injects it into templates/board-template.html.
tools: Read, Glob, Write, Edit, Grep
maxTurns: 30
---

You are the board generator. Your job: read all work/ markdown files, extract structured data, and write a self-contained `work/board.html` by injecting the data into `templates/board-template.html`.

## Data extraction rules

### Task files (`work/tasks/*.md`)

Task `status` values in markdown are **English** (see `CLAUDE.md` / `README.md`): `Inbox`, `Clarifying`, `Ready`, `InProgress`, `InReview`, `Blocked`, `Done`, `Dropped`. Pass them through to JSON unchanged. (Legacy Japanese statuses may still appear in old files; the board template normalizes them to English on load.)

Parse YAML frontmatter (between `---` delimiters). Extract these fields:

| Field | Key in JSON |
|-------|-------------|
| `id` | `id` |
| `title` | `title` |
| `status` | `status` |
| `priority` | `priority` |
| `focus_area` | `focusArea` |
| `project` | `project` |
| `work_item` | `workItem` |
| `type` | `type` |
| `estimate` | `estimate` |
| `due` | `due` |
| `started_at` | `startedAt` |
| `ended_at` | `endedAt` |
| `tags` | `tags` (array) |

Also extract the `## Done Definition` section body as `doneDefinition` (string), and the first paragraph after the frontmatter as `description` (string, up to 200 chars).

If a field is missing, omit it from the JSON object (do not include `null` or empty string).

### Focus Area files (`work/focus-areas/*.md`)

Extract:
- `id`: from the first `# ` heading or the filename stem (e.g. `FA-001-name` → `FA-001`)
- `title`: text of the first `# ` heading
- `status`: value after `**Status**:` or `Status:` in the file
- `description`: first paragraph after the heading (up to 200 chars)

### Project files (`work/projects/*.md`)

Extract:
- `id`: from `id:` frontmatter or filename stem
- `title`: first `# ` heading
- `status`: `**Status**:` or frontmatter `status:`
- `focusArea`: `**Focus Area**:` or frontmatter `focus_area:`
- `description`: first paragraph after heading (up to 200 chars)
- `doneDefinition`: body of `## Done Definition` section (string)

### Work Item files (`work/work-items/*.md`)

Extract:
- `id`: frontmatter `id:` or filename stem
- `title`: first `# ` heading
- `status`: frontmatter or `**Status**:`
- `type`: frontmatter or `**Type**:` — use **English** canonical strings only: `Story` / `Investigation` / `Decision` / `Quality Item` / `Incident Item`. The template maps these to Japanese labels in the table, tree badges, and `tasks.csv`; **do not** put Japanese in JSON `type`.
- `project`: frontmatter `project:` or `**Project**:`
- `focusArea`: frontmatter `focus_area:` or `**Focus Area**:`
- `description`: first paragraph after heading (up to 200 chars)

## Optional calendar holidays (`work/calendar-holidays.json`)

If `work/calendar-holidays.json` exists and contains valid JSON:

- Parse it and set root key `holidays` on the output object to that object (as-is).
- Keys are `YYYY-MM-DD` (string) → holiday label (string). Optional `__meta` object:
  - `japanNational`: if `false`, the board uses **only** these entries (no built-in Japanese national holidays from the template). If omitted or `true`, entries **merge on top of** the template’s built-in set (same date → user label wins).

If the file is missing, omit `holidays` from the output object.

If the file is invalid JSON, skip `holidays`, warn in the report, and continue.

## Output JSON structure

Build this object:

```json
{
  "generatedAt": "<ISO 8601 timestamp>",
  "focusAreas": [ { "id": "...", "title": "...", "status": "...", "description": "..." } ],
  "projects":   [ { "id": "...", "title": "...", "status": "...", "focusArea": "...", "description": "..." } ],
  "workItems":  [ { "id": "...", "title": "...", "status": "...", "type": "...", "project": "...", "focusArea": "..." } ],
  "tasks":      [ { "id": "...", "title": "...", "status": "...", "priority": "...", "focusArea": "...", "project": "...", "workItem": "...", "estimate": "...", "due": "...", "startedAt": "...", "endedAt": "..." } ],
  "holidays":   { "__meta": { "japanNational": true }, "2026-12-29": "会社休業" }
}
```

Include `holidays` only when `work/calendar-holidays.json` was read successfully.

Omit any key whose value would be empty/null. Serialize the entire object as a **single line** (no pretty-printing, no newlines inside the JSON).

## Injection

1. Read `templates/board-template.html` in full.
2. Replace **only** the assignment `const DATA = { ... };` (one logical line in the template). Do **not** remove or alter `JP_HOLIDAYS_BUILTIN` or other script above/below except the `DATA` line.
3. Match from `const DATA = {` through the closing `};` that terminates the `DATA` object (the line replaced by `/board-html`).
4. Write the result to `work/board.html`.

## Step-by-step procedure

1. Glob `work/focus-areas/*.md` — read each, extract FA data.
2. Glob `work/projects/*.md` — read each, extract Project data.
3. Glob `work/work-items/*.md` — read each, extract WI data.
4. Glob `work/tasks/*.md` — read each, parse frontmatter, extract Task data. Skip `.gitkeep`.
5. If `work/calendar-holidays.json` exists, read it and attach as `holidays` (see above).
6. Build the JSON object. Serialize to a single line.
7. Read `templates/board-template.html`.
8. Replace only the `const DATA = { ... };` line with the new single-line DATA assignment.
9. Write to `work/board.html`.
10. Report: counts of FAs, Projects, WIs, Tasks included; whether `holidays` was loaded; path to the generated file.

## Edge cases

- If `work/tasks/` is empty (only `.gitkeep`), write an empty `tasks: []` array and note it in the report.
- If a task file has no frontmatter, skip it with a warning.
- If `templates/board-template.html` does not exist, abort with a clear error.
- Do not modify `templates/board-template.html` — always write to `work/board.html`.
