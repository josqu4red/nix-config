{ inputs, lib, pkgs, pkgsCross, ... }: {
  imports = [
    inputs.self.nixosProfiles.server
    inputs.disko.nixosModules.disko
#    ./sd-image.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  disko.devices = import ./disk-config.nix;
  nxmods.impermanence = {
    enable = true;
    directories = [
      "/var/lib/monero"
    ];
  };

  hardware = {
    deviceTree = {
      name = "rockchip/rk3588s-orangepi-5.dtb";
      overlays = [{
        name = "enable-nvme";
        dtsFile = ./dts/enable-nvme.dts;
      }];
    };
    enableRedistributableFirmware = true;
  };

  boot = {
    kernelPackages = pkgsCross.linuxPackagesFor(pkgsCross.callPackage ./pkgs/kernel {});
    initrd = {
      availableKernelModules = lib.mkForce [ "dm_mod" "ext4" "nvme" "pcie_rockchip_host" "phy_rockchip_naneng_combphy" "phy_rockchip_pcie" ];
      kernelModules = lib.mkForce [ ];
    };

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

    consoleLogLevel = 7;
    supportedFilesystems = lib.mkForce [ "vfat" "fat32" "exfat" "ext4" ];
  };

  networking.useNetworkd = true;
  systemd.network.enable = true;

  # flash_erase /dev/mtd0 0 0  (from mtdutils)
  # dd if=uboot-spi.img of=/dev/mtdblock0 bs=4K
  system.build.uboot = pkgs.ubootOrangePi5;

  services.monero.enable = true;
}
