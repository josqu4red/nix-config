{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption;
in {
  options.my.workstation = {
    enable = mkEnableOption "module name";
  };
}
