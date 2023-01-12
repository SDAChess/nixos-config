{config, pkgs, lib, ...}:
let
  Mod = "Mod4";
  wallpaper = ./wallpaper.png;
in
{
  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
        blocks = [
          {
            block = "disk_space";
            path = "/";
            alias = "/";
            info_type = "available";
            unit = "GB";
            interval = 60;
            warning = 20.0;
            alert = 10.0;
          }
          {
            block = "memory";
            display_type = "memory";
            format_mem = "{mem_used_percents}";
            format_swap = "{swap_used_percents}";
          }
          {
            block = "cpu";
            interval = 1;
          }
          {
            block = "load";
            interval = 1;
            format = "{1m}";
          }
          { block = "sound"; }
          {
            block = "time";
            interval = 60;
            format = "%a %d/%m %R";
          }
        ];
      };
    };
  };

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = Mod;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      bars = let
        barConfigPath =
          config.xdg.configFile."i3status-rust/config-bottom.toml".target;
      in [{
        statusCommand =
          "${pkgs.i3status-rust}/bin/i3status-rs ${barConfigPath}";
        position = "bottom";
        fonts = {
          names = [ "FiraCode Nerd Font" "FontAwesome6Free" ];
          size = 9.0;
        };

        trayOutput = "primary";
      }];
      startup = [{
        command = "${pkgs.feh}/bin/feh --bg-scale ${wallpaper}";
        always = true;
        notification = false;
      }];
    };
  };
}
