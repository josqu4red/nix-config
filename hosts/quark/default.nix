{ inputs, ... }:
{
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.system76
  ];

  custom.desktop.gnome = true;
  custom.desktop.i3 = true;

  services.xserver = {
    xkb.options = "caps:swapescape";
    libinput.touchpad = {
      naturalScrolling = true;
      tappingButtonMap = "lrm";
    };
  };
}
