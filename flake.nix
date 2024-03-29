{
  description = "My system configuration flake.";

  inputs = {
    nixpkgs = { 
      url = "github:nixos/nixpkgs/nixos-unstable"; 
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin }: {

    nixosConfigurations = let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      thompson = lib.nixosSystem {
        inherit system pkgs;
        modules = [
          ./hosts/thompson
          home-manager.nixosModules.home-manager
          ./thompson.nix
        ];
      };
    };

    darwinConfigurations = let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      wozniak = darwin.lib.darwinSystem {
        inherit system pkgs;
        modules = [
          ./hosts/wozniak
          home-manager.darwinModules.home-manager
          ./wozniak.nix
        ];
      };
    };
  };
}
