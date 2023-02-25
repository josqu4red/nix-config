{ pkgs, ... }:
{
  home.packages = with pkgs; [ gws kubernetes-helm-wrapped kubectl ];

  my.home = {
    ruby.enable = true;
  };
}
