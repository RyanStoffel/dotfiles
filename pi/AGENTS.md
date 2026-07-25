# Global agent rules

These rules apply to every project unless a project-local `AGENTS.md` overrides them.

## Working style
- Be terse. Lead with the answer or the change; skip preamble and restated context.
- Plan before large or multi-file changes: briefly outline the approach, then execute.
  Skip the plan for small, obvious edits.
- Run read-only and safe commands (builds, tests, greps, status) without asking.
  Ask first before anything destructive or hard to reverse.
- When you change behavior, add or update tests that cover it.

## Code
- Never add emojis or icons to code.
- Only add comments when they are genuinely necessary.
- Match the surrounding code's style, naming, and structure.

## Git
- Prefer small, focused commits with conventional commit messages.
- Ask before running destructive git commands.
- Never add yourself as a contributor to commits or pull requests.

## All projects live under
`~/Developer` (`personal/`, `work/`, `school/`). No code lives outside it.
