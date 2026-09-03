# dotfiles

Single source of truth for this Mac, managed with **nix-darwin** + **home-manager**.
Tool configs are real, hand-editable files linked live into place; secrets are
encrypted with **sops-nix**.

## Layout

```
.
├── Justfile              # task runner (just rebuild / update / gc / secrets / scan / bootstrap)
├── .sops.yaml            # sops recipients (age key derived from ~/.ssh/id_ed25519)
├── secrets/              # sops-encrypted static secrets
├── scripts/bootstrap.sh  # provision a fresh machine
├── nix-darwin/           # the flake (rebuild target)
│   ├── flake.nix
│   └── modules/
│       ├── darwin/       # system: packages, homebrew, macOS defaults, security, fonts
│       └── home/         # home-manager: shell, git, btop, finder, zed, omp, ghostty, cmux, multiplexers
├── zed/                  # Zed config (settings.json, keymap.json, tasks.json)
├── ghostty/              # terminal palette, read by libghostty inside cmux
├── cmux/                 # cmux app chrome (pane borders, sidebar, badges)
├── tmux/ zellij/ herdr/  # multiplexer configs and session scripts
└── omp/                  # omp (oh-my-pi) config, rules, themes, and custom skills
```

Config files under `zed/`, `ghostty/`, `cmux/`, and `omp/` are symlinked into
`~/.config/*` and `~/.omp/agent` via home-manager `mkOutOfStoreSymlink`, so
edits take effect immediately. No rebuild needed for config-only changes.

## Theme

One palette, `apple-terminal`, defined once in `ghostty/config` and inherited
by everything that renders in a terminal. The 16 ANSI values, the text grays,
the selection and the cursor are Apple's own, lifted from Terminal.app's
`Clear Dark` profile (`Terminal.app/Contents/Resources/Initial Settings/`,
cross checked against a live OSC 4 query). Apple's values are already
desaturated, so the result reads near-monotone with color only where it carries
meaning: green for ok, added, or a command that resolves; red for errors and
removals; yellow for warnings and marked state; cyan for links and types;
bright white for focus.

Two deliberate deviations from Apple: the background is true black instead of
`#191d27`, and Apple's blue-gray `ANSI 0`/`ANSI 8` double as the border and dim
grays that tool chrome needs.

`ghostty/config` sets all 16 ANSI slots, so tools configured against ANSI names
(zsh syntax highlighting, starship, eza, herdr) re-theme themselves when that
file changes. Tools that only accept hex (`cmux/cmux.json`, fzf, bat, delta,
lazygit, btop, tmux, zellij, omp) repeat the palette literally and must be
updated alongside it.

## Usage

```sh
just            # list commands
just rebuild    # apply system + home config
just update     # bump flake inputs
just gc         # garbage-collect old generations
just secrets    # edit encrypted secrets
just scan       # gitleaks secret scan
```

Rebuild directly:
`sudo darwin-rebuild switch --flake ~/.dotfiles/nix-darwin#macbook`

## Fresh machine

Ensure `~/.ssh/id_ed25519` is present (needed to decrypt secrets), then:

```sh
git clone https://github.com/RyanStoffel/dotfiles.git ~/.dotfiles
~/.dotfiles/scripts/bootstrap.sh
```

## Secrets

`.sops.yaml` holds the public age recipient derived from `~/.ssh/id_ed25519.pub`.
sops-nix decrypts at activation using the matching SSH private key. Runtime state
(omp `auth.json`, `sessions/`, `node_modules`) is gitignored, never committed.
