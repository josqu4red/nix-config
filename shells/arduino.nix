{ pkgs ? import <nixpkgs> { } }:
let
  python-env = pkgs.python39.withPackages (p: with p; [ pyserial ]);
in
pkgs.mkShell {
  packages = with pkgs; [
    python-env
    arduino-cli
  ];
}
