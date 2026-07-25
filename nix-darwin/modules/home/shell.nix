{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 50000;
    shellAliases = {
      ls = "eza --icons";
      ll = "eza -la --icons";
      cat = "bat";
      rebuild = "sudo darwin-rebuild switch --flake ~/.dotfiles/nix-darwin#macbook";
      lg = "lazygit";
      cd = "z";
      dots = "cd ~/.dotfiles";
      sshvm = "TERM=xterm-256color ssh vm";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$character";
      character.success_symbol = "[>](bold green)";
      character.error_symbol = "[>](bold red)";
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f";
  };
}
