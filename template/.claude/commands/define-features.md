<!-- role: derived | canonical-source: meta-prompts/03-define-features.md -->
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

### Mandatory Completion Checklist

Before concluding this phase, verify all of the following:

- [ ] At least one `specs/[feature-id]-[slug].md` file has been created (not just discussed)
- [ ] An explicit capability-to-feature coverage list is present (each constitution capability maps to at least one feature)
- [ ] Orphan-feature disposition is documented (any proposed feature that does not trace to a capability is explicitly deferred or triggers a Compass reconsideration)
- [ ] If any of the above are missing, do NOT advance the phase — produce the missing artifacts first

## Output

- Feature specs in `/specs/[feature-id]-[slug].md`
- Feature priority order
- Task planning is deferred to `/tasks/[feature-id]-[slug].md` in Phase 5

## See Also

- Constitution: `.specify/constitution.md`
- Spec template: `.specify/spec-template.md`
