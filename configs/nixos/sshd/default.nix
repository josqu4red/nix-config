{ config, lib, ... }:
let
  inherit (lib) mkOption types;
  cfg = config.custom.sshd;
in {
  options.custom.sshd = {
    passwordAuth = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Allow password authentication";
    };
  };
  config = {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = cfg.passwordAuth;
        PermitRootLogin = "no";
      };
    };
  };
}
