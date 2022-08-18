{ config, pkgs, ... }: {
  networking.hostName = "boson";

  console = {
    font = "JetBrainsMono Nerd Font";
    #useXkbConfig = true;
    # unknown keysym 'trademark'
    # lk_add_key called with bad keycode -1
  };

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

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.jamiez = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" ];
  };

  services.fwupd.enable = true;
  virtualisation.docker.enable = true;
}
