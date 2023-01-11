{ config, pkgs, ... }:

{
  environment.systemPackages =
    [ 
      pkgs.vim
      pkgs.wget
      pkgs.git
    ];

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = 4;
}
