# Phase 0: North Star Alignment + Create Phase Docs

> **Status**: COMPLETE
> **Prereqs**: None
> **Outcome**: All phase docs and orchestrator meta-prompt exist. Golden path is defined.

## Objective

Lock the definition of success and the golden path before touching any repo files. Create all execution artifacts.

## Golden Path Definition

```
install → /compass → /define-features → /scaffold → /fine-tune → /continue
                                                          ↕
                                                    /bug (concurrent)
```

### Phase Purposes (distinct — do not merge these)

| Command | Phase | Answers | Output |
|---------|-------|---------|--------|
| `/compass` | 2 | "Who is this project?" | `.specify/constitution.md` |
| `/define-features` | 3 | "What to build?" | `/specs/*.md` feature specs |
| `/scaffold` | 4 | "How is it structured?" | Architecture in AGENTS.md, decisions/ |
| `/fine-tune` | 5 | "Build order + who does what?" | `/tasks/*.md` with ACs, model assignments, branch naming |
| `/continue` | 6–8 | "Execute the plan" | Code → Test → Review → Ship → next feature |
| `/bug` | concurrent | "Something broke" | `/bugs/LOG.md` entries |

## Actions

1. ✅ Create `docs/simplification/README.md` with phase tracker
2. ✅ Create `docs/simplification/phase-0.md` through `phase-6.md`
3. ✅ Create `meta-prompts/simplify.md` orchestrator
4. ✅ Golden path definition embedded in README.md

## Acceptance Criteria

- [x] All 7 phase docs exist with detailed, actionable instructions
- [x] `docs/simplification/README.md` has phase tracker with checkboxes
- [x] `meta-prompts/simplify.md` orchestrator created
- [x] Golden path definition is clear and agreed upon
- [x] No repo files modified (planning only)

## Next Phase

→ Phase 1: Delete Legacy + Flatten Meta-Prompts + Remove Version Language
