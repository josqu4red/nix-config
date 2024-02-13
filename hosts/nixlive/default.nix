{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-base.nix")
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
}
