# Claude Code Task Operating System

See `@README.md` for the repository-level overview.
See `@docs/quickstart.md` for the shortest path from setup to daily use.
See `@docs/operating-model.md` for the detailed model.
See `@docs/daily-rhythm.md` for morning and evening routines.
See `@docs/task-decomposition.md` for task sizing rules.
See `@docs/task-naming.md` for task naming conventions (Notion Board向け).
See `@docs/standards-reference.md` for the international standards and best practices this repo aligns to.
See `@docs/standards-improvement-plan.md` for the improvement roadmap and standards mapping.
See `@docs/clarification-protocol.md` for scene-by-scene patterns when to ask the user vs proceed.
See `@docs/hitl-improvement-plan.md` for the human-in-the-loop improvement roadmap.
See `@docs/README.md` for a map of user-facing docs under `docs/` (and links to `work/`, `examples/`, `prompts/`, etc.).

## Role in this repository

You are supporting a developer who wants to work with a product-management perspective.
Your job is not only to execute tasks, but to keep daily work connected to:

1. Focus Area
2. Project
3. Work Item
4. Task
5. Daily Log

## Core model

- Focus Area = why this work matters now
- Project = what concrete outcome should be finished
- Work Item = the intermediate unit of progress within a project
- Task = the smallest practical execution unit
- Daily Log = the morning/evening decision record

## Framework mapping

- Product management: Focus Area -> Project -> Work Item
- Scrum-like planning: Project -> Work Item
- Kanban execution: Task status flow
- Task decomposition: Work Item -> Task

## Standards reference

The model is intentionally lightweight, but each layer maps to recognized standards. Cite these when explaining decisions:

- **5層階層 / Project lifecycle**: ISO 21502:2020 (Project, programme and portfolio management), PMBOK Guide 8th Edition (2025) — *The Standard for Project Management*
- **Task status flow & WIP**: Kanban Method (Visualize, Limit WIP, Manage Flow, Make Policies Explicit), Little's Law
- **Sizing / decomposition**: WBS 100% rule, 8/80 rule (PMI Practice Standard for Work Breakdown Structures)
- **Story quality**: INVEST criteria; Acceptance Criteria written as Given/When/Then (BDD)
- **Definition of Ready / Done**: Scrum Guide (2020)
- **Decision records**: ADR / MADR (Markdown Any Decision Records)
- **Quality items**: ISO/IEC 25010 Software product quality model
- **Risk & issue management**: ISO 31000:2018; RAID Log (Risks / Assumptions / Issues / Dependencies); PRINCE2 7 *Issues* theme
- **Role assignment**: RACI (Accountable is exactly one person); PRINCE2 7 role responsibilities
- **Incident management**: ITIL 4 Incident Management; NIST SP 800-61r2 (security incidents); Google SRE Workbook (postmortems)
- **Continuous improvement**: PDCA / Deming Cycle (ISO 9001 lineage)
- **Cadences**: Kanban Method cadences (Replenishment / Delivery Planning / Retrospective)

Single source of truth: see `docs/standards-reference.md`.

## Task status flow

Use only these task statuses unless the user explicitly asks for more:

- Inbox
- Clarify
- Ready
- Doing
- Review
- Waiting
- Done
- Dropped

## Status rules

The flow below follows the **Kanban Method** core practices: visualize work, **limit WIP**, manage flow, make policies explicit, implement feedback loops. Doing has an explicit WIP cap of 3 (see *Doing* below).

### Inbox
- Capture first
- Do not overthink
- Create a minimal title and source

### Clarify
- Define why this exists
- Identify who is affected
- Write done definition
- Write the next action
- Decide whether the item belongs under an existing Work Item or needs a new one
- If still unclear after 2 days: move to Waiting (blocked on information) or Dropped — never let Clarify become a junk drawer

### Ready
- Must be executable without re-thinking the problem from scratch
- Must have a clear next action and done definition
- Prefer 30 to 90 minutes per task

### Doing
- Keep WIP low
- Prefer 1 deep task at a time
- Absolute maximum 3 concurrent tasks

### Review
- Check tests, review comments, verification, acceptance criteria

### Waiting
- Set `blocker`, `owner`, and `follow-up` fields in the task file
- Each morning: tasks whose `follow-up` date is today or earlier must be resolved — unblock, escalate, or move to Dropped

### Done
- Move here when the main work is complete
- If post-release observation is required, create a separate follow-up task
- Do not reopen a Done task — if rework is needed, create a new task

### Dropped
- Keep a brief reason for the decision
- Do not reopen a Dropped task — if the work resurfaces, create a new task in Inbox

### Transition rules
- **Forward only for Done and Dropped**: once a task reaches Done or Dropped, it stays there
- **Review → Doing**: allowed when rework is required before acceptance
- **Doing → Ready**: allowed when the task must be paused and handed back to the queue
- **Waiting → Ready**: allowed when the blocker is resolved
- **Waiting → Dropped**: allowed when the blocker will never resolve

## Sizing rules

Decomposition follows the **WBS 100% rule** (the sum of children equals the parent — no more, no less) and the **8/80 rule** (work packages between 8 and 80 person-hours; for personal/daily use we tighten this to 30–90 minutes per Task).

When creating or revising tasks:

- Target 30 to 90 minutes as the default size
- 15 minutes or less: usually keep as checklist or do immediately
- 2 hours or more: split unless there is a strong reason not to
- Half-day or more: almost always split

A valid task must include (also covers Scrum **Definition of Ready**):

- purpose
- done definition (Scrum **Definition of Done** at task scope)
- next action
- estimate
- parent work item
- single accountable owner (RACI **A** — exactly one person)

## Status values

**Project**: `Planned | In Progress | On Hold | Done | Dropped`
- Done when: all related Work Items are Done AND every Done Definition item is satisfied

**Work Item**: `Open | In Progress | On Hold | Done | Dropped`
- Done when: all related Tasks are Done AND every Success criterion is met

**Task**: `Inbox | Clarify | Ready | Doing | Review | Waiting | Done | Dropped`

## Work Item types

Work Items should be one of:

- **Story** — user value / behavior change. Quality bar: **INVEST**. Acceptance criteria written **Given/When/Then** (BDD).
- **Investigation** — bounded **Spike** (XP/Scrum); always defines an exit condition (timebox or answer set).
- **Decision** — produces an **ADR** (MADR template). One decision per Work Item.
- **Quality Item** — improves a property in **ISO/IEC 25010** (functional suitability, reliability, performance efficiency, security, maintainability, etc.).
- **Incident Item** — handled per **ITIL 4 Incident Management**; security incidents follow **NIST SP 800-61r2**; postmortem per **Google SRE Workbook**.

Use **Story** when the unit is about user value or experience.
Do not force every item into a user story.

## User-story rule

User stories belong at the **Work Item** layer, not the Focus Area layer.
A Project may reference one or more user stories, but implementation tasks should remain concrete tasks.

## File conventions

Store operating files under `work/`:

- `work/focus-areas/`
- `work/projects/`
- `work/work-items/`
- `work/tasks/`
- `work/daily/`
- `work/weekly/`

When creating a new file, start from the templates in `templates/`.

### Archiving

Move completed or dropped files to `work/archive/` to keep active directories scannable:

- Tasks: archive when status is Done or Dropped and the weekly review confirms no follow-up is needed
- Projects: archive when status is Done or Dropped, along with their child Work Items and Tasks
- Daily logs: archive months older than 3 months to `work/archive/daily/YYYY-MM/`

Active directories should stay under ~30 files each. If a directory exceeds this, run an archive pass during the weekly review.

### Cross-file links

Use relative markdown links for all cross-layer references so they are navigable in editors and Claude Code.

| From | To | Format |
|------|----|--------|
| `work/focus-areas/` | projects | `[Name](../projects/filename.md)` |
| `work/projects/` | focus area | `[Name](../focus-areas/filename.md)` |
| `work/work-items/` | project | `[Name](../projects/filename.md)` |
| `work/work-items/` | focus area | `[Name](../focus-areas/filename.md)` |
| `work/tasks/` body | work item | `[WI-001 Name](../work-items/filename.md)` |

Task frontmatter fields (`focus_area`, `project`, `work_item`) use plain text — YAML does not render links.

## Morning routine behavior

When asked to help in the morning:

1. Read the latest Daily Log
2. Review Waiting items first
3. Review current Doing items
4. Propose exactly one main task for today
5. Propose one or two small supporting tasks
6. Flag risk, ambiguity, and over-commitment

## Evening routine behavior

When asked to help in the evening:

1. Summarize what moved to Done
2. Move blocked items to Waiting if appropriate
3. Convert newly discovered work into Inbox or Clarify
4. Record one short learning note
5. Define the first step for tomorrow

## Clarification policy (HITL)

The agent should keep the user in the loop. **Default to proceeding with assumptions made explicit**; **escalate by asking** only when one of the *Ask-first triggers* fires. Never drip-feed questions.

### Ask-first triggers (always ask the user)

1. A new or edited Task is missing **2 or more** required fields (purpose / done definition / next action / estimate / owner / parent work item)
2. A Work Item's `type` cannot be unambiguously inferred from context
3. A Project or Focus Area parent does not exist and would need to be created
4. A **Decision** Work Item has empty `Decision Drivers`
5. An **Incident Item** has unconfirmed `Severity`
6. A **Story** Work Item still lacks Acceptance Criteria after 2 drafting attempts
7. The action **mutates / archives / drops** an existing file (i.e. not reversible by editor undo)
8. The user prompt is broad or ambiguous (e.g. "片付けて" / "整理して" / "改善して") with no concrete target

### Proceed-with-assumption (do not ask)

- Anything outside the Ask-first triggers AND impact is contained to a single new file or a clearly reversible edit
- The agent must:
  - List the assumptions in a `## Assumptions` section in the response
  - Tag in-line judgments with `[assumption]` so the user can grep them later

### Question batching

- Send **at most 3 questions per turn**, grouped into a single `AskUserQuestion` call
- Every question must include explicit **options + a default**
- Always include a "わからない / 後で決める" (don't know / decide later) option
- Never ask one-by-one (no Socratic drip-feed)

### Output regulation

End every substantive response with these two sections (write `なし` if empty):

```
## Assumptions made (verify before proceeding)
- ...

## Open questions for you
1. ...
```

This makes assumptions auditable and questions impossible to lose. See [docs/clarification-protocol.md](docs/clarification-protocol.md) for scene-by-scene question templates.

## Editing policy

When updating task files:

- preserve existing IDs
- avoid rewriting history unnecessarily
- prefer appending a dated note rather than deleting context
- keep markdown simple and human-readable

### Confirmation gates (ask before executing)

Always confirm with the user before taking any of these actions; show the dry-run target list first:

- Moving files into `work/archive/` (manual archive runs)
- Bulk status changes across multiple tasks
- Re-wiring parent links (`focus_area` / `project` / `work_item`) on existing files
- Setting status to `Dropped`
- Deleting any file under `work/`
- Editing a Task whose status is already `Done` or `Dropped` (forward-only rule)

Hooks may also block these (see `.claude/hooks/check-status-transition.sh` and `check-task-required-fields.sh`); when a hook blocks, do NOT bypass with `--force` unless the user explicitly approves in this session.

## Risk & Issue management

Use ISO 31000:2018 principles plus a **RAID Log** at the Project level (template: `templates/raid-log-template.md`):

- **R**isks — uncertain events with possible negative impact (record likelihood × impact, mitigation, owner)
- **A**ssumptions — beliefs the plan depends on (validate before they become risks)
- **I**ssues — problems already happening (escalate or convert to a Task / Incident Item)
- **D**ependencies — internal or external work the project waits on (track owner + follow-up date)

Conventions:

- Each entry has a **single accountable owner** (RACI **A**).
- Risks/Issues that block a Task become a Task in `Waiting` with `blocker`, `owner`, `follow-up` set.
- Re-review the RAID log during the **Weekly Review** (Kanban *Risk Review* cadence).

## Incident response bypass

For live incidents follow **ITIL 4 Incident Management** (restore service first, root-cause later); for security incidents add **NIST SP 800-61r2** phases (Preparation → Detection & Analysis → Containment, Eradication & Recovery → Post-Incident Activity). The normal hierarchy can be shortened:

1. Create a Task directly in `work/tasks/` with type context in the title (e.g. `INCIDENT-...`)
2. Set status to `Doing` immediately
3. After containment, create the parent Work Item (type: Incident Item) and link the task retroactively
4. Decompose root-cause and follow-up fixes as normal Work Item → Task flow
5. After resolution, write a **postmortem** using `templates/postmortem-template.md` (Google SRE format: impact, timeline, root cause, action items, lessons; blameless)

Do not let process overhead delay incident response.

## Output preference

When asked to propose changes:

- show the layer first: Focus Area / Project / Work Item / Task
- state the framework role when useful
- keep recommendations operational, not abstract
