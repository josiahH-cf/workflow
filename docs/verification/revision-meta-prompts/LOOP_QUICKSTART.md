# Loop Quickstart

From a fresh context window, run this phrase:

`find the next meta-prompt to execute in docs/verification/revision-meta-prompts`

Expected behavior:
1. The router reads `ROUTER_INDEX.md`.
2. It returns the next eligible prompt path and objective.
3. You confirm execution.
4. After completion, the router marks status and advances.
5. Repeat the same phrase until it returns `ROUTER_COMPLETE: true`.

## Operator Notes
- Keep all revision prompt files registered in `ROUTER_INDEX.md`.
- If execution pauses, rerun the same phrase; the router should resume from state.
- Use `BLOCKED` status instead of skipping unresolved dependencies.
- Run `docs/verification/revision-meta-prompts/phase-x-completeness-audit.md` only after all numbered rows are `DONE`.
