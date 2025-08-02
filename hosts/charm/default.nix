{ inputs, lib, config, hostFacts, pkgs, ... }: {
  imports = [
    inputs.self.nixosProfiles.server
    inputs.disko.nixosModules.disko
    ./dhcp.nix
    ./dns.nix
    ./ha
    ./monitoring.nix
    # ./sd-image.nix
  ];

  disko.devices = import ./disk-config.nix;

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
    kernelPackages = pkgs.linuxPackages_latest;
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

  nxmods = {
    networkd = with config.facts.homeNet; {
      enable = true;
      interface = hostFacts.netIf;
      address = "${hostFacts.ip}/${toString prefix.length}";
      gateway = defaultGw;
    };
    impermanence = {
      enable = true;
      directories = [
        "/var/lib/monero"
      ];
    };
    backup.enable = true;
    tailscale.enable = true;
  };

  sops.secrets."cloudflare-token" = {
    sopsFile = inputs.self.outPath + "/secrets/shared/cloudflare-token-amiez.xyz";
    key = "";
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
}
