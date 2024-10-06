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
  nxmods.impermanence = {
    enable = true;
    directories = [
      "/var/lib/docker"
    ];
  };

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader.systemd-boot.consoleMode = "max";
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
    initrd.kernelModules = [ "dm-snapshot" "usb_storage" ];
    kernelModules = [ "kvm-intel" ];
    tmp.cleanOnBoot = true;
  };

  virtualisation.libvirtd.enable = true;
  users.extraGroups.libvirtd.members = hostFacts.users;
  services.openssh.settings.PasswordAuthentication = true;

  # Disable all suspend methods
  systemd.targets = let
    targets = [ "hibernate" "hybrid-sleep" "sleep" "suspend" ];
  in builtins.listToAttrs (map (t: { name = t; value = { enable = false; }; }) targets);

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
  };
}
