return {
  -- Flash enhances the built-in search functionality by showing labels
  -- at the end of each match, letting you quickly jump to a specific
  -- location.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        "s",
        function() require("flash").jump() end,
        desc = "Flash",
        mode = { "n", "x", "o" },
      },
      {
        "S",
        function() require("flash").treesitter() end,
        desc = "Flash Treesitter",
        mode = { "n", "o", "x" },
      },
      {
        "r",
        function() require("flash").remote() end,
        desc = "Remote Flash",
        mode = { "o" },
      },
      {
        "R",
        function() require("flash").treesitter_search() end,
        desc = "Treesitter Search",
        mode = { "o", "x" },
      },
      {
        "<c-s>",
        function() require("flash").toggle() end,
        desc = "Toggle Flash Search",
        mode = { "c" },
      },
    },
  },
}
