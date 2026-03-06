# Router Execution Map

Purpose: define deterministic ordering and dependency gates for the revision loop.

## Invocation
`find the next meta-prompt to execute in docs/verification/revision-meta-prompts`

## Order Principles
1. Run foundational semantic and policy prompts first.
2. Run phase-specific design prompts next.
3. Run additive/new-phase prompts after core lifecycle alignment.
4. End with `Phase X: Completeness Audit`.

## Parallel Safety
- Any prompt with unresolved dependency must wait.
- Prompts without dependency conflicts may run in parallel lanes, but router default is serial deterministic order.

## Resume Rule
- On restart, router reads `ROUTER_INDEX.md` and selects the first `PENDING` row with satisfied dependencies.

## Completion Rule
- Loop is complete only when no eligible `PENDING` rows remain and terminal phase reports ready.
