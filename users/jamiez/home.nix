{ inputs, pkgs, ... }: {
  imports = with inputs.self.homeModules; [ base firefox git gpg kitty neovim pass tmux zsh ];

  programs.gpg.publicKeys = [{
    source = ./files/4BBCA7023906BA07.gpg.asc;
    trust = 5;
  }];

  home.packages = with pkgs; [ logseq slack spotify ];

  xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Hidden=true
  '';
}
