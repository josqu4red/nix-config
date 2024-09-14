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
    qFlipper = import ./qFlipper;
    yubikey = import ./yubikey;
    options = import ./options.nix;
  };
  default = { ... }: {
    imports = builtins.attrValues modules;
  };
in modules // { inherit default; }
