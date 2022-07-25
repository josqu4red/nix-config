{ config, pkgs, ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices.luks-root = {
    device = "/dev/disk/by-label/luks-root";
    preLVM = true;
  };

  networking.hostName = "neutrino";
  networking.networkmanager.enable = true;

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono"]; })
  ];

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
    # gsettings reset org.gnome.desktop.input-sources sources
    # xkbOptions = "caps:swapescape";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  #services.gnome.gnome-online-miners.enable = false;
  #services.gnome.evolution-data-server.enable = false;
  programs.geary.enable = false;
  programs.gnome-terminal.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.sudo.wheelNeedsPassword = false;
  users.users.jamiez = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "docker" "networkmanager" "wheel" ];
  };

  services.fwupd.enable = true;
  services.openssh.enable = true;
  virtualisation.docker.enable = true;

  system.stateVersion = "22.05"; # Did you read the comment?
}