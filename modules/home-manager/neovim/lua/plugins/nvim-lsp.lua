return {
  "neovim/nvim-lspconfig",
  cmd = "LspInfo",
  event = {"BufReadPre", "BufNewFile"},
  init = function()
    vim.opt.signcolumn = "yes"
  end,
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup('my.lsp', {}),
      callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local opts = {buffer = args.buf}

        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
        vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
        vim.keymap.set("n", "gR", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        vim.keymap.set("n", "gF", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
        vim.keymap.set("n", "gA", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

        if client:supports_method('textDocument/declaration') then
          vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
        end

        if client:supports_method('textDocument/completion') then
          vim.lsp.completion.enable(true, client.id, args.buf)
        end
      end,
    })

    -- vim.lsp.config("*", {}) for overrides
    vim.lsp.enable({"clangd", "gopls", "jsonnet_ls", "pyright", "nil_ls", "solargraph"})
  end
}
