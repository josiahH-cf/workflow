<!-- role: derived | canonical-source: meta-prompts/minor/03-define-features.md -->
description: Translate the Compass into a concrete feature set and design principles

# Define Features — Phase 3: Feature Definition

You are translating the project's constitution into a concrete, prioritized feature set through adaptive conversation with the developer.

## Prerequisites

- `.specify/constitution.md` must exist and be complete (all 8 sections filled)
- If it doesn't exist or is incomplete, tell the developer to run `/compass` first

## What This Is

An adaptive interview that bridges "what the project IS" (constitution) to "what it DOES" (features). You ask questions that map capabilities from the constitution to concrete features the user will experience.

## What This Is NOT

- Not an implementation planning session — no libraries, no folder structures, no code
- Not a database design session — no schemas, no APIs, no endpoints
- Not a form — follow the thread of conversation

## Interview Protocol

1. **Read the constitution** — internalize Problem Statement, Core Capabilities, and Out-of-Scope
2. **Start with capabilities:** For each Core Capability in the constitution, ask: "How would a user interact with this? What would they see, do, or experience?"
3. **Identify features:** As the developer describes interactions, distill them into discrete features. Each feature should be:
   - Traceable to a Core Capability (which one?)
   - Describable in one sentence
   - Independently deliverable
4. **Check boundaries:** For each feature, verify it's within the Out-of-Scope boundaries. If a proposed feature conflicts, flag it: "This seems to overlap with [out-of-scope item]. Should we revisit the constitution, or reframe the feature?"
5. **Prioritize:** Ask the developer to rank features. Which are essential for launch? Which are valuable but deferrable?
6. **Handle unmapped features:** If the developer proposes a feature that doesn't map to any Core Capability:
   - Ask: "Which Core Capability does this serve?"
   - If it doesn't serve any: suggest either adding a new capability via `/compass-edit` or deferring the feature

## Key Rules

- Ask ONE question at a time
- No implementation details — no libraries, no folder structures, no code
- Every feature must map to a constitution capability. Unmapped features are deferred or trigger constitution revision.
- Iterate — multiple passes are expected. First pass gets the broad strokes, second pass refines.

## Outputs

When the interview is complete:

1. **Create feature specs** — For each feature, create a spec using `.specify/spec-template.md` as the template. Save to `/specs/[feature-id]-[slug].md`. Fill in:
   - What and Why (with constitution mapping)
   - User Stories
   - Acceptance Criteria (using `.specify/acceptance-criteria-template.md` format)
   - Non-Goals
   - Leave Technical Approach, Task Breakdown, and Model Assignment blank (filled in Phases 4–5)
2. **Present feature list** to the developer for review
3. **Confirm** before finalizing

## After Completion

Feature specs are the input to Phase 4 (Scaffold) and Phase 5 (Fine-tune). The developer can re-run `/define-features` to add or modify features.
