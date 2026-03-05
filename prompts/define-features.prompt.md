---
mode: agent
description: 'Translate constitution into concrete features with priorities'
tools:
  - read_file
  - create_file
  - replace_string_in_file
  - run_in_terminal
---
<!-- role: derived | canonical-source: meta-prompts/minor/03-define-features.md -->
<!-- generated-from-metaprompt -->


# Phase 3 — Define Features

**Objective:** Translate the Compass constitution into a concrete, prioritized feature set. Each feature maps to a constitution capability.

**Trigger:** Phase 2 complete (constitution populated).

**Entry commands:**
- Claude: `/define-features`
- Copilot: `define-features.prompt.md`

---

## What Happens

1. Read `.specify/constitution.md` (all capabilities)
2. Interview the developer to define features that deliver those capabilities
3. For each feature, produce: name, description, Compass capability mapping, priority, scope flag
4. Features that don't map to a constitution capability → explicit deferral or Compass reconsideration
5. No implementation details — this is feature definition, not architecture

## Gate

- At least one feature spec exists in `/specs/` with Compass mapping
- Every constitution capability has at least one feature mapping
- No orphan features (every feature traces to a capability)

## Output

- Feature specs in `/specs/[feature-id]-[slug].md`
- Feature priority order
- Task planning is deferred to `/tasks/[feature-id]-[slug].md` in Phase 5

## See Also

- Constitution: `.specify/constitution.md`
- Spec template: `.specify/spec-template.md`
- v1 equivalent: Phase 1 (Scope) — v2 adds Compass mapping requirement
