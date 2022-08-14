{ pkgs, ... }:
{
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
}
