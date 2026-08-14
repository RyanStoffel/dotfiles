{ lib, ... }:
{
  imports = [
    ./shell.nix
    ./git.nix
    ./finder.nix
    ./launchd.nix
    ./zed.nix
    ./omp.nix
    ./ghostty.nix
  ];

  home.username = "ryanstoffel";
  home.homeDirectory = "/Users/ryanstoffel";
  home.stateVersion = "24.05";
  home.sessionPath = [ "$HOME/.npm-global/bin" ];

  # Single home for all code projects. No code lives outside ~/Developer.
  home.activation.createDevFolders =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p \
        "$HOME/Developer/personal" \
        "$HOME/Developer/work" \
        "$HOME/Developer/school"
    '';
}
