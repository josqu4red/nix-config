{ pkgs, ... }:
let
  nvim-treesitter-setup = pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
    # TODO: p.haskell
    [ p.c p.dockerfile p.go p.hcl p.json p.jsonnet p.lua p.nix p.python p.regex p.ruby p.vimdoc ]
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
  nvim-treesitter-rainbow = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-ts-rainbow2";
    src = pkgs.fetchFromGitHub {
      owner = "HiPhish";
      repo = "nvim-ts-rainbow2";
      rev = "v2.3.0";
      sha256 = "sha256-u3+v55on4kzPcnotMz4tb7TcuPeTgpGVY2hz1OYFT1Y=";
    };
  };
  # TODO: haskell-language-server
  extraPackages = with pkgs; [ fd go gopls pyright ripgrep nil rubyPackages.solargraph ];
in {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    inherit extraPackages;
    extraLuaConfig = builtins.readFile ./init.lua;
    plugins = with pkgs.vimPlugins; [
      # Visuals
      neoscroll-nvim
      onedark-nvim
      nvim-web-devicons
      lualine-nvim
      vim-better-whitespace
      indent-blankline-nvim
      # Tools
      conflict-marker-vim
      gitsigns-nvim
      neogit
      trouble-nvim
      # noice-nvim
      nvim-tree-lua
      telescope-nvim
      telescope-file-browser-nvim
      telescope-fzf-native-nvim
      telescope-symbols-nvim
      telescope-undo-nvim
      # LSP
      nvim-cmp
      cmp-buffer
      cmp-cmdline
      cmp-nvim-lsp
      cmp-path
      nvim-lspconfig
      luasnip
      aerial-nvim
      # Syntax
      nvim-treesitter-setup
      nvim-treesitter-endwise
      nvim-treesitter-context
      nvim-treesitter-rainbow
      vim-json
      nvim-autopairs  #replace? lexima-vim
    ];
  };
}
