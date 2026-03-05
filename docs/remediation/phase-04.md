# Phase 4: Issue/PR Templates & Review Pipeline

**Status:** not-started
**Depends on:** Phase 1 (AGENTS.md decomposition must be complete)
**Parallelizable with:** Phases 3, 5, 6, 7

## Objective

Create structured GitHub issue templates (feature, bug, agent-task) that agents can consume reliably, a PR template that enforces merge gate compliance, and agent definition files for review and implementation specialists.

## Rationale

Without structured templates, agents receive unstructured text and must infer intent. Best practices show that structured issue templates with EARS notation and checklist-based PR templates dramatically improve agent accuracy. The REGISTRY.md already references `/.github/pull_request_template.md` and agent files but they don't exist yet.

## Context Files to Read First

- `template/governance/REGISTRY.md` — Lists expected files that don't exist yet
- `template/workflow/PLAYBOOK.md` — Phase gates and Definition of Done (PR template must enforce these)
- `template/workflow/LIFECYCLE.md` — Label conventions for issue templates
- `template/workflow/BOUNDARIES.md` — (from Phase 1) Behavioral rules for agent files
- `template/workflow/ROUTING.md` — (from Phase 1) Agent routing for implementer.agent.md
- `template/specs/_TEMPLATE.md` — Current spec format (issue templates should align)
- `archive/template-legacy/agents/reviewer.v1.md` — Legacy reviewer (reference for new reviewer agent)
- `building-agents-examples.md` — Search for "ISSUE_TEMPLATE", "PULL_REQUEST_TEMPLATE", "reviewer.agent.md"

## Steps

### Step 1: Create `template/.github/ISSUE_TEMPLATE/feature.yml`

GitHub issue form template for feature requests.

```yaml
name: Feature Request
description: Propose a new feature with structured acceptance criteria
labels: ["type:feature", "status:idea"]
body:
  - type: markdown
    attributes:
      value: |
        ## Feature Request
        Describe the feature using structured acceptance criteria.
        This template is optimized for both human and agent consumption.

  - type: input
    id: title
    attributes:
      label: Feature Title
      description: Short descriptive title (2-6 words)
      placeholder: "e.g., User authentication flow"
    validations:
      required: true

  - type: textarea
    id: description
    attributes:
      label: Description
      description: 2-3 sentences describing what this does and why
      placeholder: "Describe the feature and its motivation..."
    validations:
      required: true

  - type: textarea
    id: acceptance-criteria
    attributes:
      label: Acceptance Criteria
      description: "3-7 testable criteria using GIVEN/WHEN/THEN format"
      value: |
        - [ ] AC-1: GIVEN [precondition], WHEN [action], THEN [expected outcome]
        - [ ] AC-2: GIVEN [precondition], WHEN [action], THEN [expected outcome]
        - [ ] AC-3: GIVEN [precondition], WHEN [action], THEN [expected outcome]
    validations:
      required: true

  - type: textarea
    id: affected-areas
    attributes:
      label: Affected Areas
      description: Files, modules, or directories this feature touches
      placeholder: "e.g., src/auth/, tests/auth/, docs/api.md"

  - type: dropdown
    id: priority
    attributes:
      label: Priority
      options:
        - P0 — Must have (blocks launch)
        - P1 — Should have (significant value)
        - P2 — Nice to have (incremental value)
    validations:
      required: true

  - type: textarea
    id: out-of-scope
    attributes:
      label: Out of Scope
      description: Explicitly excluded to prevent scope creep
      placeholder: "e.g., OAuth2 support is planned for a separate feature"

  - type: textarea
    id: constraints
    attributes:
      label: Constraints
      description: Performance targets, backward compatibility, security requirements
```

### Step 2: Create `template/.github/ISSUE_TEMPLATE/bug.yml`

```yaml
name: Bug Report
description: Report a bug with structured reproduction steps
labels: ["type:bug", "severity:tbd"]
body:
  - type: markdown
    attributes:
      value: |
        ## Bug Report
        Provide clear reproduction steps for both human and automated diagnosis.

  - type: input
    id: title
    attributes:
      label: Bug Title
      description: Short description of the bug
      placeholder: "e.g., Login fails with special characters in password"
    validations:
      required: true

  - type: textarea
    id: description
    attributes:
      label: Description
      description: What's wrong?
    validations:
      required: true

  - type: textarea
    id: reproduction
    attributes:
      label: Reproduction Steps
      description: Step-by-step instructions to reproduce
      value: |
        1. 
        2. 
        3. 
    validations:
      required: true

  - type: textarea
    id: expected
    attributes:
      label: Expected Behavior
      description: What should happen?
    validations:
      required: true

  - type: textarea
    id: actual
    attributes:
      label: Actual Behavior
      description: What actually happens?
    validations:
      required: true

  - type: dropdown
    id: severity
    attributes:
      label: Severity
      options:
        - blocking — Prevents core functionality
        - non-blocking — Workaround exists
    validations:
      required: true

  - type: textarea
    id: environment
    attributes:
      label: Environment
      description: OS, runtime version, relevant configuration
      placeholder: "e.g., Ubuntu 24.04, Node.js 20.11, Chrome 124"
```

### Step 3: Create `template/.github/ISSUE_TEMPLATE/agent-task.yml`

Agent-consumable task template for direct agent assignment.

```yaml
name: Agent Task
description: Create a task optimized for autonomous agent execution
labels: ["type:agent-task", "status:idea"]
body:
  - type: markdown
    attributes:
      value: |
        ## Agent Task
        Structured task for autonomous agent execution.
        Assign to @copilot or add to the agent backlog.

  - type: input
    id: title
    attributes:
      label: Task Title
      placeholder: "e.g., Add input validation to API endpoints"
    validations:
      required: true

  - type: textarea
    id: objective
    attributes:
      label: Objective
      description: What should the agent accomplish? (clear, concrete, testable)
    validations:
      required: true

  - type: textarea
    id: acceptance-criteria
    attributes:
      label: Acceptance Criteria
      description: "Testable criteria using GIVEN/WHEN/THEN format"
      value: |
        - [ ] AC-1: GIVEN [precondition], WHEN [action], THEN [expected outcome]
        - [ ] AC-2: GIVEN [precondition], WHEN [action], THEN [expected outcome]
    validations:
      required: true

  - type: textarea
    id: files-to-modify
    attributes:
      label: Files to Modify
      description: List the specific files the agent should work on
      placeholder: |
        - src/api/validation.ts
        - tests/api/validation.test.ts
    validations:
      required: true

  - type: textarea
    id: constraints
    attributes:
      label: Constraints
      description: What the agent must NOT do
      placeholder: "e.g., Do not modify database schema. Do not add new dependencies."

  - type: dropdown
    id: assigned-model
    attributes:
      label: Assigned Model
      description: Which agent should handle this?
      options:
        - claude — Complex reasoning, multi-file changes
        - copilot — UI work, iterative design, documentation
        - codex — Batch operations, migrations, CI/CD
        - auto — Let routing matrix decide
    validations:
      required: true
```

### Step 4: Create `template/.github/PULL_REQUEST_TEMPLATE.md`

PR template enforcing merge gate compliance from PLAYBOOK.md.

```markdown
## Summary

<!-- One paragraph: what changed and why. Link to the issue. -->

Closes #[ISSUE_NUMBER]

## Change Type

- [ ] Feature (new functionality)
- [ ] Bug fix (non-breaking fix)
- [ ] Refactor (no behavior change)
- [ ] Documentation
- [ ] CI/Infrastructure

## Acceptance Criteria Evidence

<!-- Copy ACs from spec. Mark each with test evidence. -->

| AC | Criterion | Test | Result |
|----|-----------|------|--------|
| AC-1 | [description] | [test file::test name] | PASS / FAIL |
| AC-2 | [description] | [test file::test name] | PASS / FAIL |
| AC-3 | [description] | [test file::test name] | PASS / FAIL |

## Checklist

### Required (all must be checked)
- [ ] Linked to an issue or spec
- [ ] All acceptance criteria have corresponding tests
- [ ] All tests pass (`[PROJECT-SPECIFIC test command]`)
- [ ] Lint passes (`[PROJECT-SPECIFIC lint command]`)
- [ ] No files modified outside spec scope
- [ ] No secrets or `.env` files committed
- [ ] Branch follows naming convention (`model/type-description`)

### Review
- [ ] Self-reviewed the diff
- [ ] AI review requested (or `@claude` mentioned)
- [ ] One human approval obtained

## Rollback Plan

<!-- How to revert if this causes issues in production -->

## Notes

<!-- Anything the reviewer should know that isn't obvious from the diff -->
```

### Step 5: Create `template/.github/agents/reviewer.agent.md`

Review specialist agent definition.

```markdown
---
name: reviewer
description: Security and quality review specialist
tools: [read_file, search, list_directory]
---

# Reviewer Agent

You are a code review specialist. Your job is to verify implementations against their specifications with rigor and precision.

## Process

1. Read `AGENTS.md` for project conventions and routing
2. Read `workflow/BOUNDARIES.md` for behavioral rules
3. Identify the feature spec from the PR description or linked issue
4. Read the spec file from `/specs/[feature-id]-[slug].md`
5. Read the task file from `/tasks/[feature-id]-[slug].md`
6. Review the PR diff against each acceptance criterion

## Review Checklist

For each acceptance criterion:
- [ ] A corresponding test exists
- [ ] The test is meaningful (asserts new behavior, not a tautology)
- [ ] The implementation satisfies the criterion
- [ ] No scope creep beyond the spec

## Additional Checks
- [ ] No secrets, credentials, or `.env` files in diff
- [ ] No files modified outside the task's declared file scope
- [ ] Error handling follows project patterns
- [ ] No dead code or debug artifacts
- [ ] Functions are reasonably sized (flag if >50 lines)

## Output Format

```
## Review: [Feature ID]

### AC Verdicts
| AC | Verdict | Evidence |
|----|---------|----------|
| AC-1 | PASS/FAIL | [test name + observation] |
| AC-2 | PASS/FAIL | [test name + observation] |

### Scope Check: PASS/FAIL
### Policy Check: PASS/FAIL
### Overall Verdict: PASS/FAIL

### Notes
[Any concerns, suggestions, or observations]
```

## Rules
- Never approve a PR with a failing AC
- Flag but don't block on style issues
- Do not suggest refactors outside the spec scope
- Reference `workflow/FAILURE_ROUTING.md` for escalation if blocked
```

### Step 6: Create `template/.github/agents/implementer.agent.md`

Implementation specialist agent definition.

```markdown
---
name: implementer
description: Feature implementation specialist following TDD
tools: [read_file, write_file, search, terminal]
---

# Implementer Agent

You are a feature implementation specialist. You build features using Test-Driven Development, one task at a time.

## Process

1. Read `AGENTS.md` for project conventions
2. Read `workflow/ROUTING.md` for branch naming and concurrency rules
3. Read `workflow/COMMANDS.md` for build/test/lint commands
4. Read the assigned task file from `/tasks/[feature-id]-[slug].md`
5. For each task (in order):
   a. Read the relevant source files to understand existing patterns
   b. Write a failing test for the task's acceptance criteria (if not already written)
   c. Implement the minimum code to make the test pass
   d. Run the full test suite
   e. Run lint
   f. Commit with message referencing the task ID: `[feature-id] T-N: description`
   g. Update the task status to complete
6. After all tasks complete, update STATUS counts in the task file

## Rules
- One task per commit
- Run tests before every commit
- Follow existing code patterns — read before writing
- Do not modify files outside the task's declared file scope
- If uncertain about an architectural decision, write it to `/decisions/` first
- Reference `workflow/BOUNDARIES.md` for ALWAYS/ASK/NEVER rules
- Reference `workflow/FAILURE_ROUTING.md` for error recovery
```

### Step 7: Update `template/governance/REGISTRY.md`

Add new files to appropriate sections:

In **Canonical Files** section, add:
```
| `/.github/PULL_REQUEST_TEMPLATE.md` | PR template (extended with v2 sections) | Human maintainer |
```
Note: This entry may already exist in REGISTRY.md — if so, just verify it's accurate.

In **Agent Definition Files** section, update to:
```
- `/.github/agents/implementer.agent.md` — Implementation specialist (TDD, one task at a time)
- `/.github/agents/reviewer.agent.md` — Review specialist (scores against spec ACs)
```
Note: `planner.agent.md` is listed in REGISTRY.md but doesn't exist. Either create it or remove the reference. Recommended: remove it since planning is handled by the orchestrator, not a dedicated agent.

## Verification Checklist

- [ ] `template/.github/ISSUE_TEMPLATE/feature.yml` exists and has required fields (title, description, ACs in GWT format, priority)
- [ ] `template/.github/ISSUE_TEMPLATE/bug.yml` exists and has required fields (title, repro steps, expected/actual, severity)
- [ ] `template/.github/ISSUE_TEMPLATE/agent-task.yml` exists and has required fields (objective, ACs, files to modify, assigned model)
- [ ] `template/.github/PULL_REQUEST_TEMPLATE.md` exists with AC evidence table, checklist, rollback plan
- [ ] `template/.github/agents/reviewer.agent.md` exists with review process and output format
- [ ] `template/.github/agents/implementer.agent.md` exists with TDD process and commit rules
- [ ] Issue template labels match LIFECYCLE.md label conventions (`type:feature`, `type:bug`, `status:idea`, `severity:tbd`)
- [ ] PR template checklist aligns with PLAYBOOK.md Definition of Done
- [ ] Agent files reference valid paths (AGENTS.md, workflow/ROUTING.md, workflow/BOUNDARIES.md, etc.)
- [ ] `template/governance/REGISTRY.md` is updated with all new files
- [ ] Orphaned `planner.agent.md` reference in REGISTRY.md is resolved (removed or file created)
- [ ] All YAML issue templates are syntactically valid

## Completion

When all verification checks pass, update this file:
- Change `**Status:** not-started` to `**Status:** done`
- Add completion timestamp
