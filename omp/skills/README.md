# Custom skills

Each skill lives exactly one directory below this one:

```text
skills/
└── my-skill/
    ├── SKILL.md
    └── references/     # optional supporting files
```

`SKILL.md` needs explicit frontmatter so OMP can discover it:

```markdown
---
name: my-skill
description: Use when a task needs this specific workflow.
---

# My skill

Put concise instructions here.
```

Use lowercase kebab-case for both the directory and `name`. Keep supporting
files inside the skill directory so they are available through
`skill://my-skill/<path>`. OMP scans only the immediate child directories; do
not group skills in additional nesting levels.
