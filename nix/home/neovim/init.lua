local opt = vim.opt

vim.g.dracula_colorterm = 0
vim.cmd [[ colorscheme dracula ]]

opt.syntax = "enable" -- Syntax highlight

-- Display settings
opt.termguicolors = true -- Truecolor
opt.mouse = "a" -- Enable mouse support
opt.scrolloff = 5 -- 2 lines above/below cursor when scrolling
opt.showmatch = true -- Show matching bracket (briefly jump)
opt.showmode = true -- Show mode in the status bar (insert/replace/...)
opt.showcmd = true -- Show typed command in status bar
opt.title = true -- Show file in titlebar
opt.matchtime = 2 -- Show matching bracket for 0.2 seconds
vim.wo.wrap = false

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

-- Default Indentation
opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- No noise
opt.errorbells = false

-- Misc
opt.incsearch = true
opt.smartcase = true
opt.swapfile = false
opt.backup = false
opt.undodir = "~/.vim/undodir"
opt.undofile = true


-- indent-blankline-nvim
-- NOTE: Has to run at the end to avoid being overriden
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]
