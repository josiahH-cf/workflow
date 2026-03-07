# RS-020 Workflow Diagram Update

## Goal
Update the workflow diagram (`docs/reference/workflow-diagram.md`) to reflect all structural lifecycle changes introduced by the revision loop — especially Phase 7a (Review Bot) with its auto-merge and findings re-entry paths.

## In Scope
- Add Phase 7a (Review Bot) node to the per-feature loop.
- Show the auto-merge path (bot PASS → merge → next feature).
- Show the findings re-entry path (bot FAIL → findings file → back to /implement).
- Distinguish Phase 7b (manual Review & Ship) as a fallback path.
- Incorporate any Phase X (Releases) additions from RS-013 if completed.
- Ensure the diagram matches LIFECYCLE.md, ORCHESTRATOR.md, and PLAYBOOK.md.

## Out of Scope
- Redesigning the diagram format or tooling (stays Mermaid).
- Adding detail for non-lifecycle changes (governance, linting, advisory).

## Observable Outcomes
- The Mermaid diagram renders correctly and shows Phase 7a with both PASS and FAIL paths.
- Every node in the diagram maps to a phase in LIFECYCLE.md.
- The `/continue` orchestration loop accurately reflects the dispatch table in ORCHESTRATOR.md.

## Dependencies
- RS-012 (Review Bot Phase) — provides the Phase 7a lifecycle definition.
- RS-013 (Phase X Releases) — may add a release phase node (incorporate if completed).

## Linked Meta-Prompt
- `docs/verification/revision-meta-prompts/20-workflow-diagram-update.md`
