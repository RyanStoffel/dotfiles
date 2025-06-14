# Dotfiles

My personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Setup

```bash
# Clone the repository
git clone git@github.com:RyanStoffel/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install GNU Stow
brew install stow

# Stow configurations
stow nix-darwin-config  # Nix Darwin configuration
stow .config            # App configurations

# Setup Nix Darwin
darwin-rebuild switch --flake ~/nix-darwin-config

# For SSH, manually create symlinks (keys stay local)
ln -s ../dotfiles/.ssh/known_hosts ~/.ssh/known_hosts
ln -s ../dotfiles/.ssh/known_hosts.old ~/.ssh/known_hosts.old
```

## Structure
```bash
~/dotfiles/
├── .config/            # Application configurations
│   ├── nvim/           # Neovim config (separate repo)
│   ├── kitty/          # Kitty terminal
│   ├── fontconfig/     # Font configuration
│   ├── nix/            # Nix configuration
│   ├── raycast/        # Raycast settings
│   └── gh/             # GitHub CLI
├── .ssh/               # SSH known hosts only
│   ├── known_hosts
│   └── known_hosts.old
├── nix-darwin-config/  # Nix Darwin config (separate repo)
└── .gitignore
```

## What's Managed

### Applications
- **Neovim**: Full Lua configuration with plugins
- **Kitty**: Terminal emulator settings
- **Raycast**: Productivity launcher
- **GitHub CLI**: Authentication and preferences

### System
- **Nix Darwin**: System-level configuration and packages
- **SSH**: Known hosts (keys remain local for security)
- **Fonts**: Font configuration

## Security Notes

- SSH private keys (`id_rsa`, `id_ed25519`) are **not** managed by dotfiles
- Only SSH `known_hosts` files are synced for convenience
- Nix Darwin configuration is kept in a separate private repository

## 📦 Dependencies

- [GNU Stow](https://www.gnu.org/software/stow/) - Symlink farm manager (installed via Homebrew)
- [Nix](https://nixos.org/) - Package manager and system configuration
- [Home Manager](https://github.com/nix-community/home-manager) - User environment management

## 🔄 Usage

### Adding New Configurations
```bash
# Create package directory
mkdir ~/dotfiles/.config/new-app

# Move config files
mv ~/.config/new-app ~/dotfiles/.config/new-app

# Stow it
cd ~/dotfiles
stow .config/new-app
```

## Updating Configurations
```bash
# Edit files directly in dotfiles directory
nvim ~/dotfiles/.config/nvim/init.lua

# Changes are automatically reflected (symlinks!)
# Commit when ready
git add .
git commit -m "Update nvim config"
git push
```

## Managing on Multiple Machines
```bash
# On new machine
git clone git@github.com:RyanStoffel/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install stow and setup everything
brew install stow
stow nix-darwin-config
stow .config

# Setup Nix Darwin
sudo darwin-rebuild switch --flake ~/nix-darwin-config

# For SSH, manually create symlinks (keys stay local)
ln -s ../dotfiles/.ssh/known_hosts ~/.ssh/known_hosts
ln -s ../dotfiles/.ssh/known_hosts.old ~/.ssh/known_hosts.old
```

## Related Repositories
[nvim](https://github.com/RyanStoffel/nvim) - Neovim configuration

[nix-darwin-config](https://github.com/RyanStoffel/nix-darwin-config) - Nix Darwin system configuration

## Notes
- Shell configuration (.zshrc) is managed by Nix Home Manager, not Stow
- GNU Stow is installed via Homebrew for consistent availability
- Font configurations work across macOS and Linux
- Raycast settings include custom scripts and shortcuts

Managed with ❤️ and GNU Stow
