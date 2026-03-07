# Phase 13: Phase 9 — Operationalize

## Objective
Define an interview-driven automation configuration phase that translates Phase 8 maintenance preferences into scheduled GitHub Actions workflows, notification routing, and release publishing automation.

## Inputs
- `docs/verification/revision-spec/RS-013-phase-x-releases.md`
- Current Phase 8 (Maintain) structure: Light / Standard / Deep levels
- Existing GitHub Actions workflow templates in `template/.github/workflows/`

## Deliverables
- `meta-prompts/phase-9-operationalize.md` — canonical interview-driven meta-prompt
- `prompts/phase-9-operationalize.prompt.md` — Copilot prompt (derived)
- `template/.claude/commands/operationalize.md` — Claude command (derived)
- `template/.github/workflows/release-publish.yml` — release publishing workflow template
- `template/.github/maintenance-config.yml` — interview output artifact template
- Updated: LIFECYCLE.md, AGENTS.md, PLAYBOOK.md, ORCHESTRATOR.md, phase-10-continue (renumbered from phase-9)
- Updated: sync-prompts.sh, validate-scaffold.sh, prompt-sync.md cross-platform map

## Constraints
- Do not prescribe specific notification platforms — interview surfaces options, user decides.
- Do not replace Phase 8 — Phase 9 augments Maintain with automation.
- Maintain re-entry support: running `/operationalize` again updates existing config without duplication.
- GitHub Actions workflows must use proper `.github/workflows/` file structure.

## Verification
- Interview covers: lint schedule, docs compliance, release automation, dependency monitoring, security scanning, notification routing, automation depth.
- Every interview decision persists in `.github/maintenance-config.yml`.
- At least one workflow template is generated per selected automation category.
- Notification routing is explicit (who, channel, failure class).
- `/continue` orchestrator updated to manage phases 2–9 (renumbered to phase-10-continue).
- `workflow-lint.sh` passes with no broken references.
