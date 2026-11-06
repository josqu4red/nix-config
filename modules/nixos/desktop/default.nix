{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.nxmods.desktop;
in
{
  options.nxmods.desktop = {
    enable = mkEnableOption "desktop";
    gnome = mkEnableOption "gnome";
    sway = mkEnableOption "sway";
  };
  config = mkMerge [
    (mkIf cfg.enable {
      services.xserver = {
        enable = true;
        xkb = {
          layout = "us";
          variant = "altgr-intl";
          options = "caps:swapescape";
        };
      };
    })
    (mkIf cfg.gnome {
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;
      services.gnome.evolution-data-server.enable = lib.mkForce false;
      environment.systemPackages = [ pkgs.gnome-tweaks ];
    })
    (mkIf cfg.sway {
      # session entry, GL and PAM only; the rest lives in the sway home-manager module
      # keep GNOME the default when both are enabled (shared machines)
      services.displayManager.defaultSession = lib.mkIf (!cfg.gnome) "sway";
      programs.sway = {
        enable = true;
        extraOptions = [ "--unsupported-gpu" ]; # silences the nvidia warning
      };
      services.xserver.displayManager.lightdm.enable = !config.services.displayManager.gdm.enable;
      services.blueman.enable = true;
      # file pickers and other portal dialogs; programs.sway adds the wlr portal
      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.lightdm.enableGnomeKeyring = true;
    })
  ];
}
