let g:dracula_colorterm = 0
colorscheme dracula

" enable syntax hightlight and completion
syntax on

" enable filetype dectection and ft specific plugin/indent
filetype plugin indent on

" Highlight current line
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn

" display settings
set t_Co=256 " Explicitly tell vim that the terminal has 256 colors
set mouse=a " use mouse in all modes
set scrolloff=5 " 2 lines above/below cursor when scrolling
set showmatch " show matching bracket (briefly jump)
set showmode " show mode in status bar (insert/replace/...)
set showcmd " show typed command in status bar
set title " show file in titlebar
set matchtime=2 " show matching bracket for 0.2 seconds
set nowrap
set colorcolumn=80

" Set relative numbers by default but switch to absolute in INSERT
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END

" Default Indentation
set smartindent
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab

" No noise
set noerrorbells

" Misc
set incsearch
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

" NERD Tree auto-open
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" Open NERD Tree with CTRL+\
map <C-\> :NERDTreeToggle<CR>
" NERD Tree auto-close
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" NERD Tree config
let NERDTreeShowHidden=1

" Display spaces and tabs
set listchars=tab:‣\ ,trail:·,precedes:«,extends:»

" GitGutter
let g:gitgutter_sign_added = '∙'
let g:gitgutter_sign_modified = '∙'
let g:gitgutter_sign_removed = '∙'
let g:gitgutter_sign_modified_removed = '∙'
highlight GitGutterAdd ctermfg=2
highlight GitGutterChange ctermfg=3
highlight GitGutterDelete ctermfg=1
highlight GitGutterChangeDelete ctermfg=4
