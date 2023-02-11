{ inputs, users, ... }:
{
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
  ];

  my.system = {
    desktop.gnome = true;
    chrysalis.enable = true;
    docker = {
      enable = true;
      privilegedUsers = users;
    };
  };
  services.flatpak.enable = true;
  services.resolved.dnssec = "false"; # https://github.com/systemd/systemd/issues/10579
}
