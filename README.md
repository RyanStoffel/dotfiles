# Dotfiles

My personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Machine-Specific Configurations

- **Apollo** (MacBook): `nixos-apollo/` - Nix Darwin configuration
- **Artemis** (Desktop): `nixos-artemis/` - NixOS configuration

## Quick Setup

### MacOS (Apollo)
```bash
# Clone the repository
git clone git@github.com:RyanStoffel/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Initialize submodules
git submodule update --init --recursive

# Install GNU Stow
brew install stow

# Setup Nix Darwin
rebuild

# Stow configurations
stow fastfetch gh ghostty nvim zsh

# SSH setup (manual symlinks)
ln -s ~/.dotfiles/.ssh/known_hosts ~/.ssh/known_hosts
ln -s ~/.dotfiles/.ssh/known_hosts.old ~/.ssh/known_hosts.old
```

### NixOS (Artemis)
```bash
# Clone the repository
git clone git@github.com:RyanStoffel/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Initialize submodules
git submodule update --init --recursive

# Rebuild system (stow will be installed automatically)
rebuild

# Stow configurations
stow fastfetch gh ghostty nvim zsh

# SSH setup (manual symlinks)
ln -s ~/.dotfiles/.ssh/known_hosts ~/.ssh/known_hosts
ln -s ~/.dotfiles/.ssh/known_hosts.old ~/.ssh/known_hosts.old
```

## Structure
```bash
~/.dotfiles/
├── nixos-apollo/       # MacOS Nix Darwin config (submodule)
│   ├── flake.nix
│   ├── flake.lock
│   ├── home.nix
│   └── README.md
├── nixos-artemis/      # NixOS config (submodule)
│   ├── flake.nix
│   ├── configuration.nix
│   ├── home.nix
│   ├── packages.nix
│   └── hardware-configuration.nix
├── nvim/               # Neovim config (submodule)
├── fastfetch/
├── gh/
├── ghostty/
├── zsh/
├── .ssh/               # SSH known hosts only
└── README.md
```

## Managing Configurations

### Machine-Aware Commands
The aliases automatically detect your machine:

**Apollo (MacOS):**
- `rebuild` - Rebuild Darwin configuration
- `rebuild-test` - Test Darwin configuration

**Artemis (NixOS):**
- `rebuild` - Rebuild NixOS system and home-manager
- `rebuild-test` - Test NixOS configuration
- `rebuild-home` - Rebuild only home-manager

### Syncing Changes
```bash
# Update all dotfiles and submodules
update-dotfiles

# Sync and commit changes
sync-configs
```

## What's Managed

### Applications
- **Neovim**: Full Lua configuration with plugins
- **Ghostty**: Terminal emulator settings
- **GitHub CLI**: Authentication and preferences
- **Zsh**: Shell configuration with modules

### System
- **Nix Darwin** (macOS): System-level configuration and packages
- **NixOS** (Linux): Complete system configuration
- **SSH**: Known hosts (keys remain local for security)
- **Fonts**: Font configuration

## Security Notes

- SSH private keys (`id_rsa`, `id_ed25519`) are **not** managed by dotfiles for security
- Only SSH `known_hosts` files are synced
- Both machine configurations use the same shared dotfiles (nvim, zsh, etc.)
- Configurations are independently version controlled as submodules

## Dependencies

- [GNU Stow](https://www.gnu.org/software/stow/) - Symlink farm manager
- [Nix](https://nixos.org/) - Package manager and system configuration
- [Home Manager](https://github.com/nix-community/home-manager) - User environment management

## Related Repositories

- [nvim](https://github.com/RyanStoffel/nvim) - Neovim configuration
- [nixos-apollo](https://github.com/RyanStoffel/nix-darwin-config) - Nix Darwin system configuration  
- [nixos-artemis](https://github.com/RyanStoffel/nixos-artemis) - NixOS system configuration

Managed with ❤️ and GNU Stow
