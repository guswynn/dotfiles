set nocompatible
set tabstop=2
set expandtab
set shiftwidth=2
set number
set ls=2
set ruler
set history=50
set backspace=indent,eol,start

set noswapfile

"au BufRead,BufNewFile *.asm set filetype=txt
syntax on
"set autoindent
"set smartindent
"filetype indent plugin on
""set cindent
"let delimitMate_expand_cr=1
"
"
""Set expand Tab is off for now"
filetype plugin on
set expandtab"
colorscheme peachpuff
highlight ColorColumn ctermbg=0
highlight SignColumn ctermbg=0
highlight SpellBad ctermbg=9

set hlsearch
highlight Search ctermfg=yellow
set wildmode=longest,list,full
set wildmenu
"
"" from guide
set showcmd
"set cursorline
set colorcolumn=80,88

set scrolljump=1

set nowrap

set ttimeout ttimeoutlen=0
set timeoutlen=1000
" Disable Arrow keys in Escape mode
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Disable Arrow keys in Insert mode
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

let mapleader = "\<Space>"
function! FollowTag()
    if !exists("w:tagbrowse")
        vsplit
        let w:tagbrowse=1
    endif
    execute "tag " . expand("<cword>")
    execute "normal! \<c-w>="
endfunction
nnoremap <Leader><Leader> :call FollowTag()<CR>

function! EditTarget()
    let basepath = expand('%:p:h') . '/TARGETS'
    if !filereadable(basepath)
        let basepath = expand('%:p:h') . '/../TARGETS'
        if !filereadable(basepath)
            echo "Cannot find TARGETS file"
            return
        endif
    endif
    execute "vsplit " . basepath
endfunction
nnoremap <Leader>t :call EditTarget()<CR>

let g:ale_lint_on_enter = 0
let g:ale_python_autopep8_use_global=1
let g:ale_python_flake8_use_global=1
let g:ale_python_isort_use_global=1
let g:ale_python_mypy_use_global=1
let g:ale_python_mypy_options='--ignore-missing-imports'
let g:ale_python_pycodestyle_use_global=1
let g:ale_python_pylint_use_global=1
let g:ale_python_yapf_use_global=1
let g:ale_echo_msg_format = '[%linter%] %s'

" Format Python with https://github.com/ambv/black
function Blackify()
  let b:ale_fixers = {'python': ['pyfmt']}

endfunction

autocmd BufNewFile,BufRead *.py call Blackify()

autocmd BufNewFile,BufRead *.h,*.cpp let b:ale_fixers = {'cpp': ['clang-format']}

" Format when we save
let g:ale_fix_on_save = 1

" vimwiki lmaoooo got em
let g:vimwiki_list = [{'path': '~/wiki/', 'syntax': 'markdown', 'ext': '.md'}]

" Easy movement between lint warnings and errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
