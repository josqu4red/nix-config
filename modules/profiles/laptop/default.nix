{ lib, ... }: {
  imports = [
    ../workstation
  ];

  boot.plymouth.enable = true;

  boot.initrd.luks = {
    fido2Support = true;
    devices.luks-root = {
      device = "/dev/disk/by-label/luks-root";
      preLVM = true;
      fido2.credential = "8ade4e84782523170000a7f93662ae5f89e6eb40452d1abb01f81256fc8be0cedb6af128c5cb9c007112fafed78711d9";
      fido2.passwordLess = true;
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  services.libinput.touchpad = {
    clickMethod = "clickfinger";
    naturalScrolling = true;
    tappingButtonMap = "lrm";
  };
}
