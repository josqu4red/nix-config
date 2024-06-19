local g = vim.g
local map = vim.keymap
local autocmd = vim.api.nvim_create_autocmd

g.mapleader = ','
g.localleader = ','
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_perl_provider = 0

vim.opt.cursorline = true
vim.opt.number = true
vim.opt.laststatus = 3 -- full-width status line
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.mouse = 'r'

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftround = true
vim.opt.shiftwidth = 2

vim.opt.list = true
vim.opt.listchars = { tab = '>·', trail = '·' }

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

map.set('n', '-', 'ddkP') -- swap above
map.set('n', '_', 'ddp')  -- swap below
map.set('v', 'p', '"_dP', { noremap = true }) -- dont yank on paste

-- Plugins

require('onedark').setup {
  style = 'darker',
}
require('onedark').load()

require('rainbow-delimiters.setup').setup()

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  endwise = {
    enable = true,
  },
}

require('treesitter-context').setup()

require('nvim-tree').setup{
  filters = { custom = { "^.git$" } }
}
map.set('n', '<Leader>n', ':NvimTreeFindFileToggle<CR>')

require('lualine').setup()

require('neoscroll').setup()

require('ibl').setup()

require('gitsigns').setup{
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map('n', '<Leader>gs', gs.stage_hunk)
    map('n', '<Leader>gr', gs.reset_hunk)
    map('v', '<Leader>gs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('v', '<Leader>gr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<Leader>gS', gs.stage_buffer)
    map('n', '<Leader>gR', gs.reset_buffer)
    map('n', '<Leader>gu', gs.undo_stage_hunk)
    map('n', '<Leader>gp', gs.preview_hunk)
    map('n', '<Leader>gb', gs.toggle_current_line_blame)
    map('n', '<Leader>gd', gs.toggle_deleted)
  end
}

telescope = require('telescope')
telescope.load_extension('file_browser')
telescope.load_extension("undo")
local builtin = require('telescope.builtin')
map.set('n', '<leader>fb', builtin.buffers, {})
map.set('n', '<leader>ff', builtin.find_files, {})
map.set('n', '<leader>fg', builtin.live_grep, {})
map.set('n', '<leader>fh', builtin.help_tags, {})
map.set('n', '<leader>fs', builtin.symbols, {})
map.set('n', '<leader>ft', telescope.extensions.file_browser.file_browser, {})
map.set('n', '<leader>fu', telescope.extensions.undo.undo, {})

require("aerial").setup({
  on_attach = function(bufnr)
    map.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    map.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

require('nvim-autopairs').setup()

-- Completion/LSP

local luasnip = require 'luasnip'
local cmp = require 'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  }),
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local on_attach = function(client, bufnr)
  local attach_opts = { silent = true, buffer = bufnr }
  map.set('n', 'gd', vim.lsp.buf.definition, attach_opts)
  map.set('n', 'gi', vim.lsp.buf.implementation, attach_opts)
  map.set('n', '<leader>D', vim.lsp.buf.type_definition, attach_opts)
  map.set('n', '<space>', vim.lsp.buf.hover, attach_opts)
  map.set('n', '<space>s', vim.lsp.buf.signature_help, attach_opts)
  map.set('n', '<leader>rn', vim.lsp.buf.rename, attach_opts)
  map.set('n', 'so', require('telescope.builtin').lsp_references, attach_opts)

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.document_formatting then
      map.set('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', attach_opts)
  elseif client.server_capabilities.document_range_formatting then
      map.set('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', attach_opts)
  end
end

-- Enable LSP servers
local lspconfig = require('lspconfig')
local capabilities = vim.tbl_deep_extend(
  'force',
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities(),
  { workspace = { didChangeWatchedFiles = { dynamicRegistration = true } } }
);

-- TODO: hls
local servers = {'gopls', 'pyright', 'nil_ls', 'solargraph'}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- require("noice").setup({
--   lsp = {
--     override = {
--       ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
--       ["vim.lsp.util.stylize_markdown"] = true,
--       ["cmp.entry.get_documentation"] = true,
--     },
--   },
-- })
