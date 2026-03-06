# RS-010 Workflow Linting Observability

## Goal
Define a non-destructive linting and observability process for workflow artifacts that flags structural and quality issues without auto-remediation.

## In Scope
- Orphaned file detection signals.
- File-length warnings beyond 120 lines.
- End-of-file newline policy checks across repository text files.
- Light heuristic instruction-clarity warnings.

## Out of Scope
- Automatic file rewrites.
- Strict readability scoring as hard failure.

## Observable Outcomes
- Lint process produces actionable callouts only.
- Findings are attributable and reviewable.

## Dependencies
- RS-008.

## Linked Meta-Prompt
- `docs/verification/revision-meta-prompts/10-workflow-linting-observability.md`
