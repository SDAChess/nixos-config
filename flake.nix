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
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosModules = {
        home = {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.sda = import ./home;
        };
      };
      nixosConfigurations = {
        thompson = lib.nixosSystem {
          inherit system pkgs;
          modules = [ 
            ./thompson
            home-manager.nixosModule 
          ];
        };
        stroustrup = lib.nixosSystem {
          inherit system pkgs;
          modules = [ 
            ./stroupstrup
            home-manager.nixosModule 
          ];
        };
      };
    };
}
