{
  description = "darwin config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }@inputs:
  let
    system = "aarch64-darwin";
    username = "ryanstoffel";
  in
  {
    darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        ./modules/darwin/packages.nix
        ./modules/darwin/homebrew.nix
        ./modules/darwin/system-defaults.nix
        ./modules/darwin/security.nix
        ./modules/darwin/fonts.nix
        home-manager.darwinModules.home-manager
        {
          system.primaryUser = username;
	  home-manager.backupFileExtension = "hm-backup";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = import ./modules/home/home.nix;
        }
      ];
    };
  };
}
