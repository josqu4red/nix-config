{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.system.cli-tools;
in {
  options.my.system.cli-tools.enable = mkEnableOption "cli-tools";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bc
      binutils
      colordiff
      curl
      dig
      file
      git
      htop
      jq
      less
      lsof
      ncdu
      nettools
      rsync
      screen
      socat
      strace
      sysstat
      tree
      unzip
      vim
    ];

    environment.variables = {
      EDITOR = "vim";
      PAGER = "less";
    };
  };
}
