{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.neovim;

  nvim-treesitter-setup = pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
    # TODO: p.haskell
    [ p.dockerfile p.go p.hcl p.json p.jsonnet p.nix p.python p.regex p.ruby ]
  );
  nvim-treesitter-endwise = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-treesitter-endwise";
    src = pkgs.fetchFromGitHub {
      owner = "RRethy";
      repo = "nvim-treesitter-endwise";
      rev = "0cf4601c330cf724769a2394df555a57d5fd3f34";
      sha256 = "sha256-Pns+3gLlwhrojKQWN+zOFxOmgRkG3vTPGoLX90Sg+oo=";
    };
  };
  nvim-ts-rainbow2 = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-ts-rainbow2";
    src = pkgs.fetchFromGitLab {
      owner = "HiPhish";
      repo = "nvim-ts-rainbow2";
      rev = "3bfcb9a7dd55d106f2e8afd3dcaec1ac624db2db";
      sha256 = "sha256-rfD0HcwxYM7u/D+MN8tDue+4dZfTZcCxLEOKOGYRAe4=";
    };
  };
  # TODO: haskell-language-server
  extraPackages = with pkgs; [ fd gopls nodePackages.pyright ripgrep rnix-lsp rubyPackages.solargraph ];
in {
  options.my.home.neovim = {
    enable = mkEnableOption "neovim";
  };
  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      vimAlias = true;
      vimdiffAlias = true;
      inherit extraPackages;
      extraConfig = "lua << EOF\n" + builtins.readFile ./init.lua + "\nEOF";
      plugins = with pkgs.vimPlugins; [
        # Layout
        bufferline-nvim
        lualine-nvim
        nvim-web-devicons
        nvim-tree-lua
        # Git
        conflict-marker-vim
        gitsigns-nvim
        # LSP
        nvim-cmp
        cmp-buffer
        cmp-cmdline
        cmp-nvim-lsp
        cmp-path
        nvim-lspconfig
        luasnip
        # Syntax
        nvim-treesitter-setup
        nvim-treesitter-endwise
        nvim-treesitter-context
        # nvim-treesitter-textobjects
        nvim-ts-rainbow2
        vim-better-whitespace
        vim-json
        vim-nix
        nvim-autopairs
        # Visuals
        neoscroll-nvim
        onedark-nvim

        telescope-nvim
        #telescope-file-browser-nvim
        telescope-fzf-native-nvim
        telescope-symbols-nvim
        #telescope_hoogle
      ];
    };
  };
}
