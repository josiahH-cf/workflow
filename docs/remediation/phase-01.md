# Phase 1: AGENTS.md Decomposition — TOC Hub Architecture

**Status:** done
**Completed:** 2026-03-05
**Depends on:** nothing (foundational phase)
**Estimated files:** ~12 modified or created

## Objective

Transform the monolithic 207-line `template/AGENTS.md` into a compact routing hub (<80 lines) that links to modular sub-files. This is the foundational change — all subsequent phases depend on this new structure.

## Rationale

Frontier LLMs follow ~150–200 instructions reliably; beyond that, compliance degrades exponentially. The current AGENTS.md tries to be comprehensive and navigational simultaneously. Splitting it makes each section independently consumable and deeply detailed without bloating the root file.

## Context Files to Read First

- `template/AGENTS.md` — The current monolithic file (source material for decomposition)
- `template/governance/REGISTRY.md` — Canonical file registry (must be updated)
- `template/workflow/FILE_CONTRACTS.md` — Artifact contracts (must add new files)
- `template/governance/POLICY_TESTS.md` — Validation rules (must add new checks)
- `building-agents-examples.md` — Best practices reference (search for "AGENTS.md" sections)

## Steps

### Step 1: Create `template/workflow/ROUTING.md`

Extract these sections from `template/AGENTS.md` into a new file:
- **Agent Routing Matrix** (the full table)
- **Branch Naming** (format, model/type/description rules, examples)
- **Concurrency Rules** (worktree pattern, max parallel, setup command)

The new file should have a header explaining it's referenced from AGENTS.md and is part of the canonical workflow.

### Step 2: Create `template/workflow/COMMANDS.md`

Extract these sections:
- **Core Commands** (the full Install/Build/Test/Lint/Format/Type-check table with `[PROJECT-SPECIFIC]` placeholders)
- **Code Conventions** (the `[PROJECT-SPECIFIC]` placeholder block)

Add context: "These values are populated during Phase 4 (Scaffold Project). Until then, placeholders remain."

### Step 3: Create `template/workflow/BOUNDARIES.md`

Extract these sections:
- **Boundaries** — ALWAYS, ASK FIRST, NEVER (all three subsections with full bullet lists)
- **Bug Tracking** — The bug format template and triage rules (small vs large bugs, backlog cycle)

### Step 4: Create `template/workflow/SPECS.md`

Extract the **Specification Workflow** section:
- The 5-step workflow (read constitution → check specs → create tasks → write ACs → verify)
- The **Spec artifacts** list (constitution, templates, per-feature specs, task breakdowns, decisions, STATE.json)
- Add a note: "See Phase 5 remediation for EARS/GWT notation enhancement."

### Step 5: Restructure `template/AGENTS.md` as a TOC Hub

Replace the current file with a compact hub. Target: **<80 lines**. Structure:

```markdown
# AGENTS

Canonical entrypoint for all coding agents. Read this first, then follow links to detailed references.

## Overview

`[PROJECT-SPECIFIC]` — Filled during Compass phase (Phase 2).

## Workflow Phases

[KEEP the full phase table — this is the primary navigation aid. Keep the same format with Purpose/Entry/Gate/Output/Next for each phase, BUT condense each phase to 2-3 lines max instead of 4-5. Remove the V1 explanation paragraph and the `/test` modes note — those belong in the linked files.]

## Quick Reference

| Section | Reference |
|---------|-----------|
| Agent routing, branches, concurrency | `workflow/ROUTING.md` |
| Build/test/lint commands, code conventions | `workflow/COMMANDS.md` |
| Boundaries (always/ask/never), bug tracking | `workflow/BOUNDARIES.md` |
| Specification workflow, artifact paths | `workflow/SPECS.md` |
| Lifecycle phases (detailed) | `workflow/LIFECYCLE.md` |
| Phase execution gates | `workflow/PLAYBOOK.md` |
| Artifact ownership & contracts | `workflow/FILE_CONTRACTS.md` |
| Failure routing & escalation | `workflow/FAILURE_ROUTING.md` |
| Policy changes | `governance/CHANGE_PROTOCOL.md` |
| Policy validation | `governance/POLICY_TESTS.md` |
| File registry | `governance/REGISTRY.md` |
| Orchestrator state | `workflow/STATE.json` |
```

**Critical:** The Workflow Phases section must stay in AGENTS.md (it's the primary routing table). Only extract the non-phase sections into sub-files.

### Step 6: Update `template/CLAUDE.md`

Scan for any references to sections that moved. Update references:
- If it references "Concurrency Rules" or "Branch Naming" → point to `workflow/ROUTING.md`
- If it references "Core Commands" → point to `workflow/COMMANDS.md`
- If it references "Boundaries" → point to `workflow/BOUNDARIES.md`
- If it references "Specification Workflow" → point to `workflow/SPECS.md`

### Step 7: Update `template/.codex/AGENTS.md`

Same reference updates as Step 6, scoped to the Codex adapter file.

### Step 8: Update `template/governance/REGISTRY.md`

Add new canonical files to the registry:

```markdown
| `/workflow/ROUTING.md` | Agent routing, branch naming, concurrency | Human maintainer |
| `/workflow/COMMANDS.md` | Build/test/lint commands, code conventions | Human maintainer |
| `/workflow/BOUNDARIES.md` | Behavioral boundaries, bug tracking format | Human maintainer |
| `/workflow/SPECS.md` | Specification workflow, artifact paths | Human maintainer |
```

### Step 9: Update `template/workflow/FILE_CONTRACTS.md`

Add contracts for the 4 new files. They are reference documents (not execution artifacts), so contracts are lightweight:

| Artifact | Owner | Updated When | Required Fields | Validation Signal |
|----------|-------|-------------|-----------------|-------------------|
| `workflow/ROUTING.md` | Human maintainer | Agent model changes | Routing matrix, branch format, concurrency rules | Tables present and non-empty |
| `workflow/COMMANDS.md` | Human maintainer | Phase 4+ | Command table, conventions | No placeholder after Phase 5 |
| `workflow/BOUNDARIES.md` | Human maintainer | Policy changes | ALWAYS/ASK/NEVER sections | All three sections present |
| `workflow/SPECS.md` | Human maintainer | Template changes | Workflow steps, artifact list | Artifact paths resolve |

### Step 10: Update `template/governance/POLICY_TESTS.md`

Add validation rules:
- "AGENTS.md links resolve" — Every markdown link in AGENTS.md points to an existing file
- "Modular workflow files present" — ROUTING.md, COMMANDS.md, BOUNDARIES.md, SPECS.md exist

## Verification Checklist

After completing all steps, verify:

- [ ] `template/AGENTS.md` is <80 lines
- [ ] Every link in `template/AGENTS.md` points to an existing file
- [ ] `template/workflow/ROUTING.md` exists and contains routing matrix + branch naming + concurrency
- [ ] `template/workflow/COMMANDS.md` exists and contains command table + code conventions
- [ ] `template/workflow/BOUNDARIES.md` exists and contains ALWAYS/ASK/NEVER + bug tracking
- [ ] `template/workflow/SPECS.md` exists and contains spec workflow + artifact paths
- [ ] No information was lost — all content from original AGENTS.md exists in sub-files
- [ ] `template/CLAUDE.md` references updated
- [ ] `template/.codex/AGENTS.md` references updated
- [ ] `template/governance/REGISTRY.md` lists all 4 new files
- [ ] `template/workflow/FILE_CONTRACTS.md` has contracts for 4 new files
- [ ] `template/governance/POLICY_TESTS.md` has new validation rules
- [ ] `grep -r 'Agent Routing Matrix' template/AGENTS.md` returns nothing (moved to ROUTING.md)
- [ ] `grep -r 'ALWAYS' template/AGENTS.md` returns nothing (moved to BOUNDARIES.md)

## Completion

When all verification checks pass, update this file:
- Change `**Status:** not-started` to `**Status:** done`
- Add completion timestamp
