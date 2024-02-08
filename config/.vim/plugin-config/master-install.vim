" install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/pack')

Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'francoiscabrol/ranger.vim'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf.vim'

Plug 'airblade/vim-gitgutter'

Plug 'lervag/vimtex'

Plug 'sirver/ultisnips'

Plug 'drewtempelmeyer/palenight.vim'

call plug#end()
