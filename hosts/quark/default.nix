{ inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.system76
    inputs.self.nixosProfiles.laptop
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.enableRedistributableFirmware = true;

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    initrd.kernelModules = [ "dm-snapshot" ];
    kernelModules = [ "kvm-intel" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/e826e8da-c625-4764-8deb-d372540d0f41";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/6D2D-E3C4";
      fsType = "vfat";
    };
    "/home" = {
      device = "/dev/disk/by-uuid/4fcc80cd-d2a9-405d-a006-74c0f4f6ce3e";
      fsType = "ext4";
    };
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/f09ca857-9494-494c-be83-a5c0e86909dc"; } ];

  custom.desktop.gnome = true;
}
