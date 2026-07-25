---
description: Stage-aware Conventional Commit
argument-hint: "[scope or extra context]"
---
Create a git commit for the current change.

1. Run `git status` and `git diff --cached`. If nothing is staged, run `git diff`, summarize what changed, and stage the relevant files with `git add` — ask first if the set is ambiguous.
2. Write a concise Conventional Commits message: `type(scope): summary`, imperative mood. Add a short body only if the change genuinely needs explanation. Extra context: $ARGUMENTS
3. Never add co-author or attribution trailers. Show me the message, then commit. Do not push.
