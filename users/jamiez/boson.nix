{ inputs, ... }:
{
  imports = with inputs.self.homeModules; [
    sway
    kube
  ];
}
