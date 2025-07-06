return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "RRethy/nvim-treesitter-endwise",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function ()
    require("nvim-treesitter.configs").setup({
      endwise = { enable = true },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
