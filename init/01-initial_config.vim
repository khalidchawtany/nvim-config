scriptencoding utf-8


if has('mac')
  let $PATH =$PATH
              \. ':/Users/juju/.composer/vendor/bin/'
              \. ':/Users/juju/Development/go/bin/gopls'
              \. ':/Users/juju/go/bin/gopls'
endif
" Set our leader key to Space
  let mapleader = "\<space>"
  let g:mapleader = "\<space>"
  let localleader = "\\"
  let g:loaclleader = "\\"

  if $TERM_PROGRAM == 'Apple_Terminal'
    set notermguicolors
  else
    set termguicolors
  endif

" Set important paths
if has('mac')
    let g:python2_host_prog='/usr/local/bin/python'
    let g:python3_host_prog='/usr/local/bin/python3'
    "First Run >> brew unlink python
    "second let g:python2_host_prog='/Volumes/Home/Development/Applications/neovim/system_python_lldb_loader'
    " UpdateRemotePlugins
elseif has('win64')
    let g:python2_host_prog='C:\Development\Python\Python2\python2.7.exe'
    let g:python3_host_prog='C:\Development\Python\Python3\python.exe'
endif
let g:python_host_skip_check = 1
let g:python3_host_skip_check = 1

filetype plugin indent on

set wildignore+=*.o,*~,*.pyc,*pycache* " Ignore compiled files
set wildmode=full                     " Complete the longest common string,
set wildoptions=pum                   " show wildmenu as normal autocompleting menu

" then list them, then full
set noshowmode
set cmdheight=1                       " Height of the command bar
set incsearch                         " Makes search act like search in modern browsers
set showmatch                         " show matching brackets when text indicator is over them
set relativenumber                    " Show line numbers
set number                            " But show the actual number for the line we're on
set ignorecase                        " Ignore case when searching...
set smartcase                         " ... unless there is a capital letter in the query
set hidden                            " I like having buffers stay around

let g:my_preview_enable = v:false
if g:my_preview_enable
  set completeopt+=preview              " Turn On preview
  " Lots of people don't like this one. I don't mind
  " and sometimes it provides really helpful stuff
else
  set completeopt-=preview              " Turn off preview
endif

set noequalalways                     " I don't like my windows changing all the time
set splitright                        " Prefer windows splitting to the right
set splitbelow                        " Prefer windows splitting to the bottom
set updatetime=250                    " Make updates happen faster

" I wouldn't use this without my DoNoHL function
set hlsearch

" Tabs
" Want auto indents automatically
set autoindent
set cindent
set wrap

" Set the width of the tab to 4 wide
" This gets overridden by vim-sleuth, so that's nice
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Make it so that long lines wrap smartly
set breakindent
let &showbreak=repeat(' ', 3)
set linebreak

" Always use spaces instead of tab characters
set expandtab

" Folding
set foldmethod=manual
set foldlevel=0
set modelines=1

" Just turn the dang bell off
set belloff=all

" Clipboard
" Always have the clipboard be the same as my regular clipboard
set clipboard+=unnamedplus

" Configure Inccommand
if exists('&inccommand')
  set inccommand=split

  function! CycleIncCommand() abort
    if &inccommand ==? 'split'
      set inccommand=nosplit
    else
      set inccommand=split
    endif
  endfunction

  nnoremap <leader>ci :call CycleIncCommand()<CR>
endif


if &list
  " Some fun characters:
  " ▸
  " ⇨
  let g:list_char_index = 0
  let g:list_char_options = [
        \ 'tab:»\ ,eol:↲,nbsp:␣,extends:…,precedes:<,extends:>,trail:·',
        \ 'tab:»·,eol:↲,nbsp:␣,extends:…,precedes:<,extends:>,trail:·,space:␣',
        \ 'tab:\ \ ,eol:↲,nbsp:␣,extends:…,precedes:<,extends:>,trail:·,space:␣',
        \ '',
        \ ]
  function! CycleListChars() abort
    execute 'set listchars=' . g:list_char_options[
            \ float2nr(
              \ fmod(g:list_char_index, len(g:list_char_options))
            \ )
          \ ]

    let g:list_char_index += 1
  endfunction

  " Cycle through list characters
  " Useful as a helper
  nnoremap <leader>cl :call CycleListChars()<CR>
endif

if !has('unix')
    " I'd like to do this, but it seems like it breaks tags functionality
    " set shell=powershell.exe
    set shell=cmd.exe
else

    set shell=/usr/local/bin/zsh
endif

" guicursor messing around
" set guicursor=n:blinkwait175-blinkoff150-blinkon175-hor10
" set guicursor=a:blinkon0

" disable netrw.vim
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1


augroup ColorschemeToggle
    autocmd!
    autocmd ColorScheme * call ColorschemeToggled()
augroup END

function! ColorschemeToggled()
    if g:colors_name == 'PaperColor'
        hi IncSearch guifg=orange
        hi Comment gui=italic
    endif
endfunction
