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
      rev = "4c344ffc8d54d7e1ba2cefaaa2c10ea93aa1cc2d";
      sha256 = "sha256-fkZjVQvlJpcKrmX8ST7TQ9VpCZ9U1dM5OLz6P8KnQAw=";
    };
  };
  nvim-ts-rainbow2 = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-ts-rainbow2";
    src = pkgs.fetchFromGitHub {
      owner = "HiPhish";
      repo = "nvim-ts-rainbow2";
      rev = "v2.3.0";
      sha256 = "sha256-u3+v55on4kzPcnotMz4tb7TcuPeTgpGVY2hz1OYFT1Y=";
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
