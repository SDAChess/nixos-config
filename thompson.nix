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
      ./home/email.nix
      ./home/git.nix
      ./home/gtk.nix
      ./home/i3.nix
      ./home/rbw.nix
      ./home/services.nix
      ./home/zsh.nix
    ];

    home = {
      stateVersion = "22.11";
      username = username;
      homeDirectory = "/home/${username}";
      packages = with pkgs; [
        gnupg
        alacritty
        gcc
        discord
        spotify
        pavucontrol
        binutils
        spectacle
        ripgrep
        feh
        unzip
        htop
        rustup
        neofetch
        clang-tools
        python311
        teams
        evince
        slack
        nixfmt
      ];
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
