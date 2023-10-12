return {
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "echasnovski/mini.bufremove",
    },
    opts = function()
      return {
        options = {
          mode = "buffers",
          close_command = function(n)
            require("mini.bufremove").delete(n, false)
          end,
          right_mouse_command = function(n)
            require("mini.bufremove").delete(n, false)
          end,
          diagnostics = "nvim_lsp",
          always_show_bufferline = false,
          offsets = {
            { filetype = "nvimtree" },
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
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "folke/noice.nvim",
    },
    opts = function()
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
          lualine_b = { "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = {
            {
              require("noice").api.status.command.get,
              cond = require("noice").api.status.command.has,
              color = { fg = "#ff9e64" },
            },
            {
              require("noice").api.status.mode.get,
              cond = require("noice").api.status.mode.has,
              color = { fg = "#ff9e64" },
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          },
          lualine_y = { "progress" },
          lualine_z = { "branch" },
        },
      }
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
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
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
}
