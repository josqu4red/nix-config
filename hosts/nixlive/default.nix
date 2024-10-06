{ inputs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-base.nix")
    inputs.self.nixosProfiles.base
  ];
}
