{ lib, pkgs, ... }: let
  defaultGw = "192.168.1.1";
  ipAddress = "192.168.1.250";
in {
  imports = [ ./sd-image.nix ];

  boot = {
    loader.grub.enable = false;
    loader.generic-extlinux-compatible.enable = true;
    consoleLogLevel = lib.mkDefault 7;
    kernelParams = ["console=ttyS0,115200n8" "console=ttyAMA0,115200n8" "console=tty0"];
  };
  nixpkgs.hostPlatform = "aarch64-linux";
  nix.settings.trusted-users = [ "@wheel" ]; # TODO: figure out signing

  networking.dhcpcd.enable = false;
  networking.defaultGateway.address = defaultGw;
  networking.interfaces.end0.ipv4.addresses = [{
    address = ipAddress;
    prefixLength = 24;
  }];

  services.chrony.enable = true;
  services.fake-hwclock.enable = true;
}
