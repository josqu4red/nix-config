{ lib, ... }:
{
  imports = [
    ../workstation
  ];

  boot.plymouth.enable = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  services.libinput.touchpad = {
    clickMethod = "clickfinger";
    naturalScrolling = true;
    tappingButtonMap = "lrm";
  };

  networking.networkmanager.enable = true;
}
