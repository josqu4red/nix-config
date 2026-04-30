{
  config,
  lib,
  inputs,
  hostFacts,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.disko.nixosModules.disko
    inputs.self.nixosProfiles.workstation
  ];

  hardware.enableRedistributableFirmware = true;
  hardware.nvidia = {
    open = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  disko.devices = import ./disk-config.nix;

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader.systemd-boot.consoleMode = "max";
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "usbhid"
      "sd_mod"
    ];
    initrd.kernelModules = [
      "dm-snapshot"
      "usb_storage"
    ];
    kernelModules = [ "kvm-intel" ];
    tmp.cleanOnBoot = true;
  };

  # for networked test vms
  environment.etc."qemu/bridge.conf".text = "allow br0";

  services.openssh.settings.PasswordAuthentication = lib.mkForce true;

  nxmods = {
    cachix.enable = false;
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
      mainInterface.name = "br0";
      bridge = {
        enable = true;
        interfaces = [
          hostFacts.netIf
          "vm-*"
        ];
        macaddress = hostFacts.mac;
      };
    };
  };

  networking.firewall.enable = false;
}
