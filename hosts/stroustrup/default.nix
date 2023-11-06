# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware.bluetooth.enable = true;

  hardware.opengl.setLdLibraryPath = true; 
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  boot.initrd.luks.devices.luksroot = {
    device = "/dev/disk/by-uuid/6b543384-a593-4b67-98ee-b4ded7b1ed60";
    preLVM = true;
    allowDiscards = true;
  };

  networking.hostName = "stroustrup"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  programs.dconf.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ dmenu i3lock ];
    };

    displayManager.gdm.enable = true;

    layout = "fr";
    xkbOptions = "eurosign:e";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  programs.zsh.enable = true;

  users.users.sda = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "dialout" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ vim wget git ];

  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.firefox.enable = true;

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    fira-code-symbols
    dejavu_fonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  

  virtualisation.docker.enable = true;
  virtualisation.containerd.enable = true;
  virtualisation.libvirtd.enable = true;
  systemd.enableUnifiedCgroupHierarchy = false;

  networking.enableIPv6 = false;

  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

