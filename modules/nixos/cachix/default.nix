{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nxmods.cachix;
in {
  options.nxmods.cachix.enable = mkEnableOption "cachix";
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.cachix ];
    nix.settings = {
      extra-substituters = [ "https://josqu4red.cachix.org" ];
      extra-trusted-public-keys = [ "josqu4red.cachix.org-1:S7wnALAmqClKxxHyIyUlraaltnPb5Q/lZPw2JyyjCrI=" ];
    };
  };
}
