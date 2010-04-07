"*****************************************************************************"
"
"     ______        _____
"   ||      |     ||     |
"    \\     /     \\     |
"     ||   |       /    /
"     ||   |      /    /
"     ||   |     /    /
"      ||   |   /    /
"      ||   | _/   _/
"      ||   |/    |_|
"      ||        / ___ __              ___    ___
"       ||     _/ \\ | \\ \−-_−-_    ||  _/ // _|
"   _   ||    /   || | || /\ /\ |    || |  || |_
"  |_|   ||__/    ||_| ||_||_||_|_   ||_|   \\__|
"
"
"                                         by Aleksandr Koss (http://nocorp.me)
"
"*****************************************************************************"

"                                                                           "
"*****************************************************************************"
"
" This config is just a part of my "The Big Vim Config" ;)
" look at ~/.vim/config/common.vim to understand how it gathers together
"
"*****************************************************************************"

 "                                                                           "
"*****************************************************************************"
"
" Key maps
"
"*****************************************************************************"
 "                                                                           "

"" Toggle between normal and insert mode

nnoremap <D-x> i
imap <D-x> <Esc>

"" Previous - Next buffer

map <C-S-Left> :bprev<CR>
map <C-S-Right> :bnext<CR>

""

imap <C-S-o> <ESC>O
imap <C-o> <ESC>o

"" Ctrl+L to clear highlight

nnoremap <C-c> :nohls<CR><C-L>
inoremap <C-c> <C-O>:nohls<CR>

"" Folding

nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>
vnoremap <Space> zf

"" Indent

" Emulate TextMate behaviour

imap <D-[> <ESC><<
imap <D-]> <ESC>>>
nmap <D-[> <<
nmap <D-]> >>
vmap <D-[> <gv
vmap <D-]> >gv

"" Windows

" Navigate between windows

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"" Surround text

"vnoremap " :call Surround('"', '"')<CR>
"vnoremap ' :call Surround("'", "'")<CR>

"""

let i=1
while i<=9
  execute "nmap <D-".i."> ".i."gt"
  execute "vmap <D-".i."> ".i."gt"
  execute "imap <D-".i."> <ESC>".i."gt"
  let i+=1
endwhile

"" Move block of text

vmap <C-j> :m'>+<CR>gv=`<my`>mzgv`yo`z
vmap <C-k> :m'<-2<CR>gv=`>my`<mzgv`yo`z

"" Autocomplete

imap <C-z> <C-x><C-o>

"" Other staff

" Sudo promt with :w!!

cmap w!! sudo tee % &>/dev/null

" vim-rails

map <Leader>rc :Rcontroller<Space>
map <Leader>rm :Rmodel<Space>
map <Leader>rv :Rview<Space>
map <Leader>rh :Rhelper<Space>

map <Leader>rl :Rlayout<Space>

map <Leader>rs :Rspec<Space>

map <Leader>re :Renvironment<Space>

map <Leader>ri :Rinitializer<Space>

map <Leader>ra :A<CR>
map <Leader>rr :R<CR>
