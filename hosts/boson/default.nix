{ users, nxConfPath, ... }:
{
  imports = [
    ./hardware.nix
  ] ++ map (c: (nxConfPath + "/${c}")) [ "chrysalis" "docker" "ledger" "qFlipper" ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  custom = {
    desktop.i3 = true;
    nix.cachix.enable = true;
    docker.privilegedUsers = users;
  };
  virtualisation.libvirtd.enable = true;
  users.extraGroups.libvirtd.members = users;
}
