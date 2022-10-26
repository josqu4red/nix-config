{ config, lib, pkgs, ... }:
let
  inherit (builtins) listToAttrs readDir;
  inherit (lib) mapAttrs' mkEnableOption mkIf mkOption nameValuePair types;

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

  zshFile = path:
    let name = baseNameOf path;
    in nameValuePair "zsh/${name}" { source = path; };

  default-config = mapAttrs' (n: v: zshFile ./zsh/${n}) (readDir ./zsh);
  extra-config = listToAttrs (map (f: zshFile f) cfg.extras);
in {
  options.my.home.zsh = {
    enable = mkEnableOption "zsh";
    extras = mkOption {
      type = with types; listOf path;
      default = [];
      example = [ ./a/file ];
      description = "Extra config for zsh (settings, functions)";
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = default-config // extra-config;
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
