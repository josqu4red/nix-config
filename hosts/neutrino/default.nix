{ inputs, ... }:
{
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
  ];

  my.system.desktop.gnome = true;
  my.system.chrysalis.enable = true;
  services.flatpak.enable = true;
}
