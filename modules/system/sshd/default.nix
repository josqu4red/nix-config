{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.system.sshd;
in {
  options.my.system.sshd.enable = mkEnableOption "sshd";
  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
