{ inputs, users, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
  ] ++ (with inputs.self.nixosConfigs; [ chrysalis docker kdeconnect ]);

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.enableRedistributableFirmware = true;

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ "dm-snapshot" ];
    kernelModules = [ "kvm-intel" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/38faff75-4433-464c-8c73-307b350c9825";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/9820-9E49";
      fsType = "vfat";
    };
    "/home" = {
      device = "/dev/disk/by-uuid/ebd272a7-102a-4e0e-9035-9406a4643f41";
      fsType = "ext4";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/15bbd7ba-6112-4d09-ada0-eff69b3c9980"; }];

  custom = {
    desktop.gnome = true;
    desktop.i3 = true;
    docker.privilegedUsers = users;
  };

  # Fixes
  # environment.sessionVariables = {
  #   QT_QPA_PLATFORM = "wayland";
  # };
  services.resolved.dnssec = "false"; # https://github.com/systemd/systemd/issues/10579
}
