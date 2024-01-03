{ hmConfPath, pkgs, ... }:
{
  imports = map (c: (hmConfPath + "/${c}")) [ "i3" "ruby" ];

  home.packages = with pkgs; [ gws kubernetes-helm-wrapped kubectl ];
}
