{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true; # for nvidia

  boot.initrd.luks.devices.luks-root = {
    device = "/dev/disk/by-label/luks-root";
    preLVM = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";

  networking.hostName = "boson";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  fonts.fonts = with pkgs; [
    jetbrains-mono
  ];

  console = {
    font = "JetbrainsMono";
    useXkbConfig = true;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  services.xserver.displayManager = {
    gdm.enable = true;
    defaultSession = "none+i3";
  };
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.layout = "fr";

  environment.systemPackages = with pkgs; [
    colordiff
    curl
    git
    gnupg
    tmux
    vim
  ];

  environment.variables = {
    EDITOR = "vim";
  };

  security.sudo.wheelNeedsPassword = false;
  users.users.jamiez = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" ];
  };

  services.fwupd.enable = true;
  services.openssh.enable = true;
  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
