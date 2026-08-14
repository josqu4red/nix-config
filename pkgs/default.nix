{ pkgs }:
let
  skipped = [
    "default.nix"
    "fhsEnv.nix"
  ];
in
builtins.listToAttrs (
  map (name: {
    name = builtins.replaceStrings [ ".nix" ] [ "" ] name;
    value = pkgs.callPackage (./. + "/${name}") { };
  }) (builtins.attrNames (builtins.removeAttrs (builtins.readDir ./.) skipped))
)
