local opt = vim.opt

opt.syntax = "enable" -- Syntax highlight

-- Display settings
opt.termguicolors = true -- Truecolor
opt.mouse = "a" -- Enable mouse support
opt.scrolloff = 5 -- 2 lines above/below cursor when scrolling
opt.showmatch = true -- Show matching bracket (briefly jump)
opt.title = true -- Show file in titlebar
opt.matchtime = 2 -- Show matching bracket for 0.2 seconds
opt.wrap = true -- Wrap long lines
opt.breakindent = true -- Preserve the indentation of a virtual line. These "virtual lines" are the ones only visible when wrap is enabled.
opt.showcmd = true
opt.cmdheight = 0
opt.laststatus = 3 -- Use a global statusbar

-- Set relative numbers in NORMAL but switch to absolute in INSERT
opt.number = true
opt.relativenumber = true
local augroup = vim.api.nvim_create_augroup("numbertoggle", {})
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  pattern = "*",
  group = augroup,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  pattern = "*",
  group = augroup,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      vim.cmd "redraw"
    end
  end,
})

-- Search config
opt.ignorecase = true -- Ignore uppercase letters when executing a search
opt.smartcase = true -- Ignore uppercase letters unless the search term has an uppercase letter
opt.hlsearch = false -- Disable highlights the results of the previous search

-- Default Indentation
opt.smartindent = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true

-- No noise
opt.errorbells = false

-- Misc
opt.swapfile = false -- Disable use of swapfile for the buffer
opt.backup = false
opt.undofile = true -- Enable persistent undo

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Keybindings
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable space in N and V
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

local nmap = function(keys, func, desc)
  if desc then
    desc = desc
  end
  vim.keymap.set('n', keys, func, { noremap = true, desc = desc })
end

opt.preserveindent = true -- Preserve indent structure as much as possible
opt.copyindent = true -- Copy the previous indentation on autoindenting
vim.keymap.set({ 'n', 'x' }, 'x', '"_x') -- Disable yank on delete
nmap('<leader>a', ':keepjumps normal! ggVG<cr>', 'Select [a]ll') -- Select all text in buffer
nmap('<leader>w', vim.cmd.write, '[w]rite buffer') -- Write buffer
nmap('<leader>bq', vim.cmd.bdelete, '[b]uffer [q]uit') -- Delete buffer
nmap('<leader>bl', function() vim.cmd.buffer("#") end, '[b]uffer [l]ast') -- Go to last buffer

-- User commands
local group = vim.api.nvim_create_augroup('user_cmds', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'help', 'man' },
  group = group,
  desc = 'Use q to close the window',
  command = 'nnoremap <buffer> q <cmd>quit<cr>'
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  desc = 'Highlight on yank',
  callback = function(event)
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
  end
})
