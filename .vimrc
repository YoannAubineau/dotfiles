" Enable syntax highlighting
syntax on

" Automatically indent based on file type
filetype indent on

" Keep indentation level from previous line
set autoindent

" Enable line numbers
set nu

" Highlight search
set hlsearch

" Underline current line in active window
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

" Enable mouse use
set mouse=a

" Import Python-specific configuration
source ~/.vim/vimrc_python

