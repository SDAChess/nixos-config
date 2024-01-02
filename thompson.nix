{ nixpkgs, pkgs, system, home-manager, darwin, ... }:
let username = "sda";
in {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.sda = {
    imports = [
      ./home/alacritty.nix
      ./home/direnv.nix
      ./home/emacs.nix
      ./home/git.nix
      ./home/i3.nix
      ./home/services.nix
      ./home/zsh.nix
    ];

    home = {
      stateVersion = "23.11";
      username = username;
      homeDirectory = "/home/${username}";
      packages = with pkgs; [
        gnupg
        alacritty
        google-chrome
        discord
        spotify
        pavucontrol
        spectacle
        ripgrep
        feh
        unzip
        htop
        rustup
        neofetch
        clang-tools
        python311
        evince
        nixfmt
      ];
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
