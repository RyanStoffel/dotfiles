#!/usr/bin/env bash
# Provision a fresh Mac from this repo.
# Assumes: macOS, a working internet connection, and your ~/.ssh/id_ed25519
# key present (needed for sops-nix to decrypt secrets).
set -euo pipefail

REPO="$HOME/.dotfiles"
FLAKE="$REPO/nix-darwin"
HOST="macbook"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

# 1. Xcode command line tools (git, etc.)
if ! xcode-select -p >/dev/null 2>&1; then
  log "Installing Xcode command line tools..."
  xcode-select --install || true
  echo "Finish the CLT install, then re-run this script." && exit 1
fi

# 2. Nix (Determinate installer, with flakes enabled by default)
if ! command -v nix >/dev/null 2>&1; then
  log "Installing Nix (Determinate)..."
  curl --proto '=https' --tlsv1.2 -sSf -L \
    https://install.determinate.systems/nix | sh -s -- install --no-confirm
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# 3. SSH key check (sops-nix decrypts with ~/.ssh/id_ed25519)
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  log "WARNING: ~/.ssh/id_ed25519 not found — sops secrets will not decrypt."
  echo "Copy your existing SSH key over (or restore it) before rebuilding."
fi

# 4. Clone the repo if it isn't here yet
if [ ! -d "$REPO/.git" ]; then
  log "Cloning dotfiles..."
  git clone https://github.com/RyanStoffel/dotfiles.git "$REPO"
fi

# 5. First build+switch via nix-darwin's flake app (darwin-rebuild not yet on PATH)
log "Running first darwin-rebuild switch..."
sudo nix run nix-darwin -- switch --flake "$FLAKE#$HOST"

log "Done. From now on use: just rebuild"
