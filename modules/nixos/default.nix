let
  modules = {
    backup = import ./backup;
    cachix = import ./cachix;
    chrysalis = import ./chrysalis;
    desktop = import ./desktop;
    docker = import ./docker;
    fake-hwclock = import ./fake-hwclock;
    impermanence = import ./impermanence;
    kdeconnect = import ./kdeconnect;
    ledger = import ./ledger;
    microvm-guest = import ./microvm-guest;
    microvm-host = import ./microvm-host;
    qFlipper = import ./qFlipper;
    yubikey = import ./yubikey;
    options = import ./options.nix;
  };
  default = { ... }: {
    imports = builtins.attrValues modules;
  };
in modules // { inherit default; }
