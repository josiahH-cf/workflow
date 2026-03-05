# Specification Workflow

> Referenced from `AGENTS.md`. This is part of the canonical workflow — see `/governance/REGISTRY.md`.

## Workflow

All work flows from specifications:

1. Read `.specify/constitution.md` before any implementation — it is the project's identity
2. Check `/specs/` for the current feature spec (copy `.specify/spec-template.md` when creating new specs)
3. Create or update `/tasks/[feature-id]-[slug].md` during Phase 5 — this is the authoritative execution artifact
4. Write acceptance criteria using `.specify/acceptance-criteria-template.md` as reference
5. Verify all acceptance criteria pass before creating a PR

## Spec Artifacts

- Constitution: `.specify/constitution.md`
- Spec template: `.specify/spec-template.md`
- AC template: `.specify/acceptance-criteria-template.md`
- Per-feature specs: `/specs/[feature-id]-[slug].md`
- Task breakdowns: `/tasks/[feature-id]-[slug].md`
- Decisions: `/decisions/[NNNN]-[slug].md`
- Orchestration state: `/workflow/STATE.json`

## Acceptance Criteria Notation

This project uses **GWT (Given/When/Then)** notation for all acceptance criteria, based on the EARS (Easy Approach to Requirements Syntax) framework.

### Format

```
GIVEN [precondition or initial state],
WHEN [action or event],
THEN [expected outcome or observable result].
```

### EARS Extensions

| Pattern | Use When | Example |
|---------|----------|---------|
| `GIVEN...WHEN...THEN` | Standard behavior | GIVEN a logged-in user, WHEN they click logout, THEN the session is destroyed |
| `WHILE...WHEN...THEN` | State-dependent behavior | WHILE the server is offline, WHEN a request arrives, THEN it is queued locally |
| `WHERE...WHEN...THEN` | Conditional features | WHERE dark mode is enabled, WHEN the page loads, THEN the dark theme is applied |
| `IF...THEN` | Unconditional requirement | IF the input is empty, THEN display a validation error |

### Why GWT?

- **Translatable to tests:** Each GWT criterion maps directly to a test: the GIVEN is the setup, the WHEN is the action, the THEN is the assertion.
- **Machine-verifiable:** Agents can parse GWT format to auto-generate test skeletons.
- **Prevents vague criteria:** Forces specificity about preconditions and expected outcomes.

### Anti-patterns

- ❌ `AC-1: The system should work correctly` — not testable
- ❌ `AC-1: Users should be able to log in` — no precondition or expected outcome
- ✅ `AC-1: GIVEN valid credentials, WHEN the user submits the login form, THEN the system redirects to the dashboard and sets a session cookie`
