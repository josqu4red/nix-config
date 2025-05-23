let
  modules = {
    acme = import ./acme;
    backup = import ./backup;
    cachix = import ./cachix;
    chrysalis = import ./chrysalis;
    desktop = import ./desktop;
    docker = import ./docker;
    fake-hwclock = import ./fake-hwclock;
    freebox-exporter = import ./freebox-exporter;
    impermanence = import ./impermanence;
    kdeconnect = import ./kdeconnect;
    ledger = import ./ledger;
    microvm-guest = import ./microvm-guest;
    microvm-host = import ./microvm-host;
    networkd = import ./networkd;
    qFlipper = import ./qFlipper;
    sops = import ./sops;
    tailscale = import ./tailscale;
    yubikey = import ./yubikey;
    options = import ./options.nix;
  };
  default = { ... }: {
    imports = builtins.attrValues modules;
  };
in modules // { inherit default; }
