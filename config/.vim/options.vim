" general options
set nocompatible
set encoding=utf-8
set fileencoding=utf-8
set fileformat=unix
set number relativenumber
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber
syntax enable
filetype plugin on
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set ai si " autoindenting and smartindenting
set ruler
set laststatus=3
set mouse=a
set mousehide
set cursorline
set wrap
autocmd BufRead,BufNewFile *.pdf,*.txt,*.md,*.tex setlocal wrap linebreak nolist
autocmd BufRead,BufNewFile *.txt,*.md,*.tex setlocal spell
autocmd BufRead,BufNewFile CMakeLists.txt setlocal nospell
autocmd BufRead,BufNewFile *.pdf setlocal readonly
set spellcapcheck=0
set spelllang=en
set spellfile=$HOME/.vimspell.en.utf-8.add
set updatetime=100 " update things every 100ms (helps git gutter)
set nobackup
set nowritebackup
set noswapfile
set history=100
set backspace=indent,eol,start " more powerful backspacing
set undolevels=1000
set hidden
set clipboard=unnamed
set showmatch
set incsearch
set hlsearch
set ignorecase smartcase
set autoread " autoreload file
set noeb vb t_vb= " no bell
set lazyredraw

" indicators
"set list listchars=tab:>·,trail:~,extends:>,precedes:<,space:·

" timeouts
set timeout ttimeout " separate mapping and keycode timeouts
set timeoutlen=500   " mapping timeout 500ms  (adjust for preference)
set ttimeoutlen=20   " keycode timeout 20ms
set ttyfast

" indents word-wrapped lines as much as the 'parent' line
set breakindent
set formatoptions=l
set lbr
