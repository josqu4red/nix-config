return {
  "neovim/nvim-lspconfig",
  cmd = "LspInfo",
  event = {"BufReadPre", "BufNewFile"},
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  init = function()
    vim.opt.signcolumn = "yes"
  end,
  config = function()
    local lsp_defaults = require("lspconfig").util.default_config

    lsp_defaults.capabilities = vim.tbl_deep_extend(
      "force",
      lsp_defaults.capabilities,
      require("cmp_nvim_lsp").default_capabilities()
    )

    -- LspAttach is where you enable features that only work
    -- if there is a language server active in the file
    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP actions",
      callback = function(event)
        local opts = {buffer = event.buf}

        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
        vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
        vim.keymap.set("n", "gR", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        vim.keymap.set("n", "gF", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
        vim.keymap.set("n", "gA", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

        -- if client.server_capabilities.document_formatting then
        --   map.set("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        -- elseif client.server_capabilities.document_range_formatting then
        --   map.set("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        -- end
      end,
    })

    local lspconfig = require("lspconfig")
    local servers = {"clangd", "gopls", "jsonnet_ls", "pyright", "nil_ls", "solargraph"}
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup({})
    end
  end
}


