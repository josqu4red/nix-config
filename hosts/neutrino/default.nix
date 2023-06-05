{ inputs, users, ... }:
{
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
  ];

  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
  };

  my.system = {
    desktop.gnome = true;
    chrysalis.enable = true;
    docker = {
      enable = true;
      privilegedUsers = users;
    };
    kdeconnect.enable = true;
  };
  services.resolved.dnssec = "false"; # https://github.com/systemd/systemd/issues/10579
}
