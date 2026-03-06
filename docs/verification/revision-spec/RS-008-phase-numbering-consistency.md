# RS-008 Phase Numbering Consistency

## Goal
Apply consistent `Phase N — Name` naming across workflow artifacts to improve navigability and reduce interpretation drift.

## In Scope
- Numbered phase labels in docs, prompts, and references.
- Cross-file consistency checks.
- File renames to embed phase numbers in filenames.

## Out of Scope
- Changing the underlying lifecycle order.
- Introducing alternate numbering schemes.
- Modifying archived test artifacts in `docs/verification/archive_after_run/`.

## Observable Outcomes
- Phase references are coherent and easy to map across files.
- No mixed naming styles remain in targeted workflow artifacts.
- All meta-prompt and prompt filenames embed phase numbers (`phase-N-name.md`).

## Dependencies
- None.

## Linked Meta-Prompt
- `docs/verification/revision-meta-prompts/08-phase-numbering-consistency.md`

## Status: DONE (2026-03-06)

### Changes Applied

#### 1. Meta-prompt file renames (15 files)
All meta-prompt files renamed from `NN-name.md` to `phase-N-name.md`:
- `01-scaffold-import.md` → `phase-1-scaffold-import.md`
- `02-compass.md` → `phase-2-compass.md`
- `02b-compass-edit.md` → `phase-2b-compass-edit.md`
- `03-define-features.md` → `phase-3-define-features.md`
- `04-scaffold-project.md` → `phase-4-scaffold-project.md`
- `05-fine-tune-plan.md` → `phase-5-fine-tune-plan.md`
- `06-code.md` → `phase-6-code.md`
- `06b-build-session.md` → `phase-6b-build-session.md`
- `07-test.md` → `phase-7-test.md`
- `07b-bug.md` → `phase-7b-bug.md`
- `07c-bugfix.md` → `phase-7c-bugfix.md`
- `07d-review-and-ship.md` → `phase-7d-review-and-ship.md`
- `07e-cross-review.md` → `phase-7e-cross-review.md`
- `08-maintain.md` → `phase-8-maintain.md`
- `09-continue.md` → `phase-9-continue.md`

#### 2. Prompt file renames (14 files)
All Copilot prompt files renamed to embed phase numbers:
- `compass.prompt.md` → `phase-2-compass.prompt.md`
- `compass-edit.prompt.md` → `phase-2b-compass-edit.prompt.md`
- `define-features.prompt.md` → `phase-3-define-features.prompt.md`
- `scaffold.prompt.md` → `phase-4-scaffold.prompt.md`
- `fine-tune.prompt.md` → `phase-5-fine-tune.prompt.md`
- `implement.prompt.md` → `phase-6-implement.prompt.md`
- `build-session.prompt.md` → `phase-6b-build-session.prompt.md`
- `test.prompt.md` → `phase-7-test.prompt.md`
- `bug.prompt.md` → `phase-7b-bug.prompt.md`
- `bugfix.prompt.md` → `phase-7c-bugfix.prompt.md`
- `review-session.prompt.md` → `phase-7d-review-session.prompt.md`
- `cross-review.prompt.md` → `phase-7e-cross-review.prompt.md`
- `maintain.prompt.md` → `phase-8-maintain.prompt.md`
- `continue.prompt.md` → `phase-9-continue.prompt.md`

#### 3. Cross-reference updates (~30 files)
- `scripts/sync-prompts.sh` — Updated `COMMAND_TO_META` mapping + added `COMMAND_TO_PROMPT` mapping
- `meta-prompts/admin/prompt-sync.md` — Updated Cross-Platform Command Map table
- All 14 prompt files — Updated `canonical-source` comment headers
- All 14 Claude command files — Updated `canonical-source` comment headers
- 7 meta-prompt files — Updated inline Copilot prompt references
- `template/AGENTS.md` — Updated all Copilot entry references
- `template/workflow/BOUNDARIES.md` — Updated `bug.prompt.md` reference
- `scripts/install.sh` — Updated Codex reference
- `meta-prompts/phase-6b-build-session.md` — Updated handoff reference
- `docs/verification/revision-spec/RS-003` and `RS-006` — Updated file references
- `docs/verification/error-msg-step-5-fine-tune.md` — Updated prompt link
- `tests/scripts/sync-prompts.bats` — Updated all filename assertions
- `tests/scripts/install.bats` — Updated prompt filename assertions
- `tests/scripts/validate-scaffold.bats` — Updated prompt filename assertions

#### 4. Phase 7b documented in LIFECYCLE.md
Added explicit `7b. Review & Ship` row to the Project-Level Phases table.

#### 5. Phase header consistency verified
All phase headers use consistent `Phase N — Name` format with em-dash separator.
