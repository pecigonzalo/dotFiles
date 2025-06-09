return {
  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "echasnovski/mini.bufremove",
    },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    },
    opts = function()
      return {
        options = {
          mode = "buffers",
          close_command = function(n) require("mini.bufremove").delete(n, false) end,
          right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
          diagnostics = "nvim_lsp",
          always_show_bufferline = false,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "left",
              separator = true,
            },
          },
        },
        highlights = {
          buffer_selected = {
            italic = false,
          },
          indicator_selected = {
            fg = { attribute = "fg", highlight = "function" },
            italic = false,
          },
        },
      }
    end,
  },
  -- Winbar
  {
    "Bekaboo/dropbar.nvim",
  },

  -- Bottom line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      vim.o.laststatus = vim.g.lualine_laststatus
      return {
        options = {
          theme = "dracula-nvim",
          icons_enabled = true,
          component_separators = "|",
          section_separators = "",
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "diff" },
          lualine_c = {
            { "diagnostics" },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, padding = { left = 0, right = 1 } },
          },
          lualine_x = {
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = { "branch" },
        },
      }
    end,
  },

  -- Displays a popup with possible key bindings of the command you started typing
  {
    "folke/which-key.nvim",
    dependencies = {
      "echasnovski/mini.icons",
    },
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    opts_extend = { "spec" },
    opts = {
      win = {
        border = "rounded",
      },
      spec = {
        mode = { "n", "v" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
      },
    },
  },

  -- Revamp many UI elements
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 1500,
      },
      picker = {
        enabled = true,
        matcher = { frecency = true },
      },
      explorer = {
        replace_netrw = true,
      },
    },
    keys = function()
      local snacks = require("snacks")
      return {
        -- vim
        { "<leader>:", function() snacks.picker.command_history() end, desc = "Command History" },
        { "<leader><space>", function() snacks.picker.smart() end, desc = "Smart Find Files" },
        { "<leader>,", function() snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>/", function() snacks.picker.grep() end, desc = "Grep" },
        { "<leader>n", function() snacks.picker.grep() end, desc = "Notifications" },
        { "<leader>un", function() snacks.notifier.hide() end, desc = "Dismiss All Notifications" },

        -- find
        { "<leader>fb", function() snacks.picker.buffers() end, desc = "Find Buffers" },
        { "<leader>ff", function() snacks.picker.files() end, desc = "Find Files" },

        -- grep
        { "<leader>sb", function() snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>sB", function() snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
        { "<leader>sg", function() snacks.picker.grep() end, desc = "Grep" },
        { "<leader>sq", function() snacks.picker.qflist() end, desc = "Quickfix List" },

        {
          "<leader>sw",
          function() snacks.picker.grep_word() end,
          desc = "Visual selection or word",
          mode = { "n", "x" },
        },

        -- search
        { "<leader>sh", function() snacks.picker.help() end, desc = "Help Pages" },
        {
          "<leader>sw",
          function() snacks.picker.grep_word() end,
          desc = "Visual selection or word",
          mode = { "n", "x" },
        },
        { "<leader>sa", function() snacks.picker.autocmds() end, desc = "Autocmds" },
        { "<leader>sc", function() snacks.picker.commands() end, desc = "Commands" },
        { "<leader>sd", function() snacks.picker.diagnostics() end, desc = "Diagnostics" },
        { "<leader>sq", function() snacks.picker.qflist() end, desc = "Quickfix List" },
        { "<leader>su", function() snacks.picker.undo() end, desc = "Undo History" },

        -- git
        { "<leader>gl", function() snacks.picker.git_log() end, desc = "Git Log" },
        { "<leader>gs", function() snacks.picker.git_status() end, desc = "Git Status" },
        { "<leader>gb", function() snacks.picker.git_branches() end, desc = "Git Branches" },

        -- LSP
        { "gd", function() snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
        { "gr", function() snacks.picker.lsp_references() end, nowait = true, desc = "References" },
        { "gI", function() snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
        { "gD", function() snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
        { "<leader>ss", function() snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },

        -- TODO
        { "<leader>st", function() snacks.picker.todo_comments() end, desc = "Todo" },
        {
          "<leader>sT",
          function() snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end,
          desc = "Todo/Fix/Fixme",
        },

        -- Buffers
        { "<leader>bd", function() snacks.bufdelete() end, desc = "Delete Buffer" },
        { "<leader>bD", function() snacks.bufdelete.other() end, desc = "Delete All Buffer" },

        -- Explorer
        {
          "<leader>e",
          function() snacks.explorer() end,
          desc = "Open Explorer",
        },
        {
          "<C-\\>",
          function() snacks.explorer() end,
          desc = "Open Explorer",
        },
      }
    end,
  },
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    event = "VeryLazy",
    opts = {
      views = {},
      lsp = {
        progress = {
          view = "notify",
          opts = {
            replace = true,
          },
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = { event = "lsp", kind = "progress" },
          view = "notify",
          opts = {
            replace = true,
          },
        },
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+l, %d+b" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
  },
}
