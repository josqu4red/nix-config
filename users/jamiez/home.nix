{ pkgs, ... }: {
  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [ slack spotify ];
  home.sessionPath = [ "$HOME/.local/bin" ];

  my.home = {
    firefox.enable = true;
    git.enable = true;
    gpg.enable = true;
    kitty.enable = true;
    neovim.enable = true;
    pass.enable = true;
    tmux.enable = true;
    vim.enable = true;
    zsh.enable = true;
  };

  xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Hidden=true
  '';
}
