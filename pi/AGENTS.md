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
- NEVER add yourself or any AI agent as an author, co-author (`Co-authored-by:`), committer, or contributor in ANY git commits, commit messages, PRs/MRs, or pushes.
- All git commits, pushes, and PR/MR operations must only ever be executed using `glab` or `gh` logged in as the user's respective accounts without any AI contributor attribution.

## All projects live under
`~/Developer` (`personal/`, `work/`, `school/`). No code lives outside it.

## WISS Agent project memory
- Canonical gateway repository: `~/Developer/work/WISSv5-Zeroclaw-VM`.
- Related WISS desktop repository: GitLab `rs31/wiss/wissv5/controller_2.2`.
- WISSv5 Agent is a range-specific operations platform combining a patched ZeroClaw gateway, the WISS desktop app, SQL/database knowledge, Cisco and hardware diagnostics, KUMO/VCM/VCD video operations, power control, reporting/metrics, RAG/memory, Reflection V2, reviewed skill proposals, and an air-gapped cross-range skill registry on NixOS/Docker.
- For every WISS Agent, controller_2.2, WIASA, range installer, KUMO/VCM/VCD, Reflection, registry, report, or WISS infrastructure task, first read `~/.pi/agent/memory/wiss-agent-project.md` completely. Treat it as durable architecture/history context, then verify current Git, GitLab, runtime, security, and issue state before acting.
- Never expose or commit WISS credentials, API keys, static tokens, `local-admin.nix`, runtime reports, or generated artifacts. Historical audit concerns are leads to verify, not automatically current facts.
- Hardware routing, power cycling, missions, network scans, and other disruptive/external actions require explicit operator approval. Never guess device, target-group, route, input, or output identifiers.
