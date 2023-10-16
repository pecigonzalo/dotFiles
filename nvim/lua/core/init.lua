local opt = vim.opt
local augroup = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd

-- Display settings
opt.title = true         -- Show file in titlebar
opt.termguicolors = true -- Truecolor
opt.scrolloff = 5        -- Lines above/below cursor when scrolling
opt.showmatch = true     -- Show matching bracket (briefly jump)
opt.matchtime = 2        -- Show matching bracket for 0.2 seconds
opt.wrap = true          -- Wrap long lines
opt.linebreak = true     -- Wrap long lines at characters in breakat
opt.breakindent = true   -- Preserve the indentation of a virtual line. These "virtual lines" are the ones only visible when wrap is enabled.
-- opt.showcmd = true
-- opt.cmdheight = 0
-- opt.laststatus = 3 -- Use a global statusbar
--
-- Set relative numbers in NORMAL but switch to absolute in INSERT
opt.number = true
opt.relativenumber = true

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
opt.hlsearch = false -- Disable highlights the results of the previous search

-- Default Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true

-- No noise
opt.errorbells = false

-- Misc
opt.swapfile = false -- Disable use of swapfile for the buffer

-- Decrease update time
opt.updatetime = 250

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

keymap({ "n", "x", "o" }, "<leader>h", "^")                             -- Quick jump to start
keymap({ "n", "x", "o" }, "<leader>l", "g_")                            -- Quick jump to end
keymap({ "n", "x" }, "x", '"_x')                                        -- Disable yank on delete
keymap("n", "<leader>a", ":keepjumps normal! ggVG<cr>", "Select [a]ll") -- Select all text in buffer
keymap("n", "<leader>w", vim.cmd.write, "[w]rite buffer")               -- Write buffer
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

-- -- Move selected line / block of text in visual mode
-- keymap("x", "K", ":move '<-2<CR>gv=gv")
-- keymap("x", "J", ":move '>+1<CR>gv=gv")

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
opt.syntax = "enable"     -- Syntax highlight
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
