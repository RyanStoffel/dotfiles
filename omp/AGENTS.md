I'm **Ryan Stoffel**. You are *my* agent. We will be working together a lot, so I thought it would be worth introducing myself.

I am a Senior Computer Science student at California Baptist University (CBU). I have had two software engineering internships. One at CAiMLL (CBU Ai & Machine Learning Lab) as a Software Engineer Research Assistant where I worked on Salesforce Production code, and one at NSWC (Navla Surface Warfare Center) Corona as a Software Engineer Intern through NREIP (Naval Research Enterprise Internship Program) where I worked on the WISSv5 Agent that was built using Zeroclaw in a NixOS Virtual Machine.

I love to build. My mind is constantly in work mode, and I love working on software. I focus on building complex things as simple as possible. I love to find ways to reduce complexity when solving problems.

I wanted to share some of my preferences here so we can be more aligned as we work together.

# *Coding Preferences - General*
---
- Keep things simple. Channel "yagni" energy unless told otherwise.
- Typesafety is useful, take advantage of it.
- Don't be scared to propose bold ideas if they can be meaningfully benefit our work.
- Be careful with destructive actions that are not explicitly requested by the user.
- Tests are good! Endless smoke tests, "regression tests" for feature deletions, etc, much less good. Tests should be focused, not slop.
- Comments are a great way to clarify functionality and how code is used. Don't comment every line, but feel free to describe (concisely) how functions are used above function definitions, classes, etc.
- Keep comments up to date! When making changes it is important to keep things in sync.
- Never use any emojis, icons, etc anywhere within code we write, they are tacky and indicate slop.

# *Questions are read-only*
---
- A question is a request for an answer, not for changes. If the message opens with "how hard would it be", "what are your thoughts", "why does", "should we", "is it possible", "can X do Y", or otherwise asks rather than instructs: answer it, and do **not** edit files.
- If the answer is obvious and the change is trivial, still answer first and offer the change. Ask before making it.

# *Match ceremony to the task*
---
- Do not spawn subagents or a multi-agent panel for work a single agent finishes in one pass. Delegation is for breadth or adversarial review, not for ordinary tasks.
- When several agents do work in parallel, state file ownership up front so they do not collide.

# *Visual and design work*
---
- Do not edit real components first.
- Standing constraints: dark mode, true black(#000) background, white primary text. Information-dense, no decorative card/pill chrome, no light-gray subtitle lines above sections. Minimal copy. No em dashes.
- Avoid continuously repainting CSS animations (pulse, shimmer, blur, spinners); they peg the GPU on high-refresh displays.

# *Blast radius*
---
- Never touch production, live databases, or daily-driver build/preview channels unless explicitly told to. When a task is adjacent to any of them, name what you are about to touch before touching it.

# *Pull Requests*
---
- Make sure titles follow conventions from the repo. They should be simple and easy to understand. Conventional commit styles in projects that use them, i.e. "fix(web): new threads no longer spike CPU"
- PR descriptions should aim for simplicity. Open with a minimal, clear description of the problem. Follow up with how you solved it.
- Never attribute yourself (or any AI) in PRS, Commits, etc.
- Open a real PR, not a draft.
- Rebase onto latest `main` or `master` before opening. Stale branches conflict and waste a review round.
- When asked to monitor or babysit a PR: poll checks and comments newer than the last push; verify each bot finding against the source before acting on it; fix real ones and dismiss false positives with a written reason; fix CI failures, distinguising real breaks from known infra flakes. If nothing is new, stay quiet – do not post filler comments. Stop when the repo's review bots are green on the latest commit.
- Merge only per the disposition given in the requst (merge when green, or stop and report). If none was given, report and ask.

# *Git Attribution & Tool Usage*
---
- Never add yourself or any AI agent as an author, co-author (`Co-authored-by:`), committer, or contributor in any git commits, commit messages, pull requests, merge requests, or pushes.
- Git actions, commits, pushes, and PR/MR creations must only ever be executed using `glab` or `gh` logged in as the user's respective accounts, without any AI attribution.