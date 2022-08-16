{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    newSession = true;
    prefix = "M-a";
    terminal = "screen-256color";
    extraConfig = builtins.readFile ./tmux/tmux.conf;
    plugins = with pkgs.tmuxPlugins; [
      prefix-highlight
      vim-tmux-navigator
    ];
  };
}
