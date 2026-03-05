# Agent Workflow Scaffold

Drop-in scaffold for agent-driven development with Claude, Copilot, and Codex. Implements an **8-phase agentic workflow** where agents interview you to define the goal, then build it autonomously.

> **Start here:** Read this README, then [AGENTS.md](template/AGENTS.md), then browse the [example project](examples/sample-project/) to see what "done" looks like.

![Feature Lifecycle](workflow-diagram.svg)

## Prerequisites

| Requirement | Required? | Notes |
|-------------|-----------|-------|
| **Git** | Yes | Any recent version |
| **Claude Code** or **GitHub Copilot Chat** | At least one | Claude Code for `/commands`, Copilot for `.prompt.md` files |
| **OpenAI Codex** | Optional | For batch/unattended execution |
| **VS Code** (or Cursor) | Recommended | For Copilot prompt integration |

You do **not** need all three AI platforms. Pick the one(s) you use:
- **Claude Code only:** Use `/commands` (e.g., `/compass`, `/implement`, `/continue`)
- **Copilot only:** Use `.prompt.md` files (copy to your VS Code prompts directory)
- **Both + Codex:** Full multi-agent routing with parallel worktrees

## Quick start

### Path A: Fastest first success (recommended)

```bash
# From the scaffold repo root:
./scripts/install.sh --with-meta-prompts /path/to/your/project

# If you want Copilot slash prompts too:
./scripts/install.sh --with-meta-prompts --with-prompts /path/to/your/project
```

Then in your target project root:
1. Run `meta-prompts/initialization.md` if present, otherwise run `/compass`
2. Run `/define-features`, `/scaffold`, `/fine-tune`
3. Run `/continue` to execute `test pre -> implement -> test post -> review/ship`

See [quickstart-first-success](docs/quickstart-first-success.md) for the complete 15-minute path.

### Path B: Manual setup

1. Download a release ZIP (`scaffold-template.zip`, `scaffold-metaprompts.zip`, or `scaffold-full.zip`)
2. Extract into your project root
3. (Optional) Copy `prompts/*.prompt.md` to your [VS Code prompts directory](#command-installation-paths)
4. If `meta-prompts/` exists, run `meta-prompts/initialization.md`; otherwise start with `/compass`

### GitHub template option

Use the "Use this template" button on GitHub, then remove files you do not need.

> `/continue` is the primary command. It detects your current phase, executes it, and auto-advances to the next. It pauses at stop gates (Compass interview, plan approval, blocking bugs) and tells you what input is needed.

For updates to an existing scaffold: Run [`meta-prompts/update.md`](meta-prompts/update.md).

## How to run a meta-prompt

Meta-prompts are instruction files that you feed to an AI agent. They are **not** scripts.

| Platform | How to run |
|----------|-----------|
| **Claude Code** | Open a session at your project root. Paste the meta-prompt contents into the chat, or reference the file with `@meta-prompts/initialization.md` |
| **Copilot Chat** | Use the corresponding `.prompt.md` file as a slash command (e.g., type `/initialization` in Copilot Chat) |
| **Codex** | Reference the file in your Codex plan or paste contents into the Codex prompt |

After initialization, you won't need meta-prompts again — use slash commands (`/compass`, `/implement`, `/continue`, etc.) instead.

## How it works

Everything traces back to the **project constitution**. The Compass interview produces a `constitution.md` that defines exactly what gets built. Every feature spec cites a constitution capability. Every task cites an acceptance criterion. Every PR cites a test. Agents can't invent features — if it isn't in the constitution, it isn't in scope.

### How artifacts connect

```
Constitution          defines WHAT the project is
    |
    v
Feature Specs         define HOW TO VERIFY each capability (acceptance criteria)
    |
    v
Task Files            define WHAT TO BUILD (ordered, model-assigned tasks)
    |
    v
PRs                   prove THAT IT WORKS (test evidence per criterion)
    |
    v
Decisions             record WHY non-obvious choices were made
```

Artifact contracts enforce this chain: a spec without a task file is invalid, a criterion without a test is invalid, a PR without verification evidence is invalid. See [FILE_CONTRACTS.md](template/workflow/FILE_CONTRACTS.md).

### Autonomous loop

The `/continue` command reads `workflow/ORCHESTRATOR.md` (the loop contract) and `workflow/STATE.json` (current state), then executes the current phase and auto-advances to the next. It loops automatically through phases, pausing only at stop gates: Compass interview, plan approval, blocking bugs, or merge approval.

For a single-invocation full build, use `/continue` — it runs the entire lifecycle from the current phase through shipping.

## The 8-phase workflow

```
1. SCAFFOLD IMPORT   -> Place files in project (initialization.md)
2. COMPASS           -> Adaptive interview -> constitution.md
3. DEFINE FEATURES   -> Map features to constitution capabilities
4. SCAFFOLD PROJECT  -> Reason about architecture (no code)
5. FINE-TUNE PLAN    -> Ordered specs with ACs, model assignments, branches
6. CODE              -> TDD implementation from spec
7. TEST              -> Verify against acceptance criteria, log bugs
   7b. REVIEW & SHIP -> Review, cross-review, PR, merge (per feature)
8. MAINTAIN          -> Documentation, compliance, release notes
   BUG TRACK         -> Parallel bug capture from any phase
```

**Phases 2-3** require developer interviews. **Phases 4-5** require architecture decisions and plan approval. **Phases 6-8** run autonomously once the plan is approved — use `/continue` to auto-advance through phases until a stop gate is reached.

Use `/continue` and it will invoke the right commands at the right time — you don't need to memorize the phase sequence.

## Platform support

| Feature | Claude Code | Copilot | Codex |
|---------|-------------|---------|-------|
| Compass interview (Phase 2) | `/compass` | `compass.prompt.md` | Manual |
| Feature definition (Phase 3) | `/define-features` | `define-features.prompt.md` | Manual |
| Architecture planning (Phase 4) | `/scaffold` | `scaffold.prompt.md` | Manual |
| Plan fine-tuning (Phase 5) | `/fine-tune` | `fine-tune.prompt.md` | Manual |
| TDD implementation (Phase 6) | `/implement` | `implement.prompt.md` | Via ExecPlan |
| Test verification (Phase 7) | `/test` | `test.prompt.md` | Via ExecPlan |
| Review & PR (Phase 7b) | `/review-session` | `review-session.prompt.md` | — |
| Maintenance (Phase 8) | `/maintain` | `maintain.prompt.md` | — |
| Auto-advance orchestration | `/continue` | `continue.prompt.md` | — |
| Bug tracking | `/bug`, `/bugfix` | `bug.prompt.md` | — |
| CI auto-fix on failure | — | — | `autofix.yml` |

## How routing works

`AGENTS.md` is the universal entrypoint read by every agent. It defines:
- Which phase you're in and what to do next
- Where orchestration state is stored (`workflow/STATE.json`)
- Which model handles which task (Claude for reasoning, Copilot for UI, Codex for batch)
- Branch naming: `model/type-short-description`
- Boundaries: what's allowed, what needs approval, what's forbidden

Adapters (`CLAUDE.md`, `.github/copilot-instructions.md`, `.codex/AGENTS.md`) point back to `AGENTS.md` and translate commands for each platform. Adapters never redefine policy — `AGENTS.md` is always authoritative.

## What this gives you

- `AGENTS.md` as the canonical routing file
- `.specify/` templates: constitution, spec, and acceptance criteria
- Workflow + governance docs for execution and policy
- Templates for specs, tasks, and decisions
- Tool adapters for Claude, Copilot, and Codex
- Claude hooks (format, protect, test reminder)
- Review rubric and extended PR template
- `.aiignore` configured for the project
- CI workflows installed and configured (see below)
- Issue and PR templates in place
- Agent definition files (implementer, reviewer) available

## CI Workflows

Five CI workflows are included in `.github/workflows/`:

| Workflow | Trigger | Purpose |
|----------|---------|--------|
| `copilot-setup-steps.yml` | Used by other workflows | Environment setup for Copilot Coding Agent |
| `copilot-agent.yml` | Issue assigned to `@copilot` | Issue-to-PR automation |
| `claude-review.yml` | PR comment mentioning `@claude` | AI-powered PR review |
| `autofix.yml` | CI failure on push | Automated fix loop (max 3 turns) |
| `agentic-triage.yml` | Scheduled (cron) | Read-only issue triage and labeling |

Claude-based workflows (`claude-review.yml`, `autofix.yml`) require the `ANTHROPIC_API_KEY` repository secret. All workflows that produce code changes require **human approval before merge**.

## After all phases complete

When all features have been built and documented, your project will contain:

- `.specify/constitution.md` — project identity, goals, boundaries (the permanent scope anchor)
- `/specs/[feature-id]-[slug].md` — one spec per feature with acceptance criteria
- `/tasks/[feature-id]-[slug].md` — one task file per feature with completion evidence
- `/decisions/[NNNN]-[slug].md` — architecture decisions made during the build
- `/bugs/LOG.md` — full bug history with fix status
- `AGENTS.md` — fully customized routing hub with your commands and conventions
- `README.md` — generated from the constitution and feature list (by Phase 8)
- `CONTRIBUTING.md` — contributor guide (generated in Phase 8)
- Merged PRs on `main` — one per feature, each with AC evidence

## ZIP choices

| ZIP | Includes |
| --- | --- |
| `scaffold-template.zip` | Template scaffold (`AGENTS.md`, `.claude/`, `.github/`, `.codex/`, and templates) |
| `scaffold-metaprompts.zip` | Copilot `.prompt.md` command files |
| `scaffold-full.zip` | Template scaffold + Copilot prompt files + `meta-prompts/` |

## Scaffold layout

```text
project/
├── AGENTS.md                        ← TOC hub (routing, phases, quick reference)
├── CLAUDE.md                        ← Claude adapter (session rules, commands)
├── .aiignore                        ← Files excluded from AI agents
├── .specify/
│   ├── constitution.md              ← Project identity (Compass output)
│   ├── spec-template.md             ← Feature spec template (EARS/GWT)
│   └── acceptance-criteria-template.md
├── specs/                           ← Per-feature specs
├── tasks/                           ← Per-feature task breakdowns
├── decisions/                       ← Architecture decision records
├── bugs/
│   └── LOG.md                       ← Bug tracking log
├── workflow/
│   ├── LIFECYCLE.md                 ← Phase definitions
│   ├── PLAYBOOK.md                  ← Phase execution gates
│   ├── FILE_CONTRACTS.md            ← Artifact schemas
│   ├── FAILURE_ROUTING.md           ← Error recovery
│   ├── STATE.json                   ← Orchestrator state
│   ├── ORCHESTRATOR.md              ← Autonomous loop contract
│   ├── ROUTING.md                   ← Agent routing, branches, concurrency
│   ├── COMMANDS.md                  ← Build/test/lint commands
│   ├── BOUNDARIES.md                ← ALWAYS/ASK/NEVER rules
│   ├── SPECS.md                     ← Specification workflow + EARS guide
│   └── CONCURRENCY.md              ← Multi-agent safety
├── governance/
│   ├── CHANGE_PROTOCOL.md
│   ├── POLICY_TESTS.md
│   └── REGISTRY.md
├── scripts/
│   ├── policy-check.sh
│   ├── setup-worktree.sh            ← Enhanced with --list, --cleanup
│   └── clash-check.sh               ← Pre-write conflict detection
├── .github/
│   ├── copilot-instructions.md
│   ├── REVIEW_RUBRIC.md
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── ISSUE_TEMPLATE/
│   │   ├── feature.yml
│   │   ├── bug.yml
│   │   └── agent-task.yml
│   ├── agents/
│   │   ├── reviewer.agent.md
│   │   └── implementer.agent.md
│   └── workflows/
│       ├── copilot-setup-steps.yml
│       ├── copilot-agent.yml
│       ├── claude-review.yml
│       ├── autofix.yml
│       └── agentic-triage.yml
├── .claude/
│   ├── settings.json
│   └── commands/                    ← Derived Claude slash commands
└── .codex/
    ├── AGENTS.md
    ├── PLANS.md
    └── config.toml
```

## Command installation paths

- Linux: `~/.config/Code/User/prompts/`
- macOS: `~/Library/Application Support/Code/User/prompts/`
- Windows: `%APPDATA%/Code/User/prompts/`
- WSL2 + Windows VS Code: `/mnt/c/Users/[WindowsUser]/AppData/Roaming/Code/User/prompts/`
- VS Code Insiders: use `Code - Insiders` in the path
- Cursor: use `Cursor` in the path

## Migration notes

If you are updating an existing scaffold:

1. Run `meta-prompts/update.md` from the target project root.
2. Preserve customized files (`AGENTS.md`, `.specify/constitution.md`, `.claude/settings.json`, `.github/workflows/copilot-setup-steps.yml`).
3. Regenerate derived prompt artifacts with `./scripts/sync-prompts.sh`.
4. Verify policy state with `scripts/policy-check.sh` in the target project.

**New in this version:** Running `install.sh` adds new files (`.aiignore`, issue templates, CI workflows, agent definitions, workflow sub-files) without overwriting existing scaffold files unless `--force` is used. Existing `AGENTS.md` content has been decomposed into sub-files under `workflow/`; run `install.sh` to get the new structure.

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues:
- Agent ignoring workflow rules
- Wrong phase detected by `/continue`
- Constitution needs changing mid-build
- Session context pollution
- CI failures and autofix

## Further reading

- [Documentation Index](docs/README.md)
- [Workflow Principles](docs/reference/principles.md)

## Maintainers

### Prompt file architecture

Each command has up to 3 parallel files that must stay in sync:

| Layer | Location | Purpose | Format |
|-------|----------|---------|--------|
| **Meta-prompt** (canonical) | `meta-prompts/minor/*.md` | Source of truth for phase and support-command logic | Markdown |
| **Claude command** (derived) | `template/.claude/commands/*.md` | Claude Code slash command | Plain operational content |
| **Copilot prompt** (derived) | `prompts/*.prompt.md` | VS Code Copilot slash command | YAML frontmatter + operational content |

Meta-prompts are canonical. Claude commands and Copilot prompts are derived. Canonical maintainer path: run `scripts/sync-prompts.sh` (or `--check` in CI). Use [`meta-prompts/prompt-sync.md`](meta-prompts/prompt-sync.md) only as a fallback when script execution is unavailable.

### Major vs minor meta-prompts

- **`meta-prompts/minor/`** — Canonical sources for individual phase commands and support commands.
- **`meta-prompts/major/`** — Session-oriented batch prompts that combine multiple phases into sustained deep-work sessions (plan-session, build-session, review-session). These are convenience wrappers, not canonical sources.
