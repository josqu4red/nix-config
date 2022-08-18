{ config, lib, pkgs, ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices.luks-root = {
    device = "/dev/disk/by-label/luks-root";
    preLVM = true;
  };

  networking.hostName = "neutrino";

  console = {
    font = "JetBrainsMono Nerd Font";
    useXkbConfig = true;
  };

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
  programs.gnome-terminal.enable = true;
  environment.systemPackages = [ pkgs.gnome.gnome-tweaks ];

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.jamiez = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "docker" "networkmanager" "wheel" ];
  };

  services.fwupd.enable = true;
  virtualisation.docker.enable = true;
}
