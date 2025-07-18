# Starship prompt initialization
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# Zoxide (better cd) initialization
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init --cmd cd zsh)"
fi

# Fastfetch system info
if command -v fastfetch >/dev/null 2>&1; then
    fastfetch
fi

# FZF integration
if command -v fzf >/dev/null 2>&1; then
    # Key bindings for fzf
    source <(fzf --zsh) 2>/dev/null || true
    
    # Custom FZF options
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    export FZF_CTRL_T_OPTS='--preview "bat --color=always --style=numbers --line-range=:500 {}"'
    export FZF_ALT_C_OPTS='--preview "tree -C {} | head -200"'
fi


# Node Version Manager (NVM) integration
if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Python virtual environment integration
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# Java version management (jenv)
if command -v jenv >/dev/null 2>&1; then
    eval "$(jenv init -)"
fi

# GitHub CLI completion
if command -v gh >/dev/null 2>&1; then
    eval "$(gh completion -s zsh)"
fi


# Salesforce CLI completion (suppress warnings)
if command -v sf >/dev/null 2>&1; then
    SF_AUTOUPDATE_DISABLE=true eval "$(sf autocomplete:script zsh 2>/dev/null)" || true
fi
