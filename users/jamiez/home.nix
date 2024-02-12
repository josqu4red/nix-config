{ inputs, pkgs, ... }: {
  imports = with inputs.self.homeConfigs; [ base firefox git gpg kitty neovim pass tmux zsh ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [ logseq slack spotify tig ];
  home.sessionPath = [ "$HOME/.local/bin" ];

  xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Hidden=true
  '';
}
