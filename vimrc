"
" ~/.vimrc
"

" plugins
call plug#begin('~/.vim/plugged')

Plug 'altercation/vim-colors-solarized'
Plug 'Valloric/YouCompleteMe'
Plug 'Valloric/ListToggle'
Plug 'tpope/vim-fugitive'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
Plug 'nvie/vim-flake8'
Plug 'hynek/vim-python-pep8-indent'
Plug 'scrooloose/nerdcommenter'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'ntpeters/vim-better-whitespace'
Plug 'mitsuhiko/vim-jinja'
Plug 'mattn/emmet-vim'
Plug 'lervag/vimtex'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

call plug#end()

" general
set number
set textwidth=80
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set cindent
set smarttab
set showtabline=1
set viminfo='100,f1
set hlsearch
set incsearch
set wildmode=list:longest,full
set backspace=indent,eol,start
set nostartofline
set ignorecase
set smartcase
set ttymouse=urxvt
set mouse=a
set ttimeout
set ttimeoutlen=100
set scrolloff=1
set sidescrolloff=5
"set completeopt=longest,menuone

" prefer vertical split
set splitright
set splitbelow

" put all swap files in a central location
set directory^=$HOME/.vim/tmp//
set backupdir^=$HOME/.vim/tmp//

" solarized dark colors
colorscheme solarized
set background=dark

" gui/terminal-specific
if has('gui_running')
  set guifont=monospace\ 11.5

  " shortcut to toggle light/dark solarized
  call togglebg#map("<F4>")

  " remove gui clutter
  set guioptions-=m   " menubar
  set guioptions-=T   " toolbar
  set guioptions-=r   " right scrollbar
  set guioptions-=L   " left scrollbar

  " disable cursor blink
  set guicursor=a:blinkon0

  " disable alt-key access to menus
  set winaltkeys=no
endif

" youcompleteme settings
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_extra_conf.py'
let g:ycm_always_populate_location_list = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

" prevent vim from detecting some tex files as 'plaintex'
let g:tex_flavor='latex'
