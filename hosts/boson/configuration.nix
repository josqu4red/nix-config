{ config, pkgs, ... }: {
  networking.hostName = "boson";

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

  users.users.jamiez = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };
}
