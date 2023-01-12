{ config, lib, pkgs, ... }:
{
  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome3.adwaita-icon-theme;
    };
    theme = { name = "Adwaita-dark"; };
  };
}
