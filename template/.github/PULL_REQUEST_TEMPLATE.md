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
