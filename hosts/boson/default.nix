{ inputs, users, nxConfPath, ... }:
{
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ] ++ map (c: (nxConfPath + "/${c}")) [ "chrysalis" "docker" "qFlipper" ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  custom = {
    desktop.i3 = true;
    desktop.layout = "fr";
    nix.cachix.enable = true;
    docker.privilegedUsers = users;
  };
  services.udisks2.enable = true;
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  virtualisation.libvirtd.enable = true;
  users.extraGroups.libvirtd.members = users;
}
