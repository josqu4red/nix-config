{ self, inputs, lib, config, hostFacts, pkgs, pkgsCross, ... }: {
  imports = [
    inputs.self.nixosProfiles.server
    inputs.disko.nixosModules.disko
    ./dhcp.nix
    ./dns.nix
    ./ha
    ./monitoring.nix
#    ./sd-image.nix
  ];

  disko.devices = import ./disk-config.nix;
  nxmods.impermanence = {
    enable = true;
    directories = [
      "/var/lib/acme"
      "/var/lib/monero"
    ];
  };

  nxmods.backup = {
    enable = true;
    paths = [ "/var/lib/acme" ];
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

  networking = with config.facts.homeNet; {
    inherit domain;
    search = [domain];
    nameservers = [ "127.0.0.1" ];
    firewall.allowedTCPPorts = [ 80 443 ];
  };

  nxmods.networkd = with config.facts.homeNet; {
    enable = true;
    interface = hostFacts.netIf;
    address = "${hostFacts.ip}/${toString prefix.length}";
    gateway = defaultGw;
  };

  # flash_erase /dev/mtd0 0 0  (from mtdutils)
  # dd if=uboot-spi.img of=/dev/mtdblock0 bs=4K
  system.build.uboot = pkgs.ubootOrangePi5;

  services.monero.enable = true;

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  sops.secrets."freebox-token" = {
    owner = "freebox-exporter";
    sopsFile = self.outPath + "/secrets/charm/freebox.json";
    format = "json";
    key = "";
  };
  services.freebox-exporter = {
    enable = true;
    apiTokenFile = config.sops.secrets."freebox-token".path;
  };
}
