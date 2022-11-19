{ pkgs }:
{
  gws = pkgs.callPackage ./gws.nix {};
  ubootLibreTechCC = pkgs.callPackage ./ubootLibreTechCC.nix {};
}
