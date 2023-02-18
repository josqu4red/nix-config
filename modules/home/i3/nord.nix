{ lib }: let
  inherit (builtins) elemAt listToAttrs;
  inherit (lib) nameValuePair zipListsWith;

  hex = [ "#2e3440" "#3b4252" "#434c5e" "#4c566a" "#d8dee9" "#e5e9f0" "#eceff4" "#8fbcbb" "#88c0d0" "#81a1c1" "#5e81ac" "#bf616a" "#d08770" "#ebcb8b" "#a3be8c" "#b48ead" ];
  names = [ "darkest" "darker" "dark" "grey" "light" "lighter" "lightest" "mint" "cyan" "blue" "purple" "red" "orange" "yellow" "green" "pink" ];
in listToAttrs(zipListsWith (k: v: nameValuePair k v) names hex) // { byId = id: elemAt hex id; }
