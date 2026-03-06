# Boundaries & Bug Tracking

> Referenced from `AGENTS.md`. This is part of the canonical workflow — see `/governance/REGISTRY.md`.

## Boundaries

### ALWAYS

- Read the spec before implementation
- Run tests before commit
- Include acceptance criteria evidence in every PR
- Follow branch naming conventions
- Reference the constitution for alignment on any design decision

### ASK FIRST

- Adding new dependencies
- Modifying CI workflows
- Changing the constitution (use `/compass-edit`). Exception: Phase 2 Compass directly populates `.specify/constitution.md` — no `/compass-edit` required during initial Compass execution.
- Modifying this file (`AGENTS.md`)
- Architectural decisions not covered by the spec

### NEVER

- Commit secrets or `.env` files
- Modify files outside the assigned scope
- Auto-merge without human approval
- Skip tests
- Make decisions not traceable to a spec or constitution principle

### Governance Blockage Recovery

If a governance policy or tooling restriction blocks a write that the current phase explicitly requires:

1. **Log failure** in `experiment-log.md` (if present) or `/bugs/LOG.md` with the blocked file, phase, and policy that triggered the block.
2. **Retry once** after confirming the write is within the current phase's documented scope (e.g., Compass writing `constitution.md` in Phase 2).
3. **If still blocked**, continue with remaining phase actions and flag the blocked write for human resolution. Do not stall indefinitely.

## Bug Tracking

Use `/bug` (Claude) or `bug.prompt.md` (Copilot) from any phase:

```
Description: [what's wrong]
Location: [file:line or component]
Phase found: [which phase discovered this]
Severity: blocking | non-blocking
Expected: [what should happen]
Actual: [what does happen]
Fix-as-you-go: yes | no
```

- Small bugs (fix-as-you-go = yes): fix in place, log the fix
- Large bugs: add to backlog as a spec, assign model + branch when picked up
- Backlog review cycle: treat queued bugs as specs with full AC/branch/model assignment
