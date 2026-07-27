{ lib, ... }:
{
  imports = [
    ../workstation
  ];

  boot.plymouth.enable = true;

  boot.initrd.luks = {
    devices.luks-root = {
      device = "/dev/disk/by-label/luks-root";
      preLVM = true;
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  services.libinput.touchpad = {
    clickMethod = "clickfinger";
    naturalScrolling = true;
    tappingButtonMap = "lrm";
  };

  networking.networkmanager.enable = true;
}
