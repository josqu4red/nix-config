{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.chrysalis ];
  services.udev.packages = [ pkgs.chrysalis ];
}
