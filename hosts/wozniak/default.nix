{ config, pkgs, ... }:

{
  imports = [ ./homebrew.nix ];

  environment.systemPackages = with pkgs; [ vim wget git ];

  fonts.fontDir.enable = true;

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    fira-code-symbols
    dejavu_fonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.sda = {
    name = "sda";
    home = "/Users/sda";
  };

}
