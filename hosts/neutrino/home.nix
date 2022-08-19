{ config, pkgs, ... }:
let
  my = import ../..;
in {
  home.stateVersion = "22.05";
  home.username = "jamiez";
  home.homeDirectory = "/home/jamiez";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [ kubernetes-helm-wrapped kubectl python3 ruby slack spotify zoom-us ];

  imports = [ my.home ];

  my.home = {
    firefox.enable = true;
    gpg.enable = true;
    nix-tools.enable = true;
    pass.enable = true;
    tmux.enable = true;
    vim.enable = true;
    vscode.enable = true;
    zsh.enable = true;
  };
}
