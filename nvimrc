let g:python_host_prog='/usr/local/bin/python'

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

let mapleader = ","
let g:mapleader = ","

"{{{ PlugIns

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

"{{{ NerdTree
  "Disable Netrw
  let g:loaded_netrw       = 1
  let g:loaded_netrwPlugin = 1

  Plug 'scrooloose/nerdtree' ", { 'on':  'NERDTreeToggle' }

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

"}}} _NerdTree

"{{{  fzf

  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install'}

"}}} _fzf

"{{{ CtrlP

  Plug 'kien/ctrlp.vim'
  Plug 'sgur/ctrlp-extensions.vim'
  Plug 'fisadev/vim-ctrlp-cmdpalette'

  Plug 'ivalkeen/vim-ctrlp-tjump'

  Plug 'suy/vim-ctrlp-commandline'
  command! CtrlPCommandLine call ctrlp#init(ctrlp#commandline#id())
  cnoremap <silent> <C-p> <C-c>:call ctrlp#init(ctrlp#commandline#id())<CR>

  Plug 'FelikZ/ctrlp-py-matcher'
  Plug 'tacahiroy/ctrlp-funky'

  Plug 'JazzCore/ctrlp-cmatcher'


  "Locate my notes
  Plug '/Volumes/Home/.nvim/plugged/ctrlp-my-notes'

  "My dash helper plugin
  Plug '/Volumes/Home/.nvim/plugged/ctrlp-dash-helper'

 "'vim-ctrlp-tjump',
  let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript','dashhelper', 'vimnotes',
                          \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir', 'funky', 'commandline']


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
  "let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
  let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }

"}}} _CtrlP

"{{{ ambi-cmd

  Plug 'thinca/vim-ambicmd'
  cnoremap <expr> <Space> ambicmd#expand("\<Space>")
  cnoremap <expr> <CR>    ambicmd#expand("\<CR>")

"}}} _ambi-cmd

"{{{  clever-f.vim

  Plug 'rhysd/clever-f.vim'
  nmap ,rf <Plug>(clever-f-reset)
  vmap ,rf <Plug>(clever-f-reset)

"}}} _clever-f.vim

"{{{  zoomwintab.vim

  let g:zoomwintab_remap = 0
  Plug 'troydm/zoomwintab.vim'
  " zoom with <META-O> in any mode
  nnoremap <silent> <a-o> :ZoomWinTabToggle<cr>
  inoremap <silent> <a-o> <c-\><c-n>:ZoomWinTabToggle<cr>a
  vnoremap <silent> <a-o> <c-\><c-n>:ZoomWinTabToggle<cr>gv

"}}} _zoomwintab.vim

"{{{  vim-submode

  Plug 'kana/vim-submode'

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
"}}} _vim-submode

"{{{  lightline.vim

  Plug 'itchyny/lightline.vim'

  let g:lightline = {
     \ 'colorscheme': 'powerline',
     \ 'component': {
     \   'readonly': '%{&readonly?"x":""}',
     \ },
     \ 'separator': { 'left': '', 'right': '' },
     \ 'subseparator': { 'left': '|', 'right': '|' }
     \ }
"}}} _lightline.vim

"{{{ emmet-vim

Plug 'mattn/emmet-vim', {'for':['html','xml','xsl','xslt','xsd','css','sass','scss','less','mustache']}

"}}} _emmet-vim

"{{{ vim-easymotion

Plug 'Lokaltog/vim-easymotion', {'on': ['<Plug>(easymotion-']}
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

"}}} _vim-easymotion

"{{{ vim-trailing-whitespace
Plug 'bronson/vim-trailing-whitespace'
  let g:extra_whitespace_ignored_filetypes = ['unite', 'mkd']
"}}} _vim-trailing-whitespace

"{{{ vim-over

Plug 'osyo-manga/vim-over', {'on': ['OverCommandLine']}
  nmap <leader>/ :OverCommandLine<cr>
  nnoremap g;s :<c-u>OverCommandLine<cr>%s/
  xnoremap g;s :<c-u>OverCommandLine<cr>%s/\%V

"}}} _vim-over

"{{{ Ultisnips
Plug 'SirVer/ultisnips'
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

"}}} _Ultisnips

"{{{ xptemplate

Plug 'drmingdrmer/xptemplate'
  " Add xptemplate global personal directory value
  if has("unix")
    set runtimepath+=/Volumes/Home/.nvim/xpt-personal
  endif
  "let g:xptemplate_nav_next = '<C-j>'
  "let g:xptemplate_nav_prev = '<C-k>'

"}}} _xptemplate

"{{{ YouCompleteMe

Plug 'Valloric/YouCompleteMe'
  " make YCM compatible with UltiSnips (using supertab)
  let g:ycm_key_list_select_completion = ['<C-j>', '<Down>']
  let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']
  let g:SuperTabDefaultCompletionType = '<C-n>'

"}}} _YouCompleteMe

"{{{ tabular
Plug 'godlygeek/tabular', {'on':'Tabularize'}
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
"}}} _tabular

"{{{ ag.vim

Plug 'rking/ag.vim', {'on': 'Ag'}
  "Disable the msg showing shortcuts after each search
  let g:ag_mapping_message=0

"}}} _ag.vim

"{{{  vim-surround



  Plug 't9md/vim-surround_custom_mapping'
  Plug 'tpope/vim-surround', {
        \   'on' :[
        \      '<Plug>Dsurround' , '<Plug>Csurround',
        \      '<Plug>Ysurround' , '<Plug>YSurround',
        \      '<Plug>Yssurround', '<Plug>YSsurround',
        \      '<Plug>YSsurround', '<Plug>VgSurround',
        \      '<Plug>VSurround' , '<Plug>ISurround'
        \ ]}

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


"}}} _vim-surround

"{{{ indexedsearch

  "Show the seach match index  eg: showing 1st mach out of 10

  Plug 'khalidchawtany/IndexedSearch', {'autoload': {'mappings':['<Plug>(ShowSearchIndex_']}}


  let g:IndexedSearch_SaneRegEx = 1
  let g:IndexedSearch_AutoCenter = 1
  let g:IndexedSearch_No_Default_Mappings = 1

  nmap <silent>n <Plug>(ShowSearchIndex_n)zv
  nmap <silent>N <Plug>(ShowSearchIndex_N)zv
  nmap <silent>* <Plug>(ShowSearchIndex_Star)zv
  nmap <silent># <Plug>(ShowSearchIndex_Pound)zv

  nmap / <Plug>(ShowSearchIndex_Forward)
  nmap ? <Plug>(ShowSearchIndex_Backward)

"}}} _indexedsearch

  "{{{ searchfold.vim foldsearch vim-foldfocus foldsearches.vim

  " Search and THEN Fold the search term containig lines using <leader>z
  " or the the inverse using <leader>iz or restore original fold using <leader>Z

  Plug 'khalidchawtany/searchfold.vim' , {'autoload': {'mappings': ['<Plug>SearchFoldNormal']}}
  nmap <leader>z <Plug>SearchFoldNormal

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
  Plug 'vasconcelloslf/vim-foldfocus'
  Plug '/Volumes/Home/.nvim/plugged/foldsearches.vim'

  "}}} _searchfold.vim foldsearch vim-foldfocus foldsearches.vim

"{{{ vim-css-color

  Plug 'ap/vim-css-color', {'for':['css','scss','sass','less','styl']}

"}}} _vim-css-color

"{{{ SplitJoin.vim
  Plug 'AndrewRadev/splitjoin.vim', { 'autoload' : {
            \ 'mappings' : ['gS', 'gJ']
            \ }}
"}}} _SplitJoin.vim


"Single Line Plugs
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'airblade/vim-gitgutter'
Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdcommenter'       ",cc ,cs
Plug 'terryma/vim-multiple-cursors'
"Plug 'tomtom/tcomment_vim'

"ColorScheme
Plug 'tomasr/molokai'
Plug 'altercation/vim-colors-solarized'

call plug#end()

"}}} _PlugIns


"{{{ Functions
  function! CreateFoldableCommentFunction()
    normal 0f/lyt'02[ 2] 2ki"{{{ lp2j0>>2ji"}}} _p04kf}x4jzaj
  endfunction

  function! HighlightAllOfWord(onoff)
    if a:onoff == 1
      :augroup highlight_all
      :au!
      :au CursorMoved * silent! exe printf('match Search /\<%s\>/', expand('<cword>'))
      :augroup END
    else
      :au! highlight_all
      match none /\<%s\>/
    endif
  endfunction

  nnoremap ,ha :call HighlightAllOfWord(1)<cr>
  nnoremap ,hA :call HighlightAllOfWord(0)<cr>

  function ToggleMouseFunction()
    if  &mouse=='a'
      set mouse=
      echo "Shell has it"
    else
      set mouse=a
      echo "Vim has it"
    endif
  endfunction

  " Strip trailing whitespace (,ss)
  function! StripWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
  endfunction

  function! FindGitDirOrRoot()
    let curdir = expand('%:p:h')
    let gitdir = finddir('.git', curdir . ';')
    if gitdir != ''
      return substitute(gitdir, '\/\.git$', '', '')
    else
      return '/'
    endif
  endfunction

  function! IndentToNextBraceInLineAbove()
    :normal 0wk
    :normal "vyf(
    let @v = substitute(@v, '.', ' ', 'g')
    :normal j"vPl
  endfunction

  " This is an updated, more powerful, version of the function discussed here:
  " http://www.reddit.com/r/vim/comments/1rzvsm/do_any_of_you_redirect_results_of_i_to_the/
  " that shows ]I, [I, ]D, [D, :ilist and :dlist results in the quickfix window, even spanning multiple files.

  function! List(command, selection, start_at_cursor, ...)
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
  endfunction

  nnoremap <silent> [I :call List("i", 0, 0)<CR>
  nnoremap <silent> ]I :call List("i", 0, 1)<CR>
  xnoremap <silent> [I :<C-u>call List("i", 1, 0)<CR>
  xnoremap <silent> ]I :<C-u>call List("i", 1, 1)<CR>

  command! -nargs=1 Ilist call List("i", 1, 0, <f-args>)

  nnoremap <silent> [D :call List("d", 0, 0)<CR>
  nnoremap <silent> ]D :call List("d", 0, 1)<CR>
  xnoremap <silent> [D :<C-u>call List("d", 1, 0)<CR>
  xnoremap <silent> ]D :<C-u>call List("d", 1, 1)<CR>

  command! -nargs=1 Dlist call List("d", 1, 0, <f-args>)

  " Restore cursor position, window position, and last search after running a
  " command.
  " from: http://stackoverflow.com/questions/12374200/using-uncrustify-with-vim
  function! Preserve(command)
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
  endfunction

  " Specify path to your Uncrustify configuration file.
  let g:uncrustify_cfg_file_path =
        \ shellescape(fnamemodify('~/.uncrustify.cfg', ':p'))

  " Don't forget to add Uncrustify executable to $PATH (on Unix) or
  " %PATH% (on Windows) for this command to work.
  function! Uncrustify(language)
    call Preserve(':silent %!uncrustify'
          \ . ' -q '
          \ . ' -l ' . a:language
          \ . ' -c ' . g:uncrustify_cfg_file_path)
  endfunction

  function! OpenHelpInCurrentWindow(topic)
    view $VIMRUNTIME/doc/help.txt
    setl filetype=help
    setl buftype=help
    setl nomodifiable
    exe 'keepjumps help ' . a:topic
  endfunction

  " ScratchPad {{{
  augroup scratchpad
    au!
    au BufNewFile,BufRead .scratchpads/scratchpad.* call ScratchPadLoad()
  augroup END

  function! ScratchPadSave()
    let ftype = matchstr(expand('%'), 'scratchpad\.\zs\(.\+\)$')
    if ftype == ''
      return
    endif
    write
  endfunction

  function! ScratchPadLoad()
    nnoremap <silent> <buffer> q :w<cr>:close<cr>
    setlocal bufhidden=hide buflisted noswapfile
  endfunction

  function! OpenScratchPad(ftype)
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
  endfunction
  " }}}

  function! GetVisualSelection()
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][: col2 - 2]
    let lines[0] = lines[0][col1 - 1:]
    return join(lines, "\n")
  endfunction

  " Merge a tab into a split in the previous window
  function! MergeTabs()
    if tabpagenr() == 1
      return
    endif
    let bufferName = bufname("%")
    if tabpagenr("$") == tabpagenr()
      close!
    else
      close!
      tabprev
    endif
    split
    execute "buffer " . bufferName
  endfunction

  function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
      exec ':saveas ' . new_name
      exec ':silent !rm ' . old_name
      redraw!
    endif
  endfunction

  "Find references of this function (function calls)
  function! SearchForCallSitesCursor()
    let searchTerm = expand("<cword>")
    call SearchForCallSites(searchTerm)
  endfunction

  " Search for call sites for term (excluding its definition) and
  " load into the quickfix list.
  function! SearchForCallSites(term)
    cexpr system('ag ' . shellescape(a:term) . '\| grep -v def')
  endfunction


  augroup ensure_directory_exists
    autocmd!
    autocmd BufNewFile * call s:EnsureDirectoryExists()
  augroup END

  function! s:EnsureDirectoryExists()
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
  endfunction


  " Press F4 to toggle the diff of currently open buffers/splits.
  "noremap <F4> :call DiffMe()<CR>
  command! DiffSplits :call DiffMe()<cr>
  let $diff_me=0
  function! DiffMe()
    windo diffthis
    if $diff_me>0
      let $diff_me=0
    else
      windo diffoff
      let $diff_me=1
    endif
  endfunction

  "Get relative path to this file
  fu! RelativePathString(file)
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
  endf

  ":Reg Shows and prompts to select from a reg
  function! Reg()
    reg
    echo "Register: "
    let char = nr2char(getchar())
    if char != "\<Esc>"
      execute "normal! \"".char."p"
    endif
    redraw
  endfunction

  command! -nargs=0 Reg call Reg()

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


" BufOnly.vim  -  Delete all the buffers except the current/named buffer.
" Copyright November 2003 by Christian J. Robinson <infynity@onewest.net>
" Distributed under the terms of the Vim license.  See ":help license".
" Usage:
" :Bonly / :BOnly / :Bufonly / :BufOnly [buffer]
" Without any arguments the current buffer is kept.  With an argument the
" buffer name/number supplied is kept.

command! -nargs=? -complete=buffer -bang BufOnly
    \ :call BufOnly('<args>', '<bang>')
nnoremap Ú<c-o> :BufOnly<cr>
function! BufOnly(buffer, bang)
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

endfunction
  "}}} _Functions


  "{{{ AutoCommands


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

  "}}} _Autocommands


  "{{{ Commands

  " Convenient command to see the difference between the current buffer and the
  " file it was loaded from, thus the changes you made.  Only define it when not
  " defined already.
  command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis

  command! -nargs=? -complete=help Help call OpenHelpInCurrentWindow(<q-args>)

  command! CreateFoldableComment call CreateFoldableCommentFunction()

  "}}} _Commands


"{{{ Global Config

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

set formatoptions-=t                  " Stop autowrapping my code

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

set shell=/usr/local/bin/zsh

set tags=./tags,tags;$HOME            " Help vim find my tags
set backupskip=/tmp/*,/private/tmp/*  " don't back up these
set autoread                          " read files on change

set binary
set noeol                             " Don’t add empty newlines at file end

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

let &showbreak = '↳ '                 " add linebreak sign
set cpo=n                             " Draw color for lines that has number only
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


"}}} _Global Config


"{{{ Key Binding

  " Edit the vimrc file
  nnoremap <silent> ,ev :e $MYVIMRC<CR>
  nnoremap <silent> ,sv :so $MYVIMRC<CR>


  nnoremap cof :call ToggleFoldMethod()<cr>

  function! ToggleFoldMethod()
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
  endfunction


  " Underline the current line with '='
  nnoremap ,u= :t.\|s/./=<cr>:nohls<cr>
  nnoremap ,u- :t.\|s/./-<cr>:nohls<cr>
  nnoremap ,u~ :t.\|s/./\\~<cr>:nohls<cr>

  " Swap two words
  nmap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>`'

  " <Leader>cd: Switch to the directory of the open buffer
  nnoremap cdc :lcd %:p:h<cr>:pwd<cr>

  " cd to the directory containing the file in the buffer
  "nnoremap <silent> ,cd :lcd %:h<CR>
  nnoremap cdr :lcd <c-r>=FindGitDirOrRoot()<cr><cr>
  nnoremap ycd :!mkdir -p %:p:h<CR>

  "Discard changes
  nnoremap dc :e!<cr>:echo '...'<cr>

  nmap <silent> ,ii :call IndentToNextBraceInLineAbove()<cr>

  "nnoremap <silent> <BS> :AirlineRefresh<cr>:redraw!<cr>:nohlsearch<cr>:sleep 250m<cr>:echo""<cr>
  "nnoremap <silent> <BS> :AirlineRefresh<cr>:nohlsearch<cr>:redraw<cr>:echo ""<cr>
  nnoremap <silent> <BS> :nohlsearch<cr>:redraw<cr>:echo ""<cr>

  noremap <leader>ss :call StripWhitespace()<CR>

  nnoremap <Leader>rn :call RenameFile()<cr>

  nmap <C-W>u :call MergeTabs()<CR>

  " Save a file as root (,W)
  noremap <leader>W :w !sudo tee % > /dev/null<CR>
  "cnoremap sw! w !sudo tee % >/dev/null

  " Shrink the current window to fit the number of lines in the buffer.  Useful
  " for those buffers that are only a few lines
  nmap <silent> ,sw :execute ":resize " . line('$')<cr>

  nnoremap <F12> :call ToggleMouseFunction()<cr>

  nmap j gj
  nmap k gk

  command! SplitLine :normal i<CR><ESC>,ss<cr>
  nnoremap K :call Preserve('SplitLine')<cr>

  "nnoremap K i<CR><Esc>^mwgk:silent! s/\v +$//<CR>:noh<CR>

  " { and } skip over closed folds
  nnoremap <expr> } foldclosed(search('^$', 'Wn')) == -1 ? "}" : "}j}"
  nnoremap <expr> { foldclosed(search('^$', 'Wnb')) == -1 ? "{" : "{k{"

  vmap > >gv
  vmap < <gv


  ".nvimrcUse 5j instead of jjjjj
  "nnoremap jjj :<C-u>echo 'Use nj!   :)    :)   :)   :)   :)   :)   :)  :)'<CR>
  "nnoremap kkk :<C-u>echo 'Use nk!   :)    :)   :)   :)   :)   :)   :)  :)'<CR>

  nnoremap ; :
  nnoremap : ;

  " Disable in favor of searchindex
  " Keep search matches in the middle of the window.
  "nnoremap n nzzzv
  "nnoremap N Nzzzv
  "nnoremap / /\\v
  "vnoremap / /\\v

  noremap H ^
  noremap L $
  vnoremap L g_

  " make it do . in visual mode
  vnoremap . :norm.<CR>

  "swap visual mode and visual block mode
  " nnoremap    v   <C-V>
  " nnoremap <C-V>     v

  " vnoremap    v   <C-V>
  " vnoremap <C-V>     v

  " select last matched item
  nnoremap <leader>/ //e<Enter>v??<Enter>

  " <Leader>``: Force quit all
  nnoremap <Leader>`` :qa!<cr>

  " <Leader>p: Copy the full path of the current file to the clipboard
  nnoremap <silent> <Leader>p :let @+=expand("%:p")<cr>:echo "Copied current file
        \ path '".expand("%:p")."' to clipboard"<cr>

  " edit in the path of current file
  nnoremap <leader>ew :e <C-R>=escape(expand('%:p:h'), ' ').'/'<CR>

  function! ExecuteLaravelGeneratorCMD()
    let cmd = CreateLaravelGeneratorFunction()
    call VimuxRunCommand(cmd)
    call VimuxZoomRunner()
  endfunction

  nnoremap ; :call ExecuteLaravelGeneratorCMD()<cr>

  "nnoremap ;  :<C-R>=CreateLaravelGeneratorFunction()<CR>
  "nnoremap ; :call VimuxSlime('"' . CreateLaravelGeneratorFunction() '"')<cr>
  "nnoremap ; :call VimuxRunCommand(CreateLaravelGeneratorFunction())<cr>

  " bind K to grep word under cursor
  "nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR><CR>

  " Uppercase word mapping.
  "
  " This mapping allows you to press <c-u> in insert mode to convert the current
  " word to uppercase.  It's handy when you're writing names of constants and
  " don't want to use Capslock.
  "
  " To use it you type the name of the constant in lowercase.  While your
  " cursor is at the end of the word, press <c-u> to uppercase it, and then
  " continue happily on your way:
  inoremap <C-u> <esc>mzgUiw`za

  nnoremap z<Space> zMzv

  "Create commented fold marker
  nnoremap <silent> <leader>c<space> :CreateFoldableComment<cr>

  " <Leader>sm: Maximize current split
  nnoremap <Leader>sm <C-w>_<C-w><Bar>

  " <Leader>,: Switch to previous split
  nnoremap <Leader>. <C-w>p
  nnoremap <Leader>sp <C-w>p

  "Clear the search highlight except when I move
  "autocmd! cursorhold * set nohlsearch
  "autocmd! cursormoved * set hlsearch

  "In normal mode move with hjkl
  "inoremap ▽ j
  "inoremap △ k
  "inoremap ◁ h
  "inoremap ▷ l

  inoremap ▽ <down>
  inoremap △ <up>
  inoremap ◁ <left>
  inoremap ▷ <right>

  " Move visual block
  vnoremap <c-j> :m '>+1<CR>gv=gv
  vnoremap <c-k> :m '<-2<CR>gv=gv

  " Select last pasted text
  nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '``]`'

  " Highlight merge conflict markers
  match Todo '\v^(\<|\=|\>){7}([^=].+)?$'

  " Jump to next/previous merge conflict marker
  nnoremap <silent> ]m /\v^(\<\|\=\|\>){7}([^=].+)?$<CR>
  nnoremap <silent> [m ?\v^(\<\|\=\|\>){7}([^=].+)\?$<CR>


  nnoremap <c-p>j :CtrlPtjump<cr>
  vnoremap <c-p>j :CtrlPtjumpVisual<cr>
  nnoremap <c-p>b :CtrlPBuffer<cr>
  nnoremap <c-p>F :CtrlP .<cr>
  nnoremap <c-p>d :CtrlPDir .<cr>
  nnoremap <c-p><c-d> :CtrlPDir<cr>
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
  nnoremap <c-p>\\ :CtrlPRTS<cr>
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
  nnoremap <c-p><c-o> :CtrlPMRU<cr>


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



  "Reselect the text you just entered
  nnoremap gV `[v`]

  "Put an empty line before and after this line : depends on PLUGIN
  nnoremap \\<Space> :normal [ ] <cr>

  "Open current directory in Finder
  nnoremap <leader><cr> :silent !open .<cr>

  "Go to alternate file
  nnoremap ÚÚ <C-^>

  "NERDTree commands
  "=======================
  nnoremap Ú<c-l> :NERDTreeTabsToggle<cr>
  nnoremap Úl :NERDTreeFind<cr>

  "Open notes text file
  "=======================
  "First add a ctrlp extensionto do this
  "nnoremap <silent> Ún  :e ~/.vim/notes


  "Open/Close commands
  "======================
  nnoremap  Úqw :close<cr>
  nnoremap  Úqq :cclose<cr>
  nnoremap  Úql :lclose<cr>

  nnoremap  Úoq :copen<cr>
  nnoremap  Úol :lopen<cr>

  nnoremap  coq :QFix<cr>

  command! -bang -nargs=? QFix call QFixToggle(<bang>0)
  function! QFixToggle(forced)
    if exists("g:qfix_win") && a:forced == 0
      cclose
      unlet g:qfix_win
    else
      copen 10
      let g:qfix_win = bufnr("$")
    endif
  endfunction

  "Buffer deletion commands
  "===========================
  nnoremap  Úwa :bufdo execute ":bw"<cr>
  nnoremap  ÚÚwa :bufdo execute ":bw!"<cr>

  nnoremap  Úww :bw<cr>
  nnoremap  ÚÚww :bw!<cr>

  "===============================================================================
  " Command-line Mode Key Mappings
  "===============================================================================

  " Bash like keys for the command line. These resemble personal zsh mappings
  cnoremap <c-a> <home>
  cnoremap <c-e> <end>

  " Ctrl-[hl]: Move left/right by word
  cnoremap <c-h> <s-left>
  cnoremap <c-l> <s-right>

  " Ctrl-Space: Show history
  cnoremap <c-@> <c-f>

  cnoremap <c-j> <down>
  cnoremap <c-k> <up>
  cnoremap <c-f> <left>
  cnoremap <c-g> <right>

  noremap glp <C-^>

  " Ctrl-v: Paste
  "cnoremap <c-v> <c-r>"


"}}} _Key Bindings