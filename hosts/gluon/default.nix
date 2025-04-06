{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.self.nixosProfiles.server
  ];

  disko.devices = import ./disk-config.nix;

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "sd_mod" ];
    initrd.kernelModules = [ "dm-snapshot" "usb_storage" ];
    kernelModules = [ "kvm-amd" ];
    tmp.cleanOnBoot = true;
  };

  nxmods = {
    impermanence.enable = true;
    tailscale.enable = true;
  };
}
