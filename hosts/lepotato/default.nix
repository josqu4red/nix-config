{ config, lib, modulesPath, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  ];
  sdImage = {
    compressImage = false;
    populateFirmwareCommands = "";
    postBuildCommands = ''
      dd if=${pkgs.ubootLibreTechCC}/u-boot.gxl.sd.bin of=$img conv=fsync,notrunc bs=512 seek=1 skip=1
      dd if=${pkgs.ubootLibreTechCC}/u-boot.gxl.sd.bin of=$img conv=fsync,notrunc bs=1 count=444
    '';
  };
  nixpkgs = {
    localSystem.system = "x86_64-linux";
    crossSystem.system = "aarch64-linux";
  };
  nix.settings.trusted-users = [ "@wheel" ]; # TODO: figure out signing
  system.stateVersion = "22.05";

  networking.hostName = "lepotato";
  networking.dhcpcd.enable = false;
  networking.interfaces.end0.ipv4.addresses = [{
    address = "192.168.1.250";
    prefixLength = 24;
  }];
  my.system.sshd.enable = true;
  security.sudo.wheelNeedsPassword = false;

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "end0" ];
    extraConfig = ''
      set vendor-string = option vendor-class-identifier;
      one-lease-per-client true;
      ping-check true;
      update-static-leases true;
      # Global Options
      option domain-name "in.amiez.io";
      option domain-name-servers 8.8.8.8;
      # Allow
      allow booting;
      allow bootp;
      allow unknown-clients;

      subnet 192.168.1.0 netmask 255.255.255.0 {
        option routers 192.168.1.1;
        pool {
          range 192.168.1.20 192.168.1.30;
        }
      }
    '';
    machines = [
      {
        hostName = "boson.in.amiez.io";
        ipAddress = "192.168.1.3";
        ethernetAddress = "38:d5:47:0f:e2:0b";
      }
    ];
  };
}
