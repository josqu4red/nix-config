{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.homeCfg.gpg;
in {
  options.homeCfg.gpg = {
    enable = mkEnableOption "gpg";
  };
  config = mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      mutableKeys = true;
      mutableTrust = true;
      # publicKeys = [
      #   {
      #     source = ./key.asc;
      #     trust = "ultimate"; # unknown, never, marginal, full
      #   }
      # ];
      # settings = {};
    };
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableZshIntegration = true;
      # extraConfig = '''';
      defaultCacheTtl = 21600;
      maxCacheTtl = 43200;
      pinentryFlavor = "gtk2"; # "curses", "tty", "gtk2", "emacs", "gnome3", "qt"
    };
  };
}
