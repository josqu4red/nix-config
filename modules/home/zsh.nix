{ config, lib, pkgs, ... }:
let
  inherit (builtins) readDir readFile;
  inherit (lib) mapAttrs' mkEnableOption mkIf nameValuePair;

  cfg = config.my.home.zsh;
  hist-size = 1000000;
  zsh-nix-shell = {
    name = "zsh-nix-shell";
    file = "nix-shell.plugin.zsh";
    src = pkgs.fetchFromGitHub {
      owner = "chisui";
      repo = "zsh-nix-shell";
      rev = "v0.5.0";
      sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
    };
  };
in {
  options.my.home.zsh = {
    enable = mkEnableOption "zsh";
  };

  config = mkIf cfg.enable {
    xdg.configFile = mapAttrs' (n: v: nameValuePair "zsh/${n}.zsh" { source = ./zsh/${n}; }) (readDir ./zsh);
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      dotDir = ".config/zsh";
      history = {
        expireDuplicatesFirst = true;
        extended = true;
        ignoreDups = true;
        ignorePatterns = [ "rm *" "l *" "cd *" ];
        ignoreSpace = true;
        save = hist-size;
        share = true;
        size = hist-size;
      };
      envExtra = ''
        export PATH=~/bin:$PATH
      '';
      initExtra = ''
        for config_file (${config.xdg.configHome}/zsh/*.zsh); do
          source $config_file
        done
      '';
      oh-my-zsh = {
        enable = true;
        plugins = ["extract"];
      };
      plugins = [zsh-nix-shell];
    };
  };
}
