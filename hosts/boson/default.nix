{ inputs, users, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.impermanence
    inputs.self.nixosProfiles.workstation
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
  hardware.nvidia.modesetting.enable = true;

  disko.devices = import ./disk-config.nix;

  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/docker"
      "/var/log"
    ];
    files = [
      "/etc/machine-id" # For journalctl
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
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
  users.extraGroups.libvirtd.members = users;
  services.openssh.settings.PasswordAuthentication = true;

  networking.firewall.enable = false; # for docker

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
      privilegedUsers = users;
    };
    desktop = {
      enable = true;
      i3 = true;
    };
  };
}
