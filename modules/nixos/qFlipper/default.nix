{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nxmods.qflipper;
in {
  options.nxmods.qflipper.enable = mkEnableOption "qFlipper";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.qFlipper ];
    services.udev.packages = [ pkgs.qFlipper ];
  };
}
