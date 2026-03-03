# AGENTS

Canonical entrypoint for all coding agents. Keep this file short and navigational.

## Mission

Ship small, reversible, test-validated changes from a written spec to merged PR with minimal manual intervention.

## Policy Precedence

When instructions conflict, use this order:

1. Direct human request in the current session
2. This file (`/AGENTS.md`)
3. Workflow control plane (`/workflow/*.md`)
4. Governance control plane (`/governance/*.md`)
5. Tool adapters (`/CLAUDE.md`, `/.github/copilot-instructions.md`, `/.codex/config.toml`)

Do not duplicate policy text across files. Link to canonical docs instead.

## Project Profile

<!-- Replace: project name, one-line description, primary language/framework -->

## Build Commands (Authoritative)

<!-- Replace with actual build steps for your project -->

- Install: `[install step]`
- Build: `[build step]`
- Test (all): `[test step]`
- Test (single): `[single test step with placeholder]`
- Lint: `[lint step]`
- Format: `[format step]`
- Type-check: `[type-check step, if applicable]`

## Architecture Snapshot

<!-- Replace with 5–15 lines mapping key directories to responsibilities -->

## Naming Conventions

- Functions and variables: [naming convention]
- Files and directories: [naming convention]

## Lifecycle Index

- Lifecycle map: `/workflow/LIFECYCLE.md`
- Phase execution contract: `/workflow/PLAYBOOK.md`
- Artifact ownership and validation: `/workflow/FILE_CONTRACTS.md`
- Failure routing and escalation: `/workflow/FAILURE_ROUTING.md`

## Governance Index

- Policy change protocol: `/governance/CHANGE_PROTOCOL.md`
- Policy test matrix: `/governance/POLICY_TESTS.md`
- Canonical file registry: `/governance/REGISTRY.md`

## Artifact References

- Specs: `/specs/[feature-id]-[slug].md`
- Tasks: `/tasks/[feature-id]-[slug].md`
- Decisions: `/decisions/[NNNN]-[slug].md`
- ExecPlan template: `/.codex/PLANS.md`

## Non-Negotiables

- Tests are written before implementation for each acceptance criterion.
- Every implemented task produces evidence in the task file session log.
- No out-of-scope file edits without a recorded decision.
- No secrets in code or instruction files.
