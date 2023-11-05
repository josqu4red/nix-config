let
  modules = {
    fake-hwclock = import ./fake-hwclock;
  };
  default = { ... }: {
    imports = builtins.attrValues modules;
  };
in modules // { inherit default; }
