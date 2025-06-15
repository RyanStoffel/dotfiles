#!/bin/zsh
# Dotfiles Installation Script
# Automatically sets up the complete development environment

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "This script is designed for macOS only"
    exit 1
fi

log_info "Starting dotfiles installation..."

# Check if we're in the right directory
if [[ ! -f "install.sh" ]] || [[ ! -d ".config" ]]; then
    log_error "Please run this script from the dotfiles directory"
    exit 1
fi

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    log_success "Homebrew installed"
else
    log_info "Homebrew already installed"
fi

# Install Nix if not present
if ! command -v nix &> /dev/null; then
    log_info "Installing Nix..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

    # Source nix
    if [[ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]]; then
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi
    log_success "Nix installed"
else
    log_info "Nix already installed"
fi

# Install GNU Stow
if ! command -v stow &> /dev/null; then
    log_info "Installing GNU Stow..."
    brew install stow
    log_success "GNU Stow installed"
else
    log_info "GNU Stow already installed"
fi

# Backup existing configurations
log_info "Backing up existing configurations..."
backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

# List of files/directories to backup
backup_items=(
    ".config/nvim"
    ".config/kitty"
    ".config/fontconfig"
    ".config/nix"
    ".config/raycast"
    ".config/gh"
    ".ssh/known_hosts"
    ".ssh/known_hosts.old"
    "nix-darwin-config"
)

for item in "${backup_items[@]}"; do
    if [[ -e "$HOME/$item" ]] && [[ ! -L "$HOME/$item" ]]; then
        log_info "Backing up $item"
        mkdir -p "$backup_dir/$(dirname "$item")"
        mv "$HOME/$item" "$backup_dir/$item"
    fi
done

log_success "Backup created at $backup_dir"

# Stow nix-darwin-config first
log_info "Setting up Nix Darwin configuration..."
stow nix-darwin-config

# Apply Nix Darwin configuration
log_info "Applying Nix Darwin configuration (this may take a while)..."
if command -v darwin-rebuild &> /dev/null; then
    sudo darwin-rebuild switch --flake ~/nix-darwin-config
else
    # Install nix-darwin first
    log_info "Installing nix-darwin..."
    sudo nix run nix-darwin -- switch --flake ~/nix-darwin-config
fi
log_success "Nix Darwin configuration applied"

# Stow other configurations
log_info "Setting up application configurations..."
stow .config
log_success "Application configurations stowed"

# Set up SSH known hosts (manual symlinks for security)
log_info "Setting up SSH known hosts..."
if [[ -f ".ssh/known_hosts" ]]; then
    ln -sf ../dotfiles/.ssh/known_hosts ~/.ssh/known_hosts
fi
if [[ -f ".ssh/known_hosts.old" ]]; then
    ln -sf ../dotfiles/.ssh/known_hosts.old ~/.ssh/known_hosts.old
fi
log_success "SSH known hosts configured"

# Final steps
log_info "Performing final setup steps..."

# Reload shell configuration
log_info "Reloading shell configuration..."
if [[ -f ~/.zshrc ]]; then
    source ~/.zshrc 2>/dev/null || true
fi

log_success "Installation completed successfully!"

echo
log_info "Summary:"
echo "Homebrew installed/updated"
echo "Nix and nix-darwin configured"
echo "GNU Stow managing dotfiles"
echo "Application configurations linked"
echo "SSH known hosts configured"
echo "Development tools installed"
echo
log_info "Backup of existing configs: $backup_dir"
echo
log_warning "Please restart your terminal or run 'source ~/.zshrc' to load new configurations"
echo
log_info "Your development environment is ready!"
EOF

# Make the script executable
chmod +x install.sh
