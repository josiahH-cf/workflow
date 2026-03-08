# Workflow Routing Audit

This folder tracks routing/governance improvements that can be implemented one-by-one in fresh AI contexts.

## Scope

Included initiatives:
1. FAST router behavior in `/continue`
2. Launch-level validation at phase ends
3. `/update-workflow` command and update-source diffing
4. Command-name/reference consistency (no user-facing slash command renames)
5. Git worktree lifecycle governance and automation

Excluded for now:
- Reviewer topology questions (deferred intentionally until behavior is clearer)

## Use

1. Open `tmp/workflow-routing-audit/ROUTING_INDEX.md`.
2. Pick one open item ID.
3. Use `tmp/workflow-routing-audit/meta-prompt-resume-item.md` in a fresh context.
4. Implement only that item, validate, then mark status in index + item file.
