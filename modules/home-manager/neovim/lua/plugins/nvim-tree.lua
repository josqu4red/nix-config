return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  keys = {
    { "<leader>n", "<cmd>NvimTreeFindFileToggle<cr>", desc = "NvimTree" },
  },
  opts = {},
}
