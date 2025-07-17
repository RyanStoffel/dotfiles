#!/bin/bash
# =============================================================================
# Zsh Configuration Migration and Setup Script
# =============================================================================

set -e

DOTFILES_DIR="$HOME/.dotfiles"
ZSH_CONFIG_DIR="$DOTFILES_DIR/zsh"
NIX_DARWIN_CONFIG="$HOME/nix-darwin-config"

echo "🚀 Setting up modular Zsh configuration..."

# Check if required directories exist
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "❌ Error: Dotfiles directory not found at $DOTFILES_DIR"
    exit 1
fi

if [[ ! -d "$ZSH_CONFIG_DIR" ]]; then
    echo "❌ Error: Zsh configuration directory not found at $ZSH_CONFIG_DIR"
    exit 1
fi

# Backup existing configuration
echo "📦 Creating backup of existing configuration..."
if [[ -f "$HOME/.zshrc" ]]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    echo "✅ Backed up existing .zshrc"
fi

# Update nix-darwin configuration if it exists
if [[ -d "$NIX_DARWIN_CONFIG" ]]; then
    echo "🔧 Updating nix-darwin configuration..."
    
    # Backup the current home.nix
    cp "$NIX_DARWIN_CONFIG/home.nix" "$NIX_DARWIN_CONFIG/home.nix.backup.$(date +%Y%m%d_%H%M%S)"
    
    echo "✅ Backed up existing home.nix"
    echo "📝 Please update your home.nix file to use the modular configuration"
    echo "   The new configuration should replace the existing zsh section with:"
    echo ""
    echo "   programs.zsh = {"
    echo "     enable = true;"
    echo "     initContent = ''"
    echo "       source \"\$HOME/.dotfiles/zsh/config.zsh\";"
    echo "     '';"
    echo "     plugins = [ /* your existing plugins */ ];"
    echo "   };"
    echo ""
fi

# Create local configuration file from example
if [[ ! -f "$ZSH_CONFIG_DIR/local.zsh" ]]; then
    echo "📄 Creating local configuration file..."
    cp "$ZSH_CONFIG_DIR/local.zsh.example" "$ZSH_CONFIG_DIR/local.zsh"
    echo "✅ Created local.zsh from example template"
fi

# Set up symlinks for easy access
echo "🔗 Setting up convenient symlinks..."
mkdir -p "$HOME/.local/bin"

cat > "$HOME/.local/bin/zsh-reload" << 'EOF'
#!/bin/bash
# Quick script to reload zsh configuration
echo "🔄 Reloading Zsh configuration..."
source "$HOME/.dotfiles/zsh/config.zsh"
echo "✅ Configuration reloaded!"
EOF

chmod +x "$HOME/.local/bin/zsh-reload"

cat > "$HOME/.local/bin/zsh-edit" << 'EOF'
#!/bin/bash
# Quick script to edit zsh configuration modules
MODULE="${1:-config}"
CONFIG_DIR="$HOME/.dotfiles/zsh"

case "$MODULE" in
    "aliases")
        $EDITOR "$CONFIG_DIR/modules/aliases.zsh"
        ;;
    "functions")
        $EDITOR "$CONFIG_DIR/modules/functions.zsh"
        ;;
    "environment")
        $EDITOR "$CONFIG_DIR/modules/environment.zsh"
        ;;
    "local")
        $EDITOR "$CONFIG_DIR/local.zsh"
        ;;
    "salesforce" | "sf")
        $EDITOR "$CONFIG_DIR/salesforce.zsh"
        ;;
    "config" | "main")
        $EDITOR "$CONFIG_DIR/config.zsh"
        ;;
    "list")
        echo "Available modules:"
        echo "  aliases     - Shell aliases"
        echo "  functions   - Custom functions"
        echo "  environment - Environment variables"
        echo "  local       - Local customizations"
        echo "  salesforce  - Salesforce development config"
        echo "  config      - Main configuration file"
        ;;
    *)
        echo "Usage: zsh-edit {module|list}"
        echo "Run 'zsh-edit list' to see available modules"
        ;;
esac
EOF

chmod +x "$HOME/.local/bin/zsh-edit"

# Test the configuration
echo "🧪 Testing new configuration..."
if zsh -c "source '$ZSH_CONFIG_DIR/config.zsh' && echo 'Configuration loads successfully!'" >/dev/null 2>&1; then
    echo "✅ Configuration test passed!"
else
    echo "❌ Configuration test failed. Please check for syntax errors."
    exit 1
fi

echo ""
echo "🎉 Modular Zsh configuration setup complete!"
echo ""
echo "Next steps:"
echo "1. Update your home.nix file (if using nix-darwin)"
echo "2. Run 'darwin-rebuild switch --flake ~/nix-darwin-config' (if using nix-darwin)"
echo "3. Or add 'source \$HOME/.dotfiles/zsh/config.zsh' to your .zshrc"
echo "4. Restart your terminal or run 'zsh-reload'"
echo "5. Customize your configuration in ~/.dotfiles/zsh/local.zsh"
echo ""
echo "Available commands:"
echo "  zsh-edit {module}  - Edit specific configuration modules"
echo "  zsh-reload         - Reload configuration"
echo ""
echo "For Salesforce development, check out the specialized configuration in:"
echo "  ~/.dotfiles/zsh/salesforce.zsh"
echo ""
echo "Happy coding! 🚀"
