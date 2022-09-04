{ pkgs }:
{
  gws = pkgs.callPackage ./gws.nix {};
  ubootLibreTechCC = pkgs.callPackage ./ubootLibreTechCC.nix {};
  yk-scripts = pkgs.callPackage ./yk-scripts.nix {};
}
