{ inputs, hostFacts, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.disko.nixosModules.disko
    inputs.self.nixosProfiles.workstation
  ];

  hardware.enableRedistributableFirmware = true;
  hardware.nvidia.open = true;

  disko.devices = import ./disk-config.nix;

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader.systemd-boot.consoleMode = "max";
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
    initrd.kernelModules = [ "dm-snapshot" "usb_storage" ];
    kernelModules = [ "kvm-intel" ];
    tmp.cleanOnBoot = true;
  };

  # for networked test vms
  environment.etc."qemu/bridge.conf".text = "allow br0";

  nxmods = {
    cachix.enable = true;
    chrysalis.enable = true;
    ledger.enable = true;
    qflipper.enable = true;
    docker = {
      enable = true;
      privilegedUsers = hostFacts.users;
    };
    desktop = {
      enable = true;
      i3 = true;
    };
    impermanence = {
      enable = true;
      directories = [
        "/var/lib/docker"
      ];
    };
    networkd = {
      enable = true;
      interface = "br0";
      bridge = {
        enable = true;
        interfaces = [ hostFacts.netIf "vm-*" ];
        macaddress = hostFacts.mac;
      };
    };
  };
}
