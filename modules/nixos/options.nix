{ lib, pkgs, ... }:
let
  inherit (lib) mkOption types;
in {
  options.settings = {
    userShell = mkOption {
      type = types.package;
      default = pkgs.bash;
      example = pkgs.zsh;
      description = "Default user shell";
    };
  };
}
