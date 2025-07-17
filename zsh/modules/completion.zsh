# =============================================================================
# Zsh Completion System Configuration
# =============================================================================

# Initialize completion system
autoload -U compinit && compinit

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Completion caching
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache

# Group completions
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%d%b'

# Process completion
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# Directory completion
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*' special-dirs true

# Command completion
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Git completion optimization
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:git-*:*' group-order 'main commands' 'alias commands' 'external commands'

# Salesforce CLI completion (if installed)
if command -v sf >/dev/null 2>&1; then
    # Add Salesforce CLI completions
    eval "$(sf autocomplete:script zsh)"
fi

# Development tools completion
if command -v npm >/dev/null 2>&1; then
    eval "$(npm completion 2>/dev/null || true)"
fi

# Docker completion
if command -v docker >/dev/null 2>&1; then
    zstyle ':completion:*:docker:*' option-stacking yes
    zstyle ':completion:*:docker-*:*' option-stacking yes
fi

# Create cache directory
mkdir -p ~/.zsh/cache
