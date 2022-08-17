{ config, pkgs, ... }: {
  config = {
    system.stateVersion = "22.05";
  
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
  
    nix = {
      package = pkgs.nixFlakes;
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
      };
    };
  
    security.sudo.wheelNeedsPassword = false;
    services.openssh.enable = true;
  };
}
