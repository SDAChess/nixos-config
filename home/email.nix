{ config, lib, pkgs, ... }:
let
  name = "Simon Scatton";
  email_perso = "simon.scatton@outlook.fr";
  email_lrde = "sscatton@lrde.epita.fr";
  email_epita = "sscatton@epita.fr";
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
    };
  };

  programs.notmuch = {
    enable = true;
    hooks = { preNew = "mbsync --all"; };
  };
}
