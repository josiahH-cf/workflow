# RS-012 Review Bot Phase

## Goal
Define a new non-blocking review-bot phase that provides objective findings before final review without forcing pass/fail gating.

## In Scope
- Phase purpose and position in lifecycle.
- Output contract for objective review findings.
- Advisory integration with downstream planning/spec updates.

## Out of Scope
- Enforcing a mandatory block on progression.
- Implementing a specific review engine.

## Observable Outcomes
- Review bot phase exists as a distinct optional step.
- Findings can feed future spec refinement.

## Dependencies
- RS-008.

## Linked Meta-Prompt
- `docs/verification/revision-meta-prompts/12-review-bot-phase.md`

## Aditional Context
Custom agent / subagent as an outside reviewer
VS Code supports custom agents for roles like planner or code reviewer, and subagents can be run with specialized behavior and models. This is the closest match to “have GPT do the work, then have Claude/Gemini act as a reviewer.”

creation of these could be that they start with a clean context window and receive only the task prompt you provide (or it is linked to our review prompt), By default they also use the same model as the main chat, so to force a different reviewer model you would use a custom agent configured for that role/model. Think through that as part of the spec, and also consider how to make it easy to run the review bot on demand without needing to set up a whole new agent each time. Maybe a command that spins up a temporary review subagent with the right prompt and model?