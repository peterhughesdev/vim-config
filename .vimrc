set nocompatible
filetype off

" set the runtime path to include vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-commentary'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'Raimondi/delimitMate'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'bling/vim-airline'
Plugin 'Valloric/YouCompleteMe'
Plugin 'majutsushi/tagbar'
Plugin 'tomasr/molokai'
Plugin 'chriskempson/vim-tomorrow-theme'
Plugin 'chriskempson/base16-vim'
Plugin 'wesQ3/vim-windowswap'

call vundle#end()
filetype plugin indent on

" colour scheme
set background=dark
colorscheme base16-default 

" misc options
" {{{ interface
" lines, cols in status line
set ruler
set rulerformat=%=%h%m%r%w\ %(%c%V%),%l/%L\ %P

" a - terse messages (like [+] instead of [Modified]
" t - truncate file names
" I - no intro message when starting vim fileless
" T - truncate long messages to avoid having to hit a key
set shortmess=atTI

" display the number of (characters|lines) in visual mode, also cur command
set showcmd

" enable mouse
set mouse=a

" current mode in status line
set showmode

" max items in popup menu
set pumheight=8

" show number column
set number
set numberwidth=3

" indicate when a line is wrapped by prefixing wrapped line with '> '
set showbreak=>\ 

" always show tab line
set showtabline=2

" highlight search matches
set hlsearch

" highlight position of cursor
set cursorline
"set cursorcolumn

" set splits to open bottom / right
set splitbelow
set splitright

"set statusline=%f\ %2*%m\ %1*%h%r%=[%{&encoding}\ %{&fileformat}\ %{strlen(&ft)?&ft:'none'}\ %{getfperm(@%)}]\ 0x%B\ %12.(%c:%l/%L%)
"set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
"set laststatus=2
" }}}
" {{{ behavior
set nocompatible
syntax on
filetype on
filetype plugin on

" fast terminal for smoother redrawing
set ttyfast

set omnifunc=syntaxcomplete#Complete

" indentation options
" Note: smartindent is seriously outdated. cindent, even, is unnecessary.
" Let the filetype plugins do the work.
set shiftwidth=4
set tabstop=4
set expandtab
filetype indent on
"set autoindent

" show matching enclosing chars for .1 sec
set showmatch
set matchtime=1

" t: autowrap text using textwidth
" l: long lines are not broken in insert mode
" c: autowrap comments using textwidth, inserting leader
" r: insert comment leader after <CR>
" o: insert comment leader after o or O
set formatoptions-=t
set formatoptions+=lcro
set textwidth=80

" context while scrolling
set scrolloff=3

" arrow keys, bs, space wrap to next/prev line
set whichwrap=b,s,<,>,[,]

" backspace over anything
set backspace=indent,eol,start

" case insensitive search if all lowercase
set ignorecase smartcase

" turn off bells, change to screen flash
set visualbell

" show our whitespace
set listchars=tab:\|\ ,trail:.
"set list

" complete to longest match, then list possibilities
set wildmode=longest,list

" turn off swap files
set noswapfile

" options for diff mode
set diffopt=filler
set diffopt+=context:4
set diffopt+=iwhite
set diffopt+=vertical

" keep a lot of history
set history=100

" keep lots of stuff
set viminfo+=:100
set viminfo+=/100

" don't duplicate an existing open buffer
set switchbuf=useopen

" }}}


" minor helpful stuff
"{{{ TAB-COMPLETE and SNIPPETS
" add new snippets as regex=>completion
" first match encountered is used
let s:snippets = {}
let s:snippets['^\s*if$'] = " () {\<CR>}\<ESC>k^f)i" 
let s:snippets['function$'] = " () {\<CR>}\<ESC>k^f(i" 
let s:snippets['^\s*class$'] = "  {\<CR>}\<ESC>kt{i"
let s:snippets['^\s*interface$'] = "  {\<CR>}\<ESC>kt{i"
let s:snippets['^\s*foreach$'] = " () {\<CR>}\<ESC>k^f)i" 
let s:snippets['^\s*while$'] = " () {\<CR>}\<ESC>k^f)i" 

" when tab is pressed:
" 1) checks snippets for matches, return match if there is one
" 2) if character behind cursor is whitespace, just return a tab
" 3) if word behind cursor contains a slash, try filename complete
" 4) otherwise, try to ctrl-p complete
fun! CleverTab()
	if pumvisible()
		return "\<C-N>"
	endif
	if col('.') > 1
		let beginning = strpart( getline('.'), 0, col('.')-1 )
		let words = split(l:beginning,' ')
		let thisWord = l:words[-1]

		for key in keys(s:snippets)
			if l:beginning =~ key
				return s:snippets[key]
			endif
		endfor
	else
		let beginning = ''
	endif

	if l:beginning == '' || l:beginning =~ '\s$'
		return "\<Tab>"
	elseif (l:thisWord =~ '/')
		return "\<C-X>\<C-F>"
	else
		return "\<C-X>\<C-O>"
		"return "\<C-P>"
	endif
endfunction
imap <Tab> <C-R>=CleverTab()<CR>
"}}}


autocmd vimenter * NERDTree
autocmd vimenter * Tagbar
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary")

nmap <F8> :NERDTreeToggle<CR>
nmap <F9> :TagbarToggle<CR>

nmap  <A-Right> :tabn<CR>
nmap  <A-Left> :tabp<CR>
nmap  <C-n> :tabnew<CR>
