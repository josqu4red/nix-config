{ pkgs, ... }:
let
  nvim-treesitter-setup = pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
    # TODO: p.haskell
    [ p.c p.dockerfile p.go p.hcl p.json p.jsonnet p.lua p.nix p.python p.regex p.ruby p.vimdoc ]
  );
  # TODO: haskell-language-server
  extraPackages = with pkgs; [ clang-tools fd go gopls manix pyright ripgrep nil rubyPackages.solargraph ];
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
      telescope-manix
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
      rainbow-delimiters-nvim
      vim-json
      nvim-autopairs  #replace? lexima-vim
    ];
  };
}
