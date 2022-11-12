{ pkgs }:
{
  gws = pkgs.callPackage ./gws.nix {};
  chrysalis = pkgs.callPackage ./chrysalis.nix {};
  ubootLibreTechCC = pkgs.callPackage ./ubootLibreTechCC.nix {};
}
