{ inputs, lib, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.system76
  ];

  services.xserver = {
    enable = true;
    layout = "us";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  services.gnome.gnome-online-miners.enable = lib.mkForce false;
  services.gnome.evolution-data-server.enable = lib.mkForce false;
  environment.systemPackages = [ pkgs.gnome.gnome-tweaks ];
}
