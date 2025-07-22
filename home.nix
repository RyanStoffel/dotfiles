
{ config, pkgs, ... }:

{
  home.username = "rstoffel";
  home.homeDirectory = "/home/rstoffel";

  home.packages = with pkgs; [
    zsh
    zip
    unzip
  ];

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
