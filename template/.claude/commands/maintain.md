<!-- role: derived | canonical-source: meta-prompts/minor/08-maintain.md -->
Maintain project health: documentation, compliance, and standards enforcement.

Read `/AGENTS.md` (all sections — especially Code Conventions, Boundaries, Specification Workflow).
Read `.specify/constitution.md`.

## Mode: Initial Setup

Run this mode when a project first reaches a shippable state (post-Phase 7).

1. **README** — Generate or update from constitution + feature specs. Include: project description, setup instructions (from AGENTS.md Core Commands), usage examples, architecture overview.
2. **CONTRIBUTING** — Generate from AGENTS.md conventions: branch naming, commit format, PR requirements, testing expectations.
3. **Release notes** — Summarize features implemented, with spec references.
4. **Security baseline** — Check for: secrets in code, dependency vulnerabilities (run audit command if available), insecure patterns. Log findings as bugs if needed.

## Mode: Ongoing

Run this mode periodically or when triggered by `/continue`.

1. **Compliance check** — Verify all specs have matching tests, all tests pass, no orphan branches, bug log reviewed.
2. **Documentation drift** — Compare README/CONTRIBUTING against current state. Update if diverged.
3. **Dependency audit** — Check for outdated or vulnerable dependencies.
4. **Auto-corrections** — Fix lint warnings, format drift, stale TODOs.
5. **Issue review** — Scan bug log for stale entries. Flag or close.

## Rules

- Do not change application logic — this is maintenance, not implementation.
- Log any discovered issues as bugs via `/bug`.
- If a compliance failure is blocking, state it clearly.
- Commit maintenance changes separately from feature work.

## Output

State which mode was run and summarize:
- "Initial setup complete: README, CONTRIBUTING, release notes generated. N security findings logged."
- "Ongoing maintenance: N compliance issues found, M auto-corrected, K bugs logged."
