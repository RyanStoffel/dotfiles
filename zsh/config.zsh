# =============================================================================
# Modular Zsh Configuration
# =============================================================================

export ZDOTDIR="${ZDOTDIR:-$HOME/.dotfiles/zsh}"

if [[ ! -d "$ZDOTDIR/modules" ]]; then
    echo "Warning: Zsh modules directory not found at $ZDOTDIR/modules"
    return 1
fi

source "$ZDOTDIR/modules/environment.zsh"
source "$ZDOTDIR/modules/options.zsh"
source "$ZDOTDIR/modules/history.zsh"
source "$ZDOTDIR/modules/completion.zsh"
source "$ZDOTDIR/modules/keybindings.zsh"
source "$ZDOTDIR/modules/functions.zsh"
source "$ZDOTDIR/modules/aliases.zsh"
source "$ZDOTDIR/modules/integrations.zsh"

[[ -f "$ZDOTDIR/local.zsh" ]] && source "$ZDOTDIR/local.zsh"
[[ -f "$ZDOTDIR/$(hostname).zsh" ]] && source "$ZDOTDIR/$(hostname).zsh"
[[ -f "$ZDOTDIR/work.zsh" ]] && source "$ZDOTDIR/work.zsh"

if [[ -n "$SALESFORCE_PROJECT" || -f "sfdx-project.json" ]]; then
    [[ -f "$ZDOTDIR/salesforce.zsh" ]] && source "$ZDOTDIR/salesforce.zsh"
fi

[[ -f "package.json" ]] && [[ -f "$ZDOTDIR/nodejs.zsh" ]] && source "$ZDOTDIR/nodejs.zsh"
