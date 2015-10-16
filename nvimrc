
" ============================================================================
" VIM-PLUG {{{
" ============================================================================

call plug#begin('~/.nvim/plugged')


"{{{ VimPlug template
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

Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/seoul256.vim'
Plug 'vim-scripts/applescript.vim'
Plug 'AndrewRadev/switch.vim'
Plug 'tommcdo/vim-exchange'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/nerdtree' ", { 'on':  'NERDTreeToggle' }
" Plug 'jistr/vim-nerdtree-tabs'
Plug 'tpope/vim-eunuch'
Plug 'mhinz/vim-grepper'
Plug '~/.vim/bundle/yankmatches.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
" Plug 'junegunn/fzf', {'do' : 'yes \| brew reinstall --HEAD fzf'}
Plug 'majutsushi/tagbar', { 'on' : [ 'Tagbar', 'TagbarToggle', ] }
Plug 'vim-scripts/TaskList.vim'
Plug 'rhysd/clever-f.vim'
Plug 'AndrewRadev/sideways.vim',
                          \ {'on': ['SidewaysLeft', 'SidewaysRight',
                          \ 'SidewaysJumpLeft', 'SidewaysJumpRight']}

Plug 'junegunn/vim-pseudocl'  "Required by obliquie & fnr
Plug 'junegunn/vim-oblique'
Plug 'junegunn/vim-fnr'
Plug 'thinca/vim-ambicmd'
" Plug 'osyo-manga/vim-over', {'on': ['OverCommandLine']}
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-unimpaired'
" Plug 'tpope/vim-repeat'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-projectionist'
" Plug 'tpope/vim-commentary'
Plug 'tpope/vim-markdown'
" Plug 'tpope/vim-vinegar'            " {-} file browser
Plug 'tpope/vim-characterize'
" Plug 'tpope/vim-classpath'
Plug 'tpope/vim-afterimage'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-scriptease'
" Plug 'tpope/vim-flagship'
Plug 'tpope/vim-dotenv'
Plug 'tpope/vim-speeddating'
Plug 'jceb/vim-orgmode'
Plug 'KabbAmine/lazyList.vim', {'on': ['LazyList']}
Plug 'vitalk/vim-simple-todo'
Plug 'dhruvasagar/vim-table-mode'
Plug 'junegunn/vim-journal'
Plug 'scrooloose/nerdcommenter'       ",cc ,cs
" Plug 'tomtom/tcomment_vim'
" Plug 'Yggdroot/indentLine'
Plug 'justinmk/vim-gtfo'
Plug 'honza/vim-snippets'
" Plug 'vim-scripts/YankRing.vim'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'troydm/zoomwintab.vim'
" Plug 'seletskiy/vim-nunu'           "Disable relative numbers on cursor move
Plug 'Shougo/junkfile.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'itchyny/calendar.vim'
Plug 'takac/vim-hardtime'
Plug 'kana/vim-submode'
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
"Plug 'ap/vim-buftabline'
Plug 'szw/vim-ctrlspace'
Plug 'mattn/emmet-vim' ", {'for':['html','xml','xsl','xslt','xsd','css','sass','scss','less','mustache']}
Plug 'habamax/vim-skipit'              "use <c-l>l to skip ahead forward in insert mode
Plug 'Lokaltog/vim-easymotion'
Plug 'machakann/vim-patternjump'
Plug 'machakann/vim-columnmove'
Plug 'bronson/vim-trailing-whitespace'
Plug 'khalidchawtany/IndexedSearch', {'autoload': {'mappings':['<Plug>(ShowSearchIndex_']}}
Plug 'ktonga/vim-follow-my-lead'      ",fml
Plug 'vim-scripts/undofile_warn.vim'
Plug 'vim-scripts/DirDiff.vim'
Plug 'mvolkmann/vim-tag-comment'



"snippets
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/neco-syntax'
Plug 'Shougo/neco-vim'
Plug 'Shougo/echodoc.vim'
Plug 'Shougo/deoplete.nvim'
" Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --gocode-completer --omnisharp-completer' }
Plug 'SirVer/ultisnips'
" Plug 'drmingdrmer/xptemplate'
Plug 'godlygeek/tabular', {'on':'Tabularize'}
Plug 't9md/vim-surround_custom_mapping'
Plug 'tpope/vim-surround', {
                          \   'on' :[
                          \      '<Plug>Dsurround' , '<Plug>Csurround',
                          \      '<Plug>Ysurround' , '<Plug>YSurround',
                          \      '<Plug>Yssurround', '<Plug>YSsurround',
                          \      '<Plug>YSsurround', '<Plug>VgSurround',
                          \      '<Plug>VSurround' , '<Plug>ISurround'
                          \ ]}

Plug 'ap/vim-css-color', {'for':['css','scss','sass','less','styl']}
Plug 'deris/vim-rengbang', { 'on': [ 'RengBang', 'RengBangUsePrev' ] }
Plug 'deris/vim-rectinsert', { 'on': ['RectInsert', 'RectReplace'] }
Plug 'tpope/vim-abolish', {'on': ['S','Subvert', 'Abolish']}
Plug 'Wolfy87/vim-enmasse', {'on': 'EnMasse'}
Plug 'AndrewRadev/inline_edit.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'hlissner/vim-multiedit'
                          " \,
                          " \{
                          " \   'on':
                          " \     [
                          " \         'MultieditAddMark', 'MultieditAddRegion',
                          " \         'MultieditRestore', 'MultieditHop', 'Multiedit',
                          " \         'MultieditClear', 'MultieditReset'
                          " \     ]
                          " \}
Plug 'vim-scripts/UnconditionalPaste'
Plug 'AndrewRadev/splitjoin.vim', { 'autoload' : {
                        \ 'mappings' : ['gJ', 'gS']
                        \ }}

" if exists('$TMUX') | Plug 'christoomey/vim-tmux-navigator' | endif



Plug 'gioele/vim-autoswap'
Plug 'mbbill/undotree'
Plug 'simnalamburt/vim-mundo'
Plug 'Shougo/vimproc.vim'
Plug 'tpope/vim-dispatch'
Plug 'benekastah/neomake'
Plug 'pgdouyon/vim-accio'
Plug 'bruno-/vim-man'
Plug 'janko-m/vim-test'
Plug 'OrangeT/vim-csharp'
Plug 'scrooloose/syntastic'
Plug 'kassio/neoterm'
Plug 'tpope/vim-endwise'
Plug 'Raimondi/delimitMate'
Plug 'ton/vim-bufsurf'
Plug 'tyru/capture.vim' "Capture EX-commad in a buffer
" Plug 'm2mdas/phpcomplete-extended'
" Plug 'm2mdas/phpcomplete-extended-laravel'
Plug 'vim-scripts/phpfolding.vim', {'for': 'php'}
Plug 'Konfekt/FastFold'
Plug 'xsbeats/vim-blade'
Plug 'tpope/vim-fugitive'
Plug 'jreybert/vimagit'
Plug 'calebsmith/vim-lambdify'
Plug 'vim-scripts/confirm-quit'
Plug 'tpope/vim-ragtag'
Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
Plug 'junegunn/limelight.vim', {'on': 'Limelight'}


"ColorScheme
Plug 'tomasr/molokai'
Plug 'NLKNguyen/papercolor-theme'
Plug 'altercation/vim-colors-solarized'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'chriskempson/tomorrow-theme'
Plug 'vim-scripts/buttercream.vim'
Plug 'vim-scripts/simpleandfriendly.vim'
Plug 'vim-scripts/nuvola.vim'
Plug 'vim-scripts/ironman.vim'
Plug 'vim-scripts/AutumnLeaf'
Plug 'vim-scripts/summerfruit256.vim'
Plug 'vim-scripts/eclipse.vim'
Plug 'vim-scripts/pyte'
Plug 'morhetz/gruvbox'
Plug 'flazz/vim-colorschemes'

Plug 'xolox/vim-misc'
Plug 'xolox/vim-colorscheme-switcher'



"Operator
Plug 'kana/vim-operator-user'
Plug 'tyru/operator-camelize.vim'
Plug 'mwgkgk/vim-operator-insert'             "insert after textobj
Plug 'mwgkgk/vim-operator-append'             "append after textobj
Plug 'emonkak/vim-operator-comment'
Plug 'osyo-manga/vim-operator-blockwise'
Plug 'machakann/vim-operator-jerk'
Plug 'emonkak/vim-operator-sort'



"textobj
Plug 'kana/vim-textobj-user'
" let g:textobj_blockwise_enable_default_key_mapping =0
Plug 'osyo-manga/vim-textobj-blockwise'       "<c-v>iw, cIw    for block selection
Plug 'Julian/vim-textobj-brace'               "ij, aj          for all kinds of brces
Plug 'RyanMcG/vim-textobj-dash'               "i-, a-          for dashes
Plug 'kana/vim-textobj-underscore'            "i_, a_          for underscore
Plug 'Úvimtaku/vim-textobj-doublecolon'        "i:, a:          for ::
Plug 'vimtaku/vim-textobj-doublecolon'
Plug 'machakann/vim-textobj-delimited'        "id, ad, iD, aD  for Delimiters takes numbers d2id
Plug 'glts/vim-textobj-comment'               "ic, ac, iC, aC  for comment
Plug 'kana/vim-textobj-fold'                  "iz, az          for folds
Plug 'glts/vim-textobj-indblock'              "io, ao, iO, aO  for indented blocks
Plug 'kana/vim-textobj-indent'                "ii, ai, iI, aI  for Indent
Plug 'mattn/vim-textobj-url'                  "iu, au          for URL
Plug 'kana/vim-textobj-line'                  "il, al          for line
Plug 'haya14busa/vim-textobj-number'          "in, an          for numbers
Plug 'hchbaw/textobj-motionmotion.vim'        "imMotionMotion  for two motion range
" Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-lastpat'               "i/, a/, i?, a/  for Searched pattern
Plug 'kana/vim-textobj-syntax'                "iy, ay          for Syntax
Plug 'machakann/vim-textobj-functioncall'     "if, af
Plug 'sgur/vim-textobj-parameter'             "i,, a,          for parameter
Plug 'Julian/vim-textobj-variable-segment'    "iv, av          for variable segment goO|rCome
" Plug 'kana/vim-niceblock'
" vim-textobj-line does this too :)
" Plug 'rhysd/vim-textobj-continuous-line'    "iv, av          for continuous line
Plug 'saaguero/vim-textobj-pastedtext'        "gb              for pasted text
Plug 'reedes/vim-textobj-sentence'            "is, as, ), (,   For real english sentences
                                              " also adds g) and g( for
                                              " sentence navigation
Plug 'reedes/vim-textobj-quote'               "iq, aq, iQ, aQ  for Curely quotes
Plug 'akiyan/vim-textobj-xml-attribute'       "ixa, axa        for XML attributes
Plug 'kana/vim-textobj-datetime'              "igda, agda,      or dates auto
                                              " igdd, igdf, igdt, igdz  means
                                              " date, full, time, timerzone
Plug 'kana/vim-textobj-entire'                "iG, aG          for entire document
Plug 'saihoooooooo/vim-textobj-space'         "iS, aS i<Space> for contineous spaces
Plug 'paulhybryant/vim-textobj-path'          "i|, a|, i\, a\          for Path
Plug 'rhysd/vim-textobj-lastinserted'         "it, at          for last inserted
Plug 'akiyan/vim-textobj-php'                 "i<, a<        for <?php ?>
Plug 'thinca/vim-textobj-between'             "ibX, abX          for between two chars
Plug 'rhysd/vim-textobj-anyblock'             "ia, aa          for (, {, [, ', ", <
Plug 'syngan/vim-textobj-postexpr'            "ige, age        for post expression
Plug 'osyo-manga/vim-textobj-multitextobj'
" Plug 'vimtaku/vim-textobj-keyvalue'

Plug 'junegunn/vim-after-object'
Plug 'PeterRincker/vim-argumentative'
Plug 'FooSoft/vim-argwrap'



"Unite
Plug 'Shougo/unite.vim'
Plug 'tsukkee/unite-tag'
Plug 'h1mesuke/unite-outline'
Plug 'Shougo/unite-outline'
Plug 'ujihisa/unite-colorscheme'
Plug 'ujihisa/unite-font'
Plug 'ujihisa/unite-locate'
Plug 'sgur/unite-everything'
Plug 'tacroe/unite-mark'
Plug 'tacroe/unite-alias'
Plug 'hakobe/unite-script'
Plug 'soh335/unite-qflist'
Plug 'thinca/vim-unite-history'
Plug 'sgur/unite-qf'
Plug 'oppara/vim-unite-cake'
Plug 't9md/vim-unite-ack'
Plug 'Sixeight/unite-grep'
Plug 'kannokanno/unite-todo'
Plug 'Shougo/unite-build'
Plug 'osyo-manga/unite-fold'
Plug 'tsukkee/unite-help'



" CTRL-P
" Plug 'kien/ctrlp.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'sgur/ctrlp-extensions.vim'
Plug 'fisadev/vim-ctrlp-cmdpalette'
Plug 'ivalkeen/vim-ctrlp-tjump'
Plug 'suy/vim-ctrlp-commandline'
Plug 'tacahiroy/ctrlp-funky'
Plug '/Volumes/Home/.nvim/plugged/ctrlp-my-notes'    "Locate my notes
Plug '/Volumes/Home/.nvim/plugged/ctrlp-dash-helper' "dash helper
Plug 'JazzCore/ctrlp-cmatcher'                       "ctrl-p matcher
" Plug 'FelikZ/ctrlp-py-matcher'                     "ctrl-p matcher
" Plug 'nixprime/cpsm'                               "ctrl-p matcher



Plug 'vasconcelloslf/vim-foldfocus'
Plug '/Volumes/Home/.nvim/plugged/foldsearches.vim'
Plug 'khalidchawtany/searchfold.vim' , {'autoload': {'mappings': ['<Plug>SearchFoldNormal']}}
Plug 'khalidchawtany/foldsearch',
      \   {
      \       'autoload':
      \       {
      \            'commands': ['Fw', 'Fs', 'Fp', 'FS', 'Fl', 'Fc', 'Fi', 'Fd', 'Fe'],
      \            'mappings':
      \                   [
      \                       '<leader>fs',
      \                       '<leader>fw',
      \                       '<leader>fl',
      \                       '<leader>fS',
      \                       '<leader>fi',
      \                       '<leader>fd',
      \                       '<leader>fe'
      \                   ]
      \       }
      \ }







"  gtfo {{{

  let g:gtfo#terminals = { 'mac' : 'iterm' }


"}}}

" rainbow parentheses {{{

  nnoremap <leader>xp :RainbowParentheses!!<CR>


"}}}

" EasyAlign {{{

  " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
  vmap <Enter> <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap g<cr> <Plug>(EasyAlign)
  let g:easy_align_ignore_comment = 0 " align comments


"}}}

" NERDTree {{{

  let g:loaded_netrw       = 1 "Disable Netrw
  let g:loaded_netrwPlugin = 1 "Disable Netrw

  "let g:nerdtree_tabs_open_on_gui_startup = 0
  let g:nerdtree_tabs_open_on_gui_startup = !$NVIM_TUI_ENABLE_TRUE_COLOR


  let NERDTreeQuitOnOpen=1
  let NERDTreeWinSize = 23

  " Don't display these kinds of files
  let NERDTreeIgnore=[ '\.ncb$', '\.suo$', '\.vcproj\.RIMNET', '\.obj$',
        \ '\.ilk$', '^BuildLog.htm$', '\.pdb$', '\.idb$',
        \ '\.embed\.manifest$', '\.embed\.manifest.res$',
        \ '\.intermediate\.manifest$', '^mt.dep$', '^.OpenIDE$', '^.git$', '^TestResult.xml$', '^.paket$', '^paket.dependencies$','^paket.lock$', '^paket.template$', '^.agignore$', '^.AutoTest.config$',
        \ '^.gitignore$', '^.idea$' , '^tags$']

  let NERDTreeShowHidden=1
  let NERDTreeShowBookmarks=1

  " nnoremap Ú<c-l> :NERDTreeTabsToggle<cr>
  nnoremap Ú<c-l><c-l> :NERDTreeToggle<cr>
  nnoremap Ú<c-l><c-d> :NERDTreeCWD<cr>
  nnoremap Ú<c-l><c-f> :NERDTreeFind<cr>


"}}}

" grepper {{{

  nmap <leader>g <plug>(Grepper)
  xmap <leader>g <plug>(Grepper)
  cmap <leader>g <plug>(GrepperNext)
  nmap gs        <plug>(GrepperMotion)
  xmap gs        <plug>(GrepperMotion)

  let g:grepper              = {}
  let g:grepper.programs     = ['ag', 'git', 'grep']
  let g:grepper.use_quickfix = 1
  let g:grepper.do_open      = 1
  let g:grepper.do_switch    = 1
  let g:grepper.do_jump      = 0


"}}}

" FZF {{{

  let $FZF_DEFAULT_COMMAND='ag -l -g ""'
  set rtp+=/usr/local/Cellar/fzf/HEAD

  " `Files [PATH]`    | Files (similar to  `:FZF` )
  " `Buffers`         | Open buffers
  " `Colors`          | Color schemes
  " `Ag [PATTERN]`    | {ag}{5} search result (CTRL-A to select all, CTRL-D to deselect all)
  " `Lines`           | Lines in loaded buffers
  " `BLines`          | Lines in the current buffer
  " `Tags`            | Tags in the project ( `ctags -R` )
  " `BTags`           | Tags in the current buffer
  " `Marks`           | Marks
  " `Windows`         | Windows
  " `Locate PATTERN`  |  `locate`  command output
  " `History`         |  `v:oldfiles`  and open buffers
  " `History:`        | Command history
  " `History/`        | Search history
  " `Snippets`        | Snippets ({UltiSnips}{6})
  " `Commits`         | Git commits (requires {fugitive.vim}{7})
  " `BCommits`        | Git commits for the current buffer
  " `Commands`        | Commands
  " `Helptags`        | Help tags [1]


  function! Map_FZF(cmd, key)
    exe "nnoremap Úf" . a:key . " :" . a:cmd . "<cr>"
    exe "nnoremap Ú<c-f><c-" . a:key . "> :" . a:cmd . "!<cr>"
    exe "nnoremap Ú<c-f>" . a:key . " :" . a:cmd . "!<cr>"
    exe "nnoremap <c-p><c-" . a:key . "> :" . a:cmd . "!<cr>"
    exe "nnoremap <c-p>" . a:key . " :" . a:cmd . "!<cr>"
    exe "tnoremap <c-p><c-" . a:key . "> <c-\\><c-n>:" . a:cmd . "!<cr>"
    " tnoremap <c-p><c-b> <c-\><c-n>:Buffers!<cr>
  endfunction

  nnoremap Úfp :exe ":Locate " . expand("%:h")<cr>
  nnoremap Ú<c-f><c-p> :exe ":Locate! " . expand("%:h")<cr>

  call Map_FZF("FZF", "f")
  call Map_FZF("Buffers", "b")
  call Map_FZF("Colors", "c")
  call Map_FZF("Ag", "a")
  call Map_FZF("Lines", "l")
  call Map_FZF("BTags", "t")
  call Map_FZF("Tags", "]")
  " call Map_FZF("Locate", "p")
  call Map_FZF("History", "h")
  call Map_FZF("History/", "/")
  call Map_FZF("History:", "Ú")             "<cr>
  call Map_FZF("Commands", "‰")             ":
  call Map_FZF("BCommits", "g")
  call Map_FZF("Snippets", "s")
  call Map_FZF("Marks", "◊")                "'
  call Map_FZF("Windows", "w")
  call Map_FZF("Helptags", "k")

  nmap <leader><tab> <plug>(fzf-maps-n)
  xmap <leader><tab> <plug>(fzf-maps-x)
  omap <leader><tab> <plug>(fzf-maps-o)

  imap <c-x><c-k> <plug>(fzf-complete-word)
  imap <c-x><c-f> <plug>(fzf-complete-path)
  imap <c-x><c-a> <plug>(fzf-complete-file-ag)
  imap <c-x><c-l> <plug>(fzf-complete-line)
  imap <c-x><c-i> <plug>(fzf-complete-buffer-line)
  imap <c-x><c-\> <plug>(fzf-complete-file)

  " Replace the default dictionary completion with fzf-based fuzzy completion
  " inoremap <expr> <c-x><c-k> fzf#complete('cat /usr/share/dict/words')

  function! PrintPathFunction(myParam)
    execute ":normal i".a:myParam
  endfunction

  function! PrintPathInNextLineFunction(myParam)
    put=a:myParam
  endfunction
  command! -nargs=1 PrintPathInNextLine call PrintPathInNextLineFunction(<f-args>)
  command! -nargs=1 PrintPath call PrintPathFunction(<f-args>)

  let g:fzf_action = {
        \ 'ctrl-m': 'e',
        \ 'ctrl-t': 'tabedit',
        \ 'ctrl-x': 'split',
        \ 'ctrl-o': 'PrintPathInNextLine',
        \ 'ctrl-i': 'PrintPath',
        \ 'ctrl-v': 'vsplit' }


" }}}

" Unite {{{

  let g:unite_data_directory=$HOME.'/.nvim/.cache/unite'

  " Execute help.
  nnoremap ÚÚh  :<C-u>Unite -start-insert help<CR>
  " Execute help by cursor keyword.
  nnoremap <silent> ÚÚ<C-h>  :<C-u>UniteWithCursorWord help<CR>

  "call unite#custom#source('buffer,file,file_rec',
  "\ 'sorters', 'sorter_length')

  let g:unite_force_overwrite_statusline = 0
  let g:unite_winheight = 10
  let g:unite_data_directory='~/.vim/.cache/unite'
  let g:unite_enable_start_insert=1
  let g:unite_source_history_yank_enable=1
  let g:unite_prompt='» '
  let g:unite_split_rule = 'botright'

  if executable('ag')
    let g:unite_source_grep_command='ag'
    let g:unite_source_grep_default_opts='--nocolor --nogroup -S -C4'
    let g:unite_source_grep_recursive_opt=''
    let g:unite_source_rec_async_command='ag --nocolor --nogroup --ignore ".hg" --ignore ".svn" --ignore ".git" --ignore ".bzr" --hidden -g ""'
  endif

  " Custom mappings for the unite buffer
  autocmd FileType unite call s:unite_settings()
  function! s:unite_settings()
    " Play nice with supertab
    let b:SuperTabDisabled=1
    " Enable navigation with control-j and control-k in insert mode
    imap <buffer> <C-j>   <Plug>(unite_select_next_line)
    imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
  endfunction

  function! Open_current_file_dir(args)
    let [args, options] = unite#helper#parse_options_args(a:args)
    let path = expand('%:h')
    let options.path = path
    call unite#start(args, options)
  endfunction

  nnoremap ÚÚcd :call Open_current_file_dir('-no-split file')<cr>
  nmap <buffer> <bs> <Plug>(unite_delete_backward_path)
  nmap <silent><buffer><esc> <Plug>(unite_all_exit) " Close Unite view

  "CtrlP & NerdTree combined
  nnoremap <silent> ÚÚF :Unite -auto-resize file/async  file_rec/async<cr>
  nnoremap <silent> ÚÚf :Unite -auto-resize file_rec/async<cr>
  nnoremap <silent> ÚÚ<c-f> :Unite -auto-resize file_rec/async<cr>

  nnoremap <silent> ÚÚd :Unite -auto-resize directory_rec/async<cr>
  nnoremap <silent> ÚÚo :Unite -auto-resize file_mru<cr>

  nnoremap <silent> ÚÚl :Unite -auto-resize outline<cr>

  "Grep commands
  nnoremap <silent> ÚÚg :Unite -auto-resize grep:.<cr>
  nnoremap <silent> ÚÚ<c-g> :Unite -auto-resize grep:/<cr>
  "Content search like Ag anc Ack
  nnoremap ÚÚ/ :Unite grep:.<cr>

  "Hostory & YankRing
  let g:unite_source_history_yank_enable = 1
  nnoremap ÚÚy :Unite history/yank<cr>
  nnoremap ÚÚ: :Unite history/command<cr>
  nnoremap ÚÚ/ :Unite history/search<cr>

  nnoremap ÚÚ? :Unite mapping<cr>

  "LustyJuggler
  nnoremap ÚÚb :Unite -quick-match buffer<cr>
  nnoremap ÚÚ<c-b> :Unite buffer<cr>

  "LustyJuggler
  nnoremap ÚÚt :Unite -quick-match tab<cr>
  nnoremap ÚÚ<c-t> :Unite tab<cr>

  "Line Search
  nnoremap ÚÚl :Unite line<cr>
  nnoremap ÚÚL :Unite -quick-match line<cr>


"}}}

" Ctrl-P {{{

  command! CtrlPCommandLine call ctrlp#init(ctrlp#commandline#id())
  cnoremap <silent> <C-p> <C-c>:call ctrlp#init(ctrlp#commandline#id())<CR>

  "'vim-ctrlp-tjump',
  let g:ctrlp_extensions = [
        \ 'tag', 'buffertag', 'quickfix', 'dir', 'rtscript', 'dashhelper',
        \ 'vimnotes', 'undo', 'line', 'changes', 'mixed', 'bookmarkdir',
        \ 'funky', 'commandline'
        \ ]

  "Open window in NERDTree if available
  let g:ctrlp_reuse_window = 'netrw\|help\|NERD\|startify'

  " Make Ctrl+P indexing faster by using ag silver searcher
  let g:ctrlp_lazy_update = 350

  "Enable caching to make it fast
  let g:ctrlp_use_caching = 1

  "Don't clean cache on exit else it will take alot to regenerate RTP
  let g:ctrlp_clear_cache_on_exit = 0

  let g:ctrlp_cache_dir = $HOME.'/.nvim/.cache/ctrlp'

  let g:ctrlp_max_files = 0
  if executable("ag")
    set grepprg=ag\ --nogroup\ --nocolor
    let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
          \ --ignore .git
          \ --ignore .svn
          \ --ignore .hg
          \ --ignore .DS_Store
          \ --ignore "**/*.pyc"
          \ --ignore vendor
          \ --ignore node_modules
          \ -g ""'

  endif

  let g:ctrlp_switch_buffer = 'e'

  "When I press C-P run CtrlP from root of my project regardless of the current
  "files path
  let g:ctrlp_cmd='CtrlPRoot'
  let g:ctrlp_map = '<c-p><c-p>'

  " Make Ctrl+P matching faster by using pymatcher
  " let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
  let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
  " let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}

  nnoremap <c-p>j :CtrlPtjump<cr>
  vnoremap <c-p>j :CtrlPtjumpVisual<cr>
  nnoremap <c-p>b :CtrlPBuffer<cr>
  nnoremap <c-p>cd :CtrlPDir .<cr>
  nnoremap <c-p>d :CtrlPDir<cr>
  nnoremap <c-p><c-[> :CtrlPFunky<Cr>
  nnoremap <c-p><c-]> :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
  nnoremap <c-p>f :execute ":CtrlP " . expand('%:p:h')<cr>
  "nnoremap <c-p>m :CtrlPMixed<cr>
  nnoremap <c-p>q :CtrlPQuickfix<cr>
  nnoremap <c-p>y :CtrlPYankring<cr>
  "nnoremap <c-p>r :CtrlPRoot<cr>
  nnoremap <c-p>w :CtrlPCurWD<cr>

  nnoremap <c-p>t :CtrlPTag<cr>
  nnoremap <c-p>[ :CtrlPBufTag<cr>
  nnoremap <c-p>] :CtrlPBufTagAll<cr>
  nnoremap <c-p>u :CtrlPUndo<cr>
  " nnoremap <c-p>\\ :CtrlPRTS<cr>
  ""nnoremap <c-p><CR> :CtrlPCmdline<cr>
  nnoremap <c-p>; :CtrlPCmdPalette<cr>
  nnoremap <c-p><CR> :CtrlPCommandLine<cr>
  nnoremap <c-p><BS> :CtrlPClearCache<cr>
  nnoremap <c-p><Space> :CtrlPClearAllCache<cr>
  nnoremap <c-p>p :CtrlPLastMode<cr>
  nnoremap <c-p>i :CtrlPChange<cr>
  nnoremap <c-p><c-i> :CtrlPChangeAll<cr>
  nnoremap <c-p>l :CtrlPLine<cr>
  nnoremap <c-p>` :CtrlPBookmarkDir<cr>
  nnoremap <c-p>@ :CtrlPBookmarkDirAdd<cr>
  nnoremap <c-p>o :CtrlPMRU<cr>

  let g:ctrlp_prompt_mappings = {
        \ 'PrtBS()':              ['<bs>', '<c-]>'],
        \ 'PrtDelete()':          ['<del>'],
        \ 'PrtDeleteWord()':      ['<c-w>'],
        \ 'PrtClear()':           ['<c-u>'],
        \ 'PrtSelectMove("j")':   ['<c-j>', '<down>'],
        \ 'PrtSelectMove("k")':   ['<c-k>', '<up>'],
        \ 'PrtSelectMove("t")':   ['<Home>', '<kHome>'],
        \ 'PrtSelectMove("b")':   ['<End>', '<kEnd>'],
        \ 'PrtSelectMove("u")':   ['<PageUp>', '<kPageUp>'],
        \ 'PrtSelectMove("d")':   ['<PageDown>', '<kPageDown>'],
        \ 'PrtHistory(-1)':       ['<c-n>'],
        \ 'PrtHistory(1)':        ['<c-p>'],
        \ 'AcceptSelection("e")': ['<cr>', '<2-LeftMouse>'],
        \ 'AcceptSelection("h")': ['<c-x>', '<c-cr>', '<c-s>'],
        \ 'AcceptSelection("t")': ['<c-t>'],
        \ 'AcceptSelection("v")': ['<c-v>', '<RightMouse>'],
        \ 'ToggleFocus()':        ['<s-tab>'],
        \ 'ToggleRegex()':        ['<c-r>'],
        \ 'ToggleByFname()':      ['<c-d>'],
        \ 'ToggleType(1)':        ['<c-f>'],
        \ 'ToggleType(-1)':       ['<c-b>'],
        \ 'PrtExpandDir()':       ['<tab>'],
        \ 'PrtInsert("c")':       ['<MiddleMouse>', '<insert>'],
        \ 'PrtInsert()':          ['<c-\>'],
        \ 'PrtCurStart()':        ['<c-a>'],
        \ 'PrtCurEnd()':          ['<c-e>'],
        \ 'PrtCurLeft()':         ['<c-h>', '<left>', '<c-^>'],
        \ 'PrtCurRight()':        ['<c-l>', '<right>'],
        \ 'PrtClearCache()':      ['<F5>', 'ÚÚ'],
        \ 'PrtDeleteEnt()':       ['<F7>'],
        \ 'CreateNewFile()':      ['<c-y>'],
        \ 'MarkToOpen()':         ['<c-z>'],
        \ 'OpenMulti()':          ['<c-o>'],
        \ 'PrtExit()':            ['<esc>', '<c-c>', '<c-g>'],
        \ }


"}}}

" Tagbar {{{

  nnoremap <silent> <leader>tb :TagbarToggle<CR>


"}}}

" YankMatches {{{

  nnoremap <silent>  dm :     call ForAllMatches('delete', {})<CR>
  nnoremap <silent>  DM :     call ForAllMatches('delete', {'inverse':1})<CR>
  nnoremap <silent>  ym :     call ForAllMatches('yank',   {})<cr>
  nnoremap <silent>  YM :     call ForAllMatches('yank',   {'inverse':1})<CR>
  vnoremap <silent>  dm :<C-U>call ForAllMatches('delete', {'visual':1})<CR>
  vnoremap <silent>  DM :<C-U>call ForAllMatches('delete', {'visual':1, 'inverse':1})<CR>
  vnoremap <silent>  ym :<C-U>call ForAllMatches('yank',   {'visual':1})<CR>
  vnoremap <silent>  YM :<C-U>call ForAllMatches('yank',   {'visual':1, 'inverse':1})<CR>


" }}}

" vim-oblique {{{

  autocmd! User Oblique       ShowSearchIndex
  autocmd! User ObliqueStar   ShowSearchIndex
  autocmd! User ObliqueRepeat ShowSearchIndex
  let g:oblique#enable_cmap=0


"}}}

" vim-fnr {{{

  " Defaults
  let g:fnr_flags   = 'gc'
  let g:fnr_hl_from = 'Todo'
  let g:fnr_hl_to   = 'IncSearch'

  "custom mapping
  nmap g;S <Plug>(FNR)
  xmap g;S <Plug>(FNR)
  nmap g;s <Plug>(FNR%)
  xmap g;s <Plug>(FNR%)

  " Special keys

  " Tab
      " i - case-insensitive match
      " w - word-boundary match (\<STRING\>)
      " g - substitute all occurrences
      " c - confirm each substitution
      " Tab or Enter to return
  " CTRL-N or CTRL-P
      " Auto-completion


"}}}

" ambicmd {{{

  if !exists("g:vim_ambicmd_mapped")
    let g:vim_ambicmd_mapped = 1
    cnoremap <expr> <Space> ambicmd#expand("\<Space>")
    cnoremap <expr> <CR>    ambicmd#expand("\<CR>")
  endif


"}}}

" vim-over {{{

  "use vim-fnr instead
  " nmap <leader>/ :OverCommandLine<cr>
  " nnoremap g;s :<c-u>OverCommandLine<cr>%s/
  " xnoremap g;s :<c-u>OverCommandLine<cr>%s/\%V


"}}}

" Clever-f {{{

  nmap f<BS> <Plug>(clever-f-reset)
  vmap f<BS> <Plug>(clever-f-reset)


"}}}

" sideways {{{

  nnoremap s;k :SidewaysJumapRight<cr>
  nnoremap s;j :SidewaysJumapLeft<cr>
  nnoremap s;l :SidewaysJumapRight<cr>
  nnoremap s;h :SidewaysJumapLeft<cr>

  nnoremap c;k :SidewaysRight<cr>
  nnoremap c;j :SidewaysLeft<cr>
  nnoremap c;l :SidewaysRight<cr>
  nnoremap c;h :SidewaysLeft<cr>


"}}}

" after-textobj {{{

  " autocmd VimEnter * call after_object#enable('=', ':', '-', '#', ' ')
  " ]= and [= instead of a= and aa=
  autocmd VimEnter * call after_object#enable([']', '['], '=', ':', '-', '#', ' ', '>', '<')


"}}}

" argumentative {{{

  "Move and manipultae arguments of a function
  nmap [; <Plug>Argumentative_Prev
  nmap ]; <Plug>Argumentative_Next
  xmap [; <Plug>Argumentative_XPrev
  xmap ]; <Plug>Argumentative_XNext
  nmap <; <Plug>Argumentative_MoveLeft
  nmap >; <Plug>Argumentative_MoveRight
  xmap i; <Plug>Argumentative_InnerTextObject
  xmap a; <Plug>Argumentative_OuterTextObject
  omap i; <Plug>Argumentative_OpPendingInnerTextObject
  omap a; <Plug>Argumentative_OpPendingOuterTextObject


"}}}

" argwrap {{{

  nnoremap <silent> g;w :ArgWrap<CR>
  let g:argwrap_padded_braces = '[{('


"}}}

" operator-usr {{{

  nmap <Space>al  <Plug>(operator-align-left)
  nmap <Space>ar  <Plug>(operator-align-right)
  nmap <Space>ac  <Plug>(operator-align-center)


"}}}

" operator-camelize {{{

  nmap <Space>u <Plug>(operator-camelize)
  nmap <Space>U <Plug>(operator-decamelize)


"}}}

" operator-insert {{{

  nmap <Space>i <Plug>(operator-insert)


"}}}

" operator-append {{{

  nmap <Space>a <Plug>(operator-append)


"}}}

" operator-comment {{{

  nmap <Space>cc <Plug>(operator-comment)
  nmap <Space>cu <Plug>(operator-uncomment)


"}}}

" operator-blockwise {{{

  nmap <Space>Y <Plug>(operator-blockwise-yank-head)
  nmap <Space>D <Plug>(operator-blockwise-delete-head)
  nmap <Space>C <Plug>(operator-blockwise-change-head)


"}}}

" operator-jerk {{{

  nmap <Space>>  <Plug>(operator-jerk-forward)
  nmap <Space>>> <Plug>(operator-jerk-forward-partial)
  nmap <Space><  <Plug>(operator-jerk-backward)
  nmap <Space><< <Plug>(operator-jerk-backward-partial)


"}}}

" operator-sort {{{

  nmap <Space>s <Plug>(operator-sort)


"}}}

" textobj-quote {{{

  let g:textobj#quote#educate = 0               " 0=disable, 1=enable (def) autoconvert to curely


"}}}

" textobj-xml {{{

  let g:textobj_xmlattribute_no_default_key_mappings=1
  vmap ax <Plug>(textobj-xmlattribute-xmlattribute)
  vmap ix <Plug>(textobj-xmlattribute-xmlattributenospace)
  omap ax <Plug>(textobj-xmlattribute-xmlattribute)
  omap ix <Plug>(textobj-xmlattribute-xmlattributenospace)


"}}}

" textobj-datetime {{{

  let g:textobj_datetime_no_default_key_mappings=1
  vmap agda <Plug>(textobj-datetime-auto)
  vmap agdd <Plug>(textobj-datetime-date)
  vmap agdf <Plug>(textobj-datetime-full)
  vmap agdt <Plug>(textobj-datetime-time)
  vmap agdz <Plug>(textobj-datetime-tz)

  vmap igda <Plug>(textobj-datetime-auto)
  vmap igdd <Plug>(textobj-datetime-date)
  vmap igdf <Plug>(textobj-datetime-full)
  vmap igdt <Plug>(textobj-datetime-time)
  vmap igdz <Plug>(textobj-datetime-tz)


  omap agda <Plug>(textobj-datetime-auto)
  omap agdd <Plug>(textobj-datetime-date)
  omap agdf <Plug>(textobj-datetime-full)
  omap agdt <Plug>(textobj-datetime-time)
  omap agdz <Plug>(textobj-datetime-tz)

  omap igda <Plug>(textobj-datetime-auto)
  omap igdd <Plug>(textobj-datetime-date)
  omap igdf <Plug>(textobj-datetime-full)
  omap igdt <Plug>(textobj-datetime-time)
  omap igdz <Plug>(textobj-datetime-tz)


"}}}

" textobj-entire {{{

  let g:textobj_entire_no_default_key_mappings =1
  vmap aG  <Plug>(textobj-entire-a)
  vmap iG  <Plug>(textobj-entire-i)
  omap aG  <Plug>(textobj-entire-a)
  omap iG  <Plug>(textobj-entire-i)


"}}}

" textobj-space {{{

  let g:textobj_space_no_default_key_mappings =1
  vmap a<Space>  <Plug>(textobj-space-a)
  vmap i<Space>  <Plug>(textobj-space-i)
  omap a<Space>  <Plug>(textobj-space-a)
  omap i<Space>  <Plug>(textobj-space-i)


"}}}

" textobj-path {{{

  let g:textobj_path_no_default_key_mappings =1
  vmap a\  <Plug>(textobj-path-next_path-a)
  vmap i\  <Plug>(textobj-path-next_path-i)
  omap a\  <Plug>(textobj-path-next_path-a)
  omap i\  <Plug>(textobj-path-next_path-i)

  vmap a\|  <Plug>(textobj-path-prev_path-a)
  vmap i\|  <Plug>(textobj-path-prev_path-i)
  omap a\|  <Plug>(textobj-path-prev_path-a)
  omap i\|  <Plug>(textobj-path-prev_path-i)


"}}}

" textobj-inserted {{{

  let g:textobj_lastinserted_no_default_key_mappings =1
  vmap at  <Plug>(textobj-lastinserted-a)
  vmap it  <Plug>(textobj-lastinserted-i)
  omap at  <Plug>(textobj-lastinserted-a)
  omap it  <Plug>(textobj-lastinserted-i)


"}}}

" textobj-php {{{

  let g:textobj_php_no_default_key_mappings =1
  vmap a<  <Plug>(textobj-php-a)
  vmap i<  <Plug>(textobj-php-i)
  omap a<  <Plug>(textobj-php-a)
  omap i<  <Plug>(textobj-php-i)


"}}}

" textobj-between {{{

  let g:textobj_between_no_default_key_mappings =1
  vmap ab  <Plug>(textobj-between-a)
  vmap ib  <Plug>(textobj-between-i)
  omap ab  <Plug>(textobj-between-a)
  omap ib  <Plug>(textobj-between-i)


"}}}

" textobj-any {{{

  let g:textobj_anyblock_no_default_key_mappings =1
  " let g:textobj#anyblock#blocks =  [ '(', '{', '[', '"', "'", '<', '`', 'f`'  ]
  vmap aa  <Plug>(textobj-anyblock-a)
  vmap ia  <Plug>(textobj-anyblock-i)
  omap aa  <Plug>(textobj-anyblock-a)
  omap ia  <Plug>(textobj-anyblock-i)


"}}}

" textobj-postexpr {{{

  let g:textobj_postexpr_no_default_key_mappings =1
  vmap ige <Plug>(textobj-postexpr-i)
  vmap age <Plug>(textobj-postexpr-a)
  omap ige <Plug>(textobj-postexpr-i)
  omap age <Plug>(textobj-postexpr-a)


"}}}

" textobj-multi {{{

  let g:textobj_multitextobj_textobjects_i = [
        \   "\<Plug>(textobj-url-i)",
        \   "\<Plug>(textobj-multiblock-i)",
        \   "\<Plug>(textobj-function-i)",
        \   "\<Plug>(textobj-entire-i)",
        \]

  omap amt <Plug>(textobj-multitextobj-a)
  omap imt <Plug>(textobj-multitextobj-i)
  vmap amt <Plug>(textobj-multitextobj-a)
  vmap imt <Plug>(textobj-multitextobj-i)


"}}}

" textobj-keyvalue {{{

  " let g:textobj_key_no_default_key_mappings=1
  " ak  <Plug>(textobj-key-a)
  " ik  <Plug>(textobj-key-i)
  " av  <Plug>(textobj-value-a)
  " iv  <Plug>(textobj-value-i)


"}}}

" nerdcommenter {{{

  "Add a space around the comment
  let g:NERDSpaceDelims=1


"}}}

" LazyList {{{

  let g:lazylist_omap = 'igll'
  nnoremap glli :LazyList
  vnoremap glli :LazyList
  nnoremap glli :LazyList<CR>
  vnoremap glli :LazyList<CR>
  nnoremap gll- :LazyList '- '<CR>
  vnoremap gll- :LazyList '- '<CR>
  nnoremap gll. :LazyList '%1%. '<CR>
  vnoremap gll. :LazyList '%1%. '<CR>

  nnoremap gll* :LazyList '* '<CR>
  vnoremap gll* :LazyList '* '<CR>

  nnoremap gllt :LazyList '- [ ] '<CR>
  vnoremap gllt :LazyList '- [ ] '<CR>

"}}}

" simple-todo {{{

  " Disable default key bindings
  let g:simple_todo_map_keys = 0

  nmap glti <Plug>(simple-todo-new)
  " imap glti <Plug>(simple-todo-new)

  let g:simple_todo_tick_symbol = 'y'

  " nmap <Leader>i <Plug>(simple-todo-new)
  " imap <Leader>i <Plug>(simple-todo-new)
  " imap <Leader>I <Plug>(simple-todo-new-start-of-line)
  " nmap <Leader>I <Plug>(simple-todo-new-start-of-line)
  " vmap <Leader>I <Plug>(simple-todo-new-start-of-line)
  " nmap <Leader>o <Plug>(simple-todo-below)
  " imap <Leader>o <Plug>(simple-todo-below)
  " nmap <Leader>O <Plug>(simple-todo-above)
  " imap <Leader>O <Plug>(simple-todo-above)
  " nmap <Leader>x <Plug>(simple-todo-mark-as-done)
  " vmap <Leader>x <Plug>(simple-todo-mark-as-done)
  " imap <Leader>x <Plug>(simple-todo-mark-as-done)
  " nmap <Leader>X <Plug>(simple-todo-mark-as-undone)
  " vmap <Leader>X <Plug>(simple-todo-mark-as-undone)
  " imap <Leader>X <Plug>(simple-todo-mark-as-undone)

"}}}

" vim-indentLine {{{

  let g:indentLine_char = '┊'
  " let g:indentLine_color_term=""
  " let g:indentLine_color_gui=""
  let g:indentLine_fileType=[] "Means all filetypes
  let g:indentLine_fileTypeExclude=[]
  let g:indentLine_bufNameExclude=[]


"}}}

" YankRing {{{

  " let g:yankring_min_element_length = 2
  " let g:yankring_max_element_length = 548576 " 4M
  " let g:yankring_dot_repeat_yank = 1
  " " let g:yankring_window_use_horiz = 0  " Use vertical split
  " " let g:yankring_window_height = 8
  " " let g:yankring_window_width = 30
  " " let g:yankring_window_increment = 50   "In vertical press space to toggle width
  " " let g:yankring_ignore_operator = 'g~ gu gU ! = gq g? > < zf g@'
  " let g:yankring_history_dir = '~/.nvim/.cache/yankring'
  " " let g:yankring_clipboard_monitor = 0   "Detect when copying from outside
  " " :YRToggle    " Toggles it
  " " :YRToggle 1  " Enables it
  " " :YRToggle 0  " Disables it
  " nnoremap sd :YRToggle

  " nnoremap <silent> <F11> :YRShow<CR>


"}}}

" yankstack {{{

  " let g:yankstack_map_keys = 0
  let g:yankstack_yank_keys = ['y', 'd']
  nnoremap <M-p> <Plug>yankstack_substitute_older_paste
  nnoremap <M-S-p> <Plug>yankstack_substitute_newer_paste


"}}}

" zoomwintab {{{

  let g:zoomwintab_remap = 0
  " zoom with <META-O> in any mode
  nnoremap <silent> <a-o> :ZoomWinTabToggle<cr>
  inoremap <silent> <a-o> <c-\><c-n>:ZoomWinTabToggle<cr>a
  vnoremap <silent> <a-o> <c-\><c-n>:ZoomWinTabToggle<cr>gv


"}}}

" junkfile {{{

  nnoremap <leader>jo :JunkfileOpen
  let g:junkfile#directory = $HOME . '/.nvim/cache/junkfile'


"}}}

" vim-peekaboo {{{

  " Default peekaboo window
  let g:peekaboo_window = 'vertical botright 30new'

  " Delay opening of peekaboo window (in ms. default: 0)
  let g:peekaboo_delay = 250

  " Compact display; do not display the names of the register groups
  let g:peekaboo_compact = 1


"}}}

" calendar {{{

  let g:calendar_date_month_name = 1


"}}}

" vim-hardtime {{{

  let g:hardtime_timeout = 1000

  let g:hardtime_allow_different_key = 1
  let g:hardtime_maxcount = 1
  let g:hardtime_default_on = 0
  let g:hardtime_showmsg = 1

  let g:list_of_normal_keys = ["h", "j", "k", "l", "-", "+", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
  let g:list_of_visual_keys = ["h", "j", "k", "l", "-", "+", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
  let g:list_of_insert_keys = ["<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]


  "Disable in certain buffers default []
  " let g:hardtime_ignore_buffer_patterns = [ "CustomPatt[ae]rn", "NERD.*" ]


"}}}

" vim-submode {{{

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

" lightline {{{

        " \ 'colorscheme': 'powerline',
        " \ 'colorscheme': 'wombat',
        " \ 'colorscheme': 'jellybeans',
  let g:lightline = {
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
        \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
        \ },
        \ 'component_function': {
        \   'fugitive': 'LightLineFugitive',
        \   'filename': 'LightLineFilename',
        \   'fileformat': 'LightLineFileformat',
        \   'filetype': 'LightLineFiletype',
        \   'fileencoding': 'LightLineFileencoding',
        \   'mode': 'LightLineMode',
        \   'ctrlpmark': 'CtrlPMark',
        \ },
        \ 'component_expand': {
        \   'syntastic': 'SyntasticStatuslineFlag',
        \ },
        \ 'component_type': {
        \   'syntastic': 'error',
        \ },
        \ 'subseparator': { 'left': '|', 'right': '|' }
        \ }

  let g:lightline.colorscheme = 'gruvbox'
  function! LightLineModified()
    return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
  endfunction

  function! LightLineReadonly()
    return &ft !~? 'help' && &readonly ? '⭤' : ''
  endfunction

  function! LightLineFilename()
    let fname = expand('%:t')
    return fname == 'ControlP' ? g:lightline.ctrlp_item :
          \ fname == '__Tagbar__' ? g:lightline.fname :
          \ fname =~ '__Gundo\|NERD_tree' ? '' :
          \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
          \ &ft == 'unite' ? unite#get_status_string() :
          \ &ft == 'vimshell' ? vimshell#get_status_string() :
          \ ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
          \ ('' != fname ? fname : '[No Name]') .
          \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
  endfunction

  function! LightLineFugitive()
    try
      if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
        let mark = '⭠ '  " edit here for cool mark
        let _ = fugitive#head()
        return strlen(_) ? mark._ : ''
      endif
    catch
    endtry
    return ''
  endfunction

  function! LightLineFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
  endfunction

  function! LightLineFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
  endfunction

  function! LightLineFileencoding()
    return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
  endfunction

  function! LightLineMode()
    let fname = expand('%:t')
    return fname == '__Tagbar__' ? 'Tagbar' :
          \ fname == 'ControlP' ? 'CtrlP' :
          \ fname == '__Gundo__' ? 'Gundo' :
          \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
          \ fname =~ 'NERD_tree' ? 'NERDTree' :
          \ &ft == 'unite' ? 'Unite' :
          \ &ft == 'vimfiler' ? 'VimFiler' :
          \ &ft == 'vimshell' ? 'VimShell' :
          \ winwidth(0) > 60 ? lightline#mode() : ''
  endfunction

  function! CtrlPMark()
    if expand('%:t') =~ 'ControlP'
      call lightline#link('iR'[g:lightline.ctrlp_regex])
      return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
            \ , g:lightline.ctrlp_next], 0)
    else
      return ''
    endif
  endfunction

  let g:ctrlp_status_func = {
        \ 'main': 'CtrlPStatusFunc_1',
        \ 'prog': 'CtrlPStatusFunc_2',
        \ }

  function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
    let g:lightline.ctrlp_regex = a:regex
    let g:lightline.ctrlp_prev = a:prev
    let g:lightline.ctrlp_item = a:item
    let g:lightline.ctrlp_next = a:next
    return lightline#statusline(0)
  endfunction

  function! CtrlPStatusFunc_2(str)
    return lightline#statusline(0)
  endfunction

  let g:tagbar_status_func = 'TagbarStatusFunc'

  function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
    return lightline#statusline(0)
  endfunction

  augroup AutoSyntastic
    autocmd!
    autocmd BufWritePost *.c,*.cpp call s:syntastic()
  augroup END
  function! s:syntastic()
    SyntasticCheck
    call lightline#update()
  endfunction

  let g:unite_force_overwrite_statusline = 0
  let g:vimfiler_force_overwrite_statusline = 0
  let g:vimshell_force_overwrite_statusline = 0


"}}}

" vim-ctrlspace {{{

  if executable("ag")
    let g:ctrlspace_glob_command = 'ag -l --nocolor -g ""'
  endif

  nnoremap <C-Space> :CtrlSpace<cr>
  autocmd filetype ctrlspace call s:ctrlspace_settings()
  function! s:ctrlspace_settings()
    " enable navigation with control-j and control-k in insert mode
    imap <buffer> <c-j>   :call <sid>move_selection_bar("down")
    imap <buffer> <c-k>   :call <sid>move_selection_bar("up")
  endfunction

  "let g:ctrlspace_use_tabline = 0



"}}}

" vim-emmet {{{

  let g:user_emmet_mode='a'         "enable all function in all mode.
  " let g:user_emmet_mode='i'         "enable all function in all mode.
  let g:user_emmet_leader_key='◊Ú'

"}}}

" vim-easymotion {{{

  map s <Plug>(easymotion-prefix)

  map sl          <Plug>(easymotion-lineforward)
  map sh          <Plug>(easymotion-linebackward)

  " map ◊l          <Plug>(easymotion-bd-fl)

  map <c-s><c-s>         <Plug>(easymotion-s2)
  " map ◊Ț<c-s>     <Plug>(easymotion-bd-s2)
  map <c-s>s      <Plug>(easymotion-sn)
  " map ◊<c-s>      <Plug>(easymotion-bd-fn)

  map <c-s>f <Plug>(easymotion-bd-f)
  map ssf    <Plug>(easymotion-bd-f)
  map <c-s>t <Plug>(easymotion-bd-t)
  map sst    <Plug>(easymotion-bd-t)
  map <c-s>w <Plug>(easymotion-bd-w)
  map ssw    <Plug>(easymotion-bd-w)
  "map ◊<c-s-w>    <Plug>(easymotion-bd-W)
  map <c-s>e <Plug>(easymotion-bd-e)
  map sse    <Plug>(easymotion-bd-e)
  "map ◊<c-s-e>    <Plug>(easymotion-bd-E)
  map <c-s>n <Plug>(easymotion-bd-n)
  map ssn    <Plug>(easymotion-bd-n)

  map <c-s>j      <Plug>(easymotion-bd-jk)
  map ssj      <Plug>(easymotion-bd-jk)
  map <c-s>k      <Plug>(easymotion-bd-jk)
  map ssk      <Plug>(easymotion-bd-jk)

  map <c-s>l      <Plug>(easymotion-eol-bd-jk)
  map <c-s>h      <Plug>(easymotion-sol-bd-jk)


  " <Plug>(easymotion-sn) <Plug>(easymotion-fn) <Plug>(easymotion-Fn)
  " <Plug>(easymotion-tn) <Plug>(easymotion-Tn) <Plug>(easymotion-bd-tn)
  " <Plug>(easymotion-sln) <Plug>(easymotion-fln) <Plug>(easymotion-Fln)
  " <Plug>(easymotion-tln) <Plug>(easymotion-Tln) <Plug>(easymotion-bd-tln)

  " <Plug>(easymotion-s2) <Plug>(easymotion-f2) <Plug>(easymotion-F2)
  " <Plug>(easymotion-t2) <Plug>(easymotion-T2) <Plug>(easymotion-bd-t2)
  " <Plug>(easymotion-sl2) <Plug>(easymotion-fl2) <Plug>(easymotion-Fl2)
  " <Plug>(easymotion-tl2) <Plug>(easymotion-Tl2) <Plug>(easymotion-bd-tl2)

  " keep cursor colum when JK motion
  let g:EasyMotion_startofline = 0
  let g:EasyMotion_force_csapprox = 1


"}}}

" columnmove {{{

  let g:columnmove_no_default_key_mappings = 1

  " <Plug>(columnmove-f)
  " <Plug>(columnmove-t)
  " <Plug>(columnmove-F)
  " <Plug>(columnmove-T)
  " <Plug>(columnmove-;)
  " <Plug>(columnmove-,)

  " <Plug>(columnmove-w)
  " <Plug>(columnmove-b)
  " <Plug>(columnmove-e)
  " <Plug>(columnmove-ge)

  " <Plug>(columnmove-W)
  " <Plug>(columnmove-B)
  " <Plug>(columnmove-E)
  " <Plug>(columnmove-gE)



"}}}

" patternjump {{{

 "M-h, M=l MAPPINGS
 let s:patternjump_patterns = {
      \ '_' : {
      \   'i' : {
      \     'head' : ['^\s*\zs\S', ',', ')', ']', '}'],
      \     'tail' : ['\<\h\k*\>', '.$'],
      \     },
      \   'n' : {
      \     'head' : ['^\s*\zs\S', '\<\h\k*\>', '.$'],
      \     },
      \   'x' : {
      \     'tail' : ['^\s*\zs\S', '\<\h\k*\>', '.$'],
      \     },
      \   'o' : {
      \     'forward'  : {'tail_inclusive' : ['\<\h\k*\>']},
      \     'backward' : {'head_inclusive' : ['\<\h\k*\>']},
      \     },
      \   },
      \ '*' : {
      \   'c' : {
      \     'head' : ['^', ' ', '/', '[A-Z]', ',', ')', ']', '}', '$'],
      \     },
      \   },
      \ }

"}}}

" columnmove {{{

"


"}}}

" vim-trailing-whitespace {{{

  let g:extra_whitespace_ignored_filetypes = ['unite', 'mkd']


"}}}

" vim-IndexedSearch {{{

  let g:IndexedSearch_SaneRegEx = 1
  let g:IndexedSearch_AutoCenter = 1
  let g:IndexedSearch_No_Default_Mappings = 1

  " nmap <silent>n <Plug>(ShowSearchIndex_n)zv
  " nmap <silent>N <Plug>(ShowSearchIndex_N)zv
  " nmap <silent>* <Plug>(ShowSearchIndex_Star)zv
  " nmap <silent># <Plug>(ShowSearchIndex_Pound)zv

  " nmap / <Plug>(ShowSearchIndex_Forward)
  " nmap ? <Plug>(ShowSearchIndex_Backward)


"}}}

" follow-my-lead {{{

  let g:fml_all_sources=1 "1 for all sources, 0(Default) for $MYVIMRC.


"}}}

" neosnippet {{{

  " Plugin key-mappings.
  imap <c-\>     <Plug>(neosnippet_expand_or_jump)
  smap <c-\>     <Plug>(neosnippet_expand_or_jump)
  xmap <c-\>     <Plug>(neosnippet_expand_target)
  " For snippet_complete marker.
  if has('conceal')
    set conceallevel=2 concealcursor=niv
  endif


"}}}

" deoplete {{{

  " Use deoplete.
  let g:deoplete#enable_at_startup = 1

  let g:deoplete#auto_completion_start_length = 1


"}}}

" YouCompleteMe {{{

  " " make YCM compatible with UltiSnips (using supertab)
  " let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
  " let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
  " let g:SuperTabDefaultCompletionType = '<C-n>'


"}}}

" UltiSnips {{{

  " better key bindings for UltiSnipsExpandTrigger

  let g:UltiSnipsEnableSnipMate = 0

  let g:UltiSnipsExpandTrigger = "‰"            "press ctrl+enter
  let g:UltiSnipsJumpForwardTrigger = "‰"       "press ctrl+enter
  let g:UltiSnipsJumpBackwardTrigger = "<m-cr>" "press alt+enter
  let g:UltiSnipsListSnippets="<s-tab>"

  let g:ultisnips_java_brace_style="nl"
  let g:Ultisnips_java_brace_style="nl"
  let g:UltiSnipsSnippetsDir="~/.nvim/UltiSnips"
  "let g:UltiSnipsSnippetDirectories = [ "/Volumes/Home/.nvim/plugged/vim-snippets/UltiSnips"]


"}}}

" xptemplate {{{

  " " Add xptemplate global personal directory value
  " if has("unix")
    " set runtimepath+=/Volumes/Home/.nvim/xpt-personal
  " endif
  " "let g:xptemplate_nav_next = '<C-j>'
  " "let g:xptemplate_nav_prev = '<C-k>'


"}}}

" tabular {{{

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
  nnoremap <leader>aa :Tabularize
  vnoremap <leader>aa :Tabularize


"}}}

" vim-surround {{{

  nmap ds <Plug>Dsurround
  nmap cs <Plug>Csurround
  nmap ys <Plug>Ysurround
  nmap yS <Plug>YSurround
  nmap yss <Plug>Yssurround
  nmap ySs <Plug>YSsurround
  nmap ySS <Plug>YSsurround
  xmap S <Plug>VSurround
  xmap gS <Plug>VgSurround

  imap <C-G>s <Plug>Isurround
  imap <C-G>S <Plug>ISurround
  imap <C-S> <Plug>Isurround


"}}}

" vim-rengbang {{{

  "Use instead of increment it is much powerfull
  " RengBang \(\d\+\) Start# Increment# Select# %03d => 001, 002


"}}}

" enmasse {{{

  " EnMass the sublime like search and edit then save back to corresponding files


"}}}

" multiple-cursor {{{

  let g:multi_cursor_use_default_mapping=0
  "Use ctrl-n to select next instance


"}}}

" multiedit {{{

  let g:multiedit_no_mappings = 1
  let g:multiedit_auto_reset = 1

  nnoremap ,me :call BindMultieditKeys()<cr>

  function! BindMultieditKeys()

    " Insert a disposable marker after the cursor
    nnoremap <leader>ma :MultieditAddMark a<CR>

    " Insert a disposable marker before the cursor
    nnoremap <leader>mi :MultieditAddMark i<CR>

    " Make a new line and insert a marker
    nnoremap <leader>mo o<Esc>:MultieditAddMark i<CR>
    nnoremap <leader>mO O<Esc>:MultieditAddMark i<CR>

    " Insert a marker at the end/start of a line
    nnoremap <leader>mA $:MultieditAddMark a<CR>
    nnoremap <leader>mI ^:MultieditAddMark i<CR>

    " Make the current selection/word an edit region
    vnoremap <leader>m :MultieditAddRegion<CR>
    nnoremap <leader>mm viw:MultieditAddRegion<CR>

    " Restore the regions from a previous edit session
    nnoremap <leader>mu :MultieditRestore<CR>

    " Move cursor between regions n times
    noremap ]gc :MultieditHop 1<CR>
    noremap [gc :MultieditHop -1<CR>

    " Start editing!
    nnoremap <leader>ms :Multiedit<CR>

    " Clear the word and start editing
    nnoremap <leader>mc :Multiedit!<CR>

    " Unset the region under the cursor
    nnoremap <silent> <leader>md :MultieditClear<CR>

    " Unset all regions
    nnoremap <silent> <leader>mr :MultieditReset<CR>

    nmap <silent> <leader>mn <leader>mm/<C-r>=expand("<cword>")<CR><CR>
    nmap <silent> <leader>mp <leader>mm?<C-r>=expand("<cword>")<CR><CR>

  endfunction


"}}}

" splitjoin {{{

  let g:splitjoin_split_mapping = 'gS'
  let g:splitjoin_join_mapping  = 'gJ'


"}}}

" tmux-navigator {{{

  if exists('$TMUX')
    let g:tmux_navigator_no_mappings = 1
    nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
    nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
    nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
    nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
    nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>
  endif


"}}}

" undotree {{{

  let g:undotree_WindowLayout = 2


"}}}

" gundo-tree {{{

  let g:gundo_preview_bottom = 1


"}}}

" neomake {{{

  " autocmd! BufWritePost * Neomake
  " let g:neomake_airline = 0
  let g:neomake_error_sign = { 'text': '✘', 'texthl': 'ErrorSign' }
  let g:neomake_warning_sign = { 'text': ':(', 'texthl': 'WarningSign' }


"}}}

" omnisharp {{{

  " let g:OmniSharp_server_type = 'roslyn'
  let g:OmniSharp_server_path = "/Volumes/Home/.nvim/plugged/Omnisharp/server/Omnisharp/bin/Debug/OmniSharp.exe"
  Plug 'nosami/Omnisharp'

  " Plug 'khalidchawtany/omnisharp-vim', {'branch': 'nUnitQuickFix'}

  let g:OmniSharp_selecter_ui = 'ctrlp'

  let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']

  "let g:OmniSharp_server_type = 'roslyn'
  autocmd Filetype cs,cshtml.html call SetOmniSharpOptions()

  function! SetOmniSharpOptions()

    if exists("g:SetOmniSharpOptionsIsSet")
      return
    endif

    source ~/.nvim/scripts/make_cs_solution.vim
    autocmd BufWritePost *.cs BuildCSharpSolution

    nnoremap ,oo :BuildCSharpSolution<cr>

    let g:SetOmniSharpOptionsIsSet = 1
    "can set preview here also but i found it causes flicker
    "set completeopt=longest,menuone

    "makes enter work like C-y, confirming a popup selection
    "inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

    setlocal omnifunc=OmniSharp#Complete

    if exists(":DeopleteEnable")
      DeopleteEnable
      let g:deoplete#omni_patterns.cs='.*[^=\);]'
      let g:deoplete#sources.cs=['omni', 'buffer', 'member', 'tag', 'file']
    endif

    " Builds can also run asynchronously with vim-dispatch installed
    nnoremap <leader>ob :wa!<cr>:OmniSharpBuildAsync<cr>

    nnoremap <leader>ogd :OmniSharpGotoDefinition<cr>
    nnoremap <leader>ofi :OmniSharpFindImplementations<cr>
    nnoremap <leader>oft :OmniSharpFindType<cr>
    nnoremap <leader>ofs :OmniSharpFindSymbol<cr>
    nnoremap <leader>ofu :OmniSharpFindUsages<cr>

    nnoremap <leader>ofm :OmniSharpFindMembers<cr>
    " cursor can be anywhere on the line containing an issue
    nnoremap <leader>ox  :OmniSharpFixIssue<cr>
    nnoremap <leader>ofx :OmniSharpFixUsings<cr>
    nnoremap <leader>ott :OmniSharpTypeLookup<cr>
    nnoremap <leader>odc :OmniSharpDocumentation<cr>
    "navigate up by method/property/field
    nnoremap <leader>ok :OmniSharpNavigateUp<cr>
    "navigate down by method/property/field
    nnoremap <leader>oj :OmniSharpNavigateDown<cr>

    " Contextual code actions (requires CtrlP or unite.vim)
    nnoremap <leader>o<space> :OmniSharpGetCodeActions<cr>
    " Run code actions with text selected in visual mode to extract method
    vnoremap <leader>o<space> :call OmniSharp#GetCodeActions('visual')<cr>

    " rename with dialog
    nnoremap <leader>onm :OmniSharpRename<cr>
    " rename without dialog - with cursor on the symbol to rename... ':Rename newname'

    " Force OmniSharp to reload the solution. Useful when switching branches etc.
    nnoremap <leader>ors :OmniSharpReloadSolution<cr>
    nnoremap <leader>ocf :OmniSharpCodeFormat<cr>
    " Load the current .cs file to the nearest project
    nnoremap <leader>otp :OmniSharpAddToProject<cr>

    " (Experimental - uses vim-dispatch or vimproc plugin) - Start the omnisharp server for the current solution
    nnoremap <leader>oss :OmniSharpStartServer<cr>
    nnoremap <leader>osp :OmniSharpStopServer<cr>

    " Add syntax highlighting for types and interfaces
    nnoremap <leader>oth :OmniSharpHighlightTypes<cr>

    nnoremap <leader>ort :OmniSharpRunTests<cr>
    nnoremap <leader>orf :OmniSharpRunTestFixture<cr>
    nnoremap <leader>ora :OmniSharpRunAllTests<cr>
    nnoremap <leader>orl :OmniSharpRunLastTests<cr>
  endfunction

  augroup omnisharp_commands
    autocmd!

    command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

    " automatic syntax check on events (TextChanged requires Vim 7.4)
    autocmd BufEnter,TextChanged,InsertLeave *.cs,*.cshtml SyntasticCheck

    " Automatically add new cs files to the nearest project on save
    autocmd BufWritePost *.cs,*.cshtml call OmniSharp#AddToProject()

    "show type information automatically when the cursor stops moving
    "autocmd CursorHold *.cs,*.cshtml call OmniSharp#TypeLookupWithoutDocumentation()
  augroup END

  "set updatetime=500
  " Remove 'Press Enter to continue' message when type information is longer than one line.
  "set cmdheight=2



"}}}

" syntastic {{{

  let g:syntastic_scala_checkers=['']
  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_check_on_open = 1
  let g:syntastic_error_symbol = "✗"
  let g:syntastic_warning_symbol = "⚠"


"}}}

" neoterm {{{

  let g:neoterm_clear_cmd = "clear; printf '=%.0s' {1..80}; clear"
  let g:neoterm_position = 'vertical'
  let g:neoterm_automap_keys = '<leader>tt'

  nnoremap <silent> <f9> :call neoterm#repl#line()<cr>
  vnoremap <silent> <f9> :call neoterm#repl#selection()<cr>

  " " TODO fix these mappings were disabled find alternatives
  " " run set test lib
  " nnoremap <silent> <leader>rt :call neoterm#test#run('all')<cr>
  " nnoremap <silent> <leader>rf :call neoterm#test#run('file')<cr>
  " nnoremap <silent> <leader>rn :call neoterm#test#run('current')<cr>
  " nnoremap <silent> <leader>rr :call neoterm#test#rerun()<cr>

  " " Useful maps
  " " closes the all terminal buffers
  " nnoremap <silent> <leader>tc :call neoterm#close_all()<cr>
  " " clear terminal
  " nnoremap <silent> <leader>tl :call neoterm#clear()<cr>


"}}}

" phpcomplete-extended {{{

  " let g:phpcomplete_index_composer_command = "composer"
  " " autocmd  FileType  php setlocal omnifunc=phpcomplete_extended#CompletePHP


"}}}

" fugitive {{{

  autocmd User fugitive
        \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
        \   nnoremap <buffer> .. :edit %:h<CR> |
        \ endif
  " autocmd BufReadPost fugitive://* set bufhidden=delete
  " set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P


"}}}

" ragtag {{{

  let g:ragtag_global_maps = 1


"}}}

" limelight {{{

  let g:limelight_conceal_guifg="#C2B294"


"}}}

" goyo {{{

  autocmd! User GoyoEnter Limelight
  autocmd! User GoyoLeave Limelight!


"}}}

" gruvbox {{{

  let g:gruvbox_contrast_dark='soft'          "soft, medium, hard"
  let g:gruvbox_contrast_light='soft'         "soft, medium, hard"


"}}}

" SearchFold {{{

  " Search and THEN Fold the search term containig lines using <leader>z
  " or the the inverse using <leader>iz or restore original fold using <leader>Z
  nmap <leader>z <Plug>SearchFoldNormal


"}}}


call plug#end()
"}}}
" ============================================================================
" FUNCTIONS & COMMANDS {{{
" ============================================================================

  function! CreateFoldableCommentFunction()"{{{
    normal 0f/lyt'02[ 2] 2ki"{{{ lp2j0>>2ji"}}}} _p04kf}x4jzaj
  endfunction"}}}

  function! HighlightAllOfWord(onoff)"{{{
    if a:onoff == 1
      :augroup highlight_all
      :au!
      :au CursorMoved * silent! exe printf('match Search /\<%s\>/', expand('<cword>'))
      :augroup END
    else
      :au! highlight_all
      match none /\<%s\>/
    endif
  endfunction"}}}

  function! ToggleMouseFunction()"{{{
    if  &mouse=='a'
      set mouse=
      echo "Shell has it"
    else
      set mouse=a
      echo "Vim has it"
    endif
  endfunction"}}}

  function! StripWhitespace()"{{{
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
  endfunction"}}}

  function! FindGitDirOrRoot()"{{{
    let curdir = expand('%:p:h')
    let gitdir = finddir('.git', curdir . ';')
    if gitdir != ''
      return substitute(gitdir, '\/\.git$', '', '')
    else
      return '/'
    endif
  endfunction"}}}

  function! IndentToNextBraceInLineAbove()"{{{
    :normal 0wk
    :normal "vyf(
    let @v = substitute(@v, '.', ' ', 'g')
    :normal j"vPl
  endfunction"}}}

  function! List(command, selection, start_at_cursor, ...)"{{{

  " This is an updated, more powerful, version of the function discussed here:
  " http://www.reddit.com/r/vim/comments/1rzvsm/do_any_of_you_redirect_results_of_i_to_the/
  " that shows ]I, [I, ]D, [D, :ilist and :dlist results in the quickfix window, even spanning multiple files.
    " derive the commands used below from the first argument
    let excmd   = a:command . "list"
    let normcmd = toupper(a:command)

    if a:selection
      if len(a:1) > 0
        let search_pattern = a:1
      else
        let old_reg = @v
        normal! gv"vy
        let search_pattern = substitute(escape(@v, '\/.*$^~[]'), '\\n', '\\n', 'g')
        let @v = old_reg
      endif
      redir => output
      silent! execute (a:start_at_cursor ? '+,$' : '') . excmd . ' /' . search_pattern
      redir END
    else
      redir => output
      silent! execute 'normal! ' . (a:start_at_cursor ? ']' : '[') . normcmd
      redir END
    endif

    " clean up the output
    let lines = split(output, '\n')

    " bail out on errors
    if lines[0] =~ '^Error detected'
      echomsg 'Could not find "' . (a:selection ? search_pattern : expand("<cword>")) . '".'
      return
    endif

    " our results may span multiple files so we need to build a relatively
    " complex list based on file names
    let filename   = ""
    let qf_entries = []
    for line in lines
      if line =~ '^\S'
        let filename = line
      else
        call add(qf_entries, {"filename" : filename, "lnum" : split(line)[1], "text" : join(split(line)[2:-1])})
      endif
    endfor

    " build the quickfix list from our results
    call setqflist(qf_entries)

    " open the quickfix window if there is something to show
    cwindow
  endfunction"}}}

  function! Preserve(command)"{{{
    " Save the last search.
    let search = @/

    " Save the current cursor position.
    let cursor_position = getpos('.')

    " Save the current window position.
    normal! H
    let window_position = getpos('.')
    call setpos('.', cursor_position)

    " Execute the command.
    execute a:command

    " Restore the last search.
    let @/ = search

    " Restore the previous window position.
    call setpos('.', window_position)
    normal! zt

    " Restore the previous cursor position.
    call setpos('.', cursor_position)
  endfunction"}}}

  function! Uncrustify(language) "{{{

  " Don't forget to add Uncrustify executable to $PATH (on Unix) or
  " %PATH% (on Windows) for this command to work.

    call Preserve(':silent %!uncrustify'
          \ . ' -q '
          \ . ' -l ' . a:language
          \ . ' -c ' . g:uncrustify_cfg_file_path)
  endfunction"}}}

  function! OpenHelpInCurrentWindow(topic) "{{{
    view $VIMRUNTIME/doc/help.txt
    setl filetype=help
    setl buftype=help
    setl nomodifiable
    exe 'keepjumps help ' . a:topic
  endfunction "}}}

  " ScratchPad {{{
  augroup scratchpad
    au!
    au BufNewFile,BufRead .scratchpads/scratchpad.* call ScratchPadLoad()
  augroup END

  function! ScratchPadSave() "{{{
    let ftype = matchstr(expand('%'), 'scratchpad\.\zs\(.\+\)$')
    if ftype == ''
      return
    endif
    write
  endfunction "}}}

  function! ScratchPadLoad() "{{{
    nnoremap <silent> <buffer> q :w<cr>:close<cr>
    setlocal bufhidden=hide buflisted noswapfile
  endfunction "}}}

  function! OpenScratchPad(ftype) "{{{
    if a:0 > 0
      let ftype = a:ftype
    else
      let pads = split(globpath('.scratchpads', 'scratchpad.*'), '\n')
      if len(pads) > 0
        let ftype = matchstr(pads[0], 'scratchpad\.\zs\(.\+\)$')
      else
        let ftype = expand('%:e')
      endif
    endif

    if ftype == ''
      echoerr 'Scratchpad need a filetype'
      return
    endif

    let scratchpad_name = '.scratchpads/scratchpad.' . ftype
    let scr_bufnum = bufnr(scratchpad_name)

    if scr_bufnum == -1
      " open the scratchpad
      exe "new " . scratchpad_name
      let dir = expand('%:p:h')
      if !isdirectory(dir)
        call mkdir(dir)
      endif
    else
      " Scratch buffer is already created. Check whether it is open
      " in one of the windows
      let scr_winnum = bufwinnr(scr_bufnum)
      if scr_winnum != -1
        " Jump to the window which has the scratchpad if we are not
        " already in that window
        if winnr() != scr_winnum
          exe scr_winnum . "wincmd w"
        endif
      else
        exe "split +buffer" . scr_bufnum
      endif
    endif
  endfunction "}}}
" }}}

  function! GetVisualSelection() "{{{
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][: col2 - 2]
    let lines[0] = lines[0][col1 - 1:]
    return join(lines, "\n")
  endfunction "}}}

  function! RenameFile() "{{{
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
      exec ':saveas ' . new_name
      exec ':silent !rm ' . old_name
      redraw!
    endif
  endfunction "}}}

  function! SearchForCallSitesCursor() "{{{
  "Find references of this function (function calls)
    let searchTerm = expand("<cword>")
    call SearchForCallSites(searchTerm)
  endfunction "}}}

  function! SearchForCallSites(term) "{{{
  " Search for call sites for term (excluding its definition) and
  " load into the quickfix list.
    cexpr system('ag ' . shellescape(a:term) . '\| grep -v def')
  endfunction "}}}

  function! s:EnsureDirectoryExists() "{{{
    let required_dir = expand("%:h")

    if !isdirectory(required_dir)
      " Remove this if-clause if you don't need the confirmation
      if !confirm("Directory '" . required_dir . "' doesn't exist. Create it?")
        return
      endif

      try
        call mkdir(required_dir, 'p')
      catch
        echoerr "Can't create '" . required_dir . "'"
      endtry
    endif
  endfunction "}}}

  function! DiffMe() "{{{
  " Toggle the diff of currently open buffers/splits.
    windo diffthis
    if $diff_me>0
      let $diff_me=0
    else
      windo diffoff
      let $diff_me=1
    endif
  endfunction "}}}

  fu! RelativePathString(file) "{{{
  "Get relative path to this file
    if strlen(a:file) == 0
      retu "[No Name]"
    en
    let common = getcwd()
    let result = ""
    while substitute(a:file, common, '', '') ==# a:file
      let common = fnamemodify(common, ':h')
      let result = ".." . (empty(result) ? '' : '/' . result)
    endw
    let forward = substitute(a:file, common, '', '')
    if !empty(result) && !empty(forward)
      retu result . forward
    elsei !empty(forward)
      retu forward[1:]
    en
  endf "}}}

  function! Reg() "{{{
  ":Reg Shows and prompts to select from a reg
    reg
    echo "Register: "
    let char = nr2char(getchar())
    if char != "\<Esc>"
      execute "normal! \"".char."p"
    endif
    redraw
  endfunction "}}}

"{{{ CreateLaravelGeneratorFunction

  function! CreateLaravelGeneratorFunction()
  "Generate laravel generator command

  "alias g:m="php artisan generate:model"
  "alias g:c="php artisan generate:controller"
  "alias g:v="php artisan generate:view"
  "alias g:se="php artisan generate:seed"
  "alias g:mi="php artisan generate:migration"
  "alias g:r="php artisan generate:resource"
  "alias g:p="php artisan generate:pivot"
  "alias g:s="php artisan generate:scaffold"

  "php artisan generate:migration create_posts_table --fields="title:string, body:text"

  let command =  input('!g:')

  "if --fields is NOT already provided
  if stridx(command, '--fields') ==? "-1"

    "Get the command part
    let cmd_shortform = strpart(command, 0,stridx(command, " "))
    "The list of commands that require --fields
    let cmd_require_fields = ['mi', 'r', 's' ]

    "if the command is NOT one of the above
    if index(cmd_require_fields, cmd_shortform) !=? "-1"
      let fields = input( "!g:" . command . ' --fields= ')
      let command = command . ' --fields="' . fields . '"'
    endif "Command requires --fields

  endif " --fields is not provided

  if strlen(command) !=? "0"
    "Prepend cmd with required stuff
    let command = "g:" . command
  endif

  return command

  endfunction

"}}} _CreateLaravelGeneratorFunction

  function! ExecuteLaravelGeneratorCMD()"{{{
    let cmd = CreateLaravelGeneratorFunction()
    call VimuxRunCommand(cmd)
    call VimuxZoomRunner()
  endfunction"}}}

function! BufOnly(buffer, bang) "{{{
  if a:buffer == ''
    " No buffer provided, use the current buffer.
    let buffer = bufnr('%')
  elseif (a:buffer + 0) > 0
    " A buffer number was provided.
    let buffer = bufnr(a:buffer + 0)
  else
    " A buffer name was provided.
    let buffer = bufnr(a:buffer)
  endif

  if buffer == -1
    echohl ErrorMsg
    echomsg "No matching buffer for" a:buffer
    echohl None
    return
  endif

  let last_buffer = bufnr('$')

  let delete_count = 0
  let n = 1
  while n <= last_buffer
    if n != buffer && buflisted(n)
      if a:bang == '' && getbufvar(n, '&modified')
        echohl ErrorMsg
        echomsg 'No write since last change for buffer'
              \ n '(add ! to override)'
        echohl None
      else
        silent exe 'bdel' . a:bang . ' ' . n
        if ! buflisted(n)
          let delete_count = delete_count+1
        endif
      endif
    endif
    let n = n+1
  endwhile

  if delete_count == 1
    echomsg delete_count "buffer deleted"
  elseif delete_count > 1
    echomsg delete_count "buffers deleted"
  endif

endfunction "}}}

function! ToggleFoldMethod() "{{{
  if &foldenable==0
    set foldenable
    set foldmethod=marker
    echomsg "FoldMethod = Marker"
  elseif  &foldmethod=='marker'
    set foldmethod=indent
    echomsg "FoldMethod = Indent"
  elseif &foldmethod=='indent'
    set foldmethod=syntax
    echomsg "FoldMethod = Syntax"
  elseif &foldmethod=='syntax'
    set nofoldenable
    echomsg "Fold Disabled"
  endif
endfunction "}}}

function! ToggleFoldMarker() "{{{
  set foldlevel=0
  if &filetype == "neosnippet"
    setlocal foldmethod=marker
    setlocal foldmarker=snippet,endsnippet
  elseif &filetype == "cs"
    " set foldtext=foldtext()
    if &foldmarker != '#region,#endregion'
      setlocal foldmarker=#region,#endregion
    else
      setlocal foldmarker={,}
      setlocal foldlevel=2
    endif
  endif
endfunction "}}}


  command! -nargs=1 Ilist call List("i", 1, 0, <f-args>)
  command! -nargs=1 Dlist call List("d", 1, 0, <f-args>)


  command! DiffSplits :call DiffMe()<cr>

  command! -nargs=0 Reg call Reg()

  command! -nargs=? -complete=buffer -bang BufOnly
      \ :call BufOnly('<args>', '<bang>')

  " Convenient command to see the difference between the current buffer and the
  " file it was loaded from, thus the changes you made.  Only define it when not
  " defined already.
  command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis

  command! -nargs=? -complete=help Help call OpenHelpInCurrentWindow(<q-args>)

  command! CreateFoldableComment call CreateFoldableCommentFunction()

  command! Cclear cclose <Bar> call setqflist([])
  nnoremap co<bs> :Cclear<cr>


" }}}
" ============================================================================
" AUTOCMD {{{
" ============================================================================



  augroup ensure_directory_exists
    autocmd!
    autocmd BufNewFile * call s:EnsureDirectoryExists()
  augroup END

  augroup global_settings
    au!
    au VimResized * :wincmd = " resize windows when vim is resized

    " return to the same line when file is reopened
    au BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \     execute 'normal! g`"zvzz' |
          \ endif
  augroup END


  "Restore cursor, fold, and options on re-open.
  au BufWinLeave *.* mkview
  au VimEnter *.* silent loadview

  "Only restore folds and cursor position
  set viewoptions="folds,cursor"
  au FileType qf call AdjustWindowHeight(3, 10)
  function! AdjustWindowHeight(minheight, maxheight)
    let l = 1
    let n_lines = 0
    let w_width = winwidth(0)
    while l <= line('$')
      " number to float for division
      let l_len = strlen(getline(l)) + 0.0
      let line_width = l_len/w_width
      let n_lines += float2nr(ceil(line_width))
      let l += 1
    endw
    exe max([min([n_lines, a:maxheight]), a:minheight]) . "wincmd _"
  endfunction

  if has("autocmd")
    " Enable file type detection
    filetype on
    " Treat .json files as .js
    autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
    " Treat .md files as Markdown
    autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
  endif


  "Enter insert mode on switch to term and on leave leave insert mode
   " autocmd! BufWinEnter,WinEnter term://* startinsert
   " autocmd BufEnter term://* startinsert
   " autocmd TermOpen * autocmd BufEnter <buffer> call feedkeys('i')
   " autocmd! BufLeave term://* stopinsert
   " autocmd BufWinEnter term://* startinsert

" }}}
" ============================================================================
" SETTINGS {{{
" ============================================================================
  let g:python_host_prog='/usr/local/bin/python'

  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

  let mapleader = ","
  let g:mapleader = ","

  "Keep diffme function state
  let $diff_me=0

  " Specify path to your Uncrustify configuration file.
  let g:uncrustify_cfg_file_path =
        \ shellescape(fnamemodify('~/.uncrustify.cfg', ':p'))


" set background=dark
" colorscheme molokai

set background=light


colorscheme gruvbox

" Enhance command-line completion
set wildmenu
set wildmode=longest,list,full

" Types of files to ignore when autocompleting things
set wildignore+=*.o,*.class,*.git,*.svn

" Fuzzy finder: ignore stuff that can't be opened, and generated files
let g:fuzzy_ignore = "*.png;*.PNG;*.JPG;*.jpg;*.GIF;*.gif;vendor/**;coverage/**;tmp/**;rdoc/**"

set grepprg=ag\ --nogroup\ --nocolor

set formatoptions-=t                  " Stop autowrapping my code

" set ambiwidth=double                " DON'T THIS FUCKS airline

"don't autoselect first item in omnicomplete,show if only one item(for preview)
"set completeopt=longest,menuone,preview
set completeopt=noinsert,menuone,noselect

set pumheight=15                      " limit completion menu height

" When completing by tag, show the whole tag, not just the function name
set showfulltag

"**** DO NOT USE ****  RUINS arrow keys & all esc based keys
" Allow cursor keys in insert mode
"set esckeys

set nrformats-=octal

set backspace=indent,eol,start        " Allow backspace in insert mode
set gdefault                          " make g default for search
set magic                             " Magic matching

" set formatoptions+=j                  " Delete comment character when joining commented lines

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

set shell=/usr/local/bin/zsh

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

set tags=./tags,tags;$HOME            " Help vim find my tags
set backupskip=/tmp/*,/private/tmp/*  " don't back up these
set autoread                          " read files on change

set fileformats+=mac

set binary
set noeol                             " Don’t add empty newlines at file end

" set clipboard=unnamed,unnamedplus

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

"set noswapfile
"Dont warn me about swap files existence
"set shortmess+=A

" set shortmess=atI                    " Don’t show the intro message when starting Vim

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
"TODO: tpope sets smrttab
set nosmarttab

set shiftwidth=2
set shiftround                        " when at 3 spaces I hit >> go to 4 not 5

set guifont=Sauce\ Code\ Powerline\ Light:h18
set textwidth=80
set wrap                              " Wrap long lines
set breakindent                       " proper indenting for long lines

set linebreak                         "Don't linebreak in the middle of words

set printoptions=header:0,duplex:long,paper:letter

let &showbreak = '↳ '                 " add linebreak sign
set cpo=n                             " Draw color for lines that has number only
set wrapscan                          " set the search scan to wrap lines

"Allow these to move to next/prev line when at the last/first char
set whichwrap+=h,l,<,>,[,]


" Show “invisible” characters
set listchars=tab:▸\ ,extends:❯,precedes:❮,trail:.,eol:¬,nbsp:×
" set listchars=tab:▸\ ,extends:❯,precedes:❮,trail:.,eol:¬,nbsp:␣
" set listchars=tab:•·,trail:·,extends:❯,precedes:❮,nbsp:×
set list

"Set the fillchar of the inactive window to something I can see
set fillchars=stlnc:\-

" Add ignorance of whitespace to diff
set diffopt+=iwhite
syntax on
" set cursorline "Use iTerm cursorline instead
set hlsearch
set ignorecase
set smartcase
set matchtime=2                       " time in decisecons to jump back from matching bracket
set incsearch                         " Highlight dynamically as pattern is typed
set history=1000
set foldmethod=marker

" These commands open folds
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo


set nowrap

set timeout
set timeoutlen=500
"NeoVim handles ESC keys as alt+key set this to solve the problem
set ttimeout
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
set showmode                          " Show the current mode


if !&scrolloff
  set scrolloff=3                       " Keep cursor in screen by value
endif
if !&sidescrolloff
  set sidescrolloff=5
endif

"set cpoptions+=ces$                   " CW wrap W with $ instead of delete
set showmode                          " Show the current mode

set noshowcmd                           " Makes OS X slow, if lazy redraw set

set display+=lastline

set mousehide                         " Hide mouse while typing

set synmaxcol=200                     " max syntax highlight chars

set splitbelow                        " put horizontal splits below

set splitright                        " put vertical splits to the right

let g:netrw_liststyle=3               "Make netrw look like NerdTree

highlight ColorColumn ctermbg=darkblue guibg=#E1340F guifg=#111111
call matchadd('ColorColumn', '\%81v', 100)

" Use a blinking upright bar cursor in Insert mode, a solid block in normal
" and a blinking underline in replace mode
  let &t_SI = "\<Esc>[5 q"
  let &t_SR = "\<Esc>[3 q"
  let &t_EI = "\<Esc>[2 q"


" }}}
" ============================================================================
" MAPPINGS {{{
" ============================================================================


tnoremap <c-o> <c-\><c-n>

nnoremap <silent> [I :call List("i", 0, 0)<CR>
nnoremap <silent> ]I :call List("i", 0, 1)<CR>
xnoremap <silent> [I :<C-u>call List("i", 1, 0)<CR>
xnoremap <silent> ]I :<C-u>call List("i", 1, 1)<CR>
nnoremap <silent> [D :call List("d", 0, 0)<CR>
nnoremap <silent> ]D :call List("d", 0, 1)<CR>
xnoremap <silent> [D :<C-u>call List("d", 1, 0)<CR>
xnoremap <silent> ]D :<C-u>call List("d", 1, 1)<CR>

  "noremap <F4> :call DiffMe()<CR>

  nnoremap Ú<c-o> :BufOnly<cr>

  nnoremap <leader>ha :call HighlightAllOfWord(1)<cr>
  nnoremap <leader>hA :call HighlightAllOfWord(0)<cr>


  nnoremap com :call ToggleFoldMarker()<cr>

  autocmd Filetype neosnippet,cs call ToggleFoldMarker()


  nnoremap cof :call ToggleFoldMethod()<cr>



  " underline the current line with '='
  nnoremap <leader>u= :t.\|s/./=<cr>:nohls<cr>
  nnoremap <leader>u- :t.\|s/./-<cr>:nohls<cr>
  nnoremap <leader>u~ :t.\|s/./\\~<cr>:nohls<cr>

  " Underline current line "{{{
  " nnoremap <leader>- "zyy"zp<c-v>$r-
  " nnoremap <leader>= "zyy"zp<c-v>$r=
  " nnoremap <leader><leader>- o<home><ESC>120i-<ESC>
  " nnoremap <leader><leader>= o<home><ESC>120i=<ESC>
  "}}}

  nnoremap gf<C-M> :e! ++ff=dos<cr>

  " Swap two words
  nmap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>`'

  " <Leader>cd: Switch to the directory of the open buffer
  nnoremap cdf :lcd %:p:h<cr>:pwd<cr>
  nnoremap cdc :lcd <c-r>=expand("%:h")<cr>/

  "cd to the directory containing the file in the buffer
  "nnoremap <silent> <leader>cd :lcd %:h<CR>
  nnoremap gpr :lcd <c-r>=FindGitDirOrRoot()<cr><cr>
  nnoremap ycd :!mkdir -p %:p:h<CR>


  " edit in the path of current file
  nnoremap <leader>ef :e <C-R>=escape(expand('%:p:h'), ' ').'/'<CR>
  nnoremap <leader>ep :e <c-r>=escape(getcwd(), ' ').'/'<cr>

  " Edit the vimrc file
  nnoremap <silent> <leader>ev :e $MYVIMRC<CR>

  " run selected vimscript
  vnoremap <Leader>sv "vy:@v<CR>

  " run vimscript line
  nnoremap <Leader>sl "vyy:@v<CR>

  " run .vimrc
  nnoremap <silent> <leader>sv :so $MYVIMRC<CR>

  "Discard changes
  nnoremap <leader>e<bs> :e! \| echo 'changes discarded'<cr>

  "Retab file
  nnoremap <leader>er :retab<cr>

  " <c-y>f Copy the full path of the current file to the clipboard
  nnoremap <silent> <c-y>f :let @+=expand("%:p")<cr>:echo "Copied current file
        \ path '".expand("%:p")."' to clipboard"<cr>



  nmap <leader>ii :call IndentToNextBraceInLineAbove()<cr>

  nnoremap <silent> <BS> :nohlsearch \| redraw! \| diffupdate \| echo ""<cr>

  noremap <leader>ss :call StripWhitespace()<CR>

  nnoremap <Leader>rn :call RenameFile()<cr>

  "save as root
  noremap <leader>W :w !sudo tee % > /dev/null<CR>
  "cnoremap sw! w !sudo tee % >/dev/null

  " Shrink the current window to fit the number of lines in the buffer.  Useful
  " for those buffers that are only a few lines
  nmap <silent> <leader>sw :execute ":resize " . line('$')<cr>

  nnoremap <F12> :call ToggleMouseFunction()<cr>

  nmap <silent> j gj
  nmap <silent> k gk

  "Make completion more comfortable
  inoremap <c-j> <c-n>
  inoremap <c-k> <c-p>

  inoremap <C-U> <C-G>u<C-U>

  "TODO: conflicts with script-ease
  command! SplitLine :normal i<CR><ESC>,ss<cr>
  nnoremap K :call Preserve('SplitLine')<cr>


  " { and } skip over closed folds
  nnoremap <expr> } foldclosed(search('^$', 'Wn')) == -1 ? "}" : "}j}"
  nnoremap <expr> { foldclosed(search('^$', 'Wnb')) == -1 ? "{" : "{k{"

  vmap > >gv
  vmap < <gv

  nnoremap ; :
  nnoremap : ;

  vnoremap ; :
  vnoremap : ;

  noremap H ^
  noremap L $
  vnoremap L g_

  onoremap H ^
  onoremap L $

  if !exists('$TMUX')
    nnoremap <silent> <c-h> <c-w><c-h>
    nnoremap <silent> <c-j> <c-w><c-j>
    nnoremap <silent> <c-k> <c-w><c-k>
    nnoremap <silent> <c-l> <c-w><c-l>
  endif

  " select last matched item
  nnoremap <leader>/ //e<Enter>v??<Enter>

  " <Leader>``: Force quit all
  nnoremap <Leader>`` :qa!<cr>

  " Edit todo list for project
  nmap ,todo :e todo.txt<cr>

  " Laravel framework commons
  nnoremap Úlv :e ./resources/views/<cr>
  nnoremap Úlc :e ./resources/views/partials/<cr>
  nnoremap Úlp :e ./public/<cr>


  "uppercase from insert mode while you are at the end of a word
  inoremap <C-u> <esc>mzgUiw`za

  "center screen cursor
  nnoremap z<Space> zMzv

  " <Leader>sm: Maximize current split
  nnoremap <Leader>sm <C-w>_<C-w><Bar>


  "Clear the search highlight except when I move
  autocmd! cursorhold * set nohlsearch
  autocmd! cursormoved * set hlsearch


  " Move visual block
  vnoremap <c-j> :m '>+1<CR>gv=gv
  vnoremap <c-k> :m '<-2<CR>gv=gv

  " Select last pasted text
  nnoremap gb `[v`]
  nnoremap <expr> g<c-v> '`[' . strpart(getregtype(), 0, 1) . '`]'

  "Reselect the text you just entered
  nnoremap gV `[v`]

  " Highlight TODO markers
  match todo '\v^(\<|\=|\>){7}([^=].+)?$'
  match todo '\v^(\<|\=|\>){7}([^=].+)?$'

  " Jump to next/previous merge conflict marker
  " nnoremap <silent> ]m /\v^(\<\|\=\|\>){7}([^=].+)?$<CR>
  " nnoremap <silent> [m ?\v^(\<\|\=\|\>){7}([^=].+)\?$<CR>

  "Put an empty line before and after this line : depends on PLUGIN
  nnoremap \\<Space> :normal [ ] <cr>

  "Open current directory in Finder
  nnoremap <leader><cr> :silent !open .<cr>

  "Go to alternate file
  nnoremap go <C-^>

  "Open/Close commands
  "======================
  nnoremap  coq :QFix<cr>
  command! QFix call QFixToggle()
  function! QFixToggle()
    for i in range(1, winnr('$'))
      let bnum = winbufnr(i)
      if getbufvar(bnum, '&buftype') == 'quickfix'
        cclose
        return
      endif
    endfor
    copen
  endfunction


  "Buffer deletion commands
  "===========================
  nnoremap  Úwa :bufdo execute ":bw"<cr>
  nnoremap  ÚÚwa :bufdo execute ":bw!"<cr>

  nnoremap  Úww :bw<cr>
  nnoremap  ÚÚww :bw!<cr>

  "Remove ^M from a file
  nnoremap  <leader>e^ :e ++ff=dos

  "Execute java using ,j
  nnoremap  <leader>ej : exe "!cd " . shellescape(expand("%:h")) . " && javac " . expand ("%:t") . " && java " . expand("%:t:r")<cr>

  "===============================================================================
  " Command-line Mode Key Mappings
  "===============================================================================

  cnoremap <c-a> <home>
  cnoremap <c-e> <end>

  cnoremap <c-j> <down>
  cnoremap <c-k> <up>

  cnoremap <c-h> <left>
  cnoremap <c-l> <right>

  cnoremap <c-g>pp <C-\>egetcwd()<CR>
  cnoremap <c-g>pf <C-r>=expand("%")<CR>

  " Ctrl-Space: Show history


  " Ctrl-v: Paste
  "cnoremap <c-v> <c-r>"

  nnoremap z0 :set foldlevel=0<cr>
  nnoremap z1 :set foldlevel=1<cr>
  nnoremap z2 :set foldlevel=2<cr>
  nnoremap z3 :set foldlevel=3<cr>
  nnoremap z4 :set foldlevel=4<cr>
  nnoremap z5 :set foldlevel=5<cr>
  nnoremap z6 :set foldlevel=6<cr>
  nnoremap z7 :set foldlevel=7<cr>
  nnoremap z8 :set foldlevel=8<cr>
  nnoremap z9 :set foldlevel=9<cr>


" }}}
" ============================================================================
" COLORS {{{
" ============================================================================



  " vim-buftabline support
  hi! SLIdentifier guibg=#151515 guifg=#ffb700 gui=bold cterm=bold ctermbg=233i ctermfg=214
  hi! SLCharacter guibg=#151515 guifg=#e6db74 ctermbg=233 ctermfg=227
  hi! SLType guibg=#151515 guifg=#66d9ae gui=bold cterm=bold ctermbg=233 ctermfg=81
  hi! link BufTabLineFill StatusLine
  hi! link BufTabLineCurrent SLIdentifier
  hi! link BufTabLineActive SLCharacter
  hi! link BufTabLineHidden SLType


  let g:terminal_color_0  = '#2e3436'
  let g:terminal_color_1  = '#cc0000'
  let g:terminal_color_2  = '#4e9a06'
  let g:terminal_color_3  = '#c4a000'
  let g:terminal_color_4  = '#3465a4'
  let g:terminal_color_5  = '#75507b'
  let g:terminal_color_6  = '#0b939b'
  let g:terminal_color_7  = '#d3d7cf'
  let g:terminal_color_8  = '#555753'
  let g:terminal_color_9  = '#ef2929'
  let g:terminal_color_10 = '#8ae234'
  let g:terminal_color_11 = '#fce94f'
  let g:terminal_color_12 = '#729fcf'
  let g:terminal_color_13 = '#ad7fa8'
  let g:terminal_color_14 = '#00f5e9'
  let g:terminal_color_15 = '#eeeeec'

  "Make the bright gray font black in terminal
  let g:terminal_color_7  = '#555042'


  "Multiedit highlight colors
  "This makes it faster too!
  hi! MultieditRegions guibg=#AF1469
  hi! MultieditFirstRegion guibg=#ED3F6C

" }}}
" ============================================================================


"{{{ Align_operator
  call operator#user#define('align-left', 'Op_command', 'call Set_op_command("left")')
  call operator#user#define('align-right', 'Op_command', 'call Set_op_command("right")')
  call operator#user#define('align-center', 'Op_command', 'call Set_op_command("center")')

  let s:op_command_command = ''

  function! Set_op_command(command)
    let s:op_command_command = a:command
  endfunction

  function! Op_command(motion_wiseness)
    execute "'[,']" s:op_command_command
  endfunction
"}}} _Align


"{{{ Binding Overrides

  "Force multiedit key bindings and make it faster :)
  call BindMultieditKeys()

"}}} _Binding Overrides


function! SetProjectPath()
  lcd ~/Development/Projects/Dwarozh/App/
  cd ~/Development/Projects/Dwarozh/App/
  pwd
endfunction

nnoremap <silent> <c-p><c-\> :call SetProjectPath()<cr>
