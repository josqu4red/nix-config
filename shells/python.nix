{ pkgs ? import <nixpkgs> {} }:
let
  python-with-packages = pkgs.python39.withPackages (p: with p; [ virtualenv ]);
in
python-with-packages.env # replacement for pkgs.mkShell
