{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.my.system.cli-tools;
  defaultPackages = with pkgs; [
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
in {
  options.my.system.cli-tools = {
    enable = mkEnableOption "cli-tools";
    excludePackages = mkOption {
      type = types.listOf types.package;
      default = [];
      example = [ pkgs.nano ];
      description = "Packages to exclude from default list";
    };
  };
  config = mkIf cfg.enable {
    programs.nano.enable = false;
    environment = {
      systemPackages = lib.lists.subtractLists cfg.excludePackages defaultPackages;
      variables = {
        EDITOR = "vim";
        PAGER = "less";
      };
    };
  };
}
