{ lib, pkgs, ... }:
{
  imports = [ ./hardware.nix ];

  services.xserver = {
    enable = true;
    layout = "us";
    # Use if change does not apply on gnome
    # /!\ resets input methods
    # gsettings reset org.gnome.desktop.input-sources xkb-options
    # xkbOptions = "caps:swapescape";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  services.gnome.core-utilities.enable = false;
  services.gnome.gnome-online-miners.enable = lib.mkForce false;
  services.gnome.evolution-data-server.enable = lib.mkForce false;
  environment.systemPackages = [ pkgs.gnome.gnome-tweaks ];

  my.system.workstation.enable = true;

  system.stateVersion = "22.05";

  services.flatpak.enable = true;
}
