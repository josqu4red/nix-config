{ pkgs, users, ... }: {
  imports = [ ../base ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.bluetooth.enable = true;
  services.udisks2.enable = true;

  networking.networkmanager.enable = true;
  networking.resolvconf.enable = false;
  services.resolved.enable = true;
  users.extraGroups.networkmanager.members = users;

  services.fwupd.enable = true;
  services.pcscd.enable = true;
  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [ pulseaudio pamixer ];
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  time.timeZone = "Europe/Paris";

  console.useXkbConfig = true;

  settings.userShell = pkgs.zsh;
}
