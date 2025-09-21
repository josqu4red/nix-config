{ pkgs }:
{
  fake-hwclock = pkgs.callPackage ./fake-hwclock.nix {};
  freebox-exporter = pkgs.callPackage ./freebox-exporter.nix {};
  grafana-strava-datasource = pkgs.callPackage ./grafana-strava-datasource.nix {};
  gws = pkgs.callPackage ./gws.nix {};
  sshrc = pkgs.callPackage ./sshrc.nix {};
  yk-scripts = pkgs.callPackage ./yk-scripts.nix {};
  hacs-espsomfyrts = pkgs.callPackage ./hacs-espsomfyrts.nix {};
  hacs-gtfs2 = pkgs.callPackage ./hacs-gtfs2 {};
  hacs-rtetempo = pkgs.callPackage ./hacs-rtetempo.nix {};
}
