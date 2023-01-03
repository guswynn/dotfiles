" Basic defaults
set nocompatible
set tabstop=2
set expandtab
set shiftwidth=2
set number
set ls=2
set ruler
set history=50
set backspace=indent,eol,start


" No swapfile getting all mad
set noswapfile


" Programming languages
syntax on
filetype plugin on
set expandtab"


" TODO: why aren't these on?
"au BufRead,BufNewFile *.asm set filetype=txt
"set autoindent
"set smartindent
"filetype indent plugin on
""set cindent
"let delimitMate_expand_cr=1
""Set expand Tab is off for now"


" Leader is space
let mapleader="\<Space>"


" no more ex mode
:map Q <Nop>


" make search and replace preview
set inccommand=nosplit


" Make search highlight nicely
set hlsearch
set wildmode=longest,list,full
set wildmenu


" TODO: what are these for
set showcmd
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


" LSP stuff

" ALE
" Currently I just have ALE for python and clang formatting, but they may be
" broken, and I use it for FAST rust formatting

" how it shoes up
let g:ale_echo_msg_format = '[%linter%] %s'
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
" only in NeoVim, cancels out the message at the bottom
let g:ale_close_preview_on_insert = 1
let g:ale_set_balloons = 1
" when it shows up
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 1
" Fixers and Linters
let g:ale_fixers = {'python': ['isort', 'black'], 'rust': ['rustfmt']}
let g:ale_rust_rustfmt_options = "+nightly"
let g:ale_rust_rustfmt_options = '--edition 2021'
let g:ale_linters = {'python': ['flake8']}

let g:ale_pattern_options = {
\   'timely-dataflow.*': {'ale_fixers': {}},
\   'differential-dataflow.*': {'ale_fixers': {}},
\}
" python
let g:ale_python_autopep8_use_global=1
let g:ale_python_flake8_use_global=1
let g:ale_python_isort_use_global=1
let g:ale_python_mypy_use_global=1
let g:ale_python_mypy_options='--ignore-missing-imports'
let g:ale_python_pycodestyle_use_global=1
let g:ale_python_pylint_use_global=1
let g:ale_python_yapf_use_global=1
" Easy movement between lint warnings and errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Not needed with ale anymore
" Language server support
" install https://github.com/autozimu/LanguageClient-neovim/blob/next/INSTALL.md
set runtimepath+=~/.vim-plugins/LanguageClient-neovim

" coc.nvim
" This is primarily for rust-analyzer
" Installed with https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim#using-vim8s-native-package-manager
" and https://github.com/fannheyward/coc-rust-analyzer

" No suggest on markdown
autocmd FileType markdown let b:coc_suggest_disable = 1

" See https://github.com/jonhoo/configs/commit/593423096b2bd3fe6d6c65d6cc44ae9e76c89f5d
" for more info
" Ctrl-Tab to go through completions
" also try shift-n thing that typically works

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Leader-g-d to jump to definition
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" from here: https://github.com/neoclide/coc.nvim/issues/586
" set "coc.preferences.jumpCommand": "CocSplitIfNotOpen" if you want this,
" currently disabled
function! SplitIfNotOpen(...)
    let fname = a:1
    let call = ''
    if a:0 == 2
	let fname = a:2
	let call = a:1
    endif
    let bufnum=bufnr(expand(fname))
    let winnum=bufwinnr(bufnum)
    if winnum != -1
	" Jump to existing split
	exe winnum . "wincmd w"
    else
	" Make new split as usual
	exe "vsplit " . fname
    endif
    " Execute the cursor movement command
    exe call
endfunction
command! -nargs=+ CocSplitIfNotOpen :call SplitIfNotOpen(<f-args>)

" TODO: try out neovim's builtin support for LSP's, following 
" https://github.com/jonhoo/configs/commit/593423096b2bd3fe6d6c65d6cc44ae9e76c89f5d


" Colors
" Using `LiquidCarbonTransparent` in wezterm
colorscheme koehler

" Make strings looks better
hi String ctermfg=Red
" Rust specific color overrides
hi rustInvalidBareKeyword ctermbg=Black ctermfg=DarkRed
" coc-rust-analyzer hover specific colors
hi CocFLoating ctermbg=DarkGray
hi CocRustTypeHint ctermfg=DarkGray
hi CocHintSign ctermfg=DarkGray
" Markdown specific colors
hi markdownItalic ctermbg=Yellow ctermfg=Black
" No longer relevant
" make search highlight look nicer
"hi Search ctermfg=Black ctermbg=Yellow guifg=Black
"hi SpellBad ctermfg=Black
"hi SpellCap ctermfg=Black


" Config and color for indentline
let g:indentLine_color_term='DarkGray'
let g:markdown_syntax_conceal=0
let g:vim_json_conceal=0

" Mouse mode
set mouse=a
" Kaleb says this is slightly better
if has('mouse_sgr')
  set ttymouse=sgr
endif

set spell spelllang=en_us
"Turn off the capitalization check
set spellcapcheck=
