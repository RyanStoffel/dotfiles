# General aliases
alias ll='ls -la'
alias c='clear'
alias cat='bat'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -m'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gp='git push'
alias gpl='git pull'
alias gpum='git push -u origin main'
alias gpom='git push origin main'
alias gplom='git pull origin main'
alias gcb='git checkout -b'
alias gcom='git checkout main'
alias gbr='git branch -r'
alias gbd='git branch -d'
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias grh='git reset --hard'
alias grs='git reset --soft'
alias gru='git reset HEAD~1'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gr='git remote -v'
alias gac='git add --all && git commit -m'

# Development aliases
# Machine-specific rebuild aliases
if [[ $(uname) == "Darwin" ]]; then
    # MacOS (Apollo) - Nix Darwin
    alias rebuild='darwin-rebuild switch --flake ~/.dotfiles/nixos-apollo && nix-collect-garbage -d'
    alias rebuild-test='darwin-rebuild build --flake ~/.dotfiles/nixos-apollo'
elif [[ -f /etc/nixos/configuration.nix ]]; then
    # NixOS (Artemis) - use absolute paths so they work from anywhere
    alias rebuild='sudo nixos-rebuild switch --flake /home/rstoffel/.dotfiles/nixos-artemis && nix-collect-garbage -d'
    alias rebuild-test='sudo nixos-rebuild test --flake /home/rstoffel/.dotfiles/nixos-artemis'
    alias rebuild-home='home-manager switch --flake /home/rstoffel/.dotfiles/nixos-artemis'
fi
