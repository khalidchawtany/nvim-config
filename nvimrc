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
