{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.my.system.docker;
in {
  options.my.system.docker = {
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
