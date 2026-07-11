return {
  {
    "akinsho/toggleterm.nvim",
    cmd = { "TermExec", "ToggleTerm" },
    keys = {
      { "<C-g>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal", mode = { "n", "t" } },
    },
    opts = {
      open_mapping = "<C-g>",
      direction = "float",
      shade_terminals = true,
      float_opts = {
        border = "curved",
      },
    },
  },
  {
    "numToStr/Navigator.nvim",
    opts = {
      disable_on_zoom = true,
    },
    keys = {
      {
        "<C-w>h",
        function() require("Navigator").left() end,
        desc = "NavigatorLeft",
        silent = true,
        mode = { "n", "t" },
      },
      {
        "<C-w>l",
        function() require("Navigator").right() end,
        desc = "NavigatorRight",
        silent = true,
        mode = { "n", "t" },
      },
      {
        "<C-w>k",
        function() require("Navigator").up() end,
        desc = "NavigatorUp",
        silent = true,
        mode = { "n", "t" },
      },
      {
        "<C-w>j",
        function() require("Navigator").down() end,
        desc = "NavigatorDown",
        silent = true,
        mode = { "n", "t" },
      },
    },
  },
}
