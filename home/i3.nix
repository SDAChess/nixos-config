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
      keybindings = lib.mkOptionDefault {
       	"${Mod}+Ctrl+L" = "exec --no-startup-id ${pkgs.betterlockscreen}/bin/betterlockscreen -l";
      };
      fonts = {
        names = [ "monospace" ];
        size = 12.0;
      };
      bars = [
        {
          mode = "dock";
          hiddenState = "hide";
          position = "bottom";
          workspaceButtons = true;
          workspaceNumbers = true;
          statusCommand = "${pkgs.i3status}/bin/i3status";
          trayOutput = "primary";
          colors = {
            background = "#000000";
            statusline = "#ffffff";
            separator = "#666666";
            focusedWorkspace = {
              border = "#4c7899";
              background = "#285577";
              text = "#ffffff";
            };
            activeWorkspace = {
              border = "#333333";
              background = "#5f676a";
              text = "#ffffff";
            };
            inactiveWorkspace = {
              border = "#333333";
              background = "#222222";
              text = "#888888";
            };
            urgentWorkspace = {
              border = "#2f343a";
              background = "#900000";
              text = "#ffffff";
            };
            bindingMode = {
              border = "#2f343a";
              background = "#900000";
              text = "#ffffff";
            };
          };
          fonts = {
            names = [ "monospace" ];
            size = 12.0;
          };
        }
      ];
      startup = [{
        command = "${pkgs.feh}/bin/feh --bg-scale ${wallpaper}";
        always = true;
        notification = false;
      }];
    };
  };
}
