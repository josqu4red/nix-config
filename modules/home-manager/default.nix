let
  modules = {
    base = import ./base;
    firefox = import ./firefox;
    git = import ./git;
    gpg = import ./gpg;
    kitty = import ./kitty;
    kube = import ./kube;
    neovim = import ./neovim;
    pass = import ./pass;
    sway = import ./sway;
    tmux = import ./tmux;
    vscode = import ./vscode;
    zsh = import ./zsh;
  };
  default =
    { ... }:
    {
      imports = builtins.attrValues modules;
    };
in
modules // { inherit default; }
