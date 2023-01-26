{ lib, ... }: {
  imports = [
    ../workstation
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
