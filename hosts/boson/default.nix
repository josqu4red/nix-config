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

  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  users.users.jamiez = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };

  my.system.workstation.enable = true;

  system.stateVersion = "22.05";
}
