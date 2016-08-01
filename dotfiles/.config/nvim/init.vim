" ============================================================================
"   Plugins
" ============================================================================
source ~/.config/nvim/plug.vim

" NERDTree (sidebar)
" ----------------------------------------------------------------------------
" options
let NERDTreeShowHidden=1

" mappings
map <Leader>n <Plug>NERDTreeTabsToggle<CR>
map <Leader>\ :NERDTreeTabsOpen<CR><c-w>l:NERDTreeTabsFind<CR>

" CtrlP (fuzzy finder)
" ----------------------------------------------------------------------------
" Default to opening in a new tab
let g:ctrlp_prompt_mappings = {
      \ 'AcceptSelection("e")': ['<c-t>'],
      \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
      \ }
let g:ctrlp_show_hidden = 1

" Ack (file contents search)
" ----------------------------------------------------------------------------
cnoreabbrev Ack Ack!
nnoremap <Leader>f :Ack!<Space>

" Silver Searcher for Ack/Ctrlp
" https://github.com/ggreer/the_silver_searcher
" ----------------------------------------------------------------------------
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use Ag over Ack
  let g:ackprg = 'ag --vimgrep'

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag -Q -l --nocolor --hidden -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Neomake (linter)
" ----------------------------------------------------------------------------
autocmd! BufEnter * Neomake
autocmd! BufWritePost * Neomake


" Deoplete (autocomplete)
" ----------------------------------------------------------------------------
" options
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#sources#syntax#min_keyword_length = 3
let g:deoplete#auto_complete_start_length = 1

" mappings
inoremap <expr><C-g> deoplete#mappings#undo_completion()
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  deoplete#mappings#smart_close_popup()."\<C-h>"

" UltiSnips (snippets)
" ----------------------------------------------------------------------------
" mappings
let g:UltiSnipsExpandTrigger="<nop>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:ulti_expand_or_jump_res = 0

" use enter to expand snippet suggestions
function ExpandSnippetOrCarriageReturn()
  let snippet = UltiSnips#ExpandSnippetOrJump()
  if g:ulti_expand_or_jump_res > 0
    return snippet
  else
    return "\<CR>"
  endif
endfunction
inoremap <expr> <CR> pumvisible() ? "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"

" Airline (status bar)
" ----------------------------------------------------------------------------
let g:airline_left_sep=' '
let g:airline_right_sep=' '
let g:airline_powerline_fonts=0

" VimTest
" ----------------------------------------------------------------------------
" options
let test#strategy = "neovim"

" mappings
map <Leader>t :TestFile<CR>
map <Leader>T :TestNearest<CR>
map <Leader>l :TestLast<CR>

" ============================================================================
"   Theming
" ============================================================================
syntax on                                " Syntax on by default

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
set background=dark
colorscheme material-theme
let g:airline_theme = 'base16_flat' " Airline


" ============================================================================
"   Settings
" ============================================================================
set clipboard=unnamed                    " Clipboard support
set title                                " Show the filename in the window titlebar.
set timeoutlen=1000 ttimeoutlen=0        " Remove the delay when escaping from insert-mode
set mouse=a                              " Enable mouse support
set number
set numberwidth=5
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
set lazyredraw

" Undo / Backup / Swap file locations
" ----------------------------------------------------------------------------
set directory=$HOME/.config/nvim/swap//
set backupdir=$HOME/.config/nvim/backup//
if exists('+undodir')
  set undodir=$HOME/.config/nvim/undo
  set undofile
endif

" Indentation
" ----------------------------------------------------------------------------
filetype plugin indent on
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Search highlighting
" ----------------------------------------------------------------------------
set incsearch " Highlight while searching
set hlsearch  " Highlight after entering search

" Window splitting behaviour
" ----------------------------------------------------------------------------
set splitbelow
set splitright

" For conceal markers.
" ----------------------------------------------------------------------------
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Trim whitespace (and keep cursor in place)
" ----------------------------------------------------------------------------
function TrimWhiteSpace()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfunction

" Trim whitespace when the file is written to or opened
autocmd FileWritePre * :call TrimWhiteSpace()
autocmd FileAppendPre * :call TrimWhiteSpace()
autocmd FilterWritePre * :call TrimWhiteSpace()
autocmd BufWritePre * :call TrimWhiteSpace()


" ============================================================================
"   Key Bindings
" ============================================================================
set list listchars=trail:.,extends:>

map <F2> :call TrimWhiteSpace()<CR>
map! <F2> :call TrimWhiteSpace()<CR>

" Make Y consistent with D
nnoremap Y y$

" Nobody ever uses "Ex" mode, and it's annoying to leave
noremap Q <nop>

" stupid window what are you for even
map q: :q<CR>

" Reselect visual block after indent/outdent: http://vimbits.com/bits/20
" ----------------------------------------------------------------------------
vnoremap < <gv
vnoremap > >gv
vnoremap = =gv

" Repurpose arrow keys to navigating windows
" ----------------------------------------------------------------------------
nnoremap <left> <C-w>h
nnoremap <right> <C-w>l
nnoremap <up> <C-w>k
nnoremap <down> <C-w>j

" Leader mappings
" ----------------------------------------------------------------------------
let mapleader = "\<Space>"

" Paste using automatic indentation
map <Leader>p :set paste<CR><esc>"*]p:set nopaste<cr>

" Get full path of buffer
map <Leader>cf :let @* = expand("%:p")<CR>

" Get full directory of buffer
map <Leader>cd :let @* = expand("%:p:h")<CR>

" Remove highlight
map <Leader>h :noh<CR>

" Save
map <Leader>s :w<CR>

" Navigate tabs
map <Leader><Tab> gt
map <Leader><S-Tab> gT
