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

" make search and replace preview
set inccommand=nosplit

set hlsearch
set wildmode=longest,list,full
set wildmenu
"
"" from guide
set showcmd
"set cursorline
" set colorcolumn=80,88

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


" vimwiki ??
let g:vimwiki_list = [{'path': '~/wiki/', 'syntax': 'markdown', 'ext': '.md'}]

" ALE
" 
" installing ale with neovim https://github.com/dense-analysis/ale#standard-installation
" mkdir -p ~/.local/share/nvim/site/pack/git-plugins/start
" git clone --depth 1 https://github.com/dense-analysis/ale.git ~/.local/share/nvim/site/pack/git-plugins/start/ale
" or use ~/.vim/pack/git-plugins/start
"
" make sure to intall cargo/rustfmt/etc and black
" rust guide: https://github.com/dense-analysis/ale/blob/master/doc/ale-rust.txt


" ALE settings
" python
let g:ale_python_autopep8_use_global=1
let g:ale_python_flake8_use_global=1
let g:ale_python_isort_use_global=1
let g:ale_python_mypy_use_global=1
let g:ale_python_mypy_options='--ignore-missing-imports'
let g:ale_python_pycodestyle_use_global=1
let g:ale_python_pylint_use_global=1
let g:ale_python_yapf_use_global=1

" how it shoes up
let g:ale_echo_msg_format = '[%linter%] %s'
" let g:ale_hover_to_preview = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
" only in NeoVim, cancels out the message at the bottom
" let g:ale_virtualtext_cursor = 1
" let g:ale_cursor_detail = 1
let g:ale_close_preview_on_insert = 1
let g:ale_set_balloons = 1


" when it shows up
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 1
let g:rustfmt_autosave = 1

" Fixers and Linters
let g:ale_fixers = {'rust': ['rustfmt'], 'python': ['isort', 'black']}

" https://rust-analyzer.github.io/manual.html#ale
let g:ale_linters = {'python': ['flake8'], 'rust': ['analyzer']}

" let g:ale_rust_rls_executable = 'rust-analyzer'
" let g:ale_rust_rls_toolchain = ''


" Easy movement between lint warnings and errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)


" Not needed with ale anymore
" Language server support
" install https://github.com/autozimu/LanguageClient-neovim/blob/next/INSTALL.md
set runtimepath+=~/.vim-plugins/LanguageClient-neovim

" For rust analyzer
" Install the analyzer here: https://github.com/rust-analyzer/rust-analyzer/tree/master/docs/user
" let g:LanguageClient_serverCommands = {'rust': ['rust-analyzer']}


" Also might want to try this:
" https://github.com/rust-lang/rust.vim
" and this: https://rust-analyzer.github.io/manual.html#coc-rust-analyzer
"
"
" read more about jumping around: https://github.com/dense-analysis/ale/blob/master/doc/ale.txt
" https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim
"
"
let mapleader =" "
nmap <leader><space> <Plug>(ale_detail)



" Try out new colors
" install vim colors here here: https://vi.stackexchange.com/questions/14587/which-directory-to-put-color-schemes
"
" Term colors: https://github.com/martinlindhe/base16-iterm2
" You like base16-chalk
"
" builtin, altered for search
colorscheme peachpuff
hi Search ctermfg=Black
hi SpellBad ctermfg=Black
hi SpellCap ctermfg=Black
" you may also like this
" https://github.com/chriskempson/base16-vim 
" colorscheme base16-default-dark
