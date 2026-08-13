return {
  {
    "zbirenbaum/copilot.lua",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = function()
      -- vim.g.ai_cmp = true:  copilot suggestions come from the completion menu (blink-copilot source)
      -- vim.g.ai_cmp = false: copilot.lua native ghost text, accepted with <Tab>
      return {
        suggestion = {
          enabled = not vim.g.ai_cmp,
          auto_trigger = true,
          hide_during_completion = vim.g.ai_cmp,
          keymap = {
            accept = false, -- handled by blink.cmp
            next = "<M-]>",
            prev = "<M-[>",
          },
        },
        panel = { enabled = false },
        -- Don't start the Copilot language server in pi.nvim buffers.
        filetypes = {
          ["pi-chat-history"] = false,
          ["pi-chat-prompt"] = false,
          ["pi-chat-attachments"] = false,
          ["pi-dialog"] = false,
        },
      }
    end,
  },
}
