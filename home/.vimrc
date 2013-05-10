set nocompatible

let mapleader = ","

filetype plugin on
filetype indent on

syntax on
set number
set laststatus=2

" word wrap
set wrap!

" tab stuff
"set tabstop=2
"set shiftwidth=2
"set softtabstop=2
"set autoindent
"set expandtab
"set smarttab

" search stuff
set incsearch
set hlsearch
set ignorecase
set smartcase
set gdefault

" no idea
set directory=~/tmp,/var/tmp,/tmp

nmap <silent> <Leader>d :noh<cr>
