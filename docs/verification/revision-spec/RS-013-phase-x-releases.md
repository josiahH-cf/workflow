# RS-013 Phase 9 — Operationalize

## Goal
Define `Phase 9: Operationalize` as an interview-driven automation configuration phase that translates the user's ongoing maintenance preferences into executable GitHub Actions workflows and notification routing. Phase 8 (Maintain) defines *what* to check; Phase 9 defines *how often, how automatically, and who gets told when it fails*.

## In Scope
- Interview sub-process covering automation depth, schedule, and notification routing.
- Maintenance-config artifact (`.github/maintenance-config.yml`) recording all decisions.
- Generated GitHub Actions workflows for scheduled maintenance tasks (lint, docs compliance, release publishing, dependency monitoring, security scanning).
- Notification routing configuration (failure emails, Slack webhooks, GitHub Issues auto-creation).
- Mapping Phase 8 maintenance levels (Light/Standard/Deep) to automation tiers.
- Release publishing workflow (`release-publish.yml`) with semver enforcement and changelog generation.

## Out of Scope
- Implementing project-specific CI/CD pipelines unrelated to maintenance.
- Mandating specific notification platforms — the interview surfaces options, the user decides.
- Replacing Phase 8 — Operationalize augments Maintain with automation, it does not replace manual runs.

## Observable Outcomes
- Every interview decision is persisted in `.github/maintenance-config.yml`.
- At least one GitHub Actions workflow is generated per automation category selected.
- Notification routing is explicit: who is notified, via what channel, for which failure classes.
- The automation tier matches the user's selected maintenance level.
- Re-entry to Phase 9 updates existing config and workflows without duplication.

## Dependencies
- RS-008 (phase numbering consistency).

## Linked Meta-Prompt
- `docs/verification/revision-meta-prompts/13-phase-x-releases.md`
