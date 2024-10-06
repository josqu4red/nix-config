{ config, inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.self.nixosProfiles.server
  ];

  hardware.enableRedistributableFirmware = true;

  disko.devices = import ./disk-config.nix;

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelModules = [ "kvm-intel" ];
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    kernelParams = [ "libata.noacpi=1" ];
    supportedFilesystems = [ "zfs" ];
    zfs.extraPools = [ "tank" ];
  };

  networking.hostId = "d11630ed";

  services.transmission = {
    enable = true;
    settings = {
      download-dir = "/srv/torrents";
      incomplete-dir = "/srv/torrents/.incomplete";
    };
  };

  services.mediatomb = {
    enable = true;
    openFirewall = true;
    mediaDirectories = map (path: { inherit path; recursive = true; hidden-files = false; })
                           [ "/srv/torrents" "/srv/media/video" ];
  };
}
