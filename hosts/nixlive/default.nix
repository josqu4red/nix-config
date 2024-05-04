{ inputs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-base.nix")
    inputs.self.nixosProfiles.base
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
}
