let
  modules = {
    chrysalis = import ./chrysalis;
    cli-tools = import ./cli-tools;
    desktop = import ./desktop;
    docker = import ./docker;
    kdeconnect = import ./kdeconnect;
    ledger = import ./ledger;
    nix = import ./nix;
    pipewire = import ./pipewire;
    qFlipper = import ./qFlipper;
    sshd = import ./sshd;
    users = import ./users;
    yubikey = import ./yubikey;
  };
  default = { ... }: {
    imports = builtins.attrValues modules;
  };
in modules // { inherit default; }
