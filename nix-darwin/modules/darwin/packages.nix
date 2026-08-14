{ pkgs, ... }:
{
  environment.systemPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  environment.systemPackages = with pkgs; [
    # navigation and search
    ripgrep
    fd
    fzf
    zoxide
    broot

    # file viewing
    bat
    eza
    jless

    # git
    lazygit
    delta
    gh
    git-absorb
    difftastic

    # system monitoring
    htop
    btop
    procs
    dust
    duf
    bandwhich

    # data manipulation
    jq
    yq
    xh
    hyperfine

    # docs
    tealdeer

    # misc
    tokei
    sd
    watchexec
    python3
    uv

    # dotfiles workflow
    just
    nixpkgs-fmt

    # node runtime (pi-acp adapter for native pi-in-Zed runs via npx)
    nodejs_22

    # secrets management
    sops
    age
    ssh-to-age
    gitleaks

    # editors
    vim
    neovim
  ];
}
