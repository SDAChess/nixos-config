{
  description = "My system configuration flake.";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-22.11";
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

  outputs = { self, nixpkgs, home-manager, darwin}:
    {
      nixosConfigurations =
      {
      };
      
      darwinConfigurations = 
      let
        system = "aarch64-darwin";
        pkgs = import nixpkgs { inherit system; };
      in
      {
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
