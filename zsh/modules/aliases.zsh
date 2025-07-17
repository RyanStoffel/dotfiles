# =============================================================================
# Zsh Aliases
# =============================================================================

# General Aliases
alias ll='ls -la'
alias c='clear'
alias cat='bat'

# =============================================================================
# Git Aliases
# =============================================================================

# Basic git shortcuts
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -m'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'

# Push/Pull shortcuts
alias gp='git push'
alias gpl='git pull'
alias gpum='git push -u origin main'
alias gpom='git push origin main'
alias gplom='git pull origin main'

# Branch management
alias gcb='git checkout -b'
alias gcom='git checkout main'
alias gbr='git branch -r'
alias gbd='git branch -d'

# Stash shortcuts
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'

# Reset shortcuts
alias grh='git reset --hard'
alias grs='git reset --soft'
alias gru='git reset HEAD~1'

# Remote shortcuts
alias gf='git fetch'
alias gfa='git fetch --all'
alias gr='git remote -v'

# Quick commit and push
alias gac='git add --all && git commit -m'

# =============================================================================
# Development Aliases
# =============================================================================

# Nix Aliases
alias rebuild='sudo darwin-rebuild switch --flake ~/nix-darwin-config && nix-collect-garbage -d'

# Salesforce Development Aliases (add your custom ones here)
# alias sf-org-list='sf org list'
# alias sf-deploy='sf project deploy start'
# alias sf-test='sf apex run test'
