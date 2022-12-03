{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.nix-tools;
in {
  options.my.home.nix-tools = {
    enable = mkEnableOption "nix-tools";
  };
  config = mkIf cfg.enable {
    home.packages = builtins.attrValues {
      inherit (pkgs) nvd;
    };
    programs.nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
