" NERD Tree auto-open
vim.api.nvim_create_autocmd('StdinReadPre', {
  command = '* let s:std_in=1'
})
vim.api.nvim_create_autocmd('VimEnter', {
  command = '* if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe \'NERDTree\' argv()[0] | wincmd p | ene | endif'
})
" Open NERD Tree with CTRL+\\
vim.api.nvim_set_keymap('<C-\\>', ':NERDTreeToggle<CR>')
" NERD Tree auto-close
vim.api.nvim_create_autocmd('bufenter' {
  command = '* if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif'
})
" NERD Tree config
local NERDTreeShowHidden=1
