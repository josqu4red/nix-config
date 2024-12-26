{ inputs, pkgs, ... }: {
  imports = with inputs.self.homeModules; [ base firefox git gpg kitty neovim pass tmux zsh ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-27.3.11"
      ];
    };
  };

  home.packages = with pkgs; [ logseq slack spotify ];

  xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Hidden=true
  '';
}
