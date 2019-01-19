let PMN = 'Dein'

"BlackList {{{
let s:PM_BL = [
\'lldb.nvim',
\'ncm2',
\'phpcd.vim',
\'vim-which-key',
\'deoplete.nvim'
\ ]
"}}}}
"WhiteList {{{
let s:PM_WL = [
      \ ]
"}}}}
  "Dein {{{
  if(PMN == 'Dein')
    "Clean unused plugins UNINSTALL
    "call map(dein#check_clean(), "delete(v:val, 'rf')")

    "dein Scripts-----------------------------
    if &compatible
      set nocompatible               " Be iMproved
    endif

    "Dein be quiet ;)
    "let g:dein#install_progress_type="none"
    "let g:dein#install_message_type="none"
    let g:dein#install_process_timeout=50000

    "Let Notifier notify me of anything
    let g:dein#enable_notification=1

    " Required:
    set runtimepath^=~/.config/nvim/dein/repos/github.com/Shougo/dein.vim

    " Required:
    call dein#begin(expand('~/.config/nvim/dein'))

    " Let dein manage dein
    " Required:
    call dein#add('Shougo/dein.vim')

    "This is same as calling dein
    function! PM ( plugin, ...) "{{{
      "Use this to not cause recache: You can have disarmed list
      "let list=['02', '03', '03', '16', '17', '17', '28', '29', '29']
      "let unduplist=filter(copy(list), 'index(list, v:val, v:key+1)==-1')

      let debug = 0   " to show debugging of on_commands
      let merged = 0  " to debug without recache
      let options = {}
      if len(a:000) > 0
          let options = a:1

          if debug && has_key(options, 'on_cmd')
              echom string(options['on_cmd'])
          endif

          " force some plugins to force merge themselves
          " unless we are debuggin
          if ! debug && has_key(options, 'merged') && options.merged == 1
              let merged = 1
          endif
      endif

      " let options.merged = merged

      if !PM_ISS(a:plugin) | return 0 | endif

      call dein#add( a:plugin, options )

      return 1
    endfunction "}}}

  endif
  "}}} _Dein
  "Plug {{{
  if(PMN=='Plug')
    " Extend the length of the timeout for vim-plug
    let g:plug_timeout=60

    call plug#begin('~/.config/nvim/plugged')
    let g:DeinToVimPlug = {'build':'do', 'rev': 'branch', 'on_ft':'for', 'on_cmd':'on','on_map':'on'}

    "This is same as calling Plug command
    function! PM ( plugin, ...) "{{{
      if !PM_ISS(a:plugin) | return 0 | endif
      " if dir not set use a custom dir pointing to dein path
      " build  => do
      " on_ft  => for
      " on_cmd => on
      " on_map => on
      let options = {}
      if len(a:000) > 0
        "Copy relevant values from passed args to options, changing option name|key.  
        for [key, value] in items(g:DeinToVimPlug)
          if has_key(a:1, key)
            let options.key = value
          endif
        endfor
        "Use dein dir for the plugins
        "let options.dir = '~/.config/nvim/dein/repos/github.com/' . strpart(a:plugin, 0, stridx(a:plugin, '/'))
        Plug a:plugin, options
      else
        Plug a:plugin
      endif
      return 1
    endfunction "}}}
  endif

  "}}} _Plug
  function! PM_SOURCE(plugin) "{{{
    if s:PMN == 'Dein'
      call dein#source(a:plugin)
    else
      call plug#load(a:plugin)
    endif
  endfunction "}}}
  function! PM_ISS(plugin) "{{{
    if len(s:PM_WL) > 0
      " PlugIn is NOT white listed, don not load
      if index(s:PM_WL, strpart(a:plugin, stridx(a:plugin, '/')+1)) < 0
        return 0
      endif
    else
      " PlugIn is black listed, don not load
      if index(s:PM_BL, strpart(a:plugin, stridx(a:plugin, '/')+1)) >= 0
        return 0
      endif
    endif
    return 1
  endfunction "}}}
  function! PM_END() "{{{
    if s:PMN=='Dein'
      call dein#end()
      " If you want to install not installed plugins on startup.
      "if dein#check_install()
      "  call dein#install()
      "endif
    endif

    if s:PMN=='Plug'
      call plug#end()
    endif

    filetype plugin indent on
  endfunction "}}}
  "Link plugin manager {{{
"let PM=function(PMN)
"let s:PM=PM
let s:PMN = PMN
"}}}

