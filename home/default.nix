{ config, pkgs, lib, ... }:
let
  username = "sda";
in {

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

  programs.firefox.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
