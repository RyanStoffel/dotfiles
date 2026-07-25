---
description: Review the current diff for bugs, security, error handling
argument-hint: "[staged | working | path]"
---
Review the current changes (default to staged if any are staged, otherwise the working tree; if $1 is a path, scope to it).

Focus, most important first:
- Correctness bugs and logic errors
- Security issues (injection, secrets, auth, unsafe input)
- Error handling and edge cases
- Unnecessary complexity or duplication

Report findings most-severe first with `file:line` references and a concrete fix for each. Be terse. Scope: $ARGUMENTS
