# Governance Explainer

## What Is Governance in This Workflow?

Governance is the set of rules that keep the scaffold trustworthy as you build on it. It answers: *"What can I change freely, and what requires a process?"*

There are three layers:

1. **Canonical policy files** — the source of truth for how the workflow behaves (AGENTS.md, `/workflow/*.md`, `/governance/*.md`).
2. **Policy tests** — automated checks that enforce the policy files are consistent and complete.
3. **Change protocol** — the process for modifying policy files themselves.

## Who Owns What?

The **Canonical Policy Registry** (`/governance/REGISTRY.md`) lists every governed file, what it controls, and who owns it. Most files are owned by the human maintainer. Two exceptions:

- `STATE.json` is written by the orchestrator agent.
- `constitution.md` is co-owned between the Compass phase and the human (editable via `/compass-edit`).

Adapter files (`CLAUDE.md`, `copilot-instructions.md`, etc.) are **not canonical** — they import or link to the canonical files but must never redefine policy.

## What Blocks Progress?

**Policy test failures are hard stops.** If a check in `POLICY_TESTS.md` fails, that means the scaffold has drifted from its own rules. You must fix the artifact or the policy before continuing feature delivery. This isn't a warning — it's a signal that the process contract is broken.

Examples of blocking rules:
- Specs must have Feature IDs and Acceptance Criteria IDs.
- Task files must map to AC IDs.
- Placeholders like `[PROJECT-SPECIFIC]` must be resolved by a specific phase.
- Build/lint/test commands must be real, not placeholders.
- `STATE.json` must parse and point to an existing task.

## What Doesn't Block Progress?

**Workflow lint findings are informational.** The lint contract (`LINT_CONTRACT.md`) describes structural health checks, but lint output goes to `LINT_REPORT.md` as an advisory — failure does not block merges or phase transitions.

**Review rubric scores flag, but don't gate.** The review rubric has categories (like Performance, Style) that surface concerns for human consideration, not automated rejection.

**Boundaries are best practices, not gates.** `BOUNDARIES.md` describes recommended habits (read the spec first, run tests before commit, etc.) but these aren't enforced by automated checks.

## How Do I Change a Policy File?

You don't edit governance files during normal feature work. The **Change Protocol** (`/governance/CHANGE_PROTOCOL.md`) requires:

1. A decision record with the triggering failure pattern, proposed diff, impact assessment, and rollback plan.
2. A builder agent drafts the proposal.
3. A reviewer agent validates necessity and risk.
4. A human approves the merge.
5. Governance changes must be in isolated PRs — never bundled with feature code.

## Summary

| Layer | Purpose | Enforcement |
|---|---|---|
| Canonical files | Define how the workflow works | Structural — they are the rules |
| Policy tests | Verify artifacts match the rules | Automated — block on failure |
| Lint contract | Surface structural health | Informational — advisory only |
| Change protocol | Control mutations to governance | Process — requires proposal + human approval |
| Boundaries | Best practices for agents and humans | Cultural — not automated |
