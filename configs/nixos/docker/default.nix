{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption types;
  cfg = config.custom.docker;
in {
  options.custom.docker = {
    privilegedUsers = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "jdoe" ];
      description = "Users allowed to run docker commands";
    };
    flavor = mkOption {
      type = types.str;
      default = "docker";
      example = "podman";
      description = "Install docker or podman";
    };
  };
  config = let
    settings = {
      docker = {};
      podman = {
        dockerCompat = true;
      };
    };
  in {
    virtualisation.${cfg.flavor} = {
      enable = true;
    } // settings.${cfg.flavor};
    environment.systemPackages = [ pkgs."${cfg.flavor}-compose" ];
    users.extraGroups.${cfg.flavor}.members = cfg.privilegedUsers;
  };
}
