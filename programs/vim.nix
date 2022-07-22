{ pkgs, ... }:
let
  vim-desert256 = pkgs.vimUtils.buildVimPlugin {
    name = "vim-desert256";
    src = pkgs.fetchFromGitHub {
      owner = "brafales";
      repo = "vim-desert256";
      rev = "adc0940171363d5724a9c2a5183a3e12e04c627a";
      sha256 = "rq28iqkeSJIJLaWFJqp5cvOxj3GxUEfcfY4VOWoJmTk=";
    };
  };
in {
  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile files/vim/vimrc;
    plugins = with pkgs.vimPlugins; [
      delimitMate
      nerdtree
      nerdtree-git-plugin
      rainbow
      tmux-complete-vim
      vim-airline
      vim-desert256
      vim-endwise
      vim-gitgutter
      vim-go
      vim-json
      vim-jsonnet
      vim-nix
      vim-ruby
      vim-terraform
    ];
  };
}
