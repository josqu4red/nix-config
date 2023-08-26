{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.my.system.podman;
in {
  options.my.system.podman = {
    enable = mkEnableOption "podman";
    privilegedUsers = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "jdoe" ];
      description = "Users allowed to run podman commands";
    };
  };
  config = mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };
    environment.systemPackages = [ pkgs.podman-compose ];
    users.extraGroups.podman.members = cfg.privilegedUsers;
  };
}
