-- AI integrations. Pi is the primary coding agent frontend; future AI
-- plugins/extensions can live here too.
return {
  {
    "alex35mil/pi.nvim",
    keys = {
      { "<leader>pp", "<Cmd>Pi<CR>", desc = "Pi panel (float)" },
      {
        "<leader>pf",
        function()
          local ok, pi = pcall(require, "pi")
          if not ok or not pi.is_visible() then
            vim.cmd("Pi") -- closed: open in the current layout, don't flip
          else
            vim.cmd("PiToggleLayout") -- open: flip float/side
          end
        end,
        desc = "Pi toggle layout",
      },
      { "<leader>ps", "<Cmd>Pi layout=side<CR>", desc = "Pi side panel" },
      { "<leader>pm", "<Cmd>PiSendMention<CR>", desc = "Pi mention file/selection", mode = { "n", "x" } },
      { "<leader>pa", "<Cmd>PiAttention<CR>", desc = "Pi open next attention request" },
      { "<leader>pc", "<Cmd>PiContinue<CR>", desc = "Pi continue last session" },
      { "<leader>pr", "<Cmd>PiResume<CR>", desc = "Pi resume past session" },
      { "<leader>px", "<Cmd>PiAbort<CR>", desc = "Pi abort current operation" },
      { "<leader>pM", "<Cmd>PiSelectModel<CR>", desc = "Pi select model" },
      { "<leader>pT", "<Cmd>PiSelectThinking<CR>", desc = "Pi select thinking level" },
    },
    opts = {
      cli = {
        -- RPC mode never shows pi's project trust prompt. --approve trusts
        -- project-local .pi files for the run (same effect as /trust).
        args = { "--approve" },
      },
      layout = {
        default = "float",
        float = { width = 0.6, height = 0.8, border = "rounded" },
        side = { position = "right", width = 88 },
      },
    },
    config = function(_, opts)
      require("pi").setup(opts)

      -- Close the panel with <C-d> while in the pi prompt.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "pi-chat-prompt" },
        callback = function(ev)
          vim.keymap.set({ "n", "i" }, "<C-d>", "<Cmd>PiToggleChat<CR>", {
            buffer = ev.buf,
            desc = "Close π panel",
          })
        end,
      })

      -- The pi chat floats at zindex 10, below most other floats (snacks
      -- explorer/pickers, telescope, ...). Any focusable foreign float that
      -- opens over it would partially cover the chat, which reads as the
      -- panel being destroyed. Tuck the chat away while a foreign float is
      -- open and restore it focused when that float closes.
      local hidden_for = {} ---@type table<integer, true>

      local function pi_layout_windows()
        local ok, Sessions = pcall(require, "pi.sessions.manager")
        if not ok then return {} end
        local session = Sessions.get()
        if not session or not session.chat then return {} end
        local layout = session.chat._layout
        return { layout._history_win, layout._prompt_win, layout._attachments_win }
      end

      local function is_pi_window(win)
        for _, id in ipairs(pi_layout_windows()) do
          if id == win then return true end
        end
        return vim.startswith(vim.bo[vim.api.nvim_win_get_buf(win)].filetype or "", "pi-")
      end

      local function any_foreign_float_open()
        for _, w in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_config(w).zindex and not is_pi_window(w) then return true end
        end
        return false
      end

      vim.api.nvim_create_autocmd("WinEnter", {
        callback = function()
          local win = vim.api.nvim_get_current_win()
          vim.schedule(function()
            if not vim.api.nvim_win_is_valid(win) then return end
            -- By now the window is fully set up: zindex assigned and, for pi
            -- windows, filetype/layout fields populated.
            local cfg = vim.api.nvim_win_get_config(win)
            if not cfg.zindex or is_pi_window(win) or hidden_for[win] then return end
            local Pi = require("pi")
            if not Pi.is_visible() then return end
            hidden_for[win] = true
            Pi.toggle_chat()
            vim.api.nvim_create_autocmd("WinClosed", {
              pattern = tostring(win),
              once = true,
              callback = function()
                hidden_for[win] = nil
                if not vim.tbl_isempty(hidden_for) then return end
                -- Give the closing float a moment to tear down, then restore
                -- the chat with focus on the prompt.
                vim.defer_fn(function()
                  if any_foreign_float_open() then return end
                  local p = require("pi")
                  if p.is_visible() then return end
                  local ok, Sessions = pcall(require, "pi.sessions.manager")
                  if not ok then return end
                  local s = Sessions.get()
                  if s and s.chat then s.chat:ensure_shown_and_focus_prompt() end
                end, 100)
              end,
            })
          end)
        end,
      })
    end,
  },
}
