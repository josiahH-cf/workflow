# Specification Workflow

> Referenced from `AGENTS.md`. This is part of the canonical workflow — see `/governance/REGISTRY.md`.
> See Phase 5 remediation for EARS/GWT notation enhancement.

## Workflow

All work flows from specifications:

1. Read `.specify/constitution.md` before any implementation — it is the project's identity
2. Check `/specs/` for the current feature spec (copy `.specify/spec-template.md` when creating new specs)
3. Create or update `/tasks/[feature-id]-[slug].md` during Phase 5 — this is the authoritative execution artifact
4. Write acceptance criteria using `.specify/acceptance-criteria-template.md` as reference
5. Verify all acceptance criteria pass before creating a PR

## Spec Artifacts

- Constitution: `.specify/constitution.md`
- Spec template: `.specify/spec-template.md`
- AC template: `.specify/acceptance-criteria-template.md`
- Per-feature specs: `/specs/[feature-id]-[slug].md`
- Task breakdowns: `/tasks/[feature-id]-[slug].md`
- Decisions: `/decisions/[NNNN]-[slug].md`
- Orchestration state: `/workflow/STATE.json`
