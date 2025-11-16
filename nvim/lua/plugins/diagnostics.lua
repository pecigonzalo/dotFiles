return {
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      {
        "<leader>xx",
        function() require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } }) end,
        desc = ": " .. "Document Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        function() require("trouble").toggle({ mode = "diagnostics" }) end,
        desc = ": " .. "Workspace Diagnostics (Trouble)",
      },
      {
        "<leader>xL",
        function() require("trouble").toggle("loclist") end,
        desc = ": " .. "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        function() require("trouble").toggle("quickfix") end,
        desc = ": " .. "Quickfix List (Trouble)",
      },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then vim.notify(err, vim.log.levels.ERROR) end
          end
        end,
        desc = ": " .. "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then vim.notify(err, vim.log.levels.ERROR) end
          end
        end,
        desc = ": " .. "Next trouble/quickfix item",
      },
    },
  },
}
