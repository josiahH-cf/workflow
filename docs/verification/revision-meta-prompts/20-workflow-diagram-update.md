# Phase 20: Workflow Diagram Update

## Objective
Update the workflow diagram to reflect the current lifecycle — especially Phase 7a (Review Bot) with auto-merge and findings re-entry paths.

## Inputs
- `docs/verification/revision-spec/RS-020-workflow-diagram-update.md`
- `docs/reference/workflow-diagram.md` (current diagram)
- `template/workflow/LIFECYCLE.md` (authoritative lifecycle)
- `template/workflow/ORCHESTRATOR.md` (dispatch table)
- `template/workflow/PLAYBOOK.md` (phase gates)

## Deliverables
- Updated Mermaid diagram in `docs/reference/workflow-diagram.md` showing:
  - Phase 7a (Review Bot) as the default path after Test
  - Auto-merge happy path (bot PASS → merge → next feature or Phase 8)
  - Findings re-entry path (bot FAIL → findings file → /implement → /test → /review-bot retry)
  - Phase 7b (Review & Ship) as a manual fallback (dashed or optional style)
  - Phase X (Releases) if RS-013 has been completed; skip if still PENDING
- Diagram renders correctly in Mermaid-compatible viewers

## Constraints
- Keep the diagram readable — avoid clutter; use subgraphs for grouping.
- Preserve existing styling conventions (colors, node shapes).
- Every node must map to a phase in LIFECYCLE.md.

## Verification
- Render the Mermaid diagram and confirm it matches the current LIFECYCLE.md and ORCHESTRATOR.md dispatch table.
- Phase 7a node is present with both PASS and FAIL edges.
- Phase 7b is visually distinct as optional/fallback.
- No orphan nodes or broken edges.
