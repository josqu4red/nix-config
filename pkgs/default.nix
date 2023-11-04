{ pkgs }:
{
  fake-hwclock = pkgs.callPackage ./fake-hwclock.nix {};
  gws = pkgs.callPackage ./gws.nix {};
  sshrc = pkgs.callPackage ./sshrc.nix {};
  yk-scripts = pkgs.callPackage ./yk-scripts.nix {};
}
