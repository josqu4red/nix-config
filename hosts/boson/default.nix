{ config, lib, pkgs, ... }:
{
  imports = [ ./hardware.nix ];

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    layout = "fr";
    displayManager.gdm.enable = true;
    displayManager.defaultSession = "none+i3";
    desktopManager.gnome.enable = false;
    windowManager.i3.enable = true;
  };
  hardware.opengl.enable = true;

  my.system.workstation.enable = true;
  my.system.sshd.enable = true;

  system.stateVersion = "22.05";
}
