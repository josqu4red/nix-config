{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.vscode;
in {
  options.my.home.vscode = {
    enable = mkEnableOption "vscode";
  };
  config = mkIf cfg.enable {
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
        update.mode = "none";
        editor = {
          bracketPairColorization.enabled = true;
          fontFamily = "JetBrainsMono Nerd Font";
          fontLigatures = true;
          fontSize = 14;
        };
        workbench.colorTheme = "Solarized Dark";
      };
    };
  };
}
