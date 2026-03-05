---
mode: agent
description: "Log a bug discovered during any workflow phase — lightweight, never interrupts"
tools:
  - read_file
  - create_file
  - replace_string_in_file
---
<!-- role: canonical-source -->

# Bug — Log a Bug (Any Phase)

Log a bug discovered during any workflow phase. Lightweight — never interrupts the current task.

## Collect Bug Details

Gather these fields (infer from context where possible — ask only if ambiguous):

- **Description:** What's wrong (one sentence)
- **Location:** file:line or component name
- **Phase found:** Which workflow phase discovered this
- **Severity:** `blocking` (stops current task) or `non-blocking` (can continue)
- **Expected:** What should happen
- **Actual:** What does happen
- **Fix-as-you-go:** `yes` (small, safe to fix now) or `no` (needs own spec/branch)

## Log It

Append the entry to the project's bug log (`bugs/LOG.md`) using this format:

```
### BUG-[NNN]: [short description]
- **Location:** [file:line]
- **Phase:** [phase number and name]
- **Severity:** [blocking | non-blocking]
- **Expected:** [expected behavior]
- **Actual:** [actual behavior]
- **Fix-as-you-go:** [yes | no]
- **Status:** open
- **Logged:** [date]
```

## Rules

- Do not fix the bug here — just log it
- If fix-as-you-go = yes AND trivial, note "recommended for immediate fix"
- If severity = blocking, state: "This blocks current task. Run bugfix to resolve."
- If no bug log exists, create `bugs/LOG.md`
- Return to the calling phase immediately after logging
