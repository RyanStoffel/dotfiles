export ZDOTDIR="${ZDOTDIR:-$HOME/.dotfiles/zsh}"

if [[ ! -d "$ZDOTDIR/modules" ]]; then
    echo "Warning: Zsh modules directory not found at $ZDOTDIR/modules"
    return 1
fi

# Load modules in specific order
source "$ZDOTDIR/modules/options.zsh"
source "$ZDOTDIR/modules/history.zsh"     
source "$ZDOTDIR/modules/plugins.zsh"    
source "$ZDOTDIR/modules/aliases.zsh"
source "$ZDOTDIR/modules/integrations.zsh"
