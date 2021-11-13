syntax on

set exrc
set secure

call plug#begin(expand('~/.vim/plugged'))
Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
Plug 'arcticicestudio/nord-vim'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clangd-completer' }
Plug 'bfrg/vim-cpp-modern'
call plug#end()
" Run :PlugInstall to install plugins

set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

colorscheme elflord 

