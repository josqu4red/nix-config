{ inputs, lib, config, hostFacts, pkgs, pkgsCross, ... }: {
  imports = [
    inputs.self.nixosProfiles.server
    inputs.disko.nixosModules.disko
    ./dhcp.nix
    ./dns.nix
#    ./sd-image.nix
  ];

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

  networking = {
    useNetworkd = true;
    nameservers = [ "127.0.0.1" ];
  };
  systemd.network = let
    inherit (config.facts) homeNet;
  in {
    enable = true;
    networks."10-lan" = {
      matchConfig.Name = hostFacts.netIf;
      address = [ "${hostFacts.ip}/${builtins.toString homeNet.prefix.length}" ];
      routes = [{ Gateway = homeNet.defaultGw; }];
      linkConfig.RequiredForOnline = "routable";
    };
  };

  # flash_erase /dev/mtd0 0 0  (from mtdutils)
  # dd if=uboot-spi.img of=/dev/mtdblock0 bs=4K
  system.build.uboot = pkgs.ubootOrangePi5;

  services.monero.enable = true;
}
