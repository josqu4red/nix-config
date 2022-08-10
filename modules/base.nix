{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    bc
    colordiff
    curl
    dig
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

  i18n.defaultLocale = "en_US.utf8";
}
