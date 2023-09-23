{ inputs, users, ... }:
{
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  my.system = {
    desktop.i3 = true;
    desktop.layout = "fr";
    chrysalis.enable = true;
    qFlipper.enable = true;
    nix.cachix.enable = true;
    docker.enable = true;
    docker.privilegedUsers = users;
  };
  services.udisks2.enable = true;
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  virtualisation.libvirtd.enable = true;
  users.extraGroups.libvirtd.members = users;
}
