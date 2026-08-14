# OMP configuration

Hand-managed Oh My Pi configuration. Home Manager links these files into
`~/.omp/agent`; config-only edits take effect without a rebuild.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yml` | Models, providers, UI, tools, theme, and skill discovery |
| `AGENTS.md` | Global instructions applied to every project |
| `keybindings.json` | Interactive key bindings |
| `themes/catppuccin-mocha.json` | The only maintained custom theme |
| `skills/` | Custom skills, one directory per skill |

Runtime files such as `config.yml.lock`, authentication state, sessions, and
managed skills do not belong here.

## Common changes

- Edit `config.yml` directly for settings.
- Edit `themes/catppuccin-mocha.json` to adjust the theme without creating a variant.
- Add a custom skill under `skills/<skill-name>/SKILL.md`; see `skills/README.md`.
- Run `just rebuild` from the repository root only after changing Home Manager links.
