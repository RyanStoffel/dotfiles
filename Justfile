# ~/.dotfiles task runner — run `just` to list commands.
set shell := ["zsh", "-cu"]

flake := env_var('HOME') / ".dotfiles/nix-darwin"
host  := "macbook"

# List available commands
default:
    @just --list

# Rebuild and switch the system + home config
rebuild:
    sudo darwin-rebuild switch --flake "{{flake}}#{{host}}"

# Build without switching (validate the config)
build:
    darwin-rebuild build --flake "{{flake}}#{{host}}"

# Update all flake inputs to latest
update:
    nix flake update --flake "{{flake}}"

# Format all nix files
fmt:
    nix run nixpkgs#nixpkgs-fmt -- "{{flake}}"

# Garbage-collect generations older than 14 days
gc:
    sudo nix-collect-garbage --delete-older-than 14d
    nix-collect-garbage --delete-older-than 14d

# Edit the encrypted secrets file
secrets:
    cd "{{justfile_directory()}}" && sops secrets/secrets.yaml

# Scan the repo for leaked secrets
scan:
    nix run nixpkgs#gitleaks -- detect --source "{{justfile_directory()}}" --verbose

# Provision a fresh machine from scratch
bootstrap:
    "{{justfile_directory()}}/scripts/bootstrap.sh"
