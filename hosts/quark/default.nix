{ inputs, ... }:
{
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.system76
  ];

  custom.desktop.gnome = true;
}
