{ inputs, ... }:
{
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  my.system.desktop.i3 = true;
  my.system.desktop.layout = "fr";
  services.udisks2.enable = true;
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  my.system.chrysalis.enable = true;
  my.system.qFlipper.enable = true;
  my.system.nix.cachix.enable = true;
}
