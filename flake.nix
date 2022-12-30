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
          home-manager.verbose = true;
        };
      };

      nixosConfigurations = 
      let 
        sharedModules = 
        [
          home-manager.nixosModule
        ]
        ++ (nixpkgs.lib.attrValues self.nixosModules);
      in
      {
        thompson = lib.nixosSystem {
          inherit system pkgs;
          modules = [ 
            ./thompson
          ] ++ sharedModules; 
        };
        stroustrup = lib.nixosSystem {
          inherit system pkgs;
          modules = [ 
            ./stroustrup
          ] ++ sharedModules;
        };
      };
    };
}
