{ inputs, lib, pkgs, ... }: let
  defaultGw = "192.168.1.1";
  ipAddress = { address = "192.168.1.250"; prefixLength = 24; };
in {
  imports = [
    inputs.self.nixosProfiles.server
    ./sd-image.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  boot = {
    loader.grub.enable = false;
    loader.generic-extlinux-compatible.enable = true;
    consoleLogLevel = lib.mkDefault 7;
    kernelParams = ["console=ttyS0,115200n8" "console=ttyAMA0,115200n8" "console=tty0"];
  };

  networking = {
    dhcpcd.enable = false;
    defaultGateway.address = defaultGw;
    interfaces.end0.ipv4.addresses = [ ipAddress ];
  };

  environment.systemPackages = [ pkgs.wakeonlan ];

  services.chrony = {
    enable = true;
    extraFlags = [ "-s" ];
  };
}
