{ ... }:
{
  imports = [ ./hardware.nix ];

  custom.desktop = {
    gnome = true;
    i3 = true;
  };
}
