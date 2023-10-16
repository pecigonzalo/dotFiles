return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    vim.keymap.set("n", "<C-\\>", function()
      require("nvim-tree.api").tree.toggle()
    end)
    return {
      filters = {
        custom = { "^\\.git$" },
      },
      hijack_cursor = true,
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
}
