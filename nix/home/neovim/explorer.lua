-- Explorer
require("nvim-tree").setup({
  filters = {
    custom = { ".git" },
  },
  hijack_cursor = true,
  open_on_setup = true,
})

vim.api.nvim_set_keymap('n', '<C-\\>', ':NvimTreeToggle<CR>', {})

vim.cmd('autocmd BufEnter * ++nested if winnr("$") == 1 && bufname() == "NvimTree_" . tabpagenr() | quit | endif')
