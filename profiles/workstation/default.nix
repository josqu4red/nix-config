{ pkgs, users, ... }: {
  imports = [
    ../base
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks = {
    fido2Support = true;
    devices.luks-root = {
      device = "/dev/disk/by-label/luks-root";
      preLVM = true;
      fido2.credential = "8ade4e84782523170000a7f93662ae5f89e6eb40452d1abb01f81256fc8be0cedb6af128c5cb9c007112fafed78711d9";
      fido2.passwordLess = true;
    };
  };

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
    pulse.enable = true;
  };

  environment.pathsToLink = [ "/share/zsh" ];

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  time.timeZone = "Europe/Paris";

  console.useXkbConfig = true;

  my.system = {
    docker = {
      enable = true;
      privilegedUsers = users;
    };
  };

  my.options = {
    userShell = pkgs.zsh;
  };
}
