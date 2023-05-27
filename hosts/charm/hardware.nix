{ lib, modulesPath, pkgs, pkgsCross, ... }:
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

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

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
