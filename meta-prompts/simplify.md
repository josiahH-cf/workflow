# Simplification Orchestrator

> Run this meta-prompt to execute the next phase of the workflow scaffold simplification.
> Each phase is designed for **fresh context** — start a new session per phase.

## Contract

1. Read `docs/simplification/README.md` — identify the **next unchecked phase**
2. Read the corresponding `docs/simplification/phase-N.md` for detailed instructions
3. Execute **every action** in the phase doc, step by step
4. Run the verification commands at the end of the phase doc
5. If all verifications pass, mark the phase complete:
   - Check off the phase in `docs/simplification/README.md` (change `[ ]` → `[x]`)
   - Update the phase doc status from `NOT STARTED` → `COMPLETE`
6. Report: what was done, what was verified, any blockers
7. **STOP** — do not proceed to the next phase. Fresh context is required.

## Rules

- **One phase per session.** Never execute two phases in one session.
- **Follow the phase doc literally.** Every step, every verification, every acceptance criterion.
- **If a step fails**, stop and report the failure. Do not skip steps.
- **If a verification fails**, attempt to fix it. If the fix isn't obvious, report and stop.
- **Commit work at the end of each phase.** Use descriptive commit messages:
  - Phase 1: `refactor: delete legacy workflow, flatten meta-prompts, remove version language`
  - Phase 2: `refactor: trim template, merge workflow docs, delete archive`
  - Phase 3: `refactor: unify installation defaults, rewrite README`
  - Phase 4: `feat: extract sample project to workflow-example repo`
  - Phase 5: `docs: add workflow diagram, verify repo integrity`
  - Phase 6: `chore: remove simplification working docs`

## Context Loading

At the start of each session, read these files to orient:

1. `docs/simplification/README.md` — phase tracker (which phase is current?)
2. `docs/simplification/phase-N.md` — current phase instructions
3. `meta-prompts/simplify.md` — this file (operational contract)

Do NOT read all phase docs — only the current one. Preserve context budget for execution.

## Phase Summary (for orientation only — read the actual phase doc for instructions)

| Phase | Title | Key Action |
|-------|-------|------------|
| 0 | North Star + Docs | Create phase docs + orchestrator *(already complete)* |
| 1 | Delete Legacy + Flatten | Remove ~32 files, flatten meta-prompts/, strip V1/V2 language |
| 2 | Trim + Merge + Archive | Delete archive, merge SPECS→FILE_CONTRACTS, platform files opt-in |
| 3 | Install + Onboarding | Default install includes prompts, rewrite README ≤100 lines |
| 4 | Extract Sample Repo | Move examples/ to `workflow-example` GitHub repo |
| 5 | Diagram + Verification | New Mermaid diagram, comprehensive verification pass |
| 6 | Cleanup | Delete simplification docs + this file |

## When All Phases Are Complete

After Phase 6, this file will no longer exist. The simplification is done.
The repository will have:
- Flat `meta-prompts/` with ~17 files
- `prompts/` with ~15 Copilot slash commands
- Lean template (≤ 60 files default install)
- README ≤ 100 lines
- New workflow diagram
- `workflow-example` linked as reference
- Zero legacy commands, zero version language
- All tests passing
