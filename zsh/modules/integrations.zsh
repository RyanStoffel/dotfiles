command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init --cmd cd zsh)"
command -v fastfetch >/dev/null 2>&1 && fastfetch

if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh) 2>/dev/null || true
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    export FZF_CTRL_T_OPTS='--preview "bat --color=always --style=numbers --line-range=:500 {}"'
    export FZF_ALT_C_OPTS='--preview "tree -C {} | head -200"'
fi

if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"
command -v jenv >/dev/null 2>&1 && eval "$(jenv init -)"
command -v gh >/dev/null 2>&1 && eval "$(gh completion -s zsh)"

if command -v sf >/dev/null 2>&1; then
    export SF_AUTOUPDATE_DISABLE=true
    export SF_LOG_LEVEL=error
fi
