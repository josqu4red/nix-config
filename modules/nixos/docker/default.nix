{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.nxmods.docker;
in {
  options.nxmods.docker = {
    enable = mkEnableOption "Container runtime";
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
  in mkIf cfg.enable {
    virtualisation.${cfg.flavor} = {
      enable = true;
    } // settings.${cfg.flavor};
    environment.systemPackages = [ pkgs."${cfg.flavor}-compose" ];
    users.extraGroups.${cfg.flavor}.members = cfg.privilegedUsers;
    networking.firewall.checkReversePath = false; # https://github.com/NixOS/nixpkgs/issues/298165
  };
}
