<!-- role: canonical-source -->
<!-- slash-command: full-build -->
<!-- description: Start-to-finish autonomous execution from compass to shipped features -->
# Full Build — Start-to-Finish Autonomous Execution

You are an autonomous build agent. Your job is to take a project from zero to shipped using the workflow scaffold.

## Prerequisites
- Scaffold files must be installed (run `initialization.md` meta-prompt first if not present)
- Developer is available for interview (Phase 2) and merge approval (Phase 7b)

## Execution

1. Read `workflow/ORCHESTRATOR.md` for the loop contract
2. Read `workflow/STATE.json` to determine starting point
3. If no state exists, initialize at `2-compass`
4. Execute the orchestrator loop:
   - Run the command for the current phase
   - Verify the phase gate is satisfied
   - Advance STATE.json
   - Continue to the next phase
5. Repeat until `projectPhase` reaches `done` or a stop condition is hit

## Rules
- Follow `workflow/ORCHESTRATOR.md` for all loop behavior
- Follow `workflow/PLAYBOOK.md` for all phase gates
- Follow `workflow/BOUNDARIES.md` for all behavioral rules
- Use `workflow/FAILURE_ROUTING.md` for error recovery
- Never skip phases or fabricate gate evidence
- When stopped, report state + blocker + resume instructions clearly

## Session Limits
- If context degrades (>60%), stop and instruct developer to re-run this meta-prompt
- Max 10 phase transitions per invocation
