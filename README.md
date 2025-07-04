# Dotfiles

My personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Setup

```bash
# Clone the repository
git clone git@github.com:RyanStoffel/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Install GNU Stow
brew install stow

# Stow configurations
stow nix-darwin-config  # Nix Darwin configuration
stow app-name           # App configurations

# Setup Nix Darwin
rebuild

# For SSH, manually create symlinks (keys stay local)
ln -s ../dotfiles/.ssh/known_hosts ~/.ssh/known_hosts
ln -s ../dotfiles/.ssh/known_hosts.old ~/.ssh/known_hosts.old
```

## Structure
```bash
~/.dotfiles/
├── fastfetch/
├── fontconfig/
├── gh/
├── ghostty/
├── nix/
├── nix-darwin-config/  # Nix Darwin config (submodule)
│   ├── flake.lock
│   ├── flake.nix
│   ├── home.nix
│   └── README.md
├── nvim/               # Nvim Config (submodule)
│   ├── init.lua
│   ├── lazy-lock.json
│   └── lua/
│       └── plugins/
│       │   ├── alpha.lua
│       │   ├── autopairs.lua
│       │   ├── catppuccin.lua
│       │   ├── cmp.lua
│       │   ├── conform.lua
│       │   ├── lsp.lua
│       │   ├── lspkind.lua
│       │   ├── lualine.lua
│       │   ├── noice.lua
│       │   ├── nvim-tree.lua
│       │   ├── snacks.lua
│       │   ├── telescope.lua
│       │   ├── treesitter.lua
│       │   └── which-key.lua
│       └── rstoffel/
│           └── init.lua
├── raycast/
├── .ssh/               # SSH known hosts only
│   ├── known_hosts
│   └── known_hosts.old
└── .gitignore
└── README.md
```

## What's Managed

### Applications
- **Neovim**: Full Lua configuration with plugins
- **Ghostty**: Terminal emulator settings
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
mkdir ~/.dotfiles/new-app/.config/new-app

# Move config files
mv ~/.config/new-app ~/.dotfiles/new-app/.config/new-app/

# Stow it
cd ~/.dotfiles
stow new-app
```

## Updating Configurations
```bash
# Edit files directly in dotfiles directory
nvim ~/dotfiles/nvim/.config/nvim/init.lua

# Changes are automatically reflected (symlinks!)
# Commit when ready
gaa
gc "Update nvim config"
gp
```

## Managing on Multiple Machines
```bash
# On new machine
git clone git@github.com:RyanStoffel/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Install stow and setup everything
brew install stow
stow nix-darwin-config
stow app-name

# Setup Nix Darwin
rebuild

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
