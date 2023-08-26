{ lib, pkgs, ... }:
let
  inherit (lib) mkOption types;
in {
  options.my.options = {
    userShell = mkOption {
      type = types.package;
      default = pkgs.bash;
      example = pkgs.zsh;
      description = "Default user shell";
    };
    defaultInterface = {
      name = mkOption {
        type = types.str;
        default = "";
        example = "eth0";
        description = "System's default network interface";
      };
      macAddress = mkOption {
        type = types.strMatching "^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$";
        default = "";
        example = "00:aa:11:bb:22:cc";
        description = "System's default network interface";
      };
    };
  };
}
