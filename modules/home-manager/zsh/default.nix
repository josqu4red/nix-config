{ config, lib, ... }:
let
  inherit (builtins) listToAttrs readDir;
  inherit (lib)
    mapAttrs'
    mkOption
    nameValuePair
    types
    ;

  cfg = config.hmmods.zsh;
  hist-size = 1000000;

  zshFile =
    path:
    let
      name = baseNameOf path;
    in
    nameValuePair "zsh/${name}" { source = path; };

  default-config = mapAttrs' (n: _: zshFile ./config/${n}) (readDir ./config);
  extra-config = listToAttrs (map zshFile cfg.extras);
in
{
  options.hmmods.zsh = {
    extras = mkOption {
      type = with types; listOf path;
      default = [ ];
      example = [ ./a/file ];
      description = "Extra config for zsh (settings, functions)";
    };
  };

  config = {
    home.sessionPath = [ "$HOME/.local/bin" ];
    xdg.configFile = default-config // extra-config;
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      dotDir = config.xdg.configHome + "/zsh";
      history = {
        expireDuplicatesFirst = true;
        extended = true;
        ignoreDups = true;
        ignorePatterns = [
          "rm *"
          "l *"
        ];
        ignoreSpace = true;
        save = hist-size;
        share = true;
        size = hist-size;
      };
      initContent = ''
        for config_file (${config.xdg.configHome}/zsh/*.zsh); do
          source $config_file
        done
      '';
      oh-my-zsh = {
        enable = true;
        plugins = [ "extract" ];
      };
    };
    programs = {
      bat.enable = true;
      fd.enable = true;
      ripgrep.enable = true;
      television.enable = true;
      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      nix-search-tv = {
        enable = true;
        enableTelevisionIntegration = true;
      };
    };
  };
}
