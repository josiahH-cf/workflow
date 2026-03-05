# Major Meta-Prompts

Session-oriented batch prompts that combine multiple workflow phases into sustained deep-work sessions. These are **convenience wrappers**, not canonical sources.

## Files

| File | Slash Command | Covers | Use When |
|------|--------------|--------|----------|
| `01-plan.md` | `/plan-session` | Phases 0-2 (Ideate, Scope, Plan) | Batch-planning multiple features in one sitting |
| `02-build.md` | `/build-session` | Phases 3-4 (Test, Implement) | TDD build session for one feature |
| `03-review-and-ship.md` | `/review-session` | Phases 5-7 (Review, PR, Merge) | Reviewing and shipping completed features |

## Relationship to minor meta-prompts

The canonical source for each phase's logic lives in `meta-prompts/minor/`. These major meta-prompts repackage that logic into longer sessions. If a phase's rules change, update the minor meta-prompt first, then re-sync the major prompts.

## When to use major vs minor

- **Minor (per-phase):** When you want precise control over one phase at a time, or when `/continue` handles orchestration for you.
- **Major (batched):** When you want to sit down and do sustained work across multiple phases without switching sessions.
