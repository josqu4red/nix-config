return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup{
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, {expr=true})

        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, {expr=true})

        -- Actions
        map("n", "<Leader>gs", gs.stage_hunk)
        map("n", "<Leader>gr", gs.reset_hunk)
        map("v", "<Leader>gs", function() gs.stage_hunk {vim.fn.line("."), vim.fn.line("v")} end)
        map("v", "<Leader>gr", function() gs.reset_hunk {vim.fn.line("."), vim.fn.line("v")} end)
        map("n", "<Leader>gS", gs.stage_buffer)
        map("n", "<Leader>gR", gs.reset_buffer)
        map("n", "<Leader>gu", gs.undo_stage_hunk)
        map("n", "<Leader>gp", gs.preview_hunk)
        map("n", "<Leader>gb", gs.toggle_current_line_blame)
        map("n", "<Leader>gd", gs.toggle_deleted)
      end
    }
  end
}
