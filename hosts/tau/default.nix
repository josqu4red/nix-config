{ inputs, pkgs, ... }:
{
  imports = [
    ./hardware.nix
  ];

  disko.devices = import ./disk-config.nix;

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "libata.noacpi=1" ];
    supportedFilesystems = [ "zfs" ];
  };

  networking.hostId = "d11630ed";

  security.sudo.wheelNeedsPassword = false;

  my.system.nix.flakesNixpkgsInNixPath = true;
  nix.settings.trusted-users = [ "@wheel" ]; # TODO: figure out signing

  services.transmission = {
    enable = true;
    settings = {
      download-dir = "/srv/torrents";
      incomplete-dir = "/srv/torrents/.incomplete";
    };
  };

  services.mediatomb = {
    enable = true;
    openFirewall = true;
    mediaDirectories = map (path: { inherit path; recursive = true; hidden-files = false; })
                           [ "/srv/torrents" "/srv/media/video" ];
  };
}
