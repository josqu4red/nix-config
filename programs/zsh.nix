{ pkgs, lib, ... }:
let
  configPath = ./zsh;
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
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      size = 1000;
      save = 1000000;
    };
    initExtra = with builtins;
      lib.strings.concatStringsSep "\n"
      (lib.attrsets.mapAttrsToList (n: v: readFile (configPath + "/${n}"))
        (readDir configPath));
    oh-my-zsh = {
      enable = true;
      plugins = ["extract"];
      # theme = "agnoster";
    };
    plugins = [zsh-nix-shell];
  };
}
