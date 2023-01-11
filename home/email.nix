{ config, lib, pkgs, ... }:
let
  inherit (lib) mapAttrs;
  inherit (builtins) typeOf;
  name = "Simon Scatton";
  email_perso = "simon.scatton@outlook.fr";
  email_lrde = "sscatton@lrde.epita.fr";
  email_prologin = "simon.scatton@prologin.org";

  make_mbsync_channel = patterns:
    (if (typeOf patterns) == "list" then {
      inherit patterns;
    } else {
      farPattern = patterns.far;
      nearPattern = patterns.near;
    }) // {
      extraConfig = {
        Create = "Both";
        Expunge = "Both";
        Remove = "None";
        SyncState = "*";
      };
    };
  make_mbsync_channels = mapAttrs (_: value: make_mbsync_channel value);

  gmail_far_near_patterns = {
    sent = {
      far = "[Gmail]/Sent Mail";
      near = "Sent";
    };
    drafts = {
      far = "[Gmail]/Drafts";
      near = "Drafts";
    };
    junk = {
      far = "[Gmail]/Spam";
      near = "Junk";
    };
    trash = {
      far = "[Gmail]/Trash";
      near = "Trash";
    };
  };
  gmail_mbsync_channels = make_mbsync_channels gmail_far_near_patterns;
in {

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.mu.enable = true;

  accounts.email = {
    accounts = {
      outlook = {
        address = email_perso;
        userName = email_perso;
        realName = name;
        flavor = "plain";
        passwordCommand = "${pkgs.rbw}/bin/rbw get email_perso";
        primary = true;
        mbsync = {
          enable = true;
          create = "maildir";
        };
        mu.enable = true;
        msmtp.enable = true;
        notmuch.enable = true;

        imap = {
          host = "outlook.office365.com";
          port = 993;
          tls.enable = true;
        };

        smtp = {
          host = "smtp.office365.com";
          port = 587;
          tls.enable = true;
          tls.useStartTls = true;
        };
      };

      lrde = {
        address = email_lrde;
        userName = "sscatton";
        realName = name;
        flavor = "plain";
        passwordCommand = "${pkgs.rbw}/bin/rbw get email_lrde";
        mbsync = {
          enable = true;
          create = "maildir";
          extraConfig.account = { AuthMechs = "LOGIN"; };
        };

        mu.enable = true;
        msmtp.enable = true;
        notmuch.enable = true;

        imap = {
          host = "imap.lrde.epita.fr";
          port = 993;
          tls.enable = true;
        };

        smtp = {
          host = "smtp.lrde.epita.fr";
          port = 587;
          tls.enable = true;
          tls.useStartTls = true;
        };
      };

      prologin = {
        address = email_prologin;
        userName = email_prologin;
        realName = name;
        aliases = [ "sda@prologin.org" ];
        flavor = "plain"; # default setting
        passwordCommand = "${pkgs.rbw}/bin/rbw get email_prologin";
        primary = false;
        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
          groups = {
            prologin-main.channels =
              (make_mbsync_channels { main = [ "INBOX" "membres@" ]; })
              // gmail_mbsync_channels;
            prologin-info.channels =
              make_mbsync_channels { info = [ "info@" "info@gcc" ]; };
          };
        };
        msmtp.enable = true;
        mu.enable = true;
        imap = {
          host = "imap.gmail.com";
          port = 993;
          tls.enable = true;
        };
        smtp = {
          host = "smtp.gmail.com";
          port = 465;
          tls.enable = true;
        };
      };
    };
  };

  programs.notmuch = {
    enable = true;
    hooks = { preNew = "mbsync --all"; };
  };
}
