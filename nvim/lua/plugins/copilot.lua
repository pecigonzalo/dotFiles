return {
  {
    "zbirenbaum/copilot.lua",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      -- filetypes = { ["*"] = true },
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function(_, opts)
      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup(opts)
    end,
  },
}
