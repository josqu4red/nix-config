{ config, pkgs, hostname, ... }: {
  config = {
    networking.hostName = hostname;

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

    environment.shells = [ pkgs.zsh ];
  };
}
