filetype on
autocmd FileType c,cpp,perl set cindent
set smartindent
set shiftwidth=2
set backup
set enc=utf-8
set fenc=utf-8
set fencs=iso-2022-jp,euc-jp,cp932,utf-8
syn on
filetype plugin on
set ic
syntax on
set noeb vb t_vb=

set backup
set backupdir=$HOME/.vim-backup
let &directory = &backupdir
if !isdirectory(expand('~/.vim-backup')) 
  call mkdir(expand('~/.vim-backup'),"p", 0700) 
endif

autocmd FileType * setlocal formatoptions-=ro

au BufEnter *.hs compiler ghc
let g:ghc="/opt/local/bin/ghc"
let g:haddock_docdir="/home/masa/doc/ghc/"
let g:haddock_browser="open"
let g:haddock_indexfiledir="/home/masa/.vim/idx/"


set iminsert=0 imsearch=0
if has("gui_running")
  set antialias 
  set macatsui
  set guifont=Osaka-Mono:h16
  set transparency=240
  hi IMLine guibg=Gray guifg=Black
endif


if has('autocmd')
  autocmd FileType c set omnifunc=ccomplete#Complete
  autocmd FileType css set omnifunc=csscomplete#CompleteCSS
  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType php set omnifunc=phpcomplete#CompletePHP
  autocmd FileType python set omnifunc=pythoncomplete#Complete
  autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
endif
set complete+=k

autocmd FileType python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl tabstop=8 expandtab shiftwidth=4 softtabstop=4

if filereadable(expand('~/.vim/neobundle.vim'))
  source ~/.vim/neobundle.vim
endif


au BufEnter * call MyLastWindow()
function! MyLastWindow()
  if &buftype=="quickfix"
    if winnr('$') < 2
      quit
    endif
  endif
endfunction
