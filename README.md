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
└── omp/                  # omp (oh-my-pi) config, rules, and custom skills
```

Config files under `zed/`, `ghostty/`, `cmux/`, and `omp/` are symlinked into
`~/.config/*` and `~/.omp/agent` via home-manager `mkOutOfStoreSymlink`, so
edits take effect immediately. No rebuild needed for config-only changes.

## Theme

Every tool is on its stock colors. The single deviation is the terminal
background, set to true black in `ghostty/config`; cmux embeds libghostty and
reads that same file, so the two apps agree. Nothing else pins a palette, which
means tools re-theme themselves on upgrade instead of drifting from a copy of
someone else's hex values kept in this repo.

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
