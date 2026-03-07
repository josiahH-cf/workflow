# RS-014 Dynamic Agent Rules & Multi-Agent Coordination

## Goal
Remove hardcoded agent-to-task bindings so any tool (Claude, Copilot, Codex) can run any phase. Enable simultaneous `/continue` across all three tools with dynamic, conflict-free work claiming.

## In Scope
- Replace static Agent Routing Matrix with capability-neutral dynamic assignment.
- Define claim-based coordination for multi-agent `/continue` (task-level locking via STATE.json or task file metadata).
- Model-neutral branch naming (remove `model/` prefix requirement).
- Update agent persona files to describe role behavior without tool coupling.
- File-level exclusivity as the single hard constraint (no two agents on the same file).
- Advisory routing hints ("Claude excels at reasoning") preserved as non-blocking guidance.
- Cross-project transferability — dynamic rules work for any project using the template.

## Out of Scope
- Enforcing which tool must handle which task type.
- Distributed lock servers or external coordination infrastructure — keep it file-based and simple.
- Changing the Phase 1–9 lifecycle structure.

## Observable Outcomes
- A user can run `/fine-tune`, `/implement`, `/continue`, or any command in Codex, Claude, or Copilot without being blocked by routing rules.
- Three simultaneous `/continue` invocations each dynamically claim independent, file-disjoint work.
- ROUTING.md contains advisory hints, not enforcement.
- Branch naming and worktree setup are model-agnostic.
- Single-agent workflows remain frictionless (no regressions).
- `clash-check.sh`, `validate-scaffold.sh`, and `workflow-lint.sh` all pass.

## Dependencies
- RS-005 (Scaffold-Agents Ownership).

## Linked Meta-Prompt
- `docs/verification/revision-meta-prompts/14-agent-rules-framework.md`
