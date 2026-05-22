{ pkgs, ... }:
let
  helm =
    with pkgs;
    wrapHelm kubernetes-helm {
      plugins = with kubernetes-helmPlugins; [
        helm-diff
        helm-git
        helm-unittest
      ];
    };
in
{
  home.packages = with pkgs; [
    chart-testing
    clusterctl
    helm
    k9s
    kind
    kubebuilder
    kubectl
    kubectl-explore
    kubectx
    kubevirt
  ];

  programs.zsh.shellAliases = {
    k = "kubectl";
    kx = "kubectx";
  };
}
