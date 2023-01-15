{ ... }:
{
  imports = [ ./hardware.nix ];

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    layout = "fr";
    displayManager.lightdm.enable = true;
    displayManager.defaultSession = "none+i3";
    windowManager.i3.enable = true;
  };
  hardware.opengl.enable = true;

  my.system.chrysalis.enable = true;
  my.system.qFlipper.enable = true;
}
