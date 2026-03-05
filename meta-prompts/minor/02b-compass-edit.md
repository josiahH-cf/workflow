<!-- role: canonical-source -->
<!-- phase: 2 -->
<!-- description: Edit constitution with explicit developer approval -->
# Compass Edit — Modify the Project Constitution

The constitution (`.specify/constitution.md`) is read-only during normal workflow. This command is the only sanctioned way to modify it.

## When to Use

- A fundamental project assumption has changed
- The developer explicitly wants to revise the project's identity or boundaries
- A downstream phase revealed that the constitution is incomplete or incorrect

## Protocol

1. Read the current constitution in full.
2. Ask the developer what they want to change and why.
3. Present proposed changes as a diff (old vs new for each modified section).
4. Wait for explicit approval before writing any edits.
5. Write only approved edits to `.specify/constitution.md`.
6. Log what changed, why, and when.

## Constraints

- Modify only sections explicitly approved by the developer.
- Do not add sections; the 8-section structure is fixed.
- If edits affect downstream specs or tasks, warn the developer and recommend rerunning `/define-features`.
- Never modify the constitution silently or as a side effect of another command.
