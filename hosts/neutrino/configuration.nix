{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices.luks-root = {
    device = "/dev/disk/by-label/luks-root";
    preLVM = true;
  };

  networking.hostName = "neutrino"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.utf8";
    LC_IDENTIFICATION = "fr_FR.utf8";
    LC_MEASUREMENT = "fr_FR.utf8";
    LC_MONETARY = "fr_FR.utf8";
    LC_NAME = "fr_FR.utf8";
    LC_NUMERIC = "fr_FR.utf8";
    LC_PAPER = "fr_FR.utf8";
    LC_TELEPHONE = "fr_FR.utf8";
    LC_TIME = "fr_FR.utf8";
  };

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

  environment.systemPackages = with pkgs; [ bc colordiff curl dig git htop jq less lsof ncdu nettools rsync screen socat strace sysstat tmux unzip vim ];
  environment.variables = {
    EDITOR = "vim";
    PAGER = "less";
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
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
    enableSSHSupport = true;
  };
  services.printing.enable = true;

  system.stateVersion = "22.05"; # Did you read the comment?
}
