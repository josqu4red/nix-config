let
  modules = {
    base = import ./base;
    laptop = import ./laptop;
    server = import ./server;
    workstation = import ./workstation;
  };
  default = { ... }: {
    imports = builtins.attrValues modules;
  };
in modules // { inherit default; }
