call plug#begin('~/.vim/plugged')

"-----------------
" Dracula Theme
"-----------------
Plug 'dracula/vim', { 'as': 'dracula' }

"-----------------
" Code Completion
"-----------------
Plug 'ervandew/supertab'
Plug 'Shougo/neocomplcache'

"-----------------------
" Surrounding Operation
"-----------------------
Plug 'Raimondi/delimitMate'
Plug 'vim-scripts/matchit.zip'
Plug 'tpope/vim-surround'

"--------------
" Code Reading
"--------------
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'

"-------------
" Other Utils
" ------------
Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf'
Plug 'airblade/vim-gitgutter'

"--------------
" Color Scheme
"--------------
Plug 'rickharris/vim-monokai'

"--------------
" Languages
"--------------
Plug 'hashivim/vim-terraform'
Plug 'juliosueiras/vim-terraform-completion'

call plug#end()

let g:dracula_colorterm = 0
colorscheme dracula

" encoding utf-8
set encoding=utf-8

" enable filetype dectection and ft specific plugin/indent
filetype plugin indent on

" enable syntax hightlight and completion
syntax enable
syntax on

" Highlight current line
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn

" display settings
set t_Co=256                                                      " Explicitly tell vim that the terminal has 256 colors "
set mouse=a                                                       " use mouse in all modes"
set report=0                                                      " always report number of lines changed"
set wrap                                                          " wrap lines
set scrolloff=5                                                   " 2 lines above/below cursor when scrolling
set showmatch                                                     " show matching bracket (briefly jump)
set showmode                                                      " show mode in status bar (insert/replace/...)
set showcmd                                                       " show typed command in status bar
set ruler                                                         " show cursor position in status bar
set title                                                         " show file in titlebar
set matchtime=2                                                   " show matching bracket for 0.2 seconds
set matchpairs+=<:>                                               " specially for html
set list listchars=tab:<+                                         " display TAB as <+++

" Default Indentation
set smartindent     " indent when
set tabstop=4       " tab width
set softtabstop=4   " backspace &
set shiftwidth=4    " indent width
set expandtab       " expand tab to space

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk

" NERD Tree auto-open
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" Open NERD Tree with CTRL+\
map <C-\> :NERDTreeToggle<CR>
" NERD Tree auto-close
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" NERD Tree config
let NERDTreeShowHidden=1

" Terraform Config
let g:terraform_align=1
let g:terraform_remap_spacebar=1
let g:terraform_commentstring='//%s'
let g:terraform_fmt_on_save=1

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
