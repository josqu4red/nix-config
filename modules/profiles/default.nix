let
  modules = {
    base = import ./base;
    base-packages = import ./base/packages.nix;
    laptop = import ./laptop;
    server = import ./server;
    workstation = import ./workstation;
  };
  default =
    { ... }:
    {
      imports = builtins.attrValues modules;
    };
in
modules // { inherit default; }
