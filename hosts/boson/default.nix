{ inputs, ... }:
{
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  my.system.desktop.i3 = true;
  my.system.desktop.layout = "fr";
  my.system.chrysalis.enable = true;
  my.system.qFlipper.enable = true;
  my.system.nix.cachix.enable = true;
}
