{ config, pkgs, ... }: {
  config = {
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

    environment.shells = [ pkgs.zsh ];
  };
}
