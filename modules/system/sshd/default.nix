{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.my.system.sshd;
in {
  options.my.system.sshd = {
    enable = mkEnableOption "sshd";
    passwordAuth = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Allow password authentication";
    };
  };
  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = cfg.passwordAuth;
        PermitRootLogin = "no";
      };
    };
  };
}
