{ pkgs }:
{
  fake-hwclock = pkgs.callPackage ./fake-hwclock.nix {};
  freebox-exporter = pkgs.callPackage ./freebox-exporter.nix {};
  gws = pkgs.callPackage ./gws.nix {};
  sshrc = pkgs.callPackage ./sshrc.nix {};
  yk-scripts = pkgs.callPackage ./yk-scripts.nix {};
  esprtsha = pkgs.callPackage ./esprtsha.nix {};
}
