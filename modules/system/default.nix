{
  imports = [
    ./defaults.nix
    ./docker.nix
    ./locales.nix
    ./nix.nix
    ./workstation.nix
  ];
  system.stateVersion = "22.05";
}
