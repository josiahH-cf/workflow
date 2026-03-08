# Meta-Prompt: Resume One Routing Item In Fresh Context

Paste this into a fresh coding-agent session at repo root.

```text
You are resuming one routing/governance initiative in this repository with fresh context.

Read these first, in order:
1. tmp/workflow-routing-audit/ROUTING_INDEX.md
2. tmp/workflow-routing-audit/items/<ITEM_ID file from index>
3. README.md
4. Any files listed in the selected item's "Candidate Files" section

Task selection:
- Ask me to choose exactly one open item ID from ROUTING_INDEX.md if I did not provide one.
- If I already provided an item ID, proceed immediately.

Execution rules:
- Work only on the selected item.
- Do not modify deferred items.
- Keep user-facing slash command names unchanged unless explicitly requested.
- Preserve non-disruptive `/continue` behavior unless the selected item explicitly requires a gate.

Implementation flow:
1. Summarize the selected item in 5 bullets: problem, goal, affected files, acceptance criteria, validation plan.
2. Implement all required changes end-to-end.
3. Regenerate derived artifacts if needed (for prompt/command map changes).
4. Run relevant validation commands/tests.
5. Update progress in:
   - tmp/workflow-routing-audit/ROUTING_INDEX.md (status)
   - selected item file (notes, decisions, evidence)
6. Return a concise completion report with:
   - changed files
   - test/validation results
   - follow-up risks or next steps

Definition of done for the selected item:
- Acceptance criteria in its tracker file are met.
- Validation section is executed or explicitly documented with blocker reasons.
- Index and item file both reflect latest status.
```
