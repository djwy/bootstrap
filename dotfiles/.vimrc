set nocompatible

" ----------------------------------------------------------------------------
"   Plugins
" ----------------------------------------------------------------------------
source ~/.vim/plug.vim

" NERDTree
" au VimEnter *  NERDTree " Automatically open NERDTREE
let NERDTreeShowHidden=1

" CtrlP map enter to new tab
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<c-t>'],
    \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
    \ }

" Neocomplete options
let g:acp_enableAtStartup = 0 " Disable AutoComplPop.
let g:neocomplete#enable_at_startup = 1 " Use neocomplete.
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3 " Set minimum syntax keyword length.

" Airline
let g:airline_theme = 'base16_default' " Airline
let g:airline_left_sep=' '
let g:airline_right_sep=' '
let g:airline_powerline_fonts=0

" ----------------------------------------------------------------------------
"   Theming
" ----------------------------------------------------------------------------
set term=xterm
set t_Co=256
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"
set background=dark
colorscheme base16-railscasts            " Would like to use peacocks-in-space
let base16colorspace=256
syntax on                                " Syntax on by default
let &t_SI.="\e[5 q"                      " have different cursor when in edit mode
let &t_EI.="\e[1 q"

" ----------------------------------------------------------------------------
"   Settings
" ----------------------------------------------------------------------------
set clipboard=unnamed                    " Clipboard support
set title                                " Show the filename in the window titlebar.
set timeoutlen=1000 ttimeoutlen=0        " Remove the delay when escaping from insert-mode
set mouse=a                              " Enable mouse support
if &term =~ '^screen'
  " tmux knows the extended mouse mode
  set ttymouse=xterm2
endif
set ttyfast
set number                               " number + relative number = line nr on active, relative for rest
set relativenumber
set laststatus=2
set ruler
set wildmenu
set autoread
set history=1000
set tabpagemax=50
set backspace=indent,eol,start
set list listchars=tab:»·,trail:·,nbsp:· " Display extra whitespace
set ignorecase                           " Case insensitive matching
set smartcase                            " Unless we use a capital letter anywhere

" Make it obvious where 80 characters is
set textwidth=100
set colorcolumn=+1

" ----------------------------------------------------------------------------
"   Undo / Backup / Swap file locations
" ----------------------------------------------------------------------------
set directory=$HOME/.vim/swap//
set backupdir=$HOME/.vim/backup//
if exists('+undodir')
  set undodir=$HOME/.vim/undo
  set undofile
endif

" ----------------------------------------------------------------------------
"   Indentation
" ----------------------------------------------------------------------------
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

" ----------------------------------------------------------------------------
"   Use the silver searcher
"   https://github.com/ggreer/the_silver_searcher
" ----------------------------------------------------------------------------
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag -Q -l --nocolor --hidden -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" ----------------------------------------------------------------------------
"   Key Bindings
" ----------------------------------------------------------------------------
set list listchars=trail:.,extends:>
autocmd FileWritePre * :call TrimWhiteSpace()
autocmd FileAppendPre * :call TrimWhiteSpace()
autocmd FilterWritePre * :call TrimWhiteSpace()
autocmd BufWritePre * :call TrimWhiteSpace()

map <F2> :call TrimWhiteSpace()<CR>
map! <F2> :call TrimWhiteSpace()<CR>
map <C-\> <Plug>NERDTreeTabsToggle<CR>

" Window mappings
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Make Y consistent with D
nnoremap Y y$

" Reselect visual block after indent/outdent: http://vimbits.com/bits/20
vnoremap < <gv
vnoremap > >gv
vnoremap = =gv

" Leader mappings
let mapleader = "\<Space>"
map <Leader>p :set paste<CR><esc>"*]p:set nopaste<cr>
map <Leader>h :noh<CR>
map <Leader>s :w<CR>
map <Leader>n <Plug>NERDTreeTabsToggle<CR>
map <Leader>\ <Plug>NERDTreeTabsOpen<CR><c-w>p<Plug>NERDTreeTabsFind<CR>
map <Leader><Tab> gt
map <Leader><S-Tab> gT

" Neocomplete mappings
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
imap <silent> <expr> <CR> <SID>neocr()
function! s:neocr()
  return pumvisible() ? "\<c-y>\<Plug>(neosnippet_expand_or_jump)" : "\<CR>"
endfunction
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
