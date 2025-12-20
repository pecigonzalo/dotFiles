local augroup = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd

-- General
vim.o.mouse = "a" -- Enable mouse
vim.o.switchbuf = "usetab" -- Open new buffer in existing window if possible
vim.o.undofile = true -- Enable persistent undo
vim.o.swapfile = false -- Disable use of swapfile for the buffer
vim.o.errorbells = false

-- Enable all filetype plugins and syntax (if not enabled, for better startup)
vim.cmd("filetype plugin indent on")
if vim.fn.exists("syntax_on") ~= 1 then vim.cmd("syntax enable") end

-- Display settings
vim.o.title = true -- Show file in titlebar
vim.o.termguicolors = true -- Truecolor
vim.o.winborder = "rounded"
vim.o.scrolloff = 5 -- Lines above/below cursor when scrolling
vim.o.signcolumn = "yes" -- Always show signcolumn
vim.o.relativenumber = true
vim.o.ruler = false -- Disable ruler
vim.o.list = true -- Show some invisible characters

vim.o.showmatch = true -- Show matching bracket (briefly jump)
vim.o.matchtime = 2 -- Show matching bracket for 0.2 seconds

vim.o.cursorline = true -- Highlight the current line
vim.o.cursorlineopt = "screenline,number" -- Highlight the whole line, and number

vim.o.wrap = false -- Wrap long lines
vim.o.linebreak = true -- Wrap long lines at characters in breakat
vim.o.breakindent = true -- Preserve the indentation of a virtual line. These "virtual lines" are the ones only visible when wrap is enabled.
vim.o.breakindentopt = "list:-1" -- Add padding for list when wrapped

-- Special UI symbols. More is set via 'mini.basics' later.
vim.o.fillchars = "eob: ,fold:╌"
vim.o.listchars = "extends:…,nbsp:␣,precedes:…,tab:> "

-- Search config
vim.o.hlsearch = false -- Disable highlights the results of the previous search

-- Default Indentation
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

-- Decrease update time
vim.o.updatetime = 250

-- Keybindings
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.keymap.set("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = function(mode, keys, func, desc)
  local opts = {
    noremap = true,
    silent = true,
  }
  if desc then opts.desc = desc end
  vim.keymap.set(mode, keys, func, opts)
end

keymap({ "n", "x", "o" }, "<leader>h", "^") -- Quick jump to start
keymap({ "n", "x", "o" }, "<leader>l", "g_") -- Quick jump to end
keymap({ "n", "x" }, "x", '"_x') -- Disable yank on delete
keymap("n", "<leader>a", ":keepjumps normal! ggVG<cr>", "Select All") -- Select all text in buffer
keymap("n", "<leader>w", vim.cmd.write, "Write Buffer") -- Write buffer
keymap("n", "<leader>bl", function() vim.cmd.buffer("#") end, "Last Buffer") -- Go to last buffer

-- Keep selection on indent
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Keep center when scrolling
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- Paste over currently selected text without yanking it
keymap("v", "p", '"_dP')

-- Move selected line / block of text in visual mode
keymap("x", "K", ":move '<-2<CR>gv=gv")
keymap("x", "J", ":move '>+1<CR>gv=gv")

-- Configure diagnostics and windows
-- These have to configured before plugins and tools hook into them
vim.diagnostic.config({
  signs = true,
  underline = true,
  update_in_insert = false,
  float = {
    focusable = true,
    style = "minimal",
    source = "always", -- Show source
  },
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  severity_sort = true,
})

-- Syntax
vim.o.syntax = "enable" -- Syntax highlight
vim.g.editorconfig = true -- Enable EditorConfig support

-- User commands
local user_group = augroup("user", { clear = true })

aucmd("FileType", {
  desc = "Use q to close the window",
  group = user_group,
  pattern = { "help", "man" },
  command = "nnoremap <buffer> q <cmd>quit<cr>",
})

-- Restore cursor to file position in previous editing session
aucmd("BufReadPost", {
  group = user_group,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then vim.cmd('normal! g`"zz') end
  end,
})
