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

" lightline
"Plug 'itchyny/lightline.vim'
"Plug 'itchyny/vim-gitbranch'

" auto commenter
"Plug 'preservim/nerdcommenter'

" autopairs
Plug 'jiangmiao/auto-pairs'

" git gutter
Plug 'airblade/vim-gitgutter'

"Plug 'vim-latex/vim-latex'
Plug 'lervag/vimtex'

Plug 'SirVer/ultisnips'
"Plug 'honza/vim-snippets'

Plug 'dylanaraps/wal'

call plug#end()
