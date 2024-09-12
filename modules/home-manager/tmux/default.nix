{ pkgs, ... }: {
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
}
