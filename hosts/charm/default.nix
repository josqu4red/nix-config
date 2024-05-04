{ inputs, lib, pkgs, pkgsCross, ... }: let
  defaultGw = "192.168.1.1";
  ipAddress = "192.168.1.240";
  nameservers = ["192.168.1.250"];
  domain = "in.amiez.io";
in {
  imports = [
    inputs.self.nixosProfiles.server
    ./sd-image.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  hardware = {
    deviceTree = {
      name = "rockchip/rk3588s-orangepi-5.dtb";
      overlays = let
        i2c = import ./device-tree-overlays/opi5-i2c.nix;
        sata = import ./device-tree-overlays/opi5-sata.nix;
      in [ i2c sata ];
    };
    enableRedistributableFirmware = true;
    firmware = [ (pkgs.callPackage ./pkgs/mali-firmware {}) ];
  };

  boot = {
    loader.grub.enable = false;
    loader.generic-extlinux-compatible.enable = true;
    initrd.includeDefaultModules = false;
    initrd.availableKernelModules = lib.mkForce [ "dm_mod" "dm_crypt" "encrypted_keys" ];
    kernelModules = [ ];
    kernelPackages = pkgsCross.linuxPackagesFor (pkgsCross.callPackage ./pkgs/kernel {});
    extraModulePackages = [ ];
    consoleLogLevel = lib.mkDefault 7;
    supportedFilesystems = lib.mkForce [ "vfat" "fat32" "exfat" "ext4" "btrfs" ];
  };

  networking = {
    inherit domain nameservers;
    dhcpcd.enable = false;
    defaultGateway.address = defaultGw;
    interfaces.end1.ipv4.addresses = [{
      address = ipAddress;
      prefixLength = 24;
    }];
  };

  services.chrony.enable = true;
}
