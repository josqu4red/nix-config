{ inputs, lib, pkgs, pkgsCross, ... }: let
  defaultGw = "192.168.1.1";
  ipAddress = { address = "192.168.1.240"; prefixLength = 24; };
  nameservers = ["192.168.1.250"];
  domain = "in.amiez.io";
in {
  imports = [
    inputs.self.nixosProfiles.server
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.impermanence
#    ./sd-image.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  disko.devices = import ./disk-config.nix;
  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/monero"
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

  services.monero.enable = true;
}
