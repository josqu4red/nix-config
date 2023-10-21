{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.qFlipper ];
  services.udev.packages = [ pkgs.qFlipper ];
}
