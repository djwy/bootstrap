set nocompatible

" bundles + plugin settings
source ~/.vim/plug.vim
source ~/.vim/neocomplete.config.vim
let g:airline_theme = 'base16_default' " Airline
let g:airline_powerline_fonts = 1
" au VimEnter *  NERDTree " Automatically open NERDTREE
let NERDTreeShowHidden=1
" end bundles + plugin settings
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<c-t>'],
    \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
    \ }

" Syntastic settings
let g:syntastic_javascript_checkers = ['eslint']
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0

" Theming
set term=xterm
set t_Co=256
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"
set background=dark
colorscheme base16-railscasts        " Would like to use peacocks-in-space
let base16colorspace=256

syntax on                         " Syntax on by default
let &t_SI.="\e[5 q"               " have different cursor when in edit mode
let &t_EI.="\e[1 q"

" Settings
set clipboard=unnamed             " Clipboard support
set title                         " Show the filename in the window titlebar.
set timeoutlen=1000 ttimeoutlen=0 " Remove the delay when escaping from insert-mode
set mouse=a                       " Enable mouse support
set ttyfast
set ttymouse=xterm2
set number                        " number + relative number = line nr on active, relative for rest
set relativenumber
set laststatus=2
set ruler
set wildmenu
set autoread
set history=1000
set tabpagemax=50
set backspace=indent,eol,start
set list listchars=tab:»·,trail:·,nbsp:· " Display extra whitespace
set ignorecase " Case insensitive matching
set smartcase  " Unless we use a capital letter anywhere

" Indentation
filetype plugin indent on
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Search highlighting
set incsearch " Highlight while searching
set hlsearch  " Highlight after entering search

" Window splitting behaviour
set splitbelow
set splitright

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Removes trailing spaces
function TrimWhiteSpace()
  %s/\s*$//
  ''
endfunction

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag -Q -l --nocolor --hidden -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

set list listchars=trail:.,extends:>
autocmd FileWritePre * :call TrimWhiteSpace()
autocmd FileAppendPre * :call TrimWhiteSpace()
autocmd FilterWritePre * :call TrimWhiteSpace()
autocmd BufWritePre * :call TrimWhiteSpace()

map <F2> :call TrimWhiteSpace()<CR>
map! <F2> :call TrimWhiteSpace()<CR>
map <C-\> <Plug>NERDTreeTabsToggle<CR>

" Keymaps
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

let mapleader = "\<Space>"
map <Leader>p :set paste<CR><esc>"*]p:set nopaste<cr>
map <Leader>h :noh<CR>
map <Leader>s :w<CR>
map <Leader>n <Plug>NERDTreeTabsToggle<CR>
map <Leader>\ <Plug>NERDTreeTabsOpen<CR><c-w>p<Plug>NERDTreeTabsFind<CR>
map <Leader><Tab> gt
map <Leader><S-Tab> gT

