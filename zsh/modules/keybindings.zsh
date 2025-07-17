# =============================================================================
# Key Bindings and Input Configuration
# =============================================================================

# Use emacs key bindings
bindkey -e

# Completion menu navigation
bindkey '^[[Z' reverse-menu-complete  # Shift+Tab for reverse completion

# History search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# Word movement (Alt+Arrow keys)
bindkey '^[[1;3C' forward-word        # Alt+Right
bindkey '^[[1;3D' backward-word       # Alt+Left

# Line movement
bindkey '^A' beginning-of-line        # Ctrl+A
bindkey '^E' end-of-line              # Ctrl+E

# Delete keys
bindkey '^[[3~' delete-char           # Delete key
bindkey '^H' backward-delete-char     # Backspace
bindkey '^W' backward-kill-word       # Ctrl+W

# Edit command line in editor
autoload -z edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line      # Ctrl+X Ctrl+E

# Additional useful bindings
bindkey '^U' kill-whole-line          # Ctrl+U - kill entire line
bindkey '^K' kill-line                # Ctrl+K - kill to end of line
bindkey '^Y' yank                     # Ctrl+Y - paste

# Development-specific bindings
bindkey '^[s' sudo-command-line       # Alt+S - add sudo to beginning of line

# Function to add sudo to command line
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    elif [[ $BUFFER == $'\n'* ]]; then
        LBUFFER="${LBUFFER#$'\n'}"
        LBUFFER="sudo $LBUFFER"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
