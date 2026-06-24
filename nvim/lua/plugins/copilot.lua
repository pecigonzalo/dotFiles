return {
  {
    "zbirenbaum/copilot.lua",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      -- filetypes = { ["*"] = true },
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "zbirenbaum/copilot.lua",
    },
    config = function(_, opts)
      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup(opts)
    end,
  },
  {
    "NickvanDyke/opencode.nvim",
    keys = {
      { "<C-a>", mode = { "n", "x" }, desc = "Ask opencode…" },
      { "<C-.>", mode = { "n", "t" }, desc = "Toggle opencode" },
      { "<S-C-u>", mode = "n", desc = "Scroll opencode up" },
      { "<S-C-d>", mode = "n", desc = "Scroll opencode down" },
    },
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps.
      vim.keymap.set(
        { "n", "x" },
        "<C-a>",
        function() require("opencode").ask("@this: ", { submit = true }) end,
        { desc = "Ask opencode…" }
      )
      -- vim.keymap.set(
      --   { "n", "x" },
      --   "<C-x>",
      --   function() require("opencode").select() end,
      --   { desc = "Execute opencode action…" }
      -- )
      vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end, { desc = "Toggle opencode" })
      --
      -- vim.keymap.set(
      --   { "n", "x" },
      --   "go",
      --   function() return require("opencode").operator("@this ") end,
      --   { desc = "Add range to opencode", expr = true }
      -- )
      -- vim.keymap.set(
      --   "n",
      --   "goo",
      --   function() return require("opencode").operator("@this ") .. "_" end,
      --   { desc = "Add line to opencode", expr = true }
      -- )

      vim.keymap.set(
        "n",
        "<S-C-u>",
        function() require("opencode").command("session.half.page.up") end,
        { desc = "Scroll opencode up" }
      )
      vim.keymap.set(
        "n",
        "<S-C-d>",
        function() require("opencode").command("session.half.page.down") end,
        { desc = "Scroll opencode down" }
      )

      -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o…".
      vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
      vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
    end,
  },
}
