vim.opt.showmode = false
vim.opt.cmdheight = 0

local lualine = require('lualine')

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local lualine_lsp = {
  function()
    local msg = 'No Active Lsp'
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  icon = ' LSP:',
  color = { gui = 'bold' },
}

lualine.setup({
  options = {
    theme = 'dracula-nvim',
    icons_enabled = true,
    component_separators = '|',
    section_separators = "",
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'simple_mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { lualine_lsp, 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
})
