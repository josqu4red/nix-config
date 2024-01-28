{ inputs, users, ... }:
{
  imports = [ ./hardware.nix ]
    ++ (with inputs.self.nixosConfigs; [ chrysalis docker kdeconnect ]);

  custom = {
    desktop.gnome = true;
    desktop.i3 = true;
    docker.privilegedUsers = users;
  };

  # Fixes
  # environment.sessionVariables = {
  #   QT_QPA_PLATFORM = "wayland";
  # };
  services.resolved.dnssec = "false"; # https://github.com/systemd/systemd/issues/10579
}
