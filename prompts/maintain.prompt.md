---
mode: agent
description: "Maintain project health — documentation, compliance, standards"
tools:
  - read_file
  - create_file
  - replace_string_in_file
  - run_in_terminal
---
<!-- role: derived | canonical-source: meta-prompts/minor/08-maintain.md -->

# Maintain — Phase 8: Project Health

Maintain project health: documentation, compliance, and standards enforcement.

Read `AGENTS.md` (all sections — especially Code Conventions, Boundaries, Specification Workflow).
Read `.specify/constitution.md`.

## Mode: Initial Setup

Run when a project first reaches a shippable state (post-Phase 7).

1. **README** — Generate/update from constitution + feature specs. Include: project description, setup (from AGENTS.md Core Commands), usage examples, architecture overview.
2. **CONTRIBUTING** — Generate from AGENTS.md conventions: branch naming, commit format, PR requirements, testing expectations.
3. **Release notes** — Summarize implemented features with spec references.
4. **Security baseline** — Check for: secrets in code, dependency vulnerabilities, insecure patterns. Log findings as bugs if needed.

## Mode: Ongoing

Run periodically or when triggered.

1. **Compliance check** — All specs have tests, all tests pass, no orphan branches, bug log reviewed.
2. **Documentation drift** — Compare README/CONTRIBUTING against current state. Update if diverged.
3. **Dependency audit** — Check for outdated or vulnerable dependencies.
4. **Auto-corrections** — Fix lint warnings, format drift, stale TODOs.
5. **Issue review** — Scan bug log for stale entries. Flag or close.

## Rules

- Do not change application logic — maintenance only.
- Log issues via bug tracking.
- Commit maintenance changes separately from feature work.

## Output

State which mode was run and summarize findings.
