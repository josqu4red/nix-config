{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.neovim;

  nvim-treesitter-setup = pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
    [ p.go p.hcl p.json p.jsonnet p.nix p.ruby ]
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
      rev = "09dcb851701747b3f4c5c1088befc88e1601942d";
      sha256 = "sha256-n83wbP18NaZ6/F6gFYdvaYBjXSVlePZ0954H4DUuICk=";
    };
  };
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
      extraPackages = with pkgs; [ gopls nodePackages.pyright rnix-lsp rubyPackages.solargraph ];
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
        nvim-surround
        luasnip
        # Syntax
        nvim-treesitter-setup
        nvim-treesitter-endwise
        nvim-ts-rainbow2
        vim-better-whitespace
        vim-json
        delimitMate
        # Visuals
        neoscroll-nvim
        onedark-nvim
      ];
    };
  };
}
