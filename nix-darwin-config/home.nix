{ config, pkgs, lib, ... }:
{
  home.username = "rstoffel";
  home.homeDirectory = "/Users/rstoffel";
  programs.zsh = {
    enable = true;
    shellAliases = {
			# General Aliases
      ll = "ls -la";

			# Basic git shortcuts
    	gs = "git status";
    	ga = "git add";
    	gaa = "git add --all";
    	gc = "git commit -m";
    	gco = "git checkout";
    	gb = "git branch";
    	gd = "git diff";
    	gl = "git log --oneline --graph --decorate";

    	# Push/Pull shortcuts
    	gp = "git push";
    	gpl = "git pull";
    	gpum = "git push -u origin main";      # Push and set upstream to main
    	gpom = "git push origin main";         # Push to main
    	gplom = "git pull origin main";        # Pull from main

    	# Branch management
    	gcb = "git checkout -b";               # Create and checkout new branch
    	gcom = "git checkout main";            # Switch to main
    	gbr = "git branch -r";                 # List remote branches
    	gbd = "git branch -d";                 # Delete branch

    	# Stash shortcuts
    	gst = "git stash";
    	gstp = "git stash pop";
    	gstl = "git stash list";

    	# Reset shortcuts
    	grh = "git reset --hard";
    	grs = "git reset --soft";
    	gru = "git reset HEAD~1";              # Undo last commit

    	# Remote shortcuts
    	gf = "git fetch";
    	gfa = "git fetch --all";
    	gr = "git remote -v";

    	# Quick commit and push
    	gacp = "git add --all && git commit -m";  # Add all and commit (needs message)

			# Nix Aliases
			rebuild = "sudo darwin-rebuild switch --flake ~/nix-darwin-config";
    };
    initContent = ''
      # Enable Powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Load powerlevel10k from Homebrew
      if [[ -f "/opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
        source "/opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme"
      fi

      # Load p10k configuration
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.8.0";
          sha256 = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
        };
      }
    ];
  };
  fonts.fontconfig.enable = true;
  home.stateVersion = "23.11";
}
