---
mode: agent
description: 'Log a bug discovered during any workflow phase'
tools:
  - read_file
  - create_file
  - replace_string_in_file
  - run_in_terminal
---
<!-- role: derived | canonical-source: meta-prompts/07b-bug.md -->
<!-- generated-from-metaprompt -->


### BUG-[NNN]: [short description]
- **Location:** [file:line]
- **Phase:** [phase number and name]
- **Severity:** [blocking | non-blocking]
- **Expected:** [expected behavior]
- **Actual:** [actual behavior]
- **Fix-as-you-go:** [yes | no]
- **Status:** open
- **Logged:** [date]
