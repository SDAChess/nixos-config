{ nixpkgs, pkgs, system, home-manager, darwin, ... }:
let username = "sda";
in {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.sda = {
    imports = [
      ./home/email.nix
      ./home/zsh.nix
      ./home/git.nix
      ./home/rbw.nix
      ./home/emacs.nix
    ];

    home = {
      stateVersion = "22.11";
      username = username;
      homeDirectory = "/Users/${username}";
      packages = with pkgs; [
        gnupg
        gcc
        ripgrep
        unzip
        htop
        rustup
        neofetch
        clang-tools
        python311
        nixfmt
        rbw
      ];
    };

    home.file.".gnupg/gpg-agent.conf".text = ''
      enable-ssh-support
    '';

    home.file.".gnupg/scdaemon.conf".text = ''
      disable-ccid
      reader-port Yubico
    '';

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
