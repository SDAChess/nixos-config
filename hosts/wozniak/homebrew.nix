{ system, pkgs, ... }:
{
  homebrew = {
    enable = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
    casks = [
      "discord"
      "iterm2"
      "firefox"
      "slack"
      "microsoft-teams"
    ];
  };
}
