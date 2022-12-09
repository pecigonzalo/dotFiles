vim.opt.showmode = false
vim.opt.cmdheight = 0

local lualine = require('lualine')

lualine.setup({
  options = {
    theme = 'dracula-nvim',
    icons_enabled = true,
    component_separators = '|',
    section_separators = "",
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'diff', 'diagnostics' },
    lualine_c = {
      {
        'lsp_progress',
        display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' } },
        timer = { progress_enddelay = 1000, spinner = 500, lsp_client_name_enddelay = 2000 },
        spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
      }
    },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'branch' }
  },
})
