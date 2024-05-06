{ inputs, lib, pkgs, pkgsCross, ... }: let
  defaultGw = "192.168.1.1";
  ipAddress = { address = "192.168.1.240"; prefixLength = 24; };
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
      overlays = [{
        name = "enable-nvme";
        dtsFile = ./dts/enable-nvme.dts;
      }];
    };
    enableRedistributableFirmware = true;
  };

  boot = {
    kernelPackages = pkgsCross.linuxPackagesFor(pkgsCross.callPackage ./pkgs/kernel {});

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

    consoleLogLevel = 7;

    supportedFilesystems = lib.mkForce [ "vfat" "fat32" "exfat" "ext4" ];
  };

  networking = {
    inherit domain nameservers;
    dhcpcd.enable = false;
    defaultGateway.address = defaultGw;
    interfaces.end0.ipv4.addresses = [ ipAddress ];
  };

  services.chrony.enable = true;

  # flash_erase /dev/mtd0 0 0  (from mtdutils)
  # dd if=uboot-spi.img of=/dev/mtdblock0 bs=4K
  system.build.uboot = pkgs.ubootOrangePi5;
}
