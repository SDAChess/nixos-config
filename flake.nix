{
  description = "My system configuration flake.";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:guibou/nixGL";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, nixgl }: {

    nixosConfigurations = let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ nixgl.overlay ];
      };
      lib = nixpkgs.lib;
    in {
      stroustrup = lib.nixosSystem {
        inherit system pkgs;
        modules = [
          ./hosts/stroustrup
          home-manager.nixosModules.home-manager
          ./stroustrup.nix
        ];
      };
    };
  };
}
