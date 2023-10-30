local o = vim.o
local augroup = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd

-- Display settings
o.title = true -- Show file in titlebar
o.termguicolors = true -- Truecolor
o.scrolloff = 5 -- Lines above/below cursor when scrolling
o.showmatch = true -- Show matching bracket (briefly jump)
o.matchtime = 2 -- Show matching bracket for 0.2 seconds
o.wrap = true -- Wrap long lines
o.linebreak = true -- Wrap long lines at characters in breakat
o.breakindent = true -- Preserve the indentation of a virtual line. These "virtual lines" are the ones only visible when wrap is enabled.
o.cursorline = false -- Disable highlighting of the current line
-- opt.showcmd = true
-- opt.cmdheight = 0
-- opt.laststatus = 3 -- Use a global statusbar
--
-- Set relative numbers in NORMAL but switch to absolute in INSERT
o.number = true
o.relativenumber = true

-- Dynamic number
local numbertoggle_group = augroup("numbertoggle", { clear = true })
aucmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  pattern = "*",
  group = numbertoggle_group,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})

aucmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  pattern = "*",
  group = numbertoggle_group,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      vim.cmd("redraw")
    end
  end,
})

-- Search config
o.hlsearch = false -- Disable highlights the results of the previous search

-- Default Indentation
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.expandtab = true

-- No noise
o.errorbells = false

-- Misc
o.swapfile = false -- Disable use of swapfile for the buffer

-- Decrease update time
o.updatetime = 250

-- -- Copy/Paste
-- opt.preserveindent = true -- Preserve indent structure as much as possible
-- opt.copyindent = true     -- Copy the previous indentation on autoindenting

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
  if desc then
    opts.desc = desc
  end
  vim.keymap.set(mode, keys, func, opts)
end

keymap({ "n", "x", "o" }, "<leader>h", "^") -- Quick jump to start
keymap({ "n", "x", "o" }, "<leader>l", "g_") -- Quick jump to end
keymap({ "n", "x" }, "x", '"_x') -- Disable yank on delete
keymap("n", "<leader>a", ":keepjumps normal! ggVG<cr>", "Select All") -- Select all text in buffer
keymap("n", "<leader>w", vim.cmd.write, "Write Buffer") -- Write buffer
keymap("n", "<leader>bl", function()
  vim.cmd.buffer("#")
end, "Last Buffer") -- Go to last buffer

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

-- User commands
local user_group = augroup("user", { clear = true })

aucmd("FileType", {
  group = user_group,
  pattern = { "help", "man" },
  desc = "Use q to close the window",
  command = "nnoremap <buffer> q <cmd>quit<cr>",
})

aucmd("TextYankPost", {
  group = augroup("highlightyank", { clear = true }),
  desc = "Highlight on yank",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 500 })
  end,
})

-- Configure diagnostics and windows
-- These have to configured before plugins and tools hook into them
vim.diagnostic.config({
  signs = true,
  underline = true,
  update_in_insert = false,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
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
o.syntax = "enable" -- Syntax highlight
vim.g.editorconfig = true -- Enable EditorConfig support

-- -- Set rounded windows
-- -- Overriding vim.lsp.util.open_floating_preview
-- local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
-- ---@diagnostic disable-next-line: duplicate-set-field
-- function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
--   opts = opts or { border = "rounded", style = "minimal", focusable = true }
--   opts.border = opts.border or "rounded"
--   return orig_util_open_floating_preview(contents, syntax, opts, ...)
-- end
--
