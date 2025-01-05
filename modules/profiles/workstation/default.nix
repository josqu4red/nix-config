{ pkgs, hostFacts, ... }: {
  imports = [ ../base ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.bluetooth.enable = true;
  services.udisks2.enable = true;

  networking.networkmanager.enable = true;
  networking.resolvconf.enable = false;
  services.resolved.enable = true;
  users.extraGroups.networkmanager.members = hostFacts.users;

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

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  time.timeZone = "Europe/Paris";

  console.useXkbConfig = true;

  settings.userShell = pkgs.zsh;
}
