# =============================================================================
# Environment Variables and PATH Configuration
# =============================================================================

# Add Doom Emacs to PATH
export PATH="$HOME/.config/emacs/bin:$PATH"

# Development Environment Variables
export EDITOR="nvim"
export BROWSER="open"

# Node.js and Development Tools
# export NODE_ENV="development"

# Java Development (useful for Salesforce development)
# export JAVA_HOME="/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"

# Salesforce CLI Environment Variables
# export SF_AUTOUPDATE_DISABLE=true
# export SF_LOG_LEVEL=debug

# Development project directories (customize as needed)
export DEV_HOME="$HOME/Development"
export PROJECTS_HOME="$HOME/Projects"

# Ensure /usr/local/bin is in PATH for development tools
export PATH="/usr/local/bin:$PATH"

# Add custom scripts directory if it exists
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
