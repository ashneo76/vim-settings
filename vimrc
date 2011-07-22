set nocompatible
syntax on
syntax sync minlines=500

call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

let mapleader=","
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

set hidden
set backspace=indent,eol,start
set tabstop=4
set autoindent
set copyindent
set number
set shiftround
set showmatch
set ignorecase
set smartcase
set smarttab
set incsearch
set history=1000
set undolevels=1000
set wildignore=*.swp,*.bak,*.pyc,*.class
set noerrorbells
set notitle

let g:molokai_original = 1
let g:impact_transbg = 1
"colorscheme impact

"set rtp+=~/.vim/vundle/
"call vundle#rc()

"Bundle 'vim-scripts/AutoClose'
