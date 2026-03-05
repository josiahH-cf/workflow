# Phase 3: CI Workflows & Automation

**Status:** done
**Completed:** 2026-03-05
**Depends on:** Phase 1 (AGENTS.md decomposition must be complete)
**Parallelizable with:** Phases 4, 5, 6, 7

## Objective

Add GitHub Actions workflows for four CI agentic patterns: issue-to-PR automation, CI-failure auto-fix, mention-triggered review, and scheduled triage. Plus a Copilot Coding Agent setup steps file.

## Rationale

Best practices identify CI-driven loops as the mechanism that "turns repos into autonomous coding engines." The project currently has only `release-template.yml` (for this scaffold repo) and `repo-checks.yml` (scaffold validation) — no agentic CI workflows that would be installed into consumer projects.

## Context Files to Read First

- `template/governance/REGISTRY.md` — Already references `copilot-setup-steps.yml` and `autofix.yml` but they don't exist in template yet
- `template/AGENTS.md` — The restructured TOC hub (from Phase 1) — workflows should reference it
- `template/workflow/PLAYBOOK.md` — Phase gates that CI workflows must respect
- `template/workflow/BOUNDARIES.md` — (from Phase 1) — NEVER rules CI must enforce
- `building-agents-examples.md` — Search for "CI-driven loops", "copilot-agent", "claude-review", "autofix", "agentic-triage" patterns

## Steps

### Step 1: Create `template/.github/workflows/copilot-setup-steps.yml`

This is the environment setup that runs before every Copilot Coding Agent session.

```yaml
# Copilot Coding Agent — Setup Steps
# Runs before every Copilot agent session to install dependencies and configure environment.
name: "Copilot Setup Steps"
on: workflow_dispatch

jobs:
  setup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      # [PROJECT-SPECIFIC] — Replace with your project's install command
      # Example for Node.js:
      # - uses: actions/setup-node@v4
      #   with:
      #     node-version: '20'
      # - run: npm ci

      # Example for Python:
      # - uses: actions/setup-python@v5
      #   with:
      #     python-version: '3.12'
      # - run: pip install -r requirements.txt

      - name: Verify setup
        run: echo "Environment ready for Copilot Coding Agent"
```

**Note:** This file is heavily project-specific. Provide clear placeholder comments showing the pattern for Node.js, Python, and generic setups.

### Step 2: Create `template/.github/workflows/copilot-agent.yml`

Issue-to-PR automation triggered when an issue is assigned to `@copilot`.

Key design decisions:
- Trigger: `issues` event with `assigned` type, filtered to `copilot` assignee
- Creates a feature branch following the naming convention from `workflow/ROUTING.md`
- Reads AGENTS.md for project context
- Creates a draft PR (never auto-merges)
- Concurrency: one job per issue number to prevent duplicate work
- Timeout: 30 minutes max

```yaml
name: "Copilot Agent — Issue to PR"
on:
  issues:
    types: [assigned]

concurrency:
  group: copilot-issue-${{ github.event.issue.number }}
  cancel-in-progress: true

jobs:
  implement:
    if: github.event.assignee.login == 'copilot'
    runs-on: ubuntu-latest
    timeout-minutes: 30
    permissions:
      contents: write
      pull-requests: write
      issues: read
    steps:
      - uses: actions/checkout@v4

      # [PROJECT-SPECIFIC] — Add your setup steps here or reference copilot-setup-steps.yml
      # - uses: actions/setup-node@v4
      # - run: npm ci

      - name: Read project context
        run: |
          echo "Reading AGENTS.md for project conventions..."
          cat AGENTS.md

      # The Copilot Coding Agent handles the rest:
      # - Reads the issue description
      # - Creates a feature branch (copilot/feat-<issue-number>-<slug>)
      # - Implements the changes following AGENTS.md conventions
      # - Opens a draft PR linking back to the issue
      # - Runs tests per workflow/PLAYBOOK.md gates

      # Note: This workflow provides the trigger and environment.
      # The actual Copilot Coding Agent orchestration is managed by GitHub.
      # See: https://docs.github.com/en/copilot/using-github-copilot/using-copilot-coding-agent
```

### Step 3: Create `template/.github/workflows/claude-review.yml`

Mention-triggered review using Claude Code Action.

```yaml
name: "Claude Review — Mention Triggered"
on:
  pull_request:
    types: [opened, synchronize]
  issue_comment:
    types: [created]

concurrency:
  group: claude-review-${{ github.event.pull_request.number || github.event.issue.number }}
  cancel-in-progress: true

jobs:
  review:
    if: >
      github.event_name == 'pull_request' ||
      (github.event_name == 'issue_comment' &&
       github.event.issue.pull_request &&
       contains(github.event.comment.body, '@claude'))
    runs-on: ubuntu-latest
    timeout-minutes: 15
    permissions:
      contents: read
      pull-requests: write
      issues: write
    steps:
      - uses: actions/checkout@v4

      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Review this PR against the project's acceptance criteria.
            Read AGENTS.md for project conventions.
            Read workflow/BOUNDARIES.md for behavioral rules.
            For each acceptance criterion, verify:
            1. A corresponding test exists
            2. The test is meaningful (not a tautology)
            3. The implementation matches the spec
            Output a PASS/FAIL verdict per criterion.
          claude_args: "--max-turns 5"
```

### Step 4: Create `template/.github/workflows/autofix.yml`

CI-failure auto-fix loop.

```yaml
name: "Auto-Fix — CI Failure Recovery"
on:
  workflow_run:
    workflows: ["CI"]  # [PROJECT-SPECIFIC] — Name of your CI workflow
    types: [completed]

concurrency:
  group: autofix-${{ github.event.workflow_run.head_branch }}
  cancel-in-progress: true

jobs:
  auto-fix:
    if: >
      github.event.workflow_run.conclusion == 'failure' &&
      github.event.workflow_run.head_branch != 'main'
    runs-on: ubuntu-latest
    timeout-minutes: 20
    permissions:
      contents: write
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ github.event.workflow_run.head_branch }}

      # [PROJECT-SPECIFIC] — Add your setup steps
      # - uses: actions/setup-node@v4
      # - run: npm ci

      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            CI failed on branch ${{ github.event.workflow_run.head_branch }}.
            Analyze the CI failure logs and fix the issue.
            Keep changes small and surgical — fix only what broke.
            Read AGENTS.md for project conventions.
            Do NOT make unrelated changes.
          claude_args: "--max-turns 3"
          # Safety: limited turns prevent runaway sessions

      # Note: The Claude Code Action will push fixes directly.
      # Human review is still required before merge (branch protection).
      # Max 3 turns prevents cost explosion.
      # This workflow only triggers on non-main branches.
```

### Step 5: Create `template/.github/workflows/agentic-triage.yml`

Scheduled autonomous triage (read-only by default).

```yaml
name: "Agentic Triage — Weekly Issue Review"
on:
  schedule:
    - cron: '0 9 * * 1'  # Every Monday at 9:00 UTC
  workflow_dispatch:  # Manual trigger for testing

jobs:
  triage:
    runs-on: ubuntu-latest
    timeout-minutes: 10
    permissions:
      issues: write
    steps:
      - uses: actions/checkout@v4

      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Review all open issues without labels.
            For each issue:
            1. Suggest appropriate labels (type:feature, type:bug, size:S/M/L)
            2. Write a one-paragraph summary comment
            3. If the issue matches a spec in /specs/, note the connection
            Do NOT modify code. Do NOT close issues. Read-only triage only.
            Read AGENTS.md for project conventions and label taxonomy.
          claude_args: "--max-turns 3"
```

### Step 6: Update `template/governance/REGISTRY.md`

Add all new CI files to the CI/CD Files section:

```markdown
## CI/CD Files

- `/.github/workflows/copilot-setup-steps.yml` — Environment setup for Copilot Coding Agent
- `/.github/workflows/copilot-agent.yml` — Issue-to-PR automation via @copilot assignment
- `/.github/workflows/claude-review.yml` — Mention-triggered PR review via @claude
- `/.github/workflows/autofix.yml` — CI-failure auto-fix loop
- `/.github/workflows/agentic-triage.yml` — Scheduled issue triage (read-only)
```

## Verification Checklist

- [ ] `template/.github/workflows/copilot-setup-steps.yml` exists with project-specific placeholders
- [ ] `template/.github/workflows/copilot-agent.yml` exists with concurrency group, timeout, draft PR
- [ ] `template/.github/workflows/claude-review.yml` exists with `@claude` trigger, max-turns limit
- [ ] `template/.github/workflows/autofix.yml` exists with failure trigger, non-main filter, max 3 turns
- [ ] `template/.github/workflows/agentic-triage.yml` exists with weekly cron, read-only scope
- [ ] All workflows have `concurrency` groups to prevent parallel runs
- [ ] All workflows have `timeout-minutes` set
- [ ] No workflow can merge without human approval (no auto-merge actions)
- [ ] Secret references use `${{ secrets.* }}` pattern (not hardcoded)
- [ ] `template/governance/REGISTRY.md` lists all 5 new workflow files
- [ ] All YAML is valid (no syntax errors)

## Completion

When all verification checks pass, update this file:
- Change `**Status:** not-started` to `**Status:** done`
- Add completion timestamp
