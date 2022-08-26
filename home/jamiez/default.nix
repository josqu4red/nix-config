{ inputs, lib, pkgs, username, ... }: {
  programs.home-manager.enable = true;

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    #stateVersion = "22.05";
  };

  home.packages = with pkgs; [ spotify ];

  my.home = {
    firefox.enable = true;
    gpg.enable = true;
    nix-tools.enable = true;
    pass.enable = true;
    tmux.enable = true;
    vim.enable = true;
    zsh.enable = true;
  };
}
