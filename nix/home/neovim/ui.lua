vim.opt.showmode = false
vim.opt.cmdheight = 0

require("notify").setup({
  timeout = 3000,
  max_height = function()
    return math.floor(vim.o.lines * 0.75)
  end,
  max_width = function()
    return math.floor(vim.o.columns * 0.75)
  end,
})

require("bufferline").setup({
  options = {
    mode = "buffers",
    -- stylua: ignore
    close_command = function(n) require("mini.bufremove").delete(n, false) end,
    -- stylua: ignore
    right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
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
})

require("lualine").setup({
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
})

-- Display characters
vim.opt.list = true
vim.opt.listchars = {
  tab = "→ ",
  eol = "↲",
  trail = "∙",
  extends = "❯",
  precedes = "❮",
}

vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { fg = "#E06C75", nocombine = true })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", { fg = "#E5C07B", nocombine = true })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent3", { fg = "#98C379", nocombine = true })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent4", { fg = "#56B6C2", nocombine = true })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent5", { fg = "#61AFEF", nocombine = true })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent6", { fg = "#C678DD", nocombine = true })
vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { fg = "#FF5555", nocombine = true })

require("indent_blankline").setup({
  char = "│",
  context_char = "┃",
  filetype_exclude = {
    "lspinfo",
    "packer",
    "checkhealth",
    "help",
    "man",
    "dashboard",
    "NvimTree",
    "text",
  },

  use_treesitter = true,

  char_highlight_list = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
    "IndentBlanklineIndent3",
    "IndentBlanklineIndent4",
    "IndentBlanklineIndent5",
    "IndentBlanklineIndent6",
  },

  show_trailing_blankline_indent = false,
  show_first_indent_level = false,

  show_current_context = true,
  show_current_context_start = false,

  space_char_blankline = " ",
})

require("noice").setup({
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
})
