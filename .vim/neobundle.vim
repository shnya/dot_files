if has('vim_starting')
	set nocompatible
        set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'davidhalter/jedi-vim'
NeoBundle 'andviro/flake8-vim'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'ervandew/supertab'

filetype plugin indent on
NeoBundleCheck

" for jedi-vim
let g:jedi#popup_on_dot = 0

" for supertab
let g:SuperTabDefaultCompletionType = "context"

" for indent-guides
colorscheme default
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=1
let g:indent_guides_auto_colors=1
let g:indent_guides_guide_size = 1
