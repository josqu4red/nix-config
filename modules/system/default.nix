{
  imports = [
    ./defaults.nix
    ./docker.nix
    ./ledger.nix
    ./locales.nix
    ./nix.nix
    ./qFlipper.nix
    ./workstation.nix
    ./yubikey.nix
  ];
  system.stateVersion = "22.05";
}
