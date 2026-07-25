---
name: dotfiles
description: How to work in Ryan's ~/.dotfiles repo (nix-darwin + home-manager). Use when editing anything under ~/.dotfiles, or config this repo manages, or when a change needs `just rebuild`.
---
# dotfiles (~/.dotfiles)

Single source of truth for this Mac: nix-darwin + home-manager. Public repo.

## Applying changes
- System/home config (anything under `nix-darwin/modules/`): run `just rebuild`
  (= `sudo darwin-rebuild switch --flake ~/.dotfiles/nix-darwin#macbook`).
- Config under `zed/`, `ghostty/`, `pi/`: **live-symlinked** via `mkOutOfStoreSymlink`
  — edits apply immediately, NO rebuild. For pi extensions/themes, run `/reload`.

## Gotchas
- Flakes only see git-tracked files. After adding a NEW file under `nix-darwin/`,
  `git add` it or the build errors ("... not tracked by Git").
- `just` recipes: `rebuild`, `build` (no switch), `update`, `gc`, `fmt`, `secrets`, `scan`.
- Secrets: sops-nix, age key derived from `~/.ssh/id_ed25519`; edit via `just secrets`.
- Never commit runtime/secrets (`auth.json`, `sessions/`, `node_modules`) — gitignored.

## Layout
`nix-darwin/` flake root; `modules/{darwin,home}/`. `zed/ ghostty/ pi/` = live configs.
