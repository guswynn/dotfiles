" Load my older vimrc
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" Mouse
" TODO: figure out how to do this without visual mode
" set mouse=a
" Somehow this makes scrolling work
nmap <Down> <C-e>
nmap <Up> <C-y>


" Turn off blinking
set guicursor=
set guicursor+=a:blinkon0
