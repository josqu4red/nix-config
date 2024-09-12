{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nxmods.chrysalis;
in {
  options.nxmods.chrysalis.enable = mkEnableOption "Keyboardio Chrysalis configuration tool";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.chrysalis ];
    services.udev.packages = [ pkgs.chrysalis ];
  };
}
