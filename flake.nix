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
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, darwin}:
    let
      linux-pkgs = import nixpkgs {
      	system = "x86_64-linux";
        config.allowUnfree = true;
      };
      darwin-pkgs = import nixpkgs {
      	system = "aarch64-darwin";
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
        pkgs = linux-pkgs;
      	system = "x86_64-linux";
      in
      {
        thompson = lib.nixosSystem {
	  inherit pkgs system;
          modules = [ 
            ./thompson
          ] ++ sharedModules; 
        };
        stroustrup = lib.nixosSystem {
	  inherit pkgs system;
          modules = [ 
            ./stroustrup
          ] ++ sharedModules;
        };
      };
      
      darwinConfigurations = 
      let
        pkgs = darwin-pkgs;
        system = "aarch64-darwin";
      in
      {
        wozniak = darwin.lib.darwinSystem {
	  inherit pkgs system;
          modules = [ ./wozniak ];
        };
      };
    };
}
