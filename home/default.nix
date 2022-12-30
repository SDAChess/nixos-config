{ config, pkgs, lib, ... }:
let
   username = "sda";
   mod = "Mod4";
   wallpaper = ./wallpaper.png;
in
{
  home = {
    stateVersion = "22.11";
    username = username;
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
      gnupg alacritty gcc discord spotify
      pavucontrol binutils spectacle ripgrep
      feh unzip htop rustup neofetch clang-tools
      python311 teams evince slack
    ];
  };


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
      modifier = mod;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      bars = let 
        barConfigPath = config.xdg.configFile."i3status-rust/config-bottom.toml".target;
      in  
      [
        {
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${barConfigPath}";
          position = "bottom";
          fonts = {
            names = ["FiraCode Nerd Font" "FontAwesome6Free"];
            size = 9.0;
          };

          trayOutput = "primary";
        }
      ];
      startup = [
        {
          command = "${pkgs.feh}/bin/feh --bg-scale ${wallpaper}";
          always = true;
          notification = false;
        }
      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "Simon Scatton";
    userEmail = "simon.scatton@epita.fr";
    signing = {
      key = "B8298DA12BEB779EE391229C64E21E63933BA3EC";
      signByDefault = true;
    };
  };

  services = {
    gpg-agent = {
      enable = true;

      enableSshSupport = true;
      pinentryFlavor = "curses";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome3.adwaita-icon-theme;
    };
    theme = {
      name = "Adwaita-dark";
    };
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
      theme = "robbyrussell";
    };
    plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.6.4";
            sha256 = "0h52p2waggzfshvy1wvhj4hf06fmzd44bv6j18k3l9rcx6aixzn6";
          };
        }
        {
          name = "fast-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zdharma";
            repo = "fast-syntax-highlighting";
            rev = "v1.55";
            sha256 = "0h7f27gz586xxw7cc0wyiv3bx0x3qih2wwh05ad85bh2h834ar8d";
          };
        }
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./p10k-config;
          file = "p10k.zsh";
        }
      ];
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [ epkgs.vterm epkgs.pdf-tools ];
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "Fira Code Nerd Font";
        size = 12.0;
      };
    };
  };


  programs.firefox.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
