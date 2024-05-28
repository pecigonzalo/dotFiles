return {
  {
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
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")

        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Git Stage")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Git Reset")
        map("n", "ghS", gs.stage_buffer, "Stage Git Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Git Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")

        map("n", "<leader>ghb", gs.toggle_current_line_blame, "Git Blame")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function()
          gs.diffthis("~")
        end, "Diff This ~")
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
  },
  {
    "sindrets/diffview.nvim",
  },
}
