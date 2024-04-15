"remove arrow keys from normal mode
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

"move by visual line not actal line
nnoremap j gj
nnoremap k gk

"use semicolon as colon in normal mode
nnoremap ; :

" jk for escape
inoremap kj <Esc>
cnoremap kj <C-C>

" move between splits and create new ones
" can be a double-edged sword when it's an accident
function! WinMove(key)
  let t:curwin = winnr()
  exec "wincmd ".a:key
  if (t:curwin == winnr())
    if (match(a:key,'[jk]'))
      wincmd v
    else
      wincmd s
    endif
    exec "wincmd ".a:key
  endif
endfunction
nnoremap <silent> <C-h> :call WinMove('h')<CR>
nnoremap <silent> <C-j> :call WinMove('j')<CR>
nnoremap <silent> <C-k> :call WinMove('k')<CR>
nnoremap <silent> <C-l> :call WinMove('l')<CR>

let mapleader = "\<Space>"
let maplocalleader ="\<Space>"

" clear search
noremap <leader>n :noh<CR>
" terminal
nmap <leader>o :term<CR>
" plugin-specific keybinds are in ~/.vim/plugin-config/keymaps.vim

" --------------------------------------------------

" tab configuration

" space-t for new tab
nmap <leader>t :tablast <bar> :tabnew<CR>

" space-1,9 to navigate to other tabs
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<CR>

" move tabs left/right using space-arrow keys
noremap <leader><Left>  :-tabmove<cr>
noremap <leader><Right> :+tabmove<cr>

" --------------------------------------------------

" buffer configuration
" space-q to close buffer
nmap <leader>q :bd<CR>

" show buffers
nnoremap <silent> <leader>bb :buffers<CR>

" delete hidden buffers
function DeleteHiddenBuffers()
  let tpbl=[]
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    silent execute 'bwipeout' buf
  endfor
endfunction
" delete empty buffers
function! DeleteEmptyBuffers()
  let [i, n; empty] = [1, bufnr('$')]
  while i <= n
    if bufexists(i) && bufname(i) == ''
      call add(empty, i)
    endif
    let i += 1
  endwhile
  if len(empty) > 0
    exe 'bdelete' join(empty)
  endif
endfunction

" space-bx to delete empty and hidden buffers
nnoremap <leader>bx :call DeleteEmptyBuffers() <bar> :call DeleteHiddenBuffers()<CR>

" change ranger f binding to r
let g:ranger_map_keys = 0
map <leader>r :Ranger<CR>

" fzf files
map <leader>f :Files<CR>

" markdown
nmap <C-m> <Plug>MarkdownPreview
nmap <M-m> <Plug>MarkdownPreviewStop
nmap <leader>m <Plug>MarkdownPreviewToggle
