return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      numhl = true, -- Highlight line numbers for git
      word_diff = false, -- Show per-word diff

      preview_config = {
        border = "rounded",
      },
    },
    keys = function()
      local gs = require("gitsigns")
      return {
        { "<leader>ghp", gs.preview_hunk, desc = "Preview Hunk" },
        { "<leader>ghu", gs.undo_stage_hunk, desc = "Undo Stage Hunk" },
        { "<leader>ghR", gs.reset_buffer, desc = "Reset Git Buffer" },

        { "<leader>ghs", gs.stage_hunk, mode = { "n" }, desc = "Git Stage Hunk" },
        { "<leader>ghr", gs.reset_hunk, mode = { "n" }, desc = "Git Reset Hunk" },
        {
          "<leader>ghs",
          function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
          mode = { "v" },
          desc = "Git Stage Selected",
        },
        {
          "<leader>ghr",
          function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
          mode = { "v" },
          desc = "Git Reset Selected",
        },

        { "<leader>ghb", gs.toggle_current_line_blame, desc = "Git Blame" },
        { "<leader>ghd", gs.diffthis, desc = "Diff This" },
        { "<leader>ghD", function() gs.diffthis("~") end, desc = "Diff This ~" },

        -- navigation
        { "]h", gs.next_hunk, desc = "Next Hunk" },
        { "[h", gs.prev_hunk, desc = "Prev Hunk" },

        -- textobject
        { "ih", gs.select_hunk, mode = { "o", "x" }, desc = "Select Git Hunk" },
      }
    end,
  },
  {
    "sindrets/diffview.nvim",
  },
}
