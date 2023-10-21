{ inputs, users, nxConfPath, ... }:
{
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
  ] ++ map (c: (nxConfPath + "/${c}")) [ "chrysalis" "docker" "kdeconnect" ];

  # environment.sessionVariables = {
  #   QT_QPA_PLATFORM = "wayland";
  # };

  custom = {
    desktop.gnome = true;
    docker.privilegedUsers = users;
  };
  services.resolved.dnssec = "false"; # https://github.com/systemd/systemd/issues/10579
}
