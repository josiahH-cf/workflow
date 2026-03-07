# Phase 21: Final QA, Simplification, and Cleanup

## Objective

This is the terminal phase of the revision loop. It absorbs the work of Phase X (Completeness Audit). Execute three passes — **Audit**, **Simplify**, **Clean** — then verify the entire system end-to-end.

---

## Pass 1: Completeness Audit

Validate that the revision loop produced a coherent, fully-linked system with no contradictions or dead ends.

### Steps

1. **Build a coverage index.** For every DONE entry in `ROUTER_INDEX.md`, confirm:
   - The revision-spec (RS-NNN) exists and its goal is satisfied by the meta-prompt's noted outputs.
   - Every file the meta-prompt claims to have modified still exists at the stated path.
   - No two meta-prompts claim conflicting ownership of the same artifact section.

2. **Falsify cross-references.** For every `*.md` file under `template/`:
   - Extract all internal file path references (e.g., `workflow/LIFECYCLE.md`, `governance/REGISTRY.md`).
   - Confirm each referenced path resolves to an existing file.
   - Flag any broken links, orphan references, or stale path mentions.

3. **Check language consistency.** Scan for:
   - Phase names that don't match LIFECYCLE.md terminology (e.g., stale "Phase X" references, old "Review & Ship" without "Phase 7b" qualifier).
   - Contradictory instructions between files (e.g., ORCHESTRATOR says one thing about dispatch, PLAYBOOK says another about gates).
   - Guards that are overly restrictive (hard enforcement language for what should be advisory-tier guidance).
   - Missing suggestions where they should exist (e.g., a phase transition that should emit an advisory callout but doesn't).

4. **Produce audit output:**
   - `AUDIT_COMPLETE: true|false`
   - `MISSING_LINKS: <count>`
   - `CONTRADICTIONS: <count>`
   - `BLOCKERS: <count>`

---

## Pass 2: Simplification Analysis

Analyze the **template** (the product) and the **repo** (the development environment) for unnecessary complexity, disconnected artifacts, and consolidation opportunities.

### Template Analysis (template/)

1. **Dead file detection.** For every file under `template/`:
   - Is it referenced by at least one other file (AGENTS.md, FILE_CONTRACTS.md, REGISTRY.md, a command, a prompt, a workflow)?
   - If nothing references it, flag it as potentially dead.

2. **Redundancy scan.** Identify:
   - Files that substantially duplicate content from another file (e.g., overlapping guidance between BOUNDARIES.md and PLAYBOOK.md).
   - Sections within files that restate rules already covered elsewhere with no added specificity.
   - Templates (`_TEMPLATE.md` files) that could be consolidated.

3. **Complexity assessment.** For each template file:
   - Is the content proportional to its purpose? Flag files that are disproportionately long for what they govern.
   - Are there sections a new user would never need? Flag them as candidates for moving to a "deep reference" location.
   - Could any two files be merged without loss of clarity?

4. **Connection integrity.** Map the full reference graph:
   - AGENTS.md → Quick Reference table → each linked file → what links back.
   - FILE_CONTRACTS.md → each artifact row → does the artifact actually get created/used?
   - REGISTRY.md → each canonical file → does it still exist at that path?
   - Commands (`.claude/commands/`) → what files does each command tell the agent to read? Do those files exist?

5. **Produce a simplification report** listing:
   - Files safe to remove (unreferenced, dead).
   - Files that could be merged (with proposed merge target).
   - Sections that could be trimmed (with rationale).
   - Reference graph gaps (A links to B, but B doesn't exist or B never links back when it should).

### Repo Analysis (root level)

1. **Identify non-product artifacts.** The repo's product is: `template/`, `scripts/install.sh`, `scripts/validate-scaffold.sh`, `scripts/sync-prompts.sh`, `scripts/test-scripts.sh`, `prompts/`, `meta-prompts/`, `tests/`, `docs/quickstart-first-success.md`, `docs/reference/`, `docs/README.md`, `README.md`, `LICENSE`, `TROUBLESHOOTING.md`.
2. **Flag everything else** as a candidate for deletion — especially:
   - `docs/verification/` — the entire revision loop tree (specs, meta-prompts, router, archives, findings, explainers, etc.). This was development scaffolding, not the product.
   - `tmp-target/` — empty test directory.
   - `workflow/` (root level, not `template/workflow/`) — contains only a `LINT_REPORT.md` from a test run.
   - Any other files or directories not part of the product.

---

## Pass 3: Clean

Execute the deletions and simplifications identified in Pass 2.

### Mandatory Deletions
- `docs/verification/` — entire tree (revision-specs, revision-meta-prompts, router index, archives, findings, governance explainer/matrix, error messages, troubleshooting messages). All of this was revision-loop scaffolding.
- `tmp-target/` — empty test artifact.
- `workflow/` (root level) — test artifact, not the product template.
- Any other non-product files identified in Pass 2.

### Conditional Simplifications
- For each simplification identified in Pass 2, apply it only if:
  - It removes genuine redundancy (not just similar-sounding content that serves different audiences).
  - It doesn't break any cross-reference or validation check.
  - The merged/trimmed result passes `validate-scaffold.sh` and `policy-check.sh`.

### Safety Rule
- Before deleting any file, confirm it is not referenced by any file under `template/`, `prompts/`, `meta-prompts/`, `scripts/`, or `tests/`.
- After all deletions, run the full validation suite to confirm nothing broke.

---

## Verification (Final System Check)

After all three passes, verify the entire system works end-to-end:

1. **`scripts/validate-scaffold.sh template`** — must report 0 failures.
2. **`template/scripts/policy-check.sh`** (run from inside `template/`) — must pass.
3. **`template/scripts/workflow-lint.sh`** (run from inside `template/`) — must produce a valid LINT_REPORT.md.
4. **`scripts/test-scripts.sh`** — if test suite exists, must pass.
5. **Mermaid diagram** in `docs/reference/workflow-diagram.md` — must render without errors; every node must map to a LIFECYCLE.md phase.
6. **Install dry-run** — `scripts/install.sh --dry-run /tmp/test-target` — must complete without errors (if supported).
7. **Cross-reference spot-check** — manually verify 5 randomly selected file references from AGENTS.md, FILE_CONTRACTS.md, and REGISTRY.md resolve to existing files with correct content.

### Completion Contract
- `AUDIT_COMPLETE: true`
- `SIMPLIFICATION_APPLIED: <count of changes>`
- `FILES_DELETED: <count>`
- `VALIDATION_SUITE: PASS`
- `SYSTEM_FUNCTIONAL: true`
