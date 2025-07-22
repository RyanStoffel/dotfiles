# Created by newuser for 5.9
source ~/.dotfiles/zsh/config.zsh


# ZSH Plugins
if [ -f "${HOME}/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "${HOME}/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [ -f "${HOME}/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "${HOME}/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
