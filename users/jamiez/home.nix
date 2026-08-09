{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = with inputs.self.homeModules; [
    base
    firefox
    git
    gpg
    kitty
    neovim
    pass
    tmux
    zsh
  ];

  programs.gpg.publicKeys = [
    {
      source = ./files/4BBCA7023906BA07.gpg.asc;
      trust = 5;
    }
  ];

  home.packages = with pkgs; [
    slack
    spotify
  ];

  services.nextcloud-client.enable = true;

  xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Hidden=true
  '';

  home.file.".ssh/yubikey.pub".source = ./files/yubikey.pub;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        User = "jamiez";
        IdentityFile = "~/.ssh/yubikey.pub";
        ServerAliveInterval = 60;
        SendEnv = [ "TMUX" ];
        IdentitiesOnly = true;
        HashKnownHosts = false;
        ForwardAgent = false;
        AddKeysToAgent = false;
        ControlMaster = "auto";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "1m";
      };
      localhost = lib.hm.dag.entryBefore [ "*" ] {
        StrictHostKeyChecking = "no";
        UserKnownHostsFile = "/dev/null";
      };
    };
  };
}
