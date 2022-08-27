{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ gws kubernetes-helm-wrapped kubectl python3 ruby slack zoom-us ];

  my.home = {
    vscode.enable = true;
  };
}
