{ lib, pkgs, ... }:
let
  inherit (lib) mkOption types;
in {
  options.custom = {
    userShell = mkOption {
      type = types.package;
      default = pkgs.bash;
      example = pkgs.zsh;
      description = "Default user shell";
    };
  };
}
