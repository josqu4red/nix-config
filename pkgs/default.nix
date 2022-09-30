{ pkgs }:
{
  gws = pkgs.callPackage ./gws.nix {};
  chrysalis = pkgs.callPackage ./chrysalis.nix {};
}
