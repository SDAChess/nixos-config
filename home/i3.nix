{config, pkgs, lib, ...}:
let
  Mod = "Mod4";
  wallpaper = ./wallpaper.png;
in
{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = Mod;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      startup = [{
        command = "${pkgs.feh}/bin/feh --bg-scale ${wallpaper}";
        always = true;
        notification = false;
      }];
    };
  };
}
