{ pkgs, users, ... }: {
  imports = [
    ../base
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;
  networking.resolvconf.enable = false;
  services.resolved.enable = true;
  users.extraGroups.networkmanager.members = users;

  security.sudo.wheelNeedsPassword = false;

  services.fwupd.enable = true;
  services.pcscd.enable = true;
  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.pathsToLink = [ "/share/zsh" ];

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  time.timeZone = "Europe/Paris";

  console.useXkbConfig = true;

  my.system = {
    cli-tools.enable = true;
    docker = {
      enable = true;
      privilegedUsers = users;
    };
  };
}
