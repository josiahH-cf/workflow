# Phase 14: Dynamic Agent Rules & Multi-Agent Coordination

## Objective
Remove hardcoded agent-to-task bindings so any tool (Claude, Copilot, Codex) can execute any phase or task. Enable simultaneous `/continue` across all three tools where each dynamically claims independent work (next feature, bug fix, parallel-safe task) without conflict.

## Inputs
- `docs/verification/revision-spec/RS-014-agent-rules-framework.md`
- `template/workflow/ROUTING.md` — current hardcoded Agent Routing Matrix
- `template/workflow/CONCURRENCY.md` — current model-specific worktree/branch conventions
- `template/AGENTS.md` — phase entry points reference all three tools already
- `template/.github/agents/*.agent.md` — per-role agent personas

## Problem Statement
Today the Agent Routing Matrix in ROUTING.md assigns fixed models to task types (e.g., "Complex architecture → Claude", "UI/frontend → Copilot", "Batch operations → Codex"). Branch naming embeds the model name (`claude/feat-auth-flow`). This prevents a user from running Fine-Tune in Codex or kicking off `/continue` in all three tools simultaneously — the rules say only one model should handle a given task type.

The real constraint is **file-level exclusivity** (no two agents editing the same file), not which model does which kind of work.

## Deliverables

### 1. Replace static Agent Routing Matrix with dynamic claim-based assignment
- Remove the hardcoded task-type → model mapping from ROUTING.md.
- Replace with a **capability-neutral** model: any agent that starts a task owns it; ownership is tracked via STATE.json or task file metadata (e.g., `assignedAgent: copilot-session-1`).
- Retain the Agent Routing Matrix as **advisory hints** ("Claude excels at deep reasoning") — not enforcement.

### 2. Multi-agent `/continue` coordination
- When `/continue` is invoked in multiple tools simultaneously, each reads STATE.json and task backlog, then **claims the next unclaimed, non-conflicting unit of work**:
  - Next pending feature (file-disjoint from in-progress work)
  - Open bug from bug log
  - Maintenance or docs task
- Claim mechanism: agent writes its identity into the task file or STATE.json before starting work. Other agents skip claimed tasks.
- If no unclaimed work exists, the agent reports "nothing to claim" rather than duplicating.

### 3. Model-neutral branch naming
- Change branch format from `model/type-description` to `agent/type-description` where `agent` is a session identifier (e.g., `agent-1/feat-auth-flow`) or simply `type-description` without model coupling.
- Update `setup-worktree.sh` to accept agent session IDs instead of model names.

### 4. Update per-role agent files
- Agent persona files (`.github/agents/*.agent.md`) should describe **role behavior** (planner, implementer, reviewer) without assuming which tool runs them.
- Any tool can act as any role.

### 5. Transferability
- The dynamic rules framework should work for any project using the template — no project-specific hardcoding.
- Document the pattern so other projects adopting this workflow get dynamic multi-agent coordination out of the box.

## Constraints
- The **only hard rule** is file-level exclusivity: no two agents may edit the same file simultaneously.
- Advisory routing hints are allowed but must not block any tool from any task.
- Do not break existing single-agent workflows — a user running only Claude should experience no friction.
- Backward-compatible: projects not using multi-agent simply ignore the claim mechanism.

## Verification
- Any single tool (Claude, Copilot, or Codex) can execute any phase end-to-end without being blocked by routing rules.
- Three simultaneous `/continue` invocations each find independent, non-conflicting work.
- No remaining hardcoded model → task-type enforcement in ROUTING.md, CONCURRENCY.md, or AGENTS.md.
- `clash-check.sh` still detects file-level conflicts.
- `validate-scaffold.sh` passes.
- `workflow-lint.sh` passes.
