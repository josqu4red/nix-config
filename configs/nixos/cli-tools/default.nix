{ pkgs, ... }:
let
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
  programs.nano.enable = false;
  environment = {
    systemPackages = defaultPackages;
    variables = {
      EDITOR = "vim";
      PAGER = "less";
    };
  };
}
