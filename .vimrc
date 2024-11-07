" A vimrc file
" enjoy

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Lines of history for vim to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Automatically read external file changes
set autoread

" Easier way to ESCAPE
inoremap kj <esc>
cnoremap kj <C-C>

inoremap KJ <esc>
cnoremap KJ <C-C>

" Need to pick a good leader
let mapleader = " "
let g:mapleader = " "

" But allow repeating the leader to just do the normal thing
nnoremap <leader><leader> <leader>

" Save alias
nnoremap <leader>w :w!<cr>

" Save all
" :wa does this. only saves those that need saving

" :W for sudo saving
" helpful for permission denied errors
command W w !sudo tee % > /dev/null

" Helpful when testing .vimrc changes
nnoremap <leader>r :source ~/.vimrc<cr>

" Numbering
set number

"
""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugins are managed through the vim8 packages with a helper
" script to download them. See :help packages
func s:packinstall()
    let l:installer = '$HOME/.vim/pack/install.sh'
    let l:cmd = 'sh ' . l:installer
    if exists(l:installer)
       execute '!' . l:cmd
    endif
endfunction
command! PackInstall call s:packinstall()

""""""""""""""""""""""""""""""""""""""""""""""""""""
" FZF
""""""""""""""""""""""""""""""""""""""""""""""""""""

" TODO

""""""""""""""""""""""""""""""""""""""""""""""""""""
" C++ highlighting
" This may slow things down
" For use with https://github.com/bfrg/vim-cpp-modern
""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable highlighting of C++11 attributes
let g:cpp_attributes_highlight = 1

" Highlight struct/class member variables (affects both C and C++ files)
let g:cpp_member_highlight = 1

" Put all standard C and C++ keywords under Vim's highlight group 'Statement'
" (affects both C and C++ files)
let g:cpp_simple_highlight = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python highlighting
""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:python_highlight_all = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""
" UI
""""""""""""""""""""""""""""""""""""""""""""""""""""

" Avoid garbled characters in other language OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on yee ol wild menu
" It's the wild west out here
" May want to set wildmode=longest:full,full
set wildmenu

" Ignore compiled files
set wildignore=*.o,*.~,*.pyc

" Ignore source control files
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.gh/*,*/.svn/*,*/.DS_STORE
endif

" Show current position
set ruler

" Command bar height
set cmdheight=2

" Allow buffers to be hidden when they are unsaved.
set hid

" Allow wrapping around lines with arrow left, right, h, and l
set whichwrap+=<,>,h,l

" Ignore case when searching
" Can disable with :set noignorecase
set ignorecase

" Try to be smart about cases when searching
set smartcase

" Highlight search results
set hlsearch

" Clear last highlight with :noh or this alias
noremap <silent> <leader><cr> :noh<cr>

" Show all search results highlighted at once
set incsearch

" Jump to matching open bracket when closing bracket is inserted
set showmatch
set mat=2

" Magical regular expressions, a lifesaver
set magic

" Performance: don't redraw while executing macros
set lazyredraw

" Do not play error sounds
set noerrorbells
set novisualbell
set t_vb=
set tm=500
set belloff=all

" Can increase this for left margin
set foldcolumn=0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Required to enable true color support on st
" https://wiki.archlinux.org/title/St#256color_and_truecolor_support_not_working_in_tmux_or_otherwise
set t_8f=[38;2;%lu;%lu;%lum        " set foreground color
set t_8b=[48;2;%lu;%lu;%lum        " set background color
try
    colorscheme gruvbox
catch
    colorscheme desert
endtry
set t_Co=256                         " Enable 256 colors
set termguicolors                    " Enable GUI colors for the terminal to get truecolor

" Syntax highlighting
syntax enable

set background=dark

" utf8 is the standard encoding for me
set encoding=utf8

" Unix is the standard file type
set ffs=unix,dos,mac

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File management
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Turn off backup files
" But note that arch linux has pretty good defaults
set nobackup
set nowb
set noswapfile

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TABS
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" I'm particular about tabs
" Use spaces instead of tabs, try to be smart about it,
" Not exactly sure about shiftwidth but we want 1 tab
" to be 4 spaces
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set softtabstop=0

" Smart indent and auto indent
set autoindent
set smartindent

" Either don't wrap lines
"set nowrap
"set sidescroll=5
"set listchars+=precedes:<,extends:>

" Or do wrap lines, but be smart about it
set wrap
set linebreak
set breakindent
set showbreak=

" Maximum text width we'll allow
" Maybe can set this to 79 for python files?
set textwidth=500

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Pressing * or # in visual mode searches for the current selection
" Similar to * or # in normal mode searches for current word
" Credit to Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Movement!
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" A simple, vim-only, easier way to move between windows
"noremap <C-h> <C-W>h
"noremap <C-j> <C-W>j
"noremap <C-k> <C-W>k
"noremap <C-l> <C-W>l

" A more complex, fancy way to use the same mappings to move between vim and tmux windows
function! s:VimNavigate(direction)
    try
        execute 'wincmd ' . a:direction
    catch
        echohl ErrorMsg
            \ | echo 'E11: Invalid in command-line window; <CR> executes, CTRL-C quits: wincmd k'
            \ | echohl None
    endtry
endfunction

nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <silent> <c-p> :TmuxNavigatePrevious<cr>
nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>

if empty($TMUX) " No tmux session available
    command! TmuxNavigateLeft call s:VimNavigate('h')
    command! TmuxNavigateDown call s:VimNavigate('j')
    command! TmuxNavigateUp call s:VimNavigate('k')
    command! TmuxNavigateRight call s:VimNavigate('l')
    command! TmuxNavigatePrevious call s:VimNavigate('p')
else " tmux session is available
    command! TmuxNavigateLeft call s:TmuxAwareNavigate('h')
    command! TmuxNavigateDown call s:TmuxAwareNavigate('j')
    command! TmuxNavigateUp call s:TmuxAwareNavigate('k')
    command! TmuxNavigateRight call s:TmuxAwareNavigate('l')
    command! TmuxNavigatePrevious call s:TmuxAwareNavigate('p')
endif

let s:tmux_is_last_pane = 0
augroup tmux_vim_navigation
    " deletes old autocommands in this augroup
    au!
    " WinEnter is 'after entering another window', notably 'not done for
    " first window'. That is, when we move from one vim window to another,
    " it means that tmux is definitively not where we came from.
    autocmd WinEnter * let s:tmux_is_last_pane = 0
augroup END

" Mapping vim directions with tmux pane edges. For use with "if-shell -F '#{pane_at_top}' 'true' 'false'"
let s:pane_edge_from_direction = {'h': 'left', 'j': 'bottom', 'k': 'top', 'l': 'right'}

function! s:TmuxAwareNavigate(direction)
    let nr = winnr()
    " Don't try the vim movement command if we just came from tmux
    " and we're trying to go to the previous pane. Vim remembers the
    " last vim window open and will go to that, but we want to go
    " back to tmux if we just came from there.
    let l:goto_previous_tmux = (a:direction == 'p' && s:tmux_is_last_pane)
    if !l:goto_previous_tmux
        call s:VimNavigate(a:direction)
    endif
    " Forward the switch panes command to tmux if:
    " a) we're on an edge; we tried switching windows in vim to no avail
    " b) we just came from tmux and we're headed back to the 'previous'
    let l:on_vim_edge = nr == winnr()
    if (l:on_vim_edge || l:goto_previous_tmux)
        try
            wall " save all the buffers. See :help wall
        catch /^Vim\%((\a\+)\)\=:E141/ " catches the no file name error
        endtry
        let l:args =
            \ 'select-pane -t '
            \ . shellescape($TMUX_PANE)
            \ . ' -' . tr(a:direction, 'phjkl', 'lLDUR')
        " Preserve zoom
        let l:args .= ' -Z'
        " Don't do anything if trying to move up from the top pane (etc)
        " However, allow movement when we are in zoom mode.
        " Also always fine to go to the previous pane
        if a:direction != 'p'
            let args =
                        \ 'if -F "#{&&:#{?window_zoomed_flag,0,1},#{pane_at_'
                        \ . s:pane_edge_from_direction[a:direction]
                        \ . '}}" "" "' . args . '"'
        endif
        silent call s:TmuxCommand(l:args)
        let s:tmux_is_last_pane = 1 " just moved to tmux
    else
        let s:tmux_is_last_pane = 0 " just moved within vim
    endif
endfunction

function! s:TmuxCommand(args)
    let l:cmd = 'tmux' . ' -S ' . s:TmuxSocket() . ' ' . a:args
    let l:x=&shellcmdflag " save (to restore) shellcmdflag state
    let &shellcmdflag='-c' " non-interactive mode for a moment
    let l:retval=system(l:cmd)
    let &shellcmdflag=l:x
    return l:retval
endfunction

function! s:TmuxSocket()
    " The socket path is the first value in the comma-separated list of $TMUX.
    return split($TMUX, ',')[0]
endfunction

" Vim will jump to the last place when reopening a file
" This might be included in some vim installs
" Super helpful
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Buffers
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Buffer movement left and right
noremap <leader>l :bnext<cr>
noremap <leader>h :bprevious<cr>

" Go to next buffer, previous buffer
noremap <leader>bn :bn<cr>
noremap <leader>bp :bp<cr>

" Go to alternate buffer
noremap <leader>ba :b#<cr>

" Close all buffers
noremap <leader>bca :bufdo bd<cr>

" Close this buffer
noremap <leader>bd :bd<cr>

" List buffers
noremap <leader>bl :buffers<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tabs
" Note that tabs should really be used like layouts
" and buffers should be used to open files
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Make a new tab
noremap <leader>tn :tabnew<cr>

" Delete all other tabs, make this the only one
noremap <leader>to :tabonly<cr>

" Close this tab
noremap <leader>tc :tabclose<cr>

" Move this tab to the end
noremap <leader>tm :tabmove<cr>

" Go to the next tab
noremap <leader>tt :tabnext<cr>

" Go to the last accessed tab
"let g:lasttab = 1
"noremap <leader>tl :exe "tabn ".g:lasttab<cr>
"au TabLeave * let g:lasttab = tabpagenr()

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Turn paste mode on/off
" Seem to be issues turning paste mode off from within
" insert mode, since paste mode disable insert mode mappings
noremap <leader>pp :set paste!<cr>
set pastetoggle=<F2>
set showmode

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Helpful functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Deletes trailing whitespace in the entire file
" Works by marking the current position, performing the
" substitution, and jumping back to the mark
func! DeleteTrailingWhitespace()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
command DeleteTrailingWhitespace call DeleteTrailingWhitespace()

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Status
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Always show status line
set laststatus=2

" Set the status line
set statusline=
set statusline +=%1*\ %n\ %*            "buffer number
set statusline +=%5*%{&ff}%*            "file format
set statusline +=%3*%y%*                "file type
set statusline +=%6*%{''.(&fenc!=''?&fenc:&enc).''}%*   "encoding
set statusline +=%5*%{''.(&paste?'\ \[PASTE\]':'').''}%*   "paste mode
set statusline +=%4*\ %<%F%*            "full path
set statusline +=%2*%m%*                "modified flag
set statusline +=%1*%=%5l%*             "current line
set statusline +=%2*/%L%*               "total lines
set statusline +=%1*%4v\ %*             "virtual column number
set statusline +=%2*0x%04B\ %*          "character under cursor

" Colors:
" 1: red
" 2: green
" 3: yellow
" 4: blue
" 5: pink
" 6: teal
" 7: white
" 8: gray
hi User1 ctermfg=166 ctermbg=16
hi User2 ctermfg=1   ctermbg=16
hi User3 ctermfg=5  ctermbg=16
hi User4 ctermfg=2   ctermbg=16
hi User5 ctermfg=11  ctermbg=16
hi User6 ctermfg=8   ctermbg=16

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Spelling
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" I think this adds code completion
set complete+=kspell

" Toggle spell check
noremap <leader>ss :setlocal spell!<cr>

" Next spelling error
noremap <leader>sn ]s

" Previous spelling error
noremap <leader>sp [s

" Add current word to dictionary
noremap <leader>sa zg

" Offer spelling replacement suggestions
noremap <leader>s? z=

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OTHER VIMRC FILES
""""""""""""""""""""""""""""""""""""""""""""""""""""""

source ~/.vim/.vimrc-py

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTES
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Yank/delete/etc history is stored in registers
" View registers with :reg
" Paste from registers with "xp where x is the register name
" Register names are viewable in the :reg table
