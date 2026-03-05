# Feature Specification: [TITLE]

> Use this template for every feature spec. Copy to `/specs/[feature-id]-[slug].md` and fill in all sections.

## What and Why

_2–3 sentences: what this feature does and why it matters. Must trace back to a Core Capability in the constitution._

**Constitution mapping:** Links to `.specify/constitution.md` → Core Capability #N

## User Stories

_Prioritized list. Each story follows: "As a [user], I want [goal] so that [benefit]."_

1. As a `[user]`, I want `[goal]` so that `[benefit]`
2. As a `[user]`, I want `[goal]` so that `[benefit]`

## Acceptance Criteria

_Hybrid EARS + Given-When-Then format. Each criterion has a verification command and checkbox._

- [ ] **AC-1:** _[name]_
  - EARS: When `[trigger]`, the system shall `[response]`
  - GWT: Given `[context]`, when `[action]`, then `[outcome]`
  - Verification: `[INSERT COMMAND]` passes

- [ ] **AC-2:** _[name]_
  - EARS: When `[trigger]`, the system shall `[response]`
  - GWT: Given `[context]`, when `[action]`, then `[outcome]`
  - Verification: `[INSERT COMMAND]` passes

## Non-Goals

_Explicitly out of scope for this feature. Prevents scope creep._

- Not: _thing this feature won't do_
- Not: _thing this feature won't do_

## Constraints

_Performance, security, compatibility, or other hard requirements._

- Performance: _constraint_
- Security: _constraint_
- Compatibility: _constraint_

## Technical Approach

_Filled during Phase 4 (Scaffold Project). Leave blank until then._

## Task Breakdown

_Filled during Phase 5 (Fine-tune Plan). Each task has model assignment and branch name._

| Task | Description | Model | Branch | AC Coverage |
|------|-------------|-------|--------|-------------|
| T-1 | _description_ | `[model]` | `model/type-slug` | AC-1 |
| T-2 | _description_ | `[model]` | `model/type-slug` | AC-2 |

## Model Assignment

_Maps each task to a model per the routing rules in AGENTS.md._

| Task | Assigned Model | Reason |
|------|---------------|--------|
| T-1 | `[model]` | _why this model for this task_ |
| T-2 | `[model]` | _why this model for this task_ |
