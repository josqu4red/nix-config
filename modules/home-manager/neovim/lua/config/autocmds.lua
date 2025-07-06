local autocmd = vim.api.nvim_create_autocmd

autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.libsonnet" },
  command = "set filetype=jsonnet",
})

autocmd({ "BufEnter" }, {
  pattern = { "*.yml", "*.yaml" },
  command = "set indentkeys-=0#",
})

autocmd({ "FileType" }, {
  pattern = "ruby",
  command = "setlocal indentkeys-=.",
})
