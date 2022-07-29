{ config, pkgs, ... }: {
  home.stateVersion = "22.05";
  home.username = "jamiez";
  home.homeDirectory = "/home/jamiez";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [ kubernetes-helm-wrapped kubectl nvd python3 ruby slack spotify zoom-us ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
      arrterian.nix-env-selector
      eamodio.gitlens
      golang.go
      jnoortheen.nix-ide
      ms-vsliveshare.vsliveshare
      vscodevim.vim
    ];
    userSettings = {
      "editor.fontFamily" = "JetBrainsMono Nerd Font";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 13;
      "workbench.colorTheme" = "Solarized Dark";
    };
  };

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  imports = [
    ../../programs/firefox.nix
    ../../programs/pass.nix
    ../../programs/tmux.nix
    ../../programs/vim.nix
  ];

  #services.gpg-agent = {
  #  enable = true;
  #  defaultCacheTtl = 1800;
  #  enableSshSupport = true;
  #};
}
