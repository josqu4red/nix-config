let
  modules = {
    base = import ./base;
    firefox = import ./firefox;
    git = import ./git;
    gpg = import ./gpg;
    i3 = import ./i3;
    kitty = import ./kitty;
    kube = import ./kube;
    neovim = import ./neovim;
    pass = import ./pass;
    tmux = import ./tmux;
    vscode = import ./vscode;
    zsh = import ./zsh;
  };
  default = { ... }: {
    imports = builtins.attrValues modules;
  };
in modules // { inherit default; }
