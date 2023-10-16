return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local map = function(mode, keys, func, desc)
        if desc then
          desc = ": " .. desc
        end
        vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
      end

      -- NOTE: The :Gitsigns calls automatically respects visual select
      map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Git Stage")
      map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Git Reset")
      map("n", "ghS", gs.stage_buffer, "Stage Git Buffer")
      map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Git Stage")
      map("n", "<leader>ghR", gs.reset_buffer, "Reset Git Buffer")

      map("n", "<leader>ghb", gs.toggle_current_line_blame, "Git Blame")
      map("n", "<leader>ghd", function() -- Inline diff
        gs.toggle_deleted()
        gs.toggle_linehl()
      end, "Inline Diff")
      map("n", "<leader>ghD", gs.diffthis, "Buffer Diff") -- Diff in seperate buffer
      map({ "o", "x" }, "ih", gs.select_hunk, "Select Git Hunk")
    end,

    numhl = true, -- Highlight line numbers for git

    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },

    preview_config = {
      border = "rounded",
    },
  },
}
