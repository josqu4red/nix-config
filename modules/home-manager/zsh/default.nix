{ config, lib, ... }:
let
  inherit (builtins) listToAttrs readDir;
  inherit (lib) mapAttrs' mkOption nameValuePair types;

  cfg = config.hmmods.zsh;
  hist-size = 1000000;

  zshFile = path:
    let name = baseNameOf path;
    in nameValuePair "zsh/${name}" { source = path; };

  default-config = mapAttrs' (n: _: zshFile ./config/${n}) (readDir ./config);
  extra-config = listToAttrs (map zshFile cfg.extras);
in {
  options.hmmods.zsh = {
    extras = mkOption {
      type = with types; listOf path;
      default = [];
      example = [ ./a/file ];
      description = "Extra config for zsh (settings, functions)";
    };
  };

  config = {
    xdg.configFile = default-config // extra-config;
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
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
      profileExtra = lib.optionalString (config.home.sessionPath != [ ]) ''
        export PATH="$PATH''${PATH:+:}${lib.concatStringsSep ":" config.home.sessionPath}"
      '';
      oh-my-zsh = {
        enable = true;
        plugins = ["extract"];
      };
    };
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.ripgrep.enable = true;
  };
}
