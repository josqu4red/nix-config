{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ gws kubernetes-helm-wrapped kubectl python3 slack zoom-us ];

  my.home = {
    ruby.enable = true;
    vscode.enable = true;
  };
}
