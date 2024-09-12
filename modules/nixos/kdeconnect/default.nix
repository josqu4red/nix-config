{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nxmods.kdeconnect;
in {
  options.nxmods.kdeconnect.enable = mkEnableOption "KDEConnect";

  config = mkIf cfg.enable {
    programs.kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };
}
