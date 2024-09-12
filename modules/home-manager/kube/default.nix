{ inputs, pkgs, ... }:
let
  helm = with pkgs; wrapHelm kubernetes-helm { plugins = [ kubernetes-helmPlugins.helm-diff ]; };
in {
  home.packages = with pkgs; [
    k9s kind kubectl kubectx helm stern
  ];

  programs.zsh.shellAliases = {
    k = "kubectl";
    kx = "kubectx";
  };
}
