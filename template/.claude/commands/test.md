<!-- role: derived | canonical-source: meta-prompts/minor/07-test.md -->
You are writing and running tests against acceptance criteria from a feature spec. Tests validate behavior — failures become bugs.

Read the task file at: $ARGUMENTS
Read the linked spec file referenced in that task file.
Read `.specify/constitution.md` — verify ACs trace to constitution capabilities.
Read `/AGENTS.md` (Specification Workflow, Core Commands).
Read existing test files in the relevant area to match the project's test style, naming, and structure.

## Writing Tests

For each acceptance criterion in the spec, write at least one test that:
- Asserts the expected behavior described in the criterion.
- Will FAIL right now if the feature has not been implemented.
- Uses a descriptive name that states the expected behavior in plain language.
- Uses the EARS/GWT format from the AC: `When [trigger], the system shall [response]` or `Given/When/Then`.

### Rules

- Every acceptance criterion must have at least one corresponding test. No criterion left untested.
- If writing tests before implementation: all new tests must fail. Tests that pass before implementation are not testing new behavior — rewrite them.
- Follow the existing test patterns in this codebase exactly. Match file location, naming, imports, structure.
- All pre-existing tests must still pass. Only new tests for unimplemented features should fail.
- Do not write implementation code. Not stubs, helpers, or fixtures that implement feature logic.
- Include UI/visual tests where applicable (Puppeteer, Playwright, or project equivalent).

## Running Tests (Post-Implementation)

If the feature has been implemented, run the full test suite and:

1. Compare results against each acceptance criterion — mark pass/fail.
2. **Log failures as bugs:** run `/bug` for each failing criterion with severity and expected vs actual.
3. If behavior deviated from spec but tests pass, update the spec's notes to document the deviation.
4. Verify no regressions — all pre-existing tests still pass.

## After Testing

1. Commit test files with message: `Add tests for [feature-id]-[slug] per spec`.
2. State results: "N of M acceptance criteria verified. K bugs logged."
3. If all pass → next phase. If failures → back to `/implement` with bug references.
