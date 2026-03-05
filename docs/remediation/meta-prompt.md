# Remediation Executor — Meta-Prompt

Paste this into a fresh context window to execute the next remediation phase.

---

You are an implementation agent executing a structured remediation plan to align the workflow scaffold with agentic best practices. The plan is documented in `docs/remediation/`.

## Instructions

1. **Read** `docs/remediation/README.md` for the phase execution order and dependency map.

2. **Find the next phase** to execute:
   - Read each `docs/remediation/phase-NN.md` file in order (01 through 09)
   - Find the first file where `**Status:**` is `not-started`
   - If the phase has dependencies, verify those phases show `**Status:** done`
   - If a dependency is not done, report the blocker and stop

3. **Execute that phase:**
   - Read the phase document thoroughly — it contains everything you need
   - Read all files listed in "Context Files to Read First"
   - Follow every step in order
   - Create or modify files exactly as specified
   - Do not skip steps or take shortcuts

4. **Verify your work:**
   - Walk through every item in the "Verification Checklist" at the end of the phase
   - Fix any failures before marking complete
   - Run any validation scripts mentioned (e.g., `validate-scaffold.sh`)

5. **Mark the phase complete:**
   - Edit the phase file: change `**Status:** not-started` to `**Status:** done`
   - Add a line: `**Completed:** YYYY-MM-DD`

6. **Report results:**
   - List what was created/modified
   - List any issues encountered and how they were resolved
   - State which phase should be executed next
   - If Phase 9 was completed, confirm that `docs/remediation/` was deleted

## Rules

- Execute ONE phase per session (fresh context per phase for best results)
- Do not modify the plan files themselves (except to mark status)
- If a step is ambiguous, prefer the interpretation that matches existing project patterns
- If a step would break existing functionality, stop and report the conflict
- Commit your changes after each phase for safety
- Phases 3-7 can be executed in any order (they are parallelizable after Phase 1)
- Phase 8 must wait for all of Phases 1-7
- Phase 9 must wait for Phase 8

## Context

- This is a scaffold/template project at `/home/josiah/workflow`
- Changes go in the `template/` directory (what gets installed into consumer projects)
- Also update `scripts/`, `tests/`, `meta-prompts/`, and `prompts/` as specified
- The best practices reference is at `building-agents-examples.md` (read if you need background)
