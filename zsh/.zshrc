# Created by newuser for 5.9
source ~/.dotfiles/zsh/config.zsh


# Zsh Autosuggestions
if [ -f "${HOME}/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "${HOME}/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Zsh Syntax Highlighting
if [ -f "${HOME}/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "${HOME}/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

