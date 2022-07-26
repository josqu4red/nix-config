{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.tmux;
in {
  options.my.home.tmux = {
    enable = mkEnableOption "tmux";
  };
  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      prefix = "M-a";
      terminal = "screen-256color";
      extraConfig = builtins.readFile ./tmux.conf;
      plugins = with pkgs.tmuxPlugins; [
        prefix-highlight
        vim-tmux-navigator
        nord
      ];
    };
  };
}
