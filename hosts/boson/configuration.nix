{ config, pkgs, ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices.luks-root = {
    device = "/dev/disk/by-label/luks-root";
    preLVM = true;
  };

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
  };
  hardware.opengl.enable = true;

  services.xserver.displayManager = {
    gdm.enable = true;
    defaultSession = "none+i3";
  };
  services.xserver.desktopManager.gnome.enable = false;
  services.xserver.windowManager.i3.enable = true;

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
