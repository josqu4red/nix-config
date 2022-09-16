{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.neovim;

  nvim-treesitter-setup = pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
    [ p.go p.hcl p.json p.jsonnet p.nix p.ruby ]
  );
in {
  options.my.home.neovim = {
    enable = mkEnableOption "neovim";
  };
  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraConfig = "lua << EOF\n" + builtins.readFile ./init.lua + "\nEOF";
      extraPackages = with pkgs; [ rnix-lsp rubyPackages.solargraph ];
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
        cmp-nvim-lsp
        nvim-lspconfig
        nvim-surround
        luasnip
        # Syntax
        nvim-treesitter-setup
        nvim-ts-rainbow
        vim-json
        # Visuals
        neoscroll-nvim
        onedark-nvim
      ];
    };
  };
}
