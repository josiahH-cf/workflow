---
mode: agent
description: "Write and run tests against acceptance criteria — failures become bugs"
tools:
  - read_file
  - create_file
  - replace_string_in_file
  - run_in_terminal
---
<!-- role: derived | canonical-source: meta-prompts/minor/07-test.md -->

# Test — Phase 7: Test Against Acceptance Criteria

Write and run tests against acceptance criteria from a feature spec. Failures become bugs.

## Setup

Read the task file at: ${input:filePath:Provide the path to the spec or task file}
Read the linked spec file referenced in that task file.
Read `.specify/constitution.md` — verify ACs trace to constitution capabilities.
Read `AGENTS.md` (Specification Workflow, Core Commands).
Read existing test files in the relevant area to match test style.

## Writing Tests

For each acceptance criterion in the spec, write at least one test that:
- Asserts the expected behavior described in the criterion
- Will FAIL if the feature has not been implemented
- Uses a descriptive name stating the expected behavior in plain language
- Uses EARS/GWT format: `When [trigger], the system shall [response]` or `Given/When/Then`

### Rules

- Every AC must have at least one test. No criterion left untested.
- Pre-implementation: all new tests must fail. Passing tests aren't testing new behavior.
- Follow existing test patterns exactly — file location, naming, imports, structure.
- All pre-existing tests must still pass.
- Do not write implementation code — not stubs, helpers, or fixtures.
- Include UI/visual tests where applicable.

## Running Tests (Post-Implementation)

If the feature is implemented, run the full test suite and:

1. Compare results against each AC — mark pass/fail.
2. **Log failures as bugs** with severity and expected vs actual.
3. If behavior deviated from spec but tests pass, update the spec notes.
4. Verify no regressions.

## After Testing

1. Commit test files: `Add tests for [feature-id]-[slug] per spec`.
2. State: "N of M acceptance criteria verified. K bugs logged."
3. All pass → next phase. Failures → back to implement with bug references.
