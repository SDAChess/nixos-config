{ config, lib, pkgs, ... }: {
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.nixpkgs-fmt
      epkgs.vterm
      epkgs.pdf-tools
      epkgs.all-the-icons
      pkgs.mu
    ];
  };
}
