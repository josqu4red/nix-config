{ pkgs }:
{
  gws = pkgs.callPackage ./gws.nix {};
  yk-scripts = pkgs.callPackage ./yk-scripts.nix {};
}
