{ config, pkgs, ... }:
let
  nvim-treesitter-setup = pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
    # TODO: p.haskell
    [ p.c p.dockerfile p.go p.hcl p.json p.jsonnet p.lua p.nix p.python p.regex p.ruby p.vimdoc ]
  );
  # TODO: haskell-language-server
  extraPackages = with pkgs; [ clang-tools fd go gopls jsonnet-language-server manix pyright ripgrep nil rubyPackages.solargraph ];
  packDir = pkgs.vimUtils.packDir config.programs.neovim.finalPackage.passthru.packpathDirs;
in {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    inherit extraPackages;
    plugins = with pkgs.vimPlugins; [
      lazy-nvim

      # UI
      onedark-nvim
      nvim-web-devicons
      lualine-nvim
      aerial-nvim
      nvim-tree-lua
      #neo-tree-nvim
      vim-better-whitespace
      indent-blankline-nvim
      neoscroll-nvim
      # Telescope
      telescope-nvim
      telescope-file-browser-nvim
      telescope-frecency-nvim
      telescope-fzf-native-nvim
      telescope-manix
      telescope-symbols-nvim
      telescope-undo-nvim

      # Syntax general
      nvim-autopairs
      rainbow-delimiters-nvim
      nvim-treesitter-setup
      nvim-treesitter-endwise
      nvim-treesitter-context
      nvim-treesitter-textobjects
      # Syntax specific
      vim-go
      vim-json
      vim-jsonnet

      # Tools
      gitsigns-nvim
      git-conflict-nvim
      trouble-nvim
      # LSP
      nvim-lspconfig
      nvim-cmp
      cmp-buffer
      cmp-cmdline
      cmp-nvim-lsp
      cmp-path
    ];
    extraLuaConfig = ''
      require("config.options")
      require("config.mappings")
      require("config.autocmds")
      require("lazy").setup({
        spec = {
          { import = "plugins" },
        },
        defaults = {
          lazy = false,
          version = false,
        },
        performance = {
          reset_packpath = false,
          rtp = { reset = false },
        },
        dev = {
          path = "${packDir}/pack/myNeovimPackages/start",
          patterns = {""},
        },
        install = { missing = false }, -- Safeguard in case we forget to install a plugin with Nix
      })
    '';
  };
  xdg.configFile."nvim/lua" = {
    recursive = true;
    source = ./lua;
  };
}
