{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.my.system.desktop;
in {
  options.my.system.desktop = {
    gnome = mkEnableOption "gnome";
    i3 = mkEnableOption "i3";
    layout = mkOption {
      type = types.str;
      default = "us";
      example = "fr";
    };
  };
  config = mkMerge [
    (mkIf (cfg.gnome || cfg.i3) {
      services.xserver = {
        enable = true;
        layout = cfg.layout;
      };
    })
    (mkIf cfg.gnome {
      services.xserver = {
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };
      services.gnome.gnome-online-miners.enable = lib.mkForce false;
      services.gnome.evolution-data-server.enable = lib.mkForce false;
      environment.systemPackages = [ pkgs.gnome.gnome-tweaks ];
    })
    (mkIf cfg.i3 {
      services.xserver = {
        displayManager.lightdm.enable = ! config.services.xserver.displayManager.gdm.enable;
        displayManager.defaultSession = "none+i3";
        windowManager.i3.enable = true;
      };
    })
  ];
}
