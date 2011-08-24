set nocompatible
syntax on
syntax sync minlines=500

"let g:pathogen_disabled =[]

"if !has('gui_running')
"    call add(g:pathogen_disabled,'css_color')
"    call add(g:pathogen_disabled,'CSApprox')
"endif

call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

let mapleader=","
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

set hidden
set backspace=indent,eol,start
set tabstop=4
set shiftwidth=4
set expandtab
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

" vim solarized dark setup
set background=dark
let g:solarized_termtrans=1
let g:solarized_termcolors=88
let g:solarized_contrast="high"
let g:solarized_visibility="high"
colorscheme solarized

"set rtp+=~/.vim/vundle/
"call vundle#rc()

"Bundle 'vim-scripts/AutoClose'
autocmd FileType html,htmldjango,jinjahtml,eruby,mako let b:closetag_html_style=1
autocmd FileType html,xhtml,xml,htmldjango,jinjahtml,eruby,mako source ~/.vim/bundle/closetag/plugin/closetag.vim
