{ inputs, lib, users, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.impermanence
    inputs.self.nixosProfiles.workstation
  ] ++ (with inputs.self.nixosConfigs; [ chrysalis docker ledger qFlipper ]);

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

  custom = {
    desktop.i3 = true;
    nix.cachix.enable = true;
    docker.privilegedUsers = users;
  };

  virtualisation.libvirtd.enable = true;
  users.extraGroups.libvirtd.members = users;
  services.openssh.settings.PasswordAuthentication = true;

  networking.firewall.enable = false; # for docker
}
