# Pull Request

## What

<!-- One sentence: what does this PR do? -->

## Feature Linkage

- Feature ID: [issue-id]-[slug]
- Spec: /specs/[feature-id]-[slug].md
- Tasks: /tasks/[feature-id]-[slug].md
- Decisions (if any): /decisions/[NNNN]-[slug].md

## Why

<!-- Link to spec: /specs/[feature-name].md -->

## Changes

<!-- Bullet list of logical changes, grouped by area -->

## Testing

- [ ] All acceptance criteria from the spec have corresponding tests
- [ ] All tests pass locally
- [ ] No existing tests were modified to accommodate new behavior
- [ ] Linting and formatting checks pass

## Criteria Coverage

<!-- Map acceptance criteria to test evidence -->

- AC-1 -> [test/suite name]
- AC-2 -> [test/suite name]
- AC-3 -> [test/suite name]

## Non-Code Checks

- [ ] Spec acceptance criteria are all addressed (compare spec vs task completion)
- [ ] Diff is under 300 lines
- [ ] No files changed outside the declared scope (compare "Affected Areas" in spec vs files in diff)
- [ ] Commit messages reference the spec or task file
- [ ] No TODOs or placeholder text in the diff
- [ ] No new dependencies added without justification
- [ ] Rollback path is documented below

## Verification

<!-- How can a reviewer verify beyond reading the diff? -->

- Commands run:
  - [install/build/lint/test commands]
- Evidence summary:
  - [what passed, where to find output]

## Rollback

<!-- Special steps beyond git revert? If none, write "Standard revert." -->
