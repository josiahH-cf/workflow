<!-- role: canonical-source -->
description: Enter edit mode for the Compass (constitution.md)

# Compass Edit — Modify the Project Constitution

The constitution (`.specify/constitution.md`) is read-only during normal workflow. This command is the only sanctioned way to modify it.

## When to Use

- A fundamental project assumption has changed
- The developer explicitly wants to revise the project's identity or boundaries
- A downstream phase revealed that the constitution is incomplete or incorrect

## Protocol

1. **Read** the current constitution in full
2. **Ask** the developer what they want to change and why
3. **Present** the proposed changes as a diff (show old vs new for each section)
4. **Wait for explicit approval** — do not write changes until the developer confirms
5. **Write** the approved changes to `.specify/constitution.md`
6. **Log** the change: what was modified, why, and when

## Constraints

- Only modify sections the developer explicitly approved
- Do not add new sections — the 8-section structure is fixed
- If the change affects downstream specs or features, warn the developer: "This change may affect [list of downstream artifacts]. You may need to re-run /define-features to update feature specs."
- Never modify the constitution silently or as a side effect of another command
