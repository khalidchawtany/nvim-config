let g:python_host_prog='/usr/local/bin/python'

"Enable true color support
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

let mapleader = ","
let g:mapleader = ","

call plug#begin('~/.nvim/plugged')
"{{{ VimPlug emplate
  "" Make sure you use single quotes
  "Plug 'junegunn/seoul256.vim'
  "Plug 'junegunn/vim-easy-align'

  "" On-demand loading
  "Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
  "Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

  "" Using git URL
  "Plug 'https://github.com/junegunn/vim-github-dashboard.git'

  "" Plugin options
  "Plug 'nsf/gocode', { 'tag': 'go.weekly.2012-03-13', 'rtp': 'vim' }

  "" Plugin outside ~/.vim/plugged with post-update hook
  "Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }

  "" Unmanaged plugin (manually installed and updated)
  "Plug '~/my-prototype-plugin'
"}}}

"NerdTree
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
"{{{ Config
  let g:nerdtree_tabs_open_on_gui_startup = 0

  Plug 'jistr/vim-nerdtree-tabs'

  nnoremap glf :NERDTreeTabsToggle<CR>
  nnoremap gLf :NERDTreeFind<CR>
  let NERDTreeQuitOnOpen=1
  let NERDTreeWinSize = 23
  " Don't display these kinds of files
  let NERDTreeIgnore=[ '\.ncb$', '\.suo$', '\.vcproj\.RIMNET', '\.obj$',
        \ '\.ilk$', '^BuildLog.htm$', '\.pdb$', '\.idb$',
        \ '\.embed\.manifest$', '\.embed\.manifest.res$',
        \ '\.intermediate\.manifest$', '^mt.dep$', '^.OpenIDE$', '^.git$',
        \ '^.gitignore$', '^.idea$' , '^tags$']
  let NERDTreeShowHidden=1
  let NERDTreeShowBookmarks=1

"}}}

"ColorScheme
Plug 'tomasr/molokai'
Plug 'altercation/vim-colors-solarized'

"clever-f.vim
Plug 'rhysd/clever-f.vim'
"{{{ Config
  nmap ,rf <Plug>(clever-f-reset)
  vmap ,rf <Plug>(clever-f-reset)
"}}}

" zoomwintab.vim
let g:zoomwintab_remap = 0
Plug 'troydm/zoomwintab.vim'
"{{{ Config
  " zoom with <META-O> in any mode
  nnoremap <silent> <a-o> :ZoomWinTabToggle<cr>
  inoremap <silent> <a-o> <c-\><c-n>:ZoomWinTabToggle<cr>a
  vnoremap <silent> <a-o> <c-\><c-n>:ZoomWinTabToggle<cr>gv
"}}}

"vim-multiple-cursors
Plug 'terryma/vim-multiple-cursors'

"vim-submode
Plug 'kana/vim-submode'
"{{{ Config
  source ~/.nvim/plugged/vim-submode/autoload/submode.vim
  " easy resize
  call submode#enter_with('h/l', 'n', '', '<C-w>h', '<C-w><')
  call submode#enter_with('h/l', 'n', '', '<C-w>l', '<C-w>>')
  call submode#map('h/l', 'n', '', 'h', '<C-w><')
  call submode#map('h/l', 'n', '', 'l', '<C-w>>')
  call submode#enter_with('j/k', 'n', '', '<C-w>j', '<C-w>-')
  call submode#enter_with('j/k', 'n', '', '<C-w>k', '<C-w>+')
  call submode#map('j/k', 'n', '', 'j', '<C-w>-')
  call submode#map('j/k', 'n', '', 'k', '<C-w>+')

  "Easy section navigation
  call submode#enter_with('section-nav', 'n', '', ']]', ']]zt')
  call submode#enter_with('section-nav', 'n', '', '[[', '[[zt')
  call submode#map('section-nav', 'n', '', ']', ']]zt')
  call submode#map('section-nav', 'n', '', '[', '[[zt')

  "Easy undo/redo
  call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
  call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
  call submode#leave_with('undo/redo', 'n', '', '<Esc>')
  call submode#map('undo/redo', 'n', '', '-', 'g-')
  call submode#map('undo/redo', 'n', '', '+', 'g+')
"}}}

"emmet-vim
Plug 'mattn/emmet-vim', {'for':['html','xml','xsl','xslt','xsd','css','sass','scss','less','mustache']}

"vim-easymotion
Plug 'Lokaltog/vim-easymotion', {'on': ['<Plug>(easymotion-']}
"{{{ Shortcuts
  map s <Plug>(easymotion-prefix)

  map ssf <Plug>(easymotion-s2)
  map sst <Plug>(easymotion-t2)

  map s<space>f <Plug>(easymotion-sn)
  map s<space>t <Plug>(easymotion-tn)

  map sl <Plug>(easymotion-lineforward)
  map sh <Plug>(easymotion-linebackward)

  map sj <Plug>(easymotion-sol-j)
  map sk <Plug>(easymotion-sol-k)

  map sdf <Plug>(easymotion-bd-f)
  map sdt <Plug>(easymotion-bd-t)
  map sdj <Plug>(easymotion-bd-jk)

  " keep cursor colum when JK motion
  let g:EasyMotion_startofline = 0 

"}}}

"vim-trailing-whitespace
Plug 'bronson/vim-trailing-whitespace'
"{{{ Config
  let g:extra_whitespace_ignored_filetypes = ['unite', 'mkd']
"}}}

"vim-over
Plug 'osyo-manga/vim-over', {'on': ['OverCommandLine']}
"{{{ Config
  nmap <leader>/ :OverCommandLine<cr>
  nnoremap g;s :<c-u>OverCommandLine<cr>%s/
  xnoremap g;s :<c-u>OverCommandLine<cr>%s/\%V
"}}}

"Ultisnips
Plug 'SirVer/ultisnips'
"{{{ Config
  " better key bindings for UltiSnipsExpandTrigger
  " let g:UltiSnipsExpandTrigger = "<tab>"
  " let g:UltiSnipsJumpForwardTrigger = "<tab>"
  " let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

  if has('gui_running')
  let g:UltiSnipsExpandTrigger = "<C-CR>"
  let g:UltiSnipsJumpForwardTrigger = "<C_CR>"
  else
    let g:UltiSnipsExpandTrigger = "‰"
    let g:UltiSnipsJumpForwardTrigger = "‰"
  endif
  let g:UltiSnipsJumpBackwardTrigger = "Â"
  let g:UltiSnipsListSnippets="<s-tab>"

  let g:ultisnips_java_brace_style="nl"
  let g:Ultisnips_java_brace_style="nl"
  let g:UltiSnipsSnippetsDir="~/.vim/UltiSnips"
  "let g:UltiSnipsSnippetDirectories = [ "/Volumes/Home/.nvim/plugged/vim-snippets/UltiSnips"]

"}}}

"xptemplate
Plug 'drmingdrmer/xptemplate'
"{{{ Config
  " Add xptemplate global personal directory value
  if has("unix")
    set runtimepath+=/Volumes/Home/.nvim/xpt-personal
  endif
  "let g:xptemplate_nav_next = '<C-j>'
  "let g:xptemplate_nav_prev = '<C-k>'
"}}}

"YouCompleteMe
Plug 'Valloric/YouCompleteMe'
"{{{ Config
  " make YCM compatible with UltiSnips (using supertab)
  let g:ycm_key_list_select_completion = ['<C-j>', '<Down>']
  let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']
  let g:SuperTabDefaultCompletionType = '<C-n>'
"}}}

"tabular
Plug 'godlygeek/tabular', {'on':'Tabularize'}
"{{{ HotKeys
  nnoremap <leader>a& :Tabularize /&<CR>
  vnoremap <leader>a& :Tabularize /&<CR>
  nnoremap <leader>a= :Tabularize /=<CR>
  vnoremap <leader>a= :Tabularize /=<CR>
  nnoremap <leader>a: :Tabularize /:<CR>
  vnoremap <leader>a: :Tabularize /:<CR>
  nnoremap <leader>a:: :Tabularize /:\zs<CR>
  vnoremap <leader>a:: :Tabularize /:\zs<CR>
  nnoremap <leader>a> :Tabularize /=><CR>
  vnoremap <leader>a> :Tabularize /=><CR>
  nnoremap <leader>a, :Tabularize /,<CR>
  vnoremap <leader>a, :Tabularize /,<CR>
  nnoremap <leader>a<Bar> :Tabularize /<Bar><CR>
  vnoremap <leader>a<Bar> :Tabularize /<Bar><CR>
"}}}

"ag.vim
Plug 'rking/ag.vim', {'on': 'Ag'}
"{{{ Config
  "Disable the msg showing shortcuts after each search
  let g:ag_mapping_message=0
"}}}

"Single Line Plugs
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'airblade/vim-gitgutter'
Plug 'honza/vim-snippets'

call plug#end()


"==============================================================================
"                                   Global Config                             =
"==============================================================================


set background=dark
colorscheme molokai

" Enhance command-line completion
set wildmenu
set wildmode=longest,list,full

" Types of files to ignore when autocompleting things
set wildignore+=*.o,*.class,*.git,*.svn

" Fuzzy finder: ignore stuff that can't be opened, and generated files
let g:fuzzy_ignore = "*.png;*.PNG;*.JPG;*.jpg;*.GIF;*.gif;vendor/**;coverage/**;tmp/**;rdoc/**"

set grepprg=ag\ --nogroup\ --nocolor

set formatoptions-=t                  "Stop autowrapping my code

" set ambiwidth=double                " DON'T THIS FUCKS airline

"don't autoselect first item in omnicomplete,show if only one item(for preview)
set completeopt=longest,menuone,preview

set complete=.,w,b,u,t                " Completion precedence
set pumheight=15                      " limit completion menu height

" When completing by tag, show the whole tag, not just the function name
set showfulltag

"**** DO NOT USE ****  RUINS arrow keys & all esc based keys
" Allow cursor keys in insert mode
"set esckeys

set backspace=indent,eol,start        " Allow backspace in insert mode
set gdefault                          " make g default for search
set magic                             " Magic matching
set encoding=utf-8 nobomb
set termencoding=utf-8
scriptencoding utf-8
set nolazyredraw

" Centralize backups, swapfiles and undo history
set backupdir=~/.nvim/.cache/backups

"How should I decide to take abackup
set backupcopy=auto

set directory=~/.nvim/.cache/swaps
set viewdir=~/.nvim/.cache/views

if exists("&undodir")
set undodir=~/.nvim/.cache/undo
endif

set undofile                          " Save undo's after file closes
"set undodir=$HOME/.vim/.cache/undo   " where to save undo histories
set undolevels=1000                   " How many undos
set undoreload=10000                  " number of lines to save for undo

" if available, store temporary files in shared memory
if isdirectory('/run/shm')
let $TMPDIR = '/run/shm'
elseif isdirectory('/dev/shm')
let $TMPDIR = '/dev/shm'
endif

set tags=./tags,tags;$HOME            " Help vim find my tags
set backupskip=/tmp/*,/private/tmp/*  " don't back up these
set autoread                          " read files on change

set binary
set noeol                              " Don’t add empty newlines at the end of files

"set noswapfile
"Dont warn me about swap files existence
"set shortmess+=A

" Respect modeline in files
set modeline
set modelines=4

" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure

set number
set relativenumber

set autoindent
set smartindent
set tabstop=2
set expandtab
set nosmarttab
set shiftwidth=2
set shiftround                        " when at 3 spaces I hit >> go to 4 not 5

set guifont=Sauce\ Code\ Powerline\ Light:h18
set textwidth=80
set wrap                              " Wrap long lines
set breakindent                       " proper indenting for long lines

set printoptions=header:0,duplex:long,paper:letter

let &showbreak = '↳ '                 "add linebreak sign
set cpo=n                             "Draw color for lines that has number only
set wrapscan                          " set the search scan to wrap lines

"Allow these to move to next/prev line when at the last/first char
set whichwrap+=h,l,<,>,[,]


" Show “invisible” characters
set listchars=tab:▸\ ,extends:❯,precedes:❮,trail:.,eol:¬,nbsp:␣
set list

"Set the fillchar of the inactive window to something I can see
set fillchars=stlnc:\-

" Add ignorance of whitespace to diff
set diffopt+=iwhite
syntax on
set cursorline
set hlsearch
set ignorecase
set smartcase
set matchtime=2                       " time in decisecons to jump back from matching bracket 
set incsearch                         " Highlight dynamically as pattern is typed
set history=1000
set foldmethod=marker

" These commands open folds
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
set timeout
set timeoutlen=750
"NeoVim handles ESC keys as alt+key set this to solve the problem
set ttimeoutlen=0

" Show the filename in the window titlebar
set title "titlestring=

syntax on
set virtualedit=all
set mouse=a
set hidden
set laststatus=2                      " force status line display
set noerrorbells visualbell t_vb=     " Disable error bells
set nostartofline                     " Don’t reset cursor to start of line when moving around
set ruler                             " Show the cursor position
set shortmess=atI                     " Don’t show the intro message when starting Vim
set showmode                          " Show the current mode
set scrolloff=3                       " Keep cursor in screen by value
set cpoptions+=ces$                   " CW wrap W with $ instead of delete
set showmode                          " Show the current mode
set showcmd                           " Show commands as typed in right botoom
set noshowcmd                         " Makes OS X slow, if lazy redraw set
set mousehide                         " Hide mouse while typing
set synmaxcol=200                     " max syntax highlight chars
set splitbelow                        " put horizontal splits below
set splitright                        " put vertical splits to the right
let g:netrw_liststyle=3               "Make netrw look like NerdTree

highlight ColorColumn ctermbg=darkblue guibg=#E1340F guifg=#111111
call matchadd('ColorColumn', '\%81v', 100)



"==============================================================================
"                                   HotKeys                                   =
"==============================================================================
