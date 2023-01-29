{ inputs, ... }:
{
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.system76
  ];

  my.system.desktop.gnome = true;
}
