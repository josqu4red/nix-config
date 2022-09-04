{ config, lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

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

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/38faff75-4433-464c-8c73-307b350c9825";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9820-9E49";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/ebd272a7-102a-4e0e-9035-9406a4643f41";
    fsType = "ext4";
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/15bbd7ba-6112-4d09-ada0-eff69b3c9980"; }];

  networking.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
