{ hmConfPath, pkgs, ... }:
{
  imports = map (c: (hmConfPath + "/${c}")) [ "ruby" ];

  home.packages = with pkgs; [ gws kubernetes-helm-wrapped kubectl ];
}
