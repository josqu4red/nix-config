return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-telescope/telescope-fzf-native.nvim",
    "nvim-telescope/telescope-symbols.nvim",
    "debugloop/telescope-undo.nvim",
    "mrcjkb/telescope-manix",
  },
  opts = {},
  config = function(_, opts)
    telescope = require('telescope')
    telescope.load_extension('file_browser')
    telescope.load_extension('frecency')
    telescope.load_extension("fzf")
    telescope.load_extension("manix")
    telescope.load_extension("undo")
  end,
  keys = {
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
    { "<leader>fG", "<cmd>Telescope grep_string<cr>", desc = "Grep cursor" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
    { "<leader>fm", "<cmd>Telescope manix<cr>", desc = "Nix man" },
    { "<leader>fs", "<cmd>Telescope symbols<cr>", desc = "Symbols" },
    { "<leader>ft", "<cmd>Telescope file_browser<cr>", desc = "File browser" },
    { "<leader>fu", "<cmd>Telescope undo<cr>", desc = "Undo history" },
  },
}

