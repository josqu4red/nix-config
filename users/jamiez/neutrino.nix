{ pkgs, ... }:
{
  home.packages = with pkgs; [ gws kubernetes-helm-wrapped kubectl slack ];

  my.home = {
    ruby.enable = true;
    vscode.enable = true;
  };
}
