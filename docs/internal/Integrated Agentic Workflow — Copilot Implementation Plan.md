
> **Purpose:** This document is a single work order for GitHub Copilot (coding agent). Execute each increment sequentially. Do not skip ahead. Stop and ask the user when indicated.

---

## Assumptions & Placeholders

|Label|Meaning|
|---|---|
|`[PROJECT-SPECIFIC]`|Value depends on the target project; leave as placeholder or prompt user|
|`[INSERT COMMAND]`|User must supply the exact CLI command for their environment|
|`[CHOOSE OPTION]`|Copilot should present options to the user and await selection|
|`[VERIFY REPO STATE]`|Copilot should run `find . -maxdepth 3 -type f` (or equivalent) to confirm current file tree before proceeding|

**Key assumptions:**

1. The repository at `github.com/josiahH-cf/workflow` is the authoritative Source C. Its current structure (confirmed via inspection) matches the map in Source A (GAP analysis §1): root contains `README.md`, `LICENSE`, `Principles for Development Using the Workflow.md`, `workflow-diagram.svg`; directories are `.github/workflows/`, `meta-prompts/` (with `initialization.md`, `update.md`, `prompt-sync.md`, `major/`, `minor/`), `prompts/`, and `template/` (with `.claude/commands/`, `.github/`, `.codex/`).
2. No root-level `AGENTS.md` currently exists in `/template/`. A Codex-scoped `AGENTS.md` exists at `/template/.codex/AGENTS.md`.
3. No `CLAUDE.md` currently exists in `/template/`. Any reference to "clause.md" is interpreted as the intended `CLAUDE.md`.
4. No `.specify/` directory exists in `/template/`.
5. Source B's 8-phase model (Scaffold Import → Compass → Define Features → Scaffold Project → Fine-tune Plan → Code → Test/Bug → Maintain) plus the parallel Bug Track is the canonical workflow definition.
6. Source A's gap register (G01–G22) provides the file-level implementation targets.
7. Branch naming in Source B uses `model/type-short-description` (e.g., `claude/feat-auth-flow`). Source A uses `agent/<tool>/<task>`. **Resolution:** Adopt Source B's format as canonical since it maps directly to model assignment in the Fine-tune Plan phase. Document both in AGENTS.md with Source B as primary.

---

## Unified Workflow — Target State

### End-to-End Phase Map

```
Phase 1          Phase 2        Phase 3           Phase 4            Phase 5
Scaffold ──────► Compass ─────► Define ──────────► Scaffold ─────────► Fine-tune
Import           (interview)    Features/Plan      Project & Gaps      Plan
                                                                        │
  ┌─────────────────────────────────────────────────────────────────────┘
  ▼
Phase 6          Phase 7           Phase 8            Parallel
Code ──────────► Test / Mark ────► Maintain ──────    Bug Track
(TDD, branch)    Changes & Bugs   (docs, CI drift)   (any phase)
```

### How AGENTS.md Orchestrates Routing

`AGENTS.md` (root of the template) is the **single entry point** every agent reads first. It contains:

1. **Project overview** — one paragraph (filled during Compass phase)
2. **Workflow phases** — numbered list with entry commands per platform
3. **Agent routing matrix** — task → model/tool assignment rules
4. **Branch naming convention** — `model/type-short-description` format
5. **Core commands** — test, lint, build, typecheck
6. **Code conventions** — language, style, architecture
7. **Boundaries** — ALWAYS / ASK FIRST / NEVER rules
8. **Specification workflow** — pointer to `.specify/` directory
9. **Concurrency rules** — worktree pattern for parallel agents

**Adapter files** (`CLAUDE.md`, `.github/copilot-instructions.md`, `.codex/AGENTS.md`) each contain a single directive: _"Follow the rules in ./AGENTS.md"_ plus platform-specific hooks or command listings. They **never** duplicate routing logic.

### Minimum Artifact Set (Link Graph)

```
AGENTS.md  (root TOC / routing hub)
  ├── referenced by: CLAUDE.md
  ├── referenced by: .github/copilot-instructions.md
  ├── referenced by: .codex/AGENTS.md
  ├── points to: .specify/constitution.md  (Compass output)
  ├── points to: .specify/spec-template.md
  ├── points to: .specify/acceptance-criteria-template.md
  ├── points to: .github/REVIEW_RUBRIC.md
  └── points to: workflow-diagram.svg

.claude/commands/
  ├── compass.md        (Phase 2 interview)
  ├── define-features.md (Phase 3)
  ├── scaffold.md       (Phase 4)
  ├── fine-tune.md      (Phase 5)
  ├── implement.md      (Phase 6)
  ├── test.md           (Phase 7)
  ├── bug.md            (Bug Track)
  ├── maintain.md       (Phase 8)
  └── continue.md       (session resumption)

prompts/
  ├── compass.prompt.md
  ├── define-features.prompt.md
  ├── scaffold.prompt.md
  ├── fine-tune.prompt.md
  ├── implement.prompt.md
  ├── test.prompt.md
  ├── bug.prompt.md
  └── maintain.prompt.md

.github/
  ├── copilot-instructions.md  (adapter → AGENTS.md)
  ├── pull_request_template.md (extended with spec/AC/evidence)
  ├── REVIEW_RUBRIC.md
  ├── agents/
  │   ├── planner.agent.md
  │   └── reviewer.agent.md
  └── workflows/
      ├── ci.yml (existing, extended)
      └── autofix.yml (new)

.codex/
  ├── AGENTS.md (adapter → root AGENTS.md)
  └── ExecPlan-template.md (existing)

meta-prompts/
  ├── initialization.md (existing — update to reference new phases)
  ├── update.md (existing — update)
  ├── prompt-sync.md (existing)
  ├── major/ (existing — update content to match 8-phase model)
  └── minor/ (existing — update content to match 8-phase model)
```

---

## Incremental Implementation Plan

Each increment is designed to be completable in a single Copilot session. Execute in order.

---

### Increment 0 — Verify Baseline

**Objective:** Confirm the current repository state before making any changes.

**Actions:**

1. Clone or checkout `main` of `josiahH-cf/workflow`.
2. Run `find . -maxdepth 4 -type f | sort` and compare against the file map in this plan's Assumptions section.
3. Confirm no root-level `AGENTS.md` exists in `/template/`.
4. Confirm no `CLAUDE.md` exists in `/template/`.
5. Confirm no `.specify/` directory exists in `/template/`.
6. Note any files that exist but are not listed above (record in a scratch note for the user).

**Acceptance Criteria:**

- [ ] File tree output matches or is reconcilable with the map above
- [ ] Any unexpected files are documented in a note to the user

**Verification:** Run the `find` command and compare. If there are major discrepancies (e.g., AGENTS.md already exists at root), STOP and ask the user before proceeding.

**Stop Condition:** If the repo structure has changed significantly from what is described here, stop and report to the user.

---

### Increment 1 — Create Root AGENTS.md (Routing Hub)

**Objective:** Create the universal agent instruction file at `/template/AGENTS.md`. This is the highest-leverage single change (Source A: G04, G05). It becomes the TOC and routing center for the entire workflow.

**File:** `/template/AGENTS.md`

**Required sections (in order):**

1. **`## Overview`** — Placeholder: `[PROJECT-SPECIFIC] — filled during Compass phase (Phase 2)`
2. **`## Workflow Phases`** — Numbered list of all 8 phases from Source B, plus the Bug Track. Each phase entry includes:
    - Phase name and one-line purpose
    - Entry command per platform: Claude (`/command-name`), Copilot (`/prompt-name`), Codex (`see .codex/AGENTS.md`)
    - Gate: what must be true before this phase starts
    - Output: what this phase produces
3. **`## Agent Routing Matrix`** — Table with columns: Task Type | Assigned Model | Branch Prefix | Reason. Populate from Source B §5 model assignment rules and Source A §5 routing matrix. Include the note: _"Model assignment is determined by the rule set below. The developer does not select the model manually unless overriding."_
4. **`## Branch Naming`** — Format: `model/type-short-description`. Examples from Source B: `claude/feat-auth-flow`, `copilot/feat-dashboard-layout`, `codex/bug-login-crash`. Type segment: `feat`, `bug`, `refactor`, `chore`, `docs`.
5. **`## Core Commands`** — Table with `[PROJECT-SPECIFIC]` placeholders for test, lint, build, typecheck commands.
6. **`## Code Conventions`** — Placeholder section: `[PROJECT-SPECIFIC] — filled during Scaffold Project phase (Phase 4)`
7. **`## Specification Workflow`** — Point to `.specify/constitution.md` (Compass output), `.specify/spec-template.md`, and `.specify/acceptance-criteria-template.md`. State: _"Read constitution before any implementation. Check spec for current feature. Verify acceptance criteria before PR."_
8. **`## Concurrency Rules`** — Git worktree pattern: `.trees/<model>-<task>/`. Max parallel agents: `[PROJECT-SPECIFIC]`. Rule: never two agents on the same file.
9. **`## Boundaries`** — Three sub-sections:
    - **ALWAYS:** Read spec before implementation; run tests before commit; include AC evidence in PR; follow branch naming
    - **ASK FIRST:** Adding dependencies; modifying CI workflows; changing constitution; modifying AGENTS.md
    - **NEVER:** Commit secrets/.env; modify files outside assigned scope; auto-merge without human approval; skip tests
10. **`## Bug Tracking`** — Reference the Bug Track (Source B): `/bug` or `:bug` command, structured log format (description, location, phase found, severity, expected vs actual, fix-as-you-go flag). Backlog review cycle treats bugs as specs.

**Acceptance Criteria:**

- [ ] `/template/AGENTS.md` exists and contains all 10 sections listed above
- [ ] Workflow Phases section lists all 8 phases + Bug Track with per-platform entry commands
- [ ] Agent Routing Matrix is a table, not prose
- [ ] Branch naming documents `model/type-short-description` as primary format
- [ ] Boundaries section has ALWAYS / ASK FIRST / NEVER sub-sections
- [ ] File is under 300 lines (Source B: "The Compass is short — if it becomes long, it is doing the wrong job" — same principle applies to AGENTS.md)

**Verification:** Open the file and confirm each section heading exists and contains substantive content (not just placeholders for sections that should have defaults).

**Stop Condition:** None — this increment is safe to complete fully.

---

### Increment 2 — Create CLAUDE.md (Adapter → AGENTS.md)

**Objective:** Create the Claude Code bridging file at `/template/CLAUDE.md` that points to AGENTS.md and adds Claude-specific command references (Source A: G06).

**File:** `/template/CLAUDE.md`

**Required content:**

1. Opening directive: `Strictly follow the rules in ./AGENTS.md for all project conventions, routing, commands, and boundaries.`
2. **`## Claude-Specific Commands`** — List of all Claude slash commands (by phase) that will exist in `.claude/commands/`. For now, list them as planned with a note that they will be created in later increments:
    - `/compass` — Phase 2 interview
    - `/define-features` — Phase 3 feature definition
    - `/scaffold` — Phase 4 project scaffolding
    - `/fine-tune` — Phase 5 plan refinement
    - `/implement` — Phase 6 coding
    - `/test` — Phase 7 testing
    - `/bug` — Bug Track
    - `/maintain` — Phase 8 maintenance
    - `/continue` — Session resumption
3. **`## Precedence`** — State: _"If any instruction in this file conflicts with AGENTS.md, AGENTS.md takes precedence."_

**Acceptance Criteria:**

- [ ] `/template/CLAUDE.md` exists
- [ ] First line references `./AGENTS.md`
- [ ] All 9 planned Claude commands are listed
- [ ] Precedence section explicitly defers to AGENTS.md

**Verification:** Grep for `AGENTS.md` in the file — must appear at least twice (directive + precedence).

**Stop Condition:** None.

---

### Increment 3 — Update Existing Adapter Files to Link to AGENTS.md

**Objective:** Modify `/template/.github/copilot-instructions.md` and `/template/.codex/AGENTS.md` so they defer to the root `AGENTS.md`.

**File changes:**

**A) `/template/.github/copilot-instructions.md`**

- Add at the top (before any existing content): `> **Routing & conventions:** Follow the rules in ../AGENTS.md. If any instruction below conflicts with AGENTS.md, AGENTS.md takes precedence.`
- Do NOT delete existing content — only prepend the linkage directive.

**B) `/template/.codex/AGENTS.md`**

- Add at the top: `> **This file is scoped to Codex. For universal routing, conventions, and workflow phases, see ../AGENTS.md. AGENTS.md takes precedence over this file.**`
- Do NOT delete existing content.

**Acceptance Criteria:**

- [ ] Both files contain a linkage directive pointing to `../AGENTS.md` (relative path)
- [ ] Both files contain a precedence statement favoring root AGENTS.md
- [ ] No existing content was deleted from either file

**Verification:** Grep both files for `AGENTS.md` — each must contain the reference. Diff against prior version to confirm no deletions.

**Stop Condition:** If either file does not exist (unexpected based on Source C), STOP and ask the user.

---

### Increment 4 — Create `.specify/` Directory and Templates

**Objective:** Create the specification infrastructure that the Compass (Phase 2) and Define Features (Phase 3) phases will populate (Source A: G02, G03, G07).

**Files to create under `/template/.specify/`:**

**A) `constitution.md`** (Compass output target — Source B Phase 2)

- This is a **template**, not a filled document. It will be populated during Phase 2 (Compass).
- Sections (all with `[PROJECT-SPECIFIC]` placeholders):
    1. `## Problem Statement` — What problem this project solves and for whom
    2. `## Target User` — Who this is for
    3. `## Definition of Success` — What success looks like
    4. `## Core Capabilities` — What the project does (mapped from Compass)
    5. `## Out-of-Scope Boundaries` — What the project deliberately refuses to become
    6. `## Inviolable Principles` — Non-negotiable principles under pressure
    7. `## Security Requirements` — Baseline security constraints
    8. `## Testing Requirements` — TDD policy and coverage expectations
- Add a header comment: `<!-- This file is generated during Phase 2 (Compass). It is read-only during normal workflow. Edit only via /compass-edit or equivalent. -->`

**B) `spec-template.md`** (Feature spec template — Source A §4 P0)

- Sections:
    1. `# Feature Specification: [TITLE]`
    2. `## What and Why` — 2-3 sentences
    3. `## User Stories` — Prioritized list
    4. `## Acceptance Criteria` — Hybrid EARS + Given-When-Then format, each with a `Verification` command and checkbox
    5. `## Non-Goals` — Explicitly out of scope
    6. `## Constraints` — Performance, security, compatibility
    7. `## Technical Approach` — Filled during Phase 4 (Scaffold Project)
    8. `## Task Breakdown` — Filled during Phase 5 (Fine-tune Plan), each task with model assignment and branch name
    9. `## Model Assignment` — Table mapping each task to a model per the routing rules in AGENTS.md

**C) `acceptance-criteria-template.md`** (Standalone AC reference — Source A: G03)

- Show the EARS format: `When [trigger], the system shall [response]`
- Show the GWT format: `Given [context], when [action], then [outcome]`
- Show the verification pattern: `Verification: [INSERT COMMAND] passes`
- Show machine-parseable checkbox format: `- [ ] AC-N: [name] — Verified`

**Acceptance Criteria:**

- [ ] `/template/.specify/` directory exists with three files
- [ ] `constitution.md` contains all 8 sections with `[PROJECT-SPECIFIC]` placeholders
- [ ] `constitution.md` has the read-only header comment
- [ ] `spec-template.md` contains all 9 sections including Model Assignment
- [ ] `acceptance-criteria-template.md` shows both EARS and GWT formats
- [ ] No implementation details appear in any of these files (they are templates/scaffolds)

**Verification:** List the directory and check each file has the expected heading structure.

**Stop Condition:** None.

---

### Increment 5 — Create Phase 2 (Compass) Commands

**Objective:** Create the interview-style Compass command for Claude and the equivalent Copilot prompt (Source A: G01; Source B: Phase 2).

**Files:**

**A) `/template/.claude/commands/compass.md`**

- Frontmatter: `description: Conduct the Compass interview to establish project identity`, `allowed-tools: Read, Bash(find:*), Bash(grep:*)`
- Body implements Source B Phase 2 behavior:
    - Adaptive interview (not scripted checklist), following the thread of answers
    - Questions target: problem and audience, definition of success, what the project will NOT do, non-negotiable principles
    - Interview ends when the agent can articulate the project identity back and the developer confirms
    - On confirmation: generate `.specify/constitution.md` from the template, filling all sections
    - Also populate the `## Overview` section of `AGENTS.md` with a one-paragraph project description
- Must reference: _"The Compass is read-only after creation. To edit, use /compass-edit."_

**B) `/template/.claude/commands/compass-edit.md`**

- Frontmatter: `description: Enter edit mode for the Compass (constitution.md)`
- Body: Read current constitution, present proposed changes, require developer approval before writing. State: _"This is the only way to modify the Compass during normal workflow."_

**C) `/prompts/compass.prompt.md`**

- Copilot-equivalent of the Claude compass command
- Same interview protocol, same output target (`.specify/constitution.md`)
- Adapt syntax for Copilot `.prompt.md` format

**Acceptance Criteria:**

- [ ] `/template/.claude/commands/compass.md` exists with adaptive interview protocol
- [ ] Interview covers: problem/audience, success definition, out-of-scope, principles (per Source B Phase 2)
- [ ] Output targets `.specify/constitution.md` AND the Overview section of `AGENTS.md`
- [ ] `/template/.claude/commands/compass-edit.md` exists with approval-gated editing
- [ ] `/prompts/compass.prompt.md` exists as Copilot equivalent
- [ ] No implementation details (code, libraries, folders) are solicited during the Compass interview

**Verification:** Read each file and confirm the interview questions target identity/purpose (not implementation). Confirm output targets are specified.

**Stop Condition:** None.

---

### Increment 6 — Create Phase 3 (Define Features) Commands

**Objective:** Create commands for the feature definition phase (Source B: Phase 3).

**Files:**

**A) `/template/.claude/commands/define-features.md`**

- Frontmatter: `description: Translate the Compass into a concrete feature set and design principles`
- Body implements Source B Phase 3:
    - Adaptive interview (not a form), responding to developer answers
    - Surfaces macro-level features, identifies which Compass capabilities each serves
    - Establishes design principles for how features behave and relate
    - Any feature that cannot trace to the Compass is flagged for deferral or Compass reconsideration
    - Output: named features with descriptions, design principles, Compass mapping, in-scope vs deferred flags
    - Output is written to `.specify/spec-template.md` (as a concrete spec, not the template itself) — or to a new `.specify/features.md` if multiple features
    - Iterative: multiple passes expected
- Must state: _"No implementation details in this phase — no libraries, no folder structures, no code."_

**B) `/prompts/define-features.prompt.md`**

- Copilot equivalent

**Acceptance Criteria:**

- [ ] Claude command exists with adaptive interview protocol
- [ ] Features are mapped to Compass capabilities
- [ ] Unmapped features trigger explicit deferral or Compass reconsideration
- [ ] Output format includes: feature name, description, Compass mapping, scope flag
- [ ] No implementation details are produced
- [ ] Copilot prompt equivalent exists

**Verification:** Read the command file; confirm it references `.specify/constitution.md` as input and produces feature specs as output.

**Stop Condition:** None.

---

### Increment 7 — Create Phase 4 (Scaffold Project) and Phase 5 (Fine-tune Plan) Commands

**Objective:** Create commands for technical scaffolding and plan finalization (Source B: Phases 4–5).

**Files:**

**A) `/template/.claude/commands/scaffold.md`** (Phase 4)

- Takes Phase 3 output, reasons about: folder/module structure, dependencies, install steps, target environments, API surfaces, data models, and **gaps/unknowns**
- Gaps are listed explicitly — not silently skipped
- Output: proposed structure, dependency list, install steps, environment declarations, unresolved questions
- Must state: _"This phase does not write code or create files — it produces a plan."_
- Iterative: multiple passes expected

**B) `/template/.claude/commands/fine-tune.md`** (Phase 5)

- Takes Phase 3 + Phase 4 output
- Produces: ordered feature specs, each with description, acceptance criteria, scope boundaries, assigned model (from AGENTS.md routing matrix), branch name (`model/type-short-description`)
- Creates branches in the repository
- **Second model review:** Instruct that each spec should be reviewed by a second model for errors/omissions before finalization (Source B Phase 5). In practice: the command should output specs and instruct the developer to have a second agent review them, or flag this as a manual step.
- Output format per spec: name, description, acceptance criteria (EARS+GWT), scope, model assignment, branch name

**C) `/prompts/scaffold.prompt.md`** and **`/prompts/fine-tune.prompt.md`**

- Copilot equivalents

**Acceptance Criteria:**

- [ ] Phase 4 command produces plans, not code
- [ ] Phase 4 command explicitly surfaces unresolved questions
- [ ] Phase 5 command produces ordered specs with model assignments and branch names
- [ ] Branch names follow `model/type-short-description` format
- [ ] Phase 5 references AGENTS.md routing matrix for model assignment
- [ ] Second-model review step is documented (even if manual)
- [ ] Both Copilot prompt equivalents exist

**Verification:** Read each command; confirm Phase 4 produces no code and Phase 5 produces specs with branch names.

**Stop Condition:** If the routing matrix in AGENTS.md (from Increment 1) needs refinement based on what these commands require, update AGENTS.md first and note the change.

---

### Increment 8 — Create Phase 6 (Code) and Phase 7 (Test) Commands

**Objective:** Create commands for implementation and testing (Source B: Phases 6–7; Source A: G08, G09, G10).

**Files:**

**A) `/template/.claude/commands/implement.md`** (Phase 6)

- Developer is in the coding tool matching the branch prefix
- References the spec for that branch as the source of intent
- References the Compass (constitution) for alignment
- Follows TDD: tests written before or alongside implementation
- If a decision arises not covered by spec, spec is updated BEFORE the decision is made
- Bugs discovered during coding are logged via `/bug`, not resolved inline unless small

**B) `/template/.claude/commands/test.md`** (Phase 7)

- Runs tests against acceptance criteria from the spec
- Logs anything that doesn't pass as a bug entry
- UI issues logged as behavioral descriptions
- Small bugs: fix in place. Large bugs: log to backlog.
- Test file naming: `[PROJECT-SPECIFIC]` (e.g., `*.test.ts` adjacent to source)
- Preferred UI testing: Puppeteer or equivalent (per Source B Phase 7)
- Output: test results, bug log entries, updated spec if behavior deviated

**C) `/template/.claude/commands/bug.md`** (Bug Track)

- Lightweight invocation from any phase (`/bug` or `:bug`)
- Captures: description, location, phase discovered, severity (blocking/non-blocking), expected vs actual, fix-as-you-go flag
- Appends to a structured bug log file (e.g., `.specify/bugs.md` or `[PROJECT-SPECIFIC]`)
- Never interrupts current task
- Backlog review cycle: bugs treated as specs (branch + model assignment when picked up)

**D) `/template/.claude/commands/bugfix.md`** (Source A: G09)

- Structured loop: read bug → reproduce (create failing test) → diagnose → fix → verify (re-run test) → verify no regressions (full suite) → PR with reproduction test

**E) Copilot equivalents:** `/prompts/implement.prompt.md`, `/prompts/test.prompt.md`, `/prompts/bug.prompt.md`

**Acceptance Criteria:**

- [ ] Phase 6 command enforces TDD and spec-first development
- [ ] Phase 6 command states: update spec before making unplanned decisions
- [ ] Phase 7 command tests against spec acceptance criteria
- [ ] Phase 7 command logs all failures as bugs (never silently skips)
- [ ] Bug command is lightweight and appends to a structured log
- [ ] Bugfix command follows reproduce → fix → verify loop
- [ ] All Copilot equivalents exist

**Verification:** Read each command. Confirm Phase 6 references spec and Compass. Confirm Phase 7 produces bug log entries. Confirm bug command does not interrupt workflow.

**Stop Condition:** None.

---

### Increment 9 — Create Phase 8 (Maintain) and Session Continuity Commands

**Objective:** Create maintenance and continuation commands (Source B: Phase 8; Source A: G17).

**Files:**

**A) `/template/.claude/commands/maintain.md`** (Phase 8)

- Two modes per Source B:
    - **Initial pass** (manual trigger after feature ships): produces/updates README, CONTRIBUTING guide, workflow diagram, release notes, security baseline
    - **Ongoing pass** (references GitHub Actions): checks folder structure, documentation, and standards compliance. Makes small corrections automatically, opens issues for anything requiring human judgment.
- References the standards defined during the initial pass as enforceable rules
- Output: standardized docs, compliance report, change log

**B) `/template/.claude/commands/continue.md`** (Session resumption — Source A: G17)

- Reads current branch, spec, test results, and bug log
- Summarizes where the session left off
- Resumes work on the current task or advances to the next phase

**C) Copilot equivalents:** `/prompts/maintain.prompt.md`

**Acceptance Criteria:**

- [ ] Maintain command has both initial and ongoing modes
- [ ] Initial mode produces: README, CONTRIBUTING, workflow diagram, release notes, security baseline
- [ ] Ongoing mode makes corrections and logs changes
- [ ] Continue command reads branch/spec/test state and resumes
- [ ] Copilot equivalent exists for maintain

**Verification:** Read each command; confirm maintain has two explicit modes and continue reads project state.

**Stop Condition:** None.

---

### Increment 10 — Create Review Infrastructure

**Objective:** Create the review rubric and extend the PR template (Source A: G11, G12).

**Files:**

**A) `/template/.github/REVIEW_RUBRIC.md`**

- Scored rubric with categories: Correctness (satisfies spec?), Test Coverage (ACs tested?), Security (no new vulnerabilities?), Performance (no regressions?), Style (follows AGENTS.md conventions?), Documentation (updated where needed?)
- Each category: Pass / Fail with required evidence description

**B) Extend `/template/.github/pull_request_template.md`**

- Add mandatory sections (do not remove existing content):
    - `## Spec Reference` — Link to the `.specify/spec.md` or feature spec used
    - `## Acceptance Criteria Checklist` — Checkboxes mapping 1:1 to spec ACs
    - `## Test Evidence` — Which tests verify which criteria
    - `## Agent / Model Used` — Which tool produced this PR and the branch name
    - `## Bug Log` — Any bugs discovered during this work

**C) `/template/.github/agents/planner.agent.md`** (Copilot custom agent — Source A: G21)

- Planning specialist: reads feature description, checks constitution, generates/updates spec
- Never writes implementation code

**D) `/template/.github/agents/reviewer.agent.md`** (Copilot custom agent — Source A: G21)

- Review specialist: reads spec, verifies each AC, checks conventions from AGENTS.md, scores against rubric

**Acceptance Criteria:**

- [ ] Review rubric file exists with 6 scored categories
- [ ] PR template has 5 new mandatory sections
- [ ] No existing PR template content was deleted
- [ ] Planner agent file exists and explicitly prohibits writing code
- [ ] Reviewer agent file exists and references both spec and rubric

**Verification:** Read each file; confirm rubric has categories, PR template has new sections, agents have correct constraints.

**Stop Condition:** None.

---

### Increment 11 — Create Claude Hooks Configuration

**Objective:** Add hook-based enforcement for Claude Code sessions (Source A: G19).

**File:** `/template/.claude/settings.json`

**Required hooks:**

1. **PostToolUse** (matcher: `Write|Edit|MultiEdit`): Auto-format with prettier (or `[PROJECT-SPECIFIC]` formatter). Timeout: 15s. Fail silently.
2. **PreToolUse** (matcher: `Write|Edit`): Block edits to protected paths (`.env`, `.git/`, `node_modules/`, `AGENTS.md`, `CLAUDE.md`, `.specify/constitution.md`). Exit code 2 to block.
3. **Stop**: Reminder to run tests before committing.

**Acceptance Criteria:**

- [ ] `/template/.claude/settings.json` exists and is valid JSON
- [ ] PostToolUse hook runs formatter on file writes
- [ ] PreToolUse hook blocks edits to protected files
- [ ] Stop hook reminds about test execution
- [ ] Protected file list includes AGENTS.md, CLAUDE.md, and constitution.md

**Verification:** Parse the JSON and confirm hook structure. Ensure protected paths are listed.

**Stop Condition:** None.

---

### Increment 12 — Create CI Workflows

**Objective:** Add spec-gating CI check and auto-fix workflow (Source A: G14, G16).

**Files:**

**A) Extend existing CI workflow** (or create `/template/.github/workflows/ci.yml` if none exists)

- Add a job/step that checks for `.specify/spec.md` (or equivalent spec file) presence before allowing merge
- This enforces: no code merges without a specification

**B) `/template/.github/workflows/autofix.yml`** (Source A: G16)

- Triggers on CI failure (`workflow_run` with `completed` + failure condition)
- Uses `anthropics/claude-code-action@v1` (or `[CHOOSE OPTION]` for Codex equivalent)
- Prompt: read failing logs, identify minimal fix, implement, verify tests pass
- Creates a PR with the fix
- Concurrency group per branch to prevent duplicate fix attempts

**Acceptance Criteria:**

- [ ] CI workflow includes a spec-existence check
- [ ] Autofix workflow triggers only on CI failure
- [ ] Autofix uses an agent action (Claude Code Action or equivalent)
- [ ] Autofix creates a PR (does not push directly to the branch)
- [ ] Concurrency prevents duplicate autofix runs on the same branch

**Verification:** Read both workflow files; confirm trigger conditions, spec check, and PR creation step.

**Stop Condition:** If the existing CI workflow structure is unclear, STOP and ask the user for their preferred CI configuration.

---

### Increment 13 — Update Meta-Prompts to Reference 8-Phase Model

**Objective:** Align the existing meta-prompts (`initialization.md`, `update.md`, `major/`, `minor/`) with the 8-phase workflow from Source B.

**File changes:**

**A) `/meta-prompts/initialization.md`**

- After scaffold import (Phase 1), the prompt should automatically initiate the Compass interview (Phase 2) — per Source B: _"import and Compass creation are a single continuous action"_
- Reference the new command: `/compass` (Claude) or the equivalent Copilot prompt
- Ensure it documents the full 8-phase lifecycle for the developer's awareness

**B) `/meta-prompts/update.md`**

- Add awareness of new files (`.specify/`, `AGENTS.md`, `CLAUDE.md`, review rubric, hooks)
- Ensure updates check for version differences before overwriting (Source B Phase 1 rule)

**C) `/meta-prompts/minor/*.md`**

- Each minor prompt should map to one of the 8 phases. If existing minor prompts use different phase names, rename or create new ones to match:
    - `01-scaffold-import.md` (Phase 1)
    - `02-compass.md` (Phase 2)
    - `03-define-features.md` (Phase 3)
    - `04-scaffold-project.md` (Phase 4)
    - `05-fine-tune-plan.md` (Phase 5)
    - `06-code.md` (Phase 6)
    - `07-test-and-bugs.md` (Phase 7)
    - `08-maintain.md` (Phase 8)
- Do NOT delete existing minor prompts if they contain valuable content — merge content into the new structure

**D) `/meta-prompts/major/*.md`**

- Update consolidated prompts to reference the 8-phase sequence
- Ensure they reference AGENTS.md as the routing source

**Acceptance Criteria:**

- [ ] `initialization.md` triggers Compass interview after scaffold import
- [ ] `update.md` handles new files (`.specify/`, `AGENTS.md`, etc.)
- [ ] Minor prompts map 1:1 to the 8 phases (or close equivalent)
- [ ] No existing valuable content was deleted (merged into new structure)
- [ ] Major prompts reference the 8-phase model and AGENTS.md

**Verification:** Read each meta-prompt; confirm phase references are correct and initialization flows into Compass.

**Stop Condition:** If existing minor prompt content is complex or unclear, STOP and ask the user how to merge it.

---

### Increment 14 — Add Worktree Support and Prompt Sync Validation

**Objective:** Enable parallel agent work and cross-platform prompt parity (Source A: G18, G22).

**Files:**

**A) `/template/scripts/setup-worktree.sh`**

- Creates a git worktree under `.trees/` with branch naming `model/type-short-description`
- Copies necessary config files (`.claude/`, `.codex/`, `.specify/`)
- Outputs instructions for the agent
- Usage: `./scripts/setup-worktree.sh <model> <type> <description>`

**B) `/meta-prompts/prompt-sync.md`** (update existing)

- Add a validation step: after syncing, diff `.claude/commands/`, `/prompts/`, and `.codex/` to verify parity
- List expected 1:1 mappings between Claude commands and Copilot prompts
- Flag any command that exists in one platform but not the other

**Acceptance Criteria:**

- [ ] Worktree script exists, is executable, and creates `.trees/` directory
- [ ] Script uses the `model/type-short-description` branch format
- [ ] Prompt-sync includes a validation/diff step
- [ ] Prompt-sync lists expected cross-platform mappings

**Verification:** Read the script; confirm branch naming and config file copying. Read prompt-sync; confirm diff step exists.

**Stop Condition:** None.

---

### Increment 15 — Final Validation and Documentation Pass

**Objective:** Verify the entire system is coherent, all links resolve, and documentation reflects the implemented state.

**Actions:**

1. **Link graph check:** Starting from `AGENTS.md`, follow every file reference and confirm the target file exists.
2. **Adapter check:** Confirm `CLAUDE.md`, `.github/copilot-instructions.md`, and `.codex/AGENTS.md` all link to root `AGENTS.md` and defer to it.
3. **Command parity check:** For each Claude command in `.claude/commands/`, confirm a corresponding Copilot prompt exists in `/prompts/`. List any gaps.
4. **Phase coverage check:** Confirm all 8 phases from Source B + Bug Track have: a Claude command, a Copilot prompt, a reference in AGENTS.md Workflow Phases section, and a minor meta-prompt.
5. **Update `/README.md`** (root): Add a section describing the 8-phase workflow and how AGENTS.md orchestrates routing. Reference the workflow diagram.
6. **Update `/workflow-diagram.svg`** (if the tool to do so is available) or create a text-based workflow diagram in AGENTS.md that matches the 8-phase model from Source B.

**Acceptance Criteria:**

- [ ] All file references from AGENTS.md resolve to existing files
- [ ] All three adapter files link to AGENTS.md
- [ ] Every Claude command has a Copilot prompt equivalent
- [ ] All 8 phases + Bug Track are represented in commands, prompts, AGENTS.md, and meta-prompts
- [ ] Root README describes the workflow and references AGENTS.md
- [ ] No orphan files (files that exist but are not referenced from any entry point)

**Verification:** Run the link graph check and command parity check as described above. Report any gaps to the user.

**Stop Condition:** If gaps are found, fix them before marking this increment complete. If a gap requires a design decision, STOP and ask the user.

---

## File Disposition Summary

### Files that STAY unchanged

- `/LICENSE`
- `/workflow-diagram.svg` (updated only if tooling permits in Increment 15)
- `/template/.github/workflows/release-template.yml` (if it exists — do not modify CI for the meta-repo itself)
- `/template/.github/ISSUE_TEMPLATE/*.md` (existing issue templates preserved)
- `/template/.codex/ExecPlan-template.md` (existing, referenced but not modified)

### Files that are MODIFIED

- `/template/.github/copilot-instructions.md` — prepend AGENTS.md linkage (Increment 3)
- `/template/.codex/AGENTS.md` — prepend root AGENTS.md linkage (Increment 3)
- `/template/.github/pull_request_template.md` — extend with spec/AC/evidence sections (Increment 10)
- `/meta-prompts/initialization.md` — update to trigger Compass (Increment 13)
- `/meta-prompts/update.md` — update for new files (Increment 13)
- `/meta-prompts/prompt-sync.md` — add validation step (Increment 14)
- `/meta-prompts/major/*.md` — update to 8-phase model (Increment 13)
- `/meta-prompts/minor/*.md` — restructure to 8-phase model (Increment 13)
- `/README.md` — add workflow description (Increment 15)
- `/Principles for Development Using the Workflow.md` — NOT modified (its content informs `.specify/constitution.md` but the original stays as-is)

### Files that are ADDED

|File|Increment|Source|
|---|---|---|
|`/template/AGENTS.md`|1|G04, G05, Source B all phases|
|`/template/CLAUDE.md`|2|G06|
|`/template/.specify/constitution.md`|4|G07, Source B Phase 2|
|`/template/.specify/spec-template.md`|4|G02|
|`/template/.specify/acceptance-criteria-template.md`|4|G03|
|`/template/.claude/commands/compass.md`|5|G01, Source B Phase 2|
|`/template/.claude/commands/compass-edit.md`|5|Source B Phase 2 edit rule|
|`/prompts/compass.prompt.md`|5|G01 (Copilot parity)|
|`/template/.claude/commands/define-features.md`|6|Source B Phase 3|
|`/prompts/define-features.prompt.md`|6|Copilot parity|
|`/template/.claude/commands/scaffold.md`|7|Source B Phase 4|
|`/template/.claude/commands/fine-tune.md`|7|Source B Phase 5|
|`/prompts/scaffold.prompt.md`|7|Copilot parity|
|`/prompts/fine-tune.prompt.md`|7|Copilot parity|
|`/template/.claude/commands/implement.md`|8|Source B Phase 6|
|`/template/.claude/commands/test.md`|8|G08, Source B Phase 7|
|`/template/.claude/commands/bug.md`|8|Source B Bug Track|
|`/template/.claude/commands/bugfix.md`|8|G09|
|`/prompts/implement.prompt.md`|8|Copilot parity|
|`/prompts/test.prompt.md`|8|Copilot parity|
|`/prompts/bug.prompt.md`|8|Copilot parity|
|`/template/.claude/commands/maintain.md`|9|Source B Phase 8|
|`/template/.claude/commands/continue.md`|9|G17|
|`/prompts/maintain.prompt.md`|9|Copilot parity|
|`/template/.github/REVIEW_RUBRIC.md`|10|G11|
|`/template/.github/agents/planner.agent.md`|10|G21|
|`/template/.github/agents/reviewer.agent.md`|10|G21|
|`/template/.claude/settings.json`|11|G19|
|`/template/.github/workflows/autofix.yml`|12|G16|
|`/template/scripts/setup-worktree.sh`|14|G18|

### Files explicitly NOT created (deferred / P2)

- Phase registry pattern (`/template/.workflow/phases/`) — Source A: G20, P2. Deferred until the 8-phase model stabilizes.
- Continuation workflow (`/template/.github/workflows/continuation.yml`) — Source A: G17 partial, P2. Requires organizational decisions about scheduled runners.
- Auto-merge policy document — Source A: G15, P2. Requires CI gates and review rubric to be in place first (created in Increments 10–12, policy document deferred).
- Copilot skills directories (`.github/skills/`) — Source A, P2. Depends on agent definitions stabilizing.

---

## Cross-Reference: Source B Phases → Increments

|Source B Phase|Increment(s)|Key Files|
|---|---|---|
|Phase 1 — Scaffold Import|0, 13|`initialization.md`, `update.md`|
|Phase 2 — Compass|4, 5|`constitution.md`, `compass.md`, `compass-edit.md`|
|Phase 3 — Define Features|4, 6|`spec-template.md`, `define-features.md`|
|Phase 4 — Scaffold Project|7|`scaffold.md`|
|Phase 5 — Fine-tune Plan|7|`fine-tune.md`|
|Phase 6 — Code|8|`implement.md`|
|Phase 7 — Test / Mark Changes|8, 10|`test.md`, `REVIEW_RUBRIC.md`, PR template|
|Phase 8 — Maintain|9, 12|`maintain.md`, `autofix.yml`|
|Bug Track|8|`bug.md`, `bugfix.md`|

## Cross-Reference: Source A Gaps → Increments

|Gap ID|Increment|Status|
|---|---|---|
|G01 (Interview)|5, 6|Covered by compass + define-features commands|
|G02 (Spec template)|4|Covered by spec-template.md|
|G03 (AC format)|4|Covered by acceptance-criteria-template.md|
|G04 (Routing)|1|Covered by AGENTS.md routing matrix|
|G05 (Root AGENTS.md)|1|Covered by /template/AGENTS.md|
|G06 (CLAUDE.md)|2|Covered by /template/CLAUDE.md|
|G07 (Constitution)|4|Covered by constitution.md|
|G08 (Test-first)|8, 11|Covered by test.md + hooks|
|G09 (Bug reproduction)|8|Covered by bugfix.md|
|G10 (Fix validation)|11, 12|Covered by hooks + autofix.yml|
|G11 (Review rubric)|10|Covered by REVIEW_RUBRIC.md|
|G12 (PR evidence)|10|Covered by PR template extension|
|G13 (Branch strategy)|1|Covered in AGENTS.md Branch Naming|
|G14 (CI spec gating)|12|Covered by CI spec-existence check|
|G15 (Auto-merge)|Deferred|P2 — requires stable CI gates first|
|G16 (CI auto-fix)|12|Covered by autofix.yml|
|G17 (Continuation)|9 (partial)|continue.md created; scheduled workflow deferred|
|G18 (Worktrees)|14|Covered by setup-worktree.sh|
|G19 (Hooks)|11|Covered by settings.json|
|G20 (Phase modularity)|Deferred|P2 — phase registry pattern deferred|
|G21 (Copilot agents)|10|Covered by planner + reviewer agents|
|G22 (Prompt sync)|14|Covered by prompt-sync.md update|