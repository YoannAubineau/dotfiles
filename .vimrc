" Get rid of original Vi compatibility
set nocompatible

" Bash-style file completion
set wildmode=longest,list

" Enable syntax highlighting
syntax on

" Make Vim use lighter colors on dark background
set background=dark

" Automatically indent based on file type
filetype indent on

" Keep indentation level from previous line
set autoindent

" Enable line numbers
set nu

" Enable ruler
set ruler

" Always show status bar
set laststatus=2

" Highlight search
set hlsearch

" Do incremental search
set incsearch

" Force 1 line of context above or below the cursor
set scrolloff=1

" Underline current line in active window
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

" Enable mouse use
set mouse=a

" Import Python-specific configuration
source ~/.vim/vimrc_python

