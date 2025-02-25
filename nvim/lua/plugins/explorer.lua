return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      vim.keymap.set("n", "<C-\\>", function() require("nvim-tree.api").tree.toggle() end)
      return {
        filters = {
          custom = { "^\\.git$" },
        },
        hijack_cursor = true,
        update_focused_file = {
          enable = true,
        },
        renderer = {
          icons = {
            glyphs = {
              git = {
                unstaged = "!",
                staged = "+",
                unmerged = "",
                renamed = "»",
                untracked = "?",
                deleted = "✘",
                ignored = "◌",
              },
            },
          },
        },
      }
    end,
  },

  -- Testing a new file explorer
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    keys = {
      { "<space>fb", ":Telescope file_browser<CR>", desc = "File Browser" },
    },
    init = function() require("telescope").load_extension("file_browser") end,
  },
}
