{ config, lib, pkgs, ... }:

{
  programs.rbw = {
    enable = true;
    settings = {
      email = "simon.scatton@outlook.fr";
      lock_timeout = 60 * 60 * 12;
      pinentry = pkgs.pinentry-qt;
    };
  };
}
