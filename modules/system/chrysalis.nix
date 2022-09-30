{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.system.chrysalis;
in {
  options.my.system.chrysalis.enable = mkEnableOption "chrysalis";
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.chrysalis ];
    services.udev.packages = [ pkgs.chrysalis ];
  };
}
