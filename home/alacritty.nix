{ config, lib, pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "Fira Code Nerd Font";
        size = 12.0;
      };
    };
  };
}
