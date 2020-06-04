set regexpengine=1

set updatetime=500

"Keep diffme function state
let $diff_me=0

" Specify path to your Uncrustify configuration file.
let g:uncrustify_cfg_file_path =
      \ shellescape(fnamemodify('~/.uncrustify.cfg', ':p'))

"set rulerformat to include line:col filename +|''
"set rulerformat=%<%(%p%%\ %)%l%<%(:%c\ %)%=%t%<\ %M
set rulerformat=%l:%<%c%=%p%%\ %R\ %m

" Enhance command-line completion
set wildmenu

" Types of files to ignore when autocompleting things
set wildignore+=*.o,*.class,*.git,*.svn

" Fuzzy finder: ignore stuff that can't be opened, and generated files
let g:fuzzy_ignore = "*.png;*.PNG;*.JPG;*.jpg;*.GIF;*.gif;vendor/**;coverage/**;tmp/**;rdoc/**"

set grepprg=ag\ --nogroup\ --nocolor

set formatoptions-=t                  " Stop autowrapping my code

" set ambiwidth=double                " DON'T THIS FUCKS airline

"don't autoselect first item in omnicomplete,show if only one item(for preview)
"set completeopt=longest,menuone,preview
set completeopt=noinsert,menuone

set pumheight=15                      " limit completion menu height

" When completing by tag, show the whole tag, not just the function name
set showfulltag

"**** DO NOT USE ****  RUINS arrow keys & all esc based keys
" Allow cursor keys in insert mode
"set esckeys

set nrformats-=octal

set backspace=indent,eol,start        " Allow backspace in insert mode
"set gdefault                          " make g default for search CONFUSES ME :(
set magic                             " Magic matching

set nolazyredraw

" set formatoptions+=j                " Delete comment character when joining commented lines

"Set these only at startup
if !exists('g:VIMRC_SOURCED')
  set encoding=utf-8 nobomb
endif

set termencoding=utf-8
scriptencoding utf-8

if has('vim')
  " small tweaks
  set ttyfast                       " indicate a fast terminal connection
  set tf                            " improve redrawing for newer computers
endif

"How should I decide to take abackup
set backupcopy=auto

if has('mac')
    if has('nvim')
        " Centralize backups, swapfiles and undo history
        set backupdir=~/.config/nvim/.cache/backups

        set directory=~/.config/nvim/.cache/swaps
        set viewdir=~/.config/nvim/.cache/views

        if exists("&undodir")
            set undodir=~/.config/nvim/.cache/undo
        endif
    else
        set backupdir=~/.vim/.cache/backups

        set directory=~/.vim/.cache/swaps
        set viewdir=~/.vim/.cache/views

        if exists("&undodir")
            set undodir=~/.vim/.cache/undo
        endif
    endif
elseif has('win')
    if has('nvim')

        " Centralize backups, swapfiles and undo history
        set backupdir=C:\Users\JuJu\AppData\Local\nvim-data\backups

        set directory=C:\Users\JuJu\AppData\Local\nvim-data\swaps
        set viewdir=C:\Users\JuJu\AppData\Local\nvim-data\views

        if exists("&undodir")
            set undodir=C:\Users\JuJu\AppData\Local\nvim-data\undo
        endif
    else
        set backupdir=C:\Users\JuJu\AppData\Local\nvim-data\backups

        set directory=C:\Users\JuJu\AppData\Local\nvim-data\swaps
        set viewdir=C:\Users\JuJu\AppData\Local\nvim-data\views

        if exists("&undodir")
            set undodir=C:\Users\JuJu\AppData\Local\nvim-data\undo
        endif
    endif
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

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

set tags=./tags,tags;$HOME            " Help vim find my tags
set backupskip=/tmp/*,/private/tmp/*  " don't back up these
set autoread                          " read files on change

set fileformats+=mac

set binary
set noeol                             " Don’t add empty newlines at file end

"set clipboard=unnamed,unnamedplus

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux'
  set t_Co=16
endif

if &tabpagemax < 50
  set tabpagemax=50
endif

if !empty(&viminfo)
  set viminfo^=!
endif

set sessionoptions-=options

set noswapfile
"Dont warn me about swap files existence
"set shortmess+=A

"set shortmess=atI                    " Don’t show the intro message when starting Vim

"prevent completion message flickers
set shortmess+=c

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
"TODO: tpope sets smarttab
set nosmarttab

set shiftwidth=4
set shiftround                        " when at 3 spaces I hit >> go to 4 not 5

set textwidth=80
set nowrap                              " don't Wrap long lines
set breakindent                       " proper indenting for long lines

set linebreak                         "Don't linebreak in the middle of words

set printoptions=header:0,duplex:long,paper:letter

let &showbreak = '↳ '                 " add linebreak sign
set wrapscan                          " set the search scan to wrap lines

"Allow these to move to next/prev line when at the last/first char
set whichwrap+=h,l,<,>,[,]

" Show “invisible” characters
set listchars=tab:▸\ ,extends:❯,precedes:❮,trail:.,eol:¬,nbsp:×
" set listchars=tab:▸\ ,extends:❯,precedes:❮,trail:.,eol:¬,nbsp:␣
" set listchars=tab:•·,trail:·,extends:❯,precedes:❮,nbsp:×
set nolist

"Set the fillchar of the inactive window to something I can see
set fillchars=stlnc:\-

" Add ignorance of whitespace to diff
set diffopt+=iwhite
syntax on
set nocursorline "Use iTerm cursorline instead

set hlsearch
set ignorecase
set smartcase
set matchtime=2                       " time in decisecons to jump back from matching bracket
set incsearch                         " Highlight dynamically as pattern is typed
set history=1000

"Show the left side fold indicator
set foldcolumn=1
set foldmethod=manual
" These commands open folds
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo

"set foldtext=MyFoldText()
function! MyFoldText()
  let line = getline(v:foldstart)
  if match( line, '^[ \t]*\(\/\*\|\/\/\)[*/\\]*[ \t]*$' ) == 0
    let initial = substitute( line, '^\([ \t]\)*\(\/\*\|\/\/\)\(.*\)', '\1\2', '' )
    let linenum = v:foldstart + 1
    while linenum < v:foldend
      let line = getline( linenum )
      let comment_content = substitute( line, '^\([ \t\/\*]*\)\(.*\)$', '\2', 'g' )
      if comment_content != ''
        break
      endif
      let linenum = linenum + 1
    endwhile
    let sub = initial . ' ' . comment_content
  else
    let sub = line
    let startbrace = substitute( line, '^.*{[ \t]*$', '{', 'g')
    if startbrace == '{'
      let line = getline(v:foldend)
      let endbrace = substitute( line, '^[ \t]*}\(.*\)$', '}', 'g')
      if endbrace == '}'
        let sub = sub.substitute( line, '^[ \t]*}\(.*\)$', '...}\1', 'g')
      endif
    endif
  endif
  let n = v:foldend - v:foldstart + 1
  let info = " " . n . " lines"

  if &foldmethod == 'marker'
    let comment_string = substitute(&cms, "\%s", "", "g")
    let sub = strpart(sub, 0, strlen(sub)- (strlen(&foldmarker)-1)/2)
    let sub = substitute( sub, '^\s*' . comment_string . '\s*', '', 'g')
    let sub = substitute( sub, '^\s*', '', 'g')
    let sub = substitute( sub, comment_string.'\s*$', '', 'g')
  endif

  let sub =  ' ' . sub . "                                                                                                                                                                                  "
  if exists("&columns")
    let sub = strpart( sub, 0, eval("&columns")-strlen(info)-7)
  else
    let sub = strpart( sub, 0, 80-strlen(info)-7)
  endif
  return  sub . info
endfunction

set timeout timeoutlen=750
"NeoVim handles ESC keys as alt+key set this to solve the problem
set ttimeout ttimeoutlen=0

" Show the filename in the window titlebar
set title "titlestring=

syntax on
set virtualedit=all
set mouse=                            " Let the term control mouse selection
set hidden
"set laststatus=2                      " force status line display
set laststatus=0                      " force status line display
set foldlevelstart=2
set showtabline=2                     " hide tabline
set noerrorbells visualbell t_vb=     " Disable error bells
set nostartofline                     " Don’t reset cursor to start of line when moving around
set ruler                             " Show the cursor position
set showmode                          " Show the current mode
set shortmess=atI                     " Don’t show the intro message when starting Vim
set inccommand=nosplit                " preview changes in the window not a split

if !&scrolloff
  set scrolloff=2                       " Keep cursor in screen by value
endif
if !&sidescrolloff
  set sidescrolloff=5
endif

"set cpoptions+=ces$                    " CW wrap W with $ instead of delete
set cpo+=n                             " Draw color for lines that has number only

set display+=lastline

set mousehide                         " Hide mouse while typing

set synmaxcol=500                     " max syntax highlight chars

set splitbelow                        " put horizontal splits below

set splitright                        " put vertical splits to the right

let g:netrw_liststyle=3               "Make netrw look like NerdTree

highlight! ColorColumn ctermbg=darkblue guibg=#E1340F guifg=#111111
let w:my_colorcol_hi_id = matchadd('ColorColumn', '\%101v', 100)
