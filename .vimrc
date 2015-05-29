" Get rid of original Vi compatibility
set nocompatible

" Bash-style file completion
set wildmode=longest,list

" Enable syntax highlighting
syntax on

" Make Vim use lighter colors on dark background
set background=dark

" Automatically indent based on file type and load related plugin if any
filetype plugin indent on

" Keep indentation level from previous line
set autoindent

" Set default indentation to 4-spaces
set shiftwidth=4
set expandtab
set softtabstop=4

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

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Force 1 line of context above or below the cursor
set scrolloff=1

" Underline current line in active window
"autocmd WinEnter * setlocal cursorline
"autocmd WinLeave * setlocal nocursorline

" Enable mouse use
set mouse=a

" Do no wrap long lines
set nowrap

" Remove trailing spaces when saving files
autocmd BufWritePre *.* :%s/\s\+$//e

" Import Python-specific configuration
source ~/.vim/vimrc_python

