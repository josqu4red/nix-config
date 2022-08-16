{ config, pkgs, ... }: {
  home.stateVersion = "22.05";
  home.username = "jamiez";
  home.homeDirectory = "/home/jamiez";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [ kubernetes-helm-wrapped kubectl nvd python3 ruby slack spotify zoom-us ];

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  imports = [
    ../../programs/firefox.nix
    ../../programs/gpg.nix
    ../../programs/pass.nix
    ../../programs/tmux.nix
    ../../programs/vim.nix
    ../../programs/vscode.nix
  ];
}
