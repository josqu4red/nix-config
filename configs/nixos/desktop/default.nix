{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.custom.desktop;
in {
  options.custom.desktop = {
    gnome = mkEnableOption "gnome";
    i3 = mkEnableOption "i3";
  };
  config = mkMerge [
    {
      services.xserver = {
        enable = true;
        xkb = {
          layout = "us";
          variant = "altgr-intl";
          options = "caps:swapescape";
        };
      };
    }
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
      services.displayManager.defaultSession = "none+i3";
      services.xserver = {
        displayManager.lightdm.enable = ! config.services.xserver.displayManager.gdm.enable;
        windowManager.i3.enable = true;
      };
      services.blueman.enable = true;
    })
  ];
}
