{ lib, pkgs, ... }:
let
  nvim-treesitter-setup = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.c
    p.dockerfile
    p.go
    p.hcl
    p.json
    p.jsonnet
    p.lua
    p.nix
    p.python
    p.regex
    p.ruby
    p.vimdoc
  ]);
  extraPackages = with pkgs; [
    clang-tools
    fd
    go
    gopls
    jsonnet-language-server
    lua-language-server
    manix
    nil
    pyright
    ripgrep
    rubyPackages.solargraph
    rubyPackages.yard
    stylua
  ];
in
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withRuby = true;
    inherit extraPackages;
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];
    initLua =
      with pkgs.vimPlugins;
      let
        mini = sub: {
          name = "mini.${sub}";
          path = mini-nvim;
        };
        plugins = [
          LazyVim
          aerial-nvim
          blink-cmp
          blink-compat
          conform-nvim
          flash-nvim
          friendly-snippets
          git-conflict-nvim
          gitsigns-nvim
          grug-far-nvim
          lazydev-nvim
          lualine-nvim
          (mini "ai")
          (mini "icons")
          (mini "pairs")
          neo-tree-nvim
          noice-nvim
          nui-nvim
          nvim-lint
          nvim-lspconfig
          nvim-treesitter-setup
          nvim-treesitter-context
          nvim-treesitter-textobjects
          nvim-ts-autotag
          nvim-web-devicons
          onedark-nvim
          persistence-nvim
          plenary-nvim
          sidekick-nvim
          snacks-nvim
          telescope-nvim
          telescope-fzf-native-nvim
          todo-comments-nvim
          trouble-nvim
          ts-comments-nvim
          vim-go
          vim-json
          vim-jsonnet
          which-key-nvim
        ];
        mkEntryFromDrv =
          drv:
          if lib.isDerivation drv then
            {
              name = "${lib.getName drv}";
              path = drv;
            }
          else
            drv;
        lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
      in
      ''
        require("lazy").setup({
          defaults = {
            lazy = true,
          },
          dev = {
            -- reuse files from pkgs.vimPlugins.*
            path = "${lazyPath}",
            patterns = { "" },
            -- fallback to download
            fallback = true,
          },
          install = { missing = false }, -- Safeguard in case we forget to install a plugin with Nix
          spec = {
            { "LazyVim/LazyVim", import = "lazyvim.plugins" },
            { import = "lazyvim.plugins.extras.editor.aerial" },
            { import = "lazyvim.plugins.extras.editor.neo-tree" },
            { import = "lazyvim.plugins.extras.ui.treesitter-context" },
            { import = "plugins" },
          },
        })
      '';
  };
  xdg.configFile."nvim/lua" = {
    recursive = true;
    source = ./lua;
  };
}
