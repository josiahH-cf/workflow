---
mode: agent
description: "Translate the Compass into a concrete feature set"
tools:
  - read_file
  - create_file
  - replace_string_in_file
  - run_in_terminal
---
<!-- role: derived | canonical-source: meta-prompts/minor/03-define-features.md -->

# Define Features — Phase 3: Feature Definition

Translate the project constitution into a concrete, prioritized feature set through adaptive conversation.

## Prerequisites

- `.specify/constitution.md` must exist and be complete
- If missing, direct developer to run Compass first

## Interview Protocol

**Adaptive interview** — bridge "what the project IS" to "what it DOES."

1. **Read the constitution** — internalize Problem Statement, Core Capabilities, Out-of-Scope
2. **Map capabilities to features:** For each Core Capability, ask: "How would a user interact with this?"
3. **Identify features:** Each must be traceable to a Core Capability, describable in one sentence, independently deliverable
4. **Check boundaries:** Verify features don't conflict with Out-of-Scope items
5. **Prioritize:** Essential for launch vs. deferrable
6. **Handle unmapped features:** If a feature doesn't map to any capability → suggest `/compass-edit` or defer

### Rules

- Ask ONE question at a time
- No implementation details — no libraries, folder structures, or code
- Every feature must map to a constitution capability
- Multiple passes expected

## Outputs

1. Create feature specs using `.specify/spec-template.md` → save to `/specs/[feature-id]-[slug].md`
2. Fill: What and Why, User Stories, Acceptance Criteria, Non-Goals
3. Leave Technical Approach, Task Breakdown, Model Assignment blank (Phases 4–5)
4. Present feature list for review and confirm
