{ config, lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "max";
  };
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

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/8b8ff36f-2ece-4287-b185-953345531852";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A88A-CD5F";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/5f19c7f2-267a-4b7d-b7fe-15ff36b3166b";
    fsType = "ext4";
  };

  fileSystems."/srv/media" = {
    device = "/dev/disk/by-uuid/a0583dd2-f940-4a0c-ba4b-b4df0f92a19e";
    fsType = "ext4";
    options = [ "noauto" ];
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/f93b64e9-cee8-42ed-ae0d-6e1daf4f778b"; }];

  networking.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
