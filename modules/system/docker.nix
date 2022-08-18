{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.systemCfg.docker;
in {
  options.systemCfg.docker = {
    enable = mkEnableOption "docker";
    privilegedUsers = mkOption {
      type = types.listOf types.string;
      default = [];
      example = [ "jdoe" ];
      description = "Users allowed to run docker commands";
    };
  };
  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.extraGroups.docker.members = cfg.privilegedUsers;
  };
}
