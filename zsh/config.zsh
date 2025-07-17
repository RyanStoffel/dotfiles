# =============================================================================
# Modular Zsh Configuration
# =============================================================================
# Author: Ryan Stoffel
# Description: Main configuration file that loads all Zsh modules
# Usage: Source this file from your .zshrc or use with nix-darwin
# =============================================================================

# Set ZDOTDIR if not already set
export ZDOTDIR="${ZDOTDIR:-$HOME/.dotfiles/zsh}"

# Ensure the modules directory exists
if [[ ! -d "$ZDOTDIR/modules" ]]; then
    echo "Warning: Zsh modules directory not found at $ZDOTDIR/modules"
    return 1
fi

# =============================================================================
# Load Configuration Modules (Order matters!)
# =============================================================================

# 1. Load environment variables first
source "$ZDOTDIR/modules/environment.zsh"

# 2. Load shell options and behavior
source "$ZDOTDIR/modules/options.zsh"

# 3. Load history configuration
source "$ZDOTDIR/modules/history.zsh"

# 4. Load completion system
source "$ZDOTDIR/modules/completion.zsh"

# 5. Load key bindings
source "$ZDOTDIR/modules/keybindings.zsh"

# 6. Load custom functions
source "$ZDOTDIR/modules/functions.zsh"

# 7. Load aliases (load after functions in case aliases depend on them)
source "$ZDOTDIR/modules/aliases.zsh"

# 8. Load tool integrations last
source "$ZDOTDIR/modules/integrations.zsh"

# =============================================================================
# Local Customizations
# =============================================================================

# Load local customizations if they exist
if [[ -f "$ZDOTDIR/local.zsh" ]]; then
    source "$ZDOTDIR/local.zsh"
fi

# Load machine-specific configurations
if [[ -f "$ZDOTDIR/$(hostname).zsh" ]]; then
    source "$ZDOTDIR/$(hostname).zsh"
fi

# Load work-specific configurations
if [[ -f "$ZDOTDIR/work.zsh" ]]; then
    source "$ZDOTDIR/work.zsh"
fi

# =============================================================================
# Development Environment Detection
# =============================================================================

# Detect if we're in a development environment and load appropriate configs
if [[ -n "$SALESFORCE_PROJECT" || -f "sfdx-project.json" ]]; then
    # Load Salesforce-specific configurations if available
    [[ -f "$ZDOTDIR/salesforce.zsh" ]] && source "$ZDOTDIR/salesforce.zsh"
fi

if [[ -f "package.json" ]]; then
    # Load Node.js-specific configurations if available
    [[ -f "$ZDOTDIR/nodejs.zsh" ]] && source "$ZDOTDIR/nodejs.zsh"
fi

# =============================================================================
# Performance Monitoring (Optional)
# =============================================================================

# Uncomment to enable zsh startup time profiling
# zmodload zsh/zprof

# Add this to the end of the file to see profiling results:
# zprof
