{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.loader.systemd-boot.consoleMode = "max";

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];

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

  nixpkgs.hostPlatform = "x86_64-linux";
}
