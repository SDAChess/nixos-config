{ config, lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Simon Scatton";
    userEmail = "simon.scatton@epita.fr";
    signing = {
      key = "B8298DA12BEB779EE391229C64E21E63933BA3EC";
      signByDefault = true;
    };
  };
}
