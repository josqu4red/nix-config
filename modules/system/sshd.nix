{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.my.system.sshd;
in {
  options.my.system.sshd.enable = mkEnableOption "sshd";
  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };
  };
}
