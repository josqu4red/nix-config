{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.system.kdeconnect;
in {
  options.my.system.kdeconnect.enable = mkEnableOption "kdeconnect";
  config = mkIf cfg.enable {
    programs.kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };
}

