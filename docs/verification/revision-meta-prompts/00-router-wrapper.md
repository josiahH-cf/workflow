# Phase 0: Router Wrapper

## Purpose
Route to the next executable revision meta-prompt in a repeatable loop from a fresh context window.

## Invocation Phrase
`find the next meta-prompt to execute in docs/verification/revision-meta-prompts`

## Router Behavior Contract
When invoked, do the following in order:
1. Read `docs/verification/revision-meta-prompts/ROUTER_INDEX.md`.
2. Select the first row where `Status` is `PENDING` and all `Depends On` entries are `DONE`.
3. Return exactly:
- `NEXT_META_PROMPT: <path>`
- `GOAL: <one-line objective>`
- `BLOCKERS: <none|short list>`
4. Ask for confirmation to execute that prompt in the current session.
5. After execution completes, update `ROUTER_INDEX.md`:
- Set that row `Status` to `DONE`.
- Write current date in `Completed On`.
- Append one-line evidence in `Notes`.
6. Repeat until no eligible `PENDING` rows remain.

## Tie-Breaking Rules
1. Prefer lower `Order` value.
2. If tied, prefer fewer dependencies.
3. If still tied, choose alphabetically by `Meta Prompt Path`.

## Pause Conditions
Pause and ask the user when:
1. A row is `PENDING` but dependencies are ambiguous.
2. Two prompts appear to overlap ownership.
3. Any required file is missing.

## Completion Condition
Return:
- `ROUTER_COMPLETE: true`
- `REMAINING_PENDING: 0`
- `NEXT_ACTION: Run Phase X: Completeness Audit`

## Non-Prescriptive Guardrail
This router only chooses order and updates tracking state. It does not define implementation strategy for any selected prompt.
