{ pkgs, ... }: {
  programs.home-manager.enable = true;

  home.packages = with pkgs; [ spotify ];

  my.home = {
    alacritty.enable = true;
    firefox.enable = true;
    git.enable = true;
    gpg.enable = true;
    neovim.enable = true;
    pass.enable = true;
    tmux.enable = true;
    vim.enable = true;
    zsh.enable = true;
  };
}
