{ pkgs, ... }:
let
  helm = with pkgs; wrapHelm kubernetes-helm { plugins = with kubernetes-helmPlugins; [ helm-diff helm-git helm-unittest ]; };
in {
  home.packages = with pkgs; [
    k9s kind kubectl kubectl-explore kubectx helm chart-testing
  ];

  programs.zsh.shellAliases = {
    k = "kubectl";
    kx = "kubectx";
  };
}
