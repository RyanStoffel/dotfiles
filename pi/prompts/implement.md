---
description: Branch, orchestrate 4 subagents, and drive a PR into develop until green
argument-hint: "<feature description>"
---
Implement this feature end-to-end: $ARGUMENTS

Derive a short kebab-case slug from the description (e.g. "add dark mode toggle" -> `add-dark-mode-toggle`).

## 1. Branch
- Ensure the working tree is clean (stash or ask if not).
- `git fetch`, then create the branch off the latest `develop`:
  `git switch develop && git pull && git switch -c feature/<slug>`

## 2. Orchestrate 4 subagents (sequential pipeline)
Run these as subagents, passing each stage's output to the next. Each subagent gets a self-contained prompt including the feature description and the repo path.

1. **planning** — Explore the relevant code, cite files/functions, and produce a numbered implementation plan (reuse existing utilities, note files each step touches, list risks/unknowns). Plan only, no code.
2. **implement** — Execute the plan. Write the code, matching surrounding style. Report every file changed with a short rationale.
3. **testing** — Detect the project's test framework/conventions, add focused tests for the new behavior and edge cases, run them, and iterate until green. Report the final result.
4. **review** — Review the full diff for correctness bugs, security, error handling, and unnecessary complexity. Return findings most-severe first with `file:line` and a concrete fix each.

Apply the review agent's fixes before opening the PR. If planning surfaces blocking unknowns, stop and ask me before implementing.

## 3. Open PR into develop
- Commit with a Conventional Commits message (no attribution/co-author trailers).
- Push and open the PR with `gh pr create --base develop --head feature/<slug>`, filling title + a body that summarizes the change, the test coverage, and the review notes.

## 4. Drive to green (poll loop)
Greptile and CI run on the PR. Loop until everything is green:
- Poll `gh pr checks <pr>` for CI status and `gh pr view <pr> --comments` for Greptile's review comments.
- Address every actionable Greptile comment and any failing check: make the fix, run the relevant tests locally, commit, and push to the same branch.
- Re-poll after each push (allow time for checks/Greptile to re-run). Ignore resolved/nit comments you've already handled.
- Stop when all checks pass and Greptile has no outstanding actionable comments. Report the final PR URL and a summary of what changed across the iterations.

Be terse in status updates. Do not merge the PR — leave it green and ready for me to merge.
