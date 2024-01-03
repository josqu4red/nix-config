{ lib, ... }: {
  imports = [
    ../workstation
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  services.xserver = {
    xkb.options = "caps:swapescape";
    libinput.touchpad = {
      clickMethod = "clickfinger";
      naturalScrolling = true;
      tappingButtonMap = "lrm";
    };
  };
}
