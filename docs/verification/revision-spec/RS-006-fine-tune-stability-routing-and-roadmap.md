# RS-006 Fine-Tune Stability Routing And Roadmap

## Goal
Define Step 5 outcomes that reduce hang risk, provide non-binding model-routing guidance, and produce a maintainable roadmap for iterative execution.

## In Scope
- Response-stability expectations for fine-tune interactions.
- Advisory model/router guidance, including cloud/local and parallel suitability signals.
- Roadmap artifact requirements for resumable execution.

## Out of Scope
- Hard model enforcement.
- Implementing runtime router code.

## Observable Outcomes
- Fine-tune outputs are structured and finish-oriented.
- Roadmap can be resumed with `/continue` and checkpoint context.

## Dependencies
- RS-001.

## Linked Meta-Prompt
- `docs/verification/revision-meta-prompts/06-fine-tune-stability-routing-and-roadmap.md`

## Status: DONE

### Changes Applied

1. **Anti-stall structural output** — Replaced free-form "What Happens" section in `meta-prompts/phase-5-fine-tune-plan.md` with a strict 4-step Execution Sequence (Read Inputs → Create Task Files → Routing Plan → Summary Table). Agent follows numbered steps and produces artifacts sequentially — no room for extended reasoning loops.

2. **Advisory model-routing** — Added Routing Plan section to `template/tasks/_TEMPLATE.md` with per-task columns: Suggested Model, Rationale, Reviewer, Parallel suitability, Context Needs. Framed as suggestions, not mandates. Developer or `/continue` may override at execution time.

3. **Resumable roadmap via Session Log + STATE** — Restructured the Session Log in `template/tasks/_TEMPLATE.md` into a structured table (Date, Last Completed, Next Action, Blockers, State Link). Updated `meta-prompts/phase-9-continue.md` Session Bootstrap to read latest Session Log row. Added rule for `/continue` to append Session Log rows after each state transition. Updated `template/workflow/FILE_CONTRACTS.md` to reflect new task file contract.

4. **Prompt sync** — Ran `scripts/sync-prompts.sh` to propagate all changes to derived `prompts/phase-5-fine-tune.prompt.md` and `prompts/phase-9-continue.prompt.md`.

### Files Changed
- `meta-prompts/phase-5-fine-tune-plan.md` (canonical)
- `meta-prompts/phase-9-continue.md` (canonical)
- `template/tasks/_TEMPLATE.md`
- `template/workflow/FILE_CONTRACTS.md`
- `prompts/phase-5-fine-tune.prompt.md` (derived, synced)
- `prompts/phase-9-continue.prompt.md` (derived, synced)
