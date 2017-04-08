

set nocompatible " Vim, not vi
filetype off

set rtp+=~/.vim/bundle/Vundle.vim " Start Vundle
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'bling/vim-airline'
Plugin 'edkolev/tmuxline.vim'

Plugin 'fatih/vim-go'
Plugin 'wlue/vim-dm-syntax'
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'
Plugin 'tpope/vim-surround'

call vundle#end()
filetype plugin indent on

map <F2> :NERDTreeToggle<CR>
map <F3> :TagbarToggle<CR>

let g:airline_theme = "dark"

" Disable Airline fonts and set separators to an empty string - this gives a
" blockier appearance, but doesn't require any fancy fonts
let g:airline_powerline_fonts = 0
let g:airline_left_sep = ""
let g:airline_left_alt_sep = ""
let g:airline_right_sep = ""
let g:airline_right_alt_sep = ""

" Disable tmuxline's separators too
let g:tmuxline_separators = {
	\ "left": '',
	\ "right": '',
	\ "left_alt": '',
	\ "right_alt": ''}

" Vertical split separator is a space
set fillchars+=vert:\ 

" map :w!! to write root-only files
cnoremap w!! w !sudo tee >/dev/null %

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set lazyredraw
set ttyfast
set ffs=unix,mac,dos
set encoding=utf-8
set autoread
set nobackup
set noswapfile
set nowritebackup

set nojoinspaces

set laststatus=2

set wildignore+=*.pyc,*_build/*,*/coverage/*

set history=50    " keep 50 lines of command line history
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set number        " show line numbers
set nowrap        " don't wrap long lines automatically
set sidescroll=2

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

if has('clipboard')
	set clipboard=unnamedplus
endif

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
	set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
syntax on
set hlsearch
colors mycolors

" Only do this part when compiled with support for autocommands.
if has("autocmd")

	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	filetype plugin indent on

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
	au!

	" For all text files set 'textwidth' to 78 characters.
	autocmd FileType text setlocal textwidth=78

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	" (happens when dropping a file on gvim).
	" Also don't do it when the mark is in the first line, that is the default
	" position when opening a file.
	autocmd BufReadPost *
		\ if line("'\"") > 1 && line("'\"") <= line("$") |
		\ exe "normal! g`\"" |
		\ endif

	augroup END

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		\ | wincmd p | diffthis
endif

set noautoindent    " Disable auto-indenting
set noexpandtab     " Don't expand tabs to spaces
set copyindent      " 
set preserveindent  " 
set softtabstop=0   " 
set shiftwidth=4    " 
set tabstop=4       " Tabs are 4 spaces wide

" Fenced languages for GHFM, ie ["python"] enables Python highlighting for:
" ```python
" def foo():
"     return 2
" ```
let g:markdown_fenced_languages = ["python", "sh", "json", "javascript", "dm"]
let g:python_recommended_style = 0 " Don't try to PEP8 my Python

