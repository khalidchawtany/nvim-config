" ============================================================================
" INIT {{{
" ============================================================================
"Prevent neovim-dot-app to source me twice {{{
if exists('neovim_dot_app')
  if exists('g:VIMRC_SOURCED')
    finish
  endif
  let g:VIMRC_SOURCED=1
endif
"}}}

let g:python_host_prog='/usr/local/bin/python'
let g:python3_host_prog='/usr/local/bin/python3'
let g:python_host_skip_check = 1
let g:python3_host_skip_check = 1

set termguicolors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
" Leader Keys {{{
  let mapleader = "\<space>"
  let g:mapleader = "\<space>"
  let localleader = "\\"
  let g:loaclleader = "\\"
"}}}
"}}} _INIT
" ============================================================================
" FUNCTIONS {{{
" ============================================================================

function! s:CleanEmptyBuffers() "{{{
  let buffers = filter(range(0, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0')
  if !empty(buffers)
    exe 'bw '.join(buffers, ' ')
  endif
endfunction
command! Cls <SID>CleanEmptyBuffers()
nnoremap <c-w>e <SID>CleanEmptyBuffers()
"}}}


function! s:InitRepeatRegisterQ() "{{{
    call repeat#set("\<Plug>(ExecuteRegisterQ)")
    return 'q'
endfunction
nnoremap <silent> <Plug>(ExecuteRegisterQ
    \ :<C-u>execute 'normal! ' . v:count1 . '@q' \|
    \ call repeat#set("\<Plug>(ExecuteRegisterQ)")<CR>

nnoremap <expr> q <SID>InitRepeatRegisterQ()
"}}}

function s:BW(BWStage) "{{{
"here is a more exotic version of my original BW script
"delete the buffer; keep windows; create a scratch buffer if no buffers left
  if(a:BWStage == 1)
    if(!buflisted(winbufnr(0)))
      bd!
      return
    endif
    let s:BWBufNum = bufnr("%")
    let s:BWWinNum = winnr()
    windo call s:BW(2)
    execute s:BWWinNum . 'wincmd w'
    let s:buflistedLeft = 0
    let s:bufFinalJump = 0
    let l:nBufs = bufnr("$")
    let l:i = 1
    while(l:i <= l:nBufs)
      if(l:i != s:BWBufNum)
        if(buflisted(l:i))
          let s:buflistedLeft = s:buflistedLeft + 1
        else
          if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
            let s:bufFinalJump = l:i
          endif
        endif
      endif
      let l:i = l:i + 1
    endwhile
    if(!s:buflistedLeft)
      if(s:bufFinalJump)
        windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
      else
        enew
        let l:newBuf = bufnr("%")
        windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
      endif
      execute s:BWWinNum . 'wincmd w'
    endif
    if(buflisted(s:BWBufNum) || s:BWBufNum == bufnr("%"))
      execute "bd! " . s:BWBufNum
    endif
    if(!s:buflistedLeft)
      set buflisted
      set bufhidden=delete
      set buftype=
      setlocal noswapfile
    endif
  else
    if(bufnr("%") == s:BWBufNum)
      let prevbufvar = bufnr("#")
      if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:BWBufNum)
        b #
      else
        bn
      endif
    endif
  endif
endfunction "}}}

command! BW call s:BW(1)
nnoremap <silent> <Plug>BW :<C-u>BW<CR>

function! s:wipeout() "{{{
  "wipe unmodified Buffers|Tabs|Windows
  let tpbl=[]
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  let wiped = 0
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1 && !getbufvar(v:val,"&mod")')
    " echom buf
    silent execute 'bdelete!' buf
    let wiped += 1
  endfor
  echom wiped . ' buffers deleted'
endfunction

command! Wipeout call s:wipeout()

"}}}

 " <c-g> insert mode align ( = , : ) {{{
function! CharsNeeded(char)
  let s:cur_line = line(".")
  let s:cur_col  =  col(".")
  let s:i   =  0
  let s:pos = -1
  while s:pos == -1
    let s:i += 1
    let s:line = getline(s:cur_line - s:i)
    let s:pos  = stridx(s:line, a:char, s:cur_col)
    if s:i == s:cur_line
      return -1
    endif
  endwhile
  return s:pos - s:cur_col + 1
endfunction

function! InsertSpaces()
  let s:char = getline(".")[-1:]
  let s:nspace = CharsNeeded(s:char)
  if s:nspace > -1
    call setline(".", getline(".")[:-2] . repeat(" ", s:nspace) . s:char)
  endif
  echom "No `" . s:char . "' found in the previous lines."
endfunction

inoremap <silent> <C-g> <C-[>:call InsertSpaces()<CR>A
"}}}

 function! Map(mode, key, op)"{{{
   "echomsg a:mode "-" a:key "-" a:op
   let silent=""
   for c in split(a:mode, '\zs')
     if c == "!"                       | let silent="<silent>"      | continue | endif
     if type(c)==1 && tolower(c) !=# c | let c=tolower(c)."noremap" | else     | let c=tolower(c)."map" | endif
     execute c silent a:key a:op
     let silent=""
   endfor
 endfunction

 command! -nargs=* Map call Map(<f-args>)
"}}}

  function! PlugTextObj(repo, key)"{{{
    let name = a:repo
    let name = substitute(name, ".*/vim-textobj-", "", "")
    execute  "call dein#add( '" . a:repo . "', {'on_map': ['<Plug>(textobj-" . name . "-']})"
    execute "Map vo" "i".a:key "<Plug>(textobj-" . name . "-i)"
    execute "Map vo" "a".a:key "<Plug>(textobj-" . name . "-a)"
  endfunction"}}}

  function! CreateFoldableCommentFunction() range"{{{

    echo "firstline ".a:firstline." lastline ".a:lastline

    for lineno in range(a:firstline, a:lastline)
      let line = getline(lineno)

      "Find the line contains the Plug as it's first word
      if ( get(split(line, " "), 0, 'Default') !=# 'call')
        continue
      endif

      let name_start = stridx(line, "/") + 1
      let name_length = stridx(line, "'", name_start) - name_start

      let name = strpart(line, name_start, name_length)

      let res = append(a:firstline - 1, " \" " . name . " {{{")
      let res = append(a:firstline, "")

      let res = append(a:lastline + 2, "")
      let res = append(a:lastline + 3, " \"}}} _" . name)

      " let cleanLine = substitute(lifirstlinene, '\(\s\| \)\+$', '', 'e')
      " call setline(lineno, cleanLine)
      break
    endfor

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
    if gitdir == '.git'
      return '.'
    endif
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
  " Why is this not a built-in Vim script function?!
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
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

  function! CreateLaravelGeneratorFunction()"{{{
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

  endfunction"}}}

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

  function! ToggleFoldMethod(...) "{{{
    let l:fm = ['syntax', 'manual', 'marker', 'indent', 'off']
    let l:index = &foldenable>0 ? index(l:fm, &foldmethod) : 0
    let l:next_fm = l:fm[ l:index + 1 * ( len(a:000)>0?-1:1) ]
    if l:next_fm=="off"
      set nofoldenable
    else
      set foldenable
      execute "set foldmethod=".l:next_fm
    endif
    let g:submode_toggle_fold = &foldenable==0? "Off": &foldmethod
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

" }}}
" ============================================================================
" PLUG-INS {{{
" ============================================================================

"Clean unused plugins UNINSTALL
"call map(dein#check_clean(), "delete(v:val, 'rf')")

"DEIN START {{{
"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath^=/Volumes/Home/.config/nvim/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin(expand('/Volumes/Home/.config/nvim/dein'))

" Let dein manage dein
" Required:
call dein#add('Shougo/dein.vim')
"}}} _DEIN START

" ----------------------------------------------------------------------------
" Libraries {{{
" ----------------------------------------------------------------------------
 " revital.vim {{{

call dein#add( 'haya14busa/revital.vim' )

 "}}} _revital.vim

 " vital.vim {{{

 call dein#add( 'vim-jp/vital.vim' )

 "}}} _vital.vim

"}}}
 " ----------------------------------------------------------------------------
 " Version Control & Diff {{{
 " ----------------------------------------------------------------------------

 " vim-fugitive {{{

 call dein#add( 'tpope/vim-fugitive'
       \ , { 'on_cmd': [
       \     'Git', 'Gcd',     'Glcd',   'Gstatus',
       \     'Gcommit',  'Gmerge',  'Gpull',  'Gpush',
       \     'Gfetch',   'Ggrep',   'Glgrep', 'Glog',
       \     'Gllog',    'Gedit',   'Gsplit', 'Gvsplit',
       \     'Gtabedit', 'Gpedit',  'Gread',  'Gwrite',
       \     'Gwq',      'Gdiff',   'Gsdiff', 'Gvdiff',
       \     'Gmove', 'Gremove', 'Gblame', 'Gbrowse' ],
       \  'hook_post_source': "call fugitive#detect(expand('%:p'))"
       \ })

 autocmd User fugitive
       \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
       \   nnoremap <buffer> .. :edit %:h<CR> |
       \ endif
 autocmd BufReadPost fugitive://* set bufhidden=delete
 " set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

 "}}} _vim-fugitive
 " gv.vim {{{

   "Requires vim-fugitive
   call dein#add( 'junegunn/gv.vim', {
         \ 'depends': 'vim-fugitive',
         \ 'on_cmd': ['GV', 'GV!', 'GV?']
         \ })

 "}}} _gv.vim
 " vim-gitgutter {{{

   call dein#add( 'airblade/vim-gitgutter' )

 "}}} _vim-gitgutter
 " vimagit {{{

   call dein#add( 'jreybert/vimagit', {'on': ['Magit'], 'rev': 'next'} )
   " Don't show help as it can be toggled by h
   let g:magit_show_help=0
   "nnoremap <leader>G :Magit<cr>
   let g:magit_show_magit_mapping=''
 "}}} _vimagit

 " DirDiff.vim {{{

   call dein#add( 'vim-scripts/DirDiff.vim', {'on_cmd': ['DirDiff']} )

 "}}} _DirDiff.vim
 " vim-diff-enhanced {{{

  call dein#add( 'chrisbra/vim-diff-enhanced' )
  " started In Diff-Mode set diffexpr (plugin not loaded yet)
  if &diff
    let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
  endif
 "}}} _vim-diff-enhanced
 " Recover-With-Diff{{{

 call dein#add( 'chrisbra/Recover.vim' )

 "}}} _Recover-With-Diff

 call dein#add('rickhowe/diffchar.vim')

 "}}}
 " ----------------------------------------------------------------------------
 " Content Editor {{{
 " ----------------------------------------------------------------------------

 " Org
 " vim-speeddating {{{

   call dein#add( 'tpope/vim-speeddating', {'on_ft': ['org'],'on_map': ['<Plug>SpeedDatingUp', '<Plug>SpeedDatingDown']} )

 "}}} _vim-speeddating
 " vim-orgmode {{{

   "call dein#add( 'jceb/vim-orgmode', {'on_ft': 'org'} )
   call dein#add( 'jceb/vim-orgmode' )
   let g:org_agenda_files=['~/org/index.org']
   let g:org_todo_keywords=['TODO', 'FEEDBACK', 'VERIFY', 'WIP', '|', 'DONE', 'DELEGATED']
   let g:org_heading_shade_leading_stars = 1   "Hide the star noise

 "}}} _vim-orgmode
 "SyntaxRange {{{

    call dein#add('SyntaxRange')

 "}}} _SyntaxRange
 "utl.vim{{{
   call dein#add( 'utl.vim' )
 "_utl.vim}}}
 " lazyList.vim {{{

   call dein#add( 'KabbAmine/lazyList.vim', {'on_cmd': ['LazyList']} )

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

 "}}} _lazyList.vim
 " vim-simple-todo {{{

   call dein#add( 'vitalk/vim-simple-todo', {'on_map': ['<Plug>(simple-todo-'] })

   " Disable default key bindings
   let g:simple_todo_map_keys = 0


   let g:simple_todo_tick_symbol = 'y'

   nmap <Leader>i <Plug>(simple-todo-new)
   nmap <Leader>I <Plug>(simple-todo-new-start-of-line)
   nmap <Leader>o <Plug>(simple-todo-below)
   nmap <Leader>O <Plug>(simple-todo-above)
   nmap <Leader>x <Plug>(simple-todo-mark-as-done)
   nmap <Leader>X <Plug>(simple-todo-mark-as-undone)


 "}}} _vim-simple-todo
 "vim-dotoo {{{
    call dein#add('dhruvasagar/vim-dotoo', {'on_ft': 'org'} )
 "}}} _vim-todo
 " vim-table-mode {{{

   call dein#add( 'dhruvasagar/vim-table-mode', {'on_cmd': ['TabelModeEnable', 'TableModeToggle', 'Tableize']} )
   let g:table_mode_corner_corner="+"
   let g:table_mode_header_fillchar="="

 "}}} _vim-table-mode
 " calendar.vim {{{

   call dein#add( 'itchyny/calendar.vim', {'on_cmd': ['Calendar'] } )
   let g:calendar_date_month_name = 1

 "}}} _calendar.vim
 " calendar-vim {{{

   call dein#add( 'mattn/calendar-vim', {'on_cmd': ['CalendarH', 'CalendarT'] } )

 "}}} _calendar-vim
 " vim-journal {{{

   "call dein#add( 'junegunn/vim-journal', {'on_ft': ['journal']} )
   call dein#add( 'junegunn/vim-journal' )

 "}}} _vim-journal
 " vimwiki {{{

   call dein#add( 'vimwiki/vimwiki' )
   let g:vimwiki_map_prefix = '<Leader>v'

 "}}} _vimwiki
 " junkfile.vim {{{

   call dein#add( 'Shougo/junkfile.vim', {'on_cmd': ['JunkfileOpen']} )
   let g:junkfile#directory = $HOME . '/.config/nvim/cache/junkfile'

   nnoremap <leader>jo :JunkfileOpen

 "}}}

 " Multi-edits
 " vim-fnr {{{


   "Requires pseudocl
   call dein#add( 'junegunn/vim-fnr', {'on_map': ['<Plug>(FNR)','<Plug>(FNR%)']} )

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
 " vim-over {{{

   " Plug 'osyo-manga/vim-over', {'on': ['OverCommandLine']}

   "use vim-fnr instead
   " nmap <leader>/ :OverCommandLine<cr>
   " nnoremap g;s :<c-u>OverCommandLine<cr>%s/
   " xnoremap g;s :<c-u>OverCommandLine<cr>%s/\%V

 "}}} _vim-over
 " vim-enmasse {{{

   call dein#add( 'Wolfy87/vim-enmasse',         { 'on_cmd': 'EnMasse'} )
   " EnMass the sublime like search and edit then save back to corresponding files

 "}}} _vim-enmasse
 " vim-swoop {{{

   call dein#add( 'pelodelfuego/vim-swoop', {'on_cmd': ['Swoop']} )
   let g:swoopUseDefaultKeyMap = 0

   " nmap <Leader>ml :call SwoopMulti()<CR>
   " vmap <Leader>ml :call SwoopMultiSelection()<CR>
   " nmap <Leader>l :call Swoop()<CR>
   " vmap <Leader>l :call SwoopSelection()<CR>

   function! Multiple_cursors_before()
     if exists('*SwoopFreezeContext') != 0
       call SwoopFreezeContext()
     endif
   endfunction

   function! Multiple_cursors_after()
     if exists('*SwoopUnFreezeContext') != 0
       call SwoopUnFreezeContext()
     endif
   endfunction

 "}}} _vim-swoop
 " vim-ags {{{

 call dein#add( 'gabesoft/vim-ags', {'on_cmd': ['Ags']} )

 "}}} _vim-ags
 " inline_edit.vim {{{

   call dein#add( 'AndrewRadev/inline_edit.vim', { 'on_cmd': ['InlineEdit']} )

 "}}} _inline_edit.vim
 " vim-multiple-cursors {{{

 "TODO: Set some mapping
   call dein#add( 'terryma/vim-multiple-cursors' )

   let g:multi_cursor_use_default_mapping=0
   "Use ctrl-n to select next instance

 "}}} _vim-multiple-cursors
 " vim-markmultiple {{{

 call dein#add( 'adinapoli/vim-markmultiple', {'on_func':['MarkMultiple']} )
 let g:mark_multiple_trigger = "<C-n>"

 nnoremap <C-N>  :call MarkMultiple()<CR>
 xnoremap <C-N>  :call MarkMultiple()<CR>

 "if effect remains on screen clear with "call MarkMultipleClean()"
 "Map <c-bs>
 Map  NV Ą :call\ MarkMultipleClean()<cr>


 "}}} _vim-markmultiple
 " multichange.vim {{{

 call dein#add( 'AndrewRadev/multichange.vim' )
 let g:multichange_mapping        = 'sm'
 let g:multichange_motion_mapping = 'm'

 "}}} _multichange.vim
 " vim-multiedit {{{

 call dein#add( 'hlissner/vim-multiedit' , { 'on_cmd': [
       \   'MultieditAddMark', 'MultieditAddRegion',
       \   'MultieditRestore', 'MultieditHop', 'Multiedit',
       \   'MultieditClear', 'MultieditReset'
       \ ] } )

   let g:multiedit_no_mappings = 1
   let g:multiedit_auto_reset = 1

   "Force multiedit key bindings and make it faster :)
   au VimEnter * call BindMultieditKeys()
   "au User vim-multiedit call BindMultieditKeys()

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

 "}}} _vim-multiedit
 " vim-abolish {{{

   call dein#add( 'tpope/vim-abolish',           { 'on_cmd': ['S','Subvert', 'Abolish']} )

 "}}} _vim-abolish
 " vim-rengbang {{{

   call dein#add( 'deris/vim-rengbang',          { 'on_cmd': [ 'RengBang', 'RengBangUsePrev' ] } )

   "Use instead of increment it is much powerfull
   " RengBang \(\d\+\) Start# Increment# Select# %03d => 001, 002

 "}}} _vim-rengbang
 " vim-rectinsert {{{

   call dein#add( 'deris/vim-rectinsert',        { 'on_cmd': ['RectInsert', 'RectReplace'] } )

 "}}} _vim-rectinsert

 " Isolate
 " NrrwRgn {{{

 call dein#add( 'chrisbra/NrrwRgn', {
       \ 'on_cmd':
       \   [
       \    'NR', 'NarrowRegion', 'NW', 'NarrowWindow', 'WidenRegion',
       \    'NRV', 'NUD', 'NRPrepare', 'NRP', 'NRMulti', 'NRM',
       \    'NRS', 'NRNoSyncOnWrite', 'NRN', 'NRL', 'NRSyncOnWrite'
       \   ],
       \ 'on_map': ['<Plug>Nrrwrgn']
       \ })

 nmap <leader>nr <Plug>NrrwrgnDo

 "}}} _NrrwRgn

 " Yank
 " YankRing {{{

   " Plug 'vim-scripts/YankRing.vim'

   " let g:yankring_min_element_length = 2
   " let g:yankring_max_element_length = 548576 " 4M
   " let g:yankring_dot_repeat_yank = 1
   " " let g:yankring_window_use_horiz = 0  " Use vertical split
   " " let g:yankring_window_height = 8
   " " let g:yankring_window_width = 30
   " " let g:yankring_window_increment = 50   "In vertical press space to toggle width
   " " let g:yankring_ignore_operator = 'g~ gu gU ! = gq g? > < zf g@'
   " let g:yankring_history_dir = '~/.config/nvim/.cache/yankring'
   " " let g:yankring_clipboard_monitor = 0   "Detect when copying from outside
   " " :YRToggle    " Toggles it
   " " :YRToggle 1  " Enables it
   " " :YRToggle 0  " Disables it
   " nnoremap sd :YRToggle

   " nnoremap <silent> <F11> :YRShow<CR>


 "}}}
 " vim-yankstack {{{

   " Plug 'maxbrunsfeld/vim-yankstack'

   " let g:yankstack_map_keys = 0
   " " let g:yankstack_yank_keys = ['y', 'd']
   " nmap <leader>p <Plug>yankstack_substitute_older_paste
   " nmap <leader>P <Plug>yankstack_substitute_newer_paste

 "}}} _vim-yankstack
 " YankMatches {{{

   " Plug '~/.config/nvim/plugged/yankmatches.vim'

   " nnoremap <silent>  dm :     call ForAllMatches('delete', {})<CR>
   " nnoremap <silent>  DM :     call ForAllMatches('delete', {'inverse':1})<CR>
   " nnoremap <silent>  ym :     call ForAllMatches('yank',   {})<cr>
   " nnoremap <silent>  YM :     call ForAllMatches('yank',   {'inverse':1})<CR>
   " vnoremap <silent>  dm :<C-U>call ForAllMatches('delete', {'visual':1})<CR>
   " vnoremap <silent>  DM :<C-U>call ForAllMatches('delete', {'visual':1, 'inverse':1})<CR>
   " vnoremap <silent>  ym :<C-U>call ForAllMatches('yank',   {'visual':1})<CR>
   " vnoremap <silent>  YM :<C-U>call ForAllMatches('yank',   {'visual':1, 'inverse':1})<CR>


 " }}}
 " vim-peekaboo {{{

   call dein#add( 'junegunn/vim-peekaboo' )

   " Default peekaboo window
   let g:peekaboo_window = 'vertical botright 30new'

   " Delay opening of peekaboo window (in ms. default: 0)
   let g:peekaboo_delay = 200

   " Compact display; do not display the names of the register groups
   let g:peekaboo_compact = 1


 "}}} _vim-peekaboo
 " UnconditionalPaste {{{

   call dein#add( 'vim-scripts/UnconditionalPaste', {'on_map': ['<Plug>UnconditionalPaste']} )
   Map n gPP  <Plug>UnconditionalPasteGPlusBefore
   Map n gPp  <Plug>UnconditionalPasteGPlusAfter
   Map n gpP  <Plug>UnconditionalPastePlusBefore
   Map n gpp  <Plug>UnconditionalPastePlusAfter
   Map n gUP  <Plug>UnconditionalPasteRecallUnjoinBefore
   Map n gUp  <Plug>UnconditionalPasteRecallUnjoinAfter
   Map n guP  <Plug>UnconditionalPasteUnjoinBefore
   Map n gup  <Plug>UnconditionalPasteUnjoinAfter
   Map n gQP  <Plug>UnconditionalPasteRecallQueriedBefore
   Map n gQp  <Plug>UnconditionalPasteRecallQueriedAfter
   Map n gqP  <Plug>UnconditionalPasteQueriedBefore
   Map n gqp  <Plug>UnconditionalPasteQueriedAfter
   Map n gQBP <Plug>UnconditionalPasteRecallDelimitedBefore
   Map n gQBp <Plug>UnconditionalPasteRecallDelimitedAfter
   Map n gqbP <Plug>UnconditionalPasteDelimitedBefore
   Map n gqbp <Plug>UnconditionalPasteDelimitedAfter
   Map n gBP  <Plug>UnconditionalPasteJaggedBefore
   Map n gBp  <Plug>UnconditionalPasteJaggedAfter
   Map n gsP  <Plug>UnconditionalPasteSpacedBefore
   Map n gsp  <Plug>UnconditionalPasteSpacedAfter
   Map n g#P  <Plug>UnconditionalPasteCommentedBefore
   Map n g#p  <Plug>UnconditionalPasteCommentedAfter
   Map n g>P  <Plug>UnconditionalPasteShiftedBefore
   Map n g>p  <Plug>UnconditionalPasteShiftedAfter
   Map n g[[P <Plug>UnconditionalPasteLessIndentBefore
   Map n g[[p <Plug>UnconditionalPasteLessIndentAfter
   Map n g]]P <Plug>UnconditionalPasteMoreIndentBefore
   Map n g]]p <Plug>UnconditionalPasteMoreIndentAfter
   Map n g]p  <Plug>UnconditionalPasteIndentedAfter
   Map n g[p  <Plug>UnconditionalPasteIndentedBefore
   Map n g[P  <Plug>UnconditionalPasteIndentedBefore
   Map n g]P  <Plug>UnconditionalPasteIndentedBefore
   Map n g,"P <Plug>UnconditionalPasteCommaDoubleQuoteBefore
   Map n g,"p <Plug>UnconditionalPasteCommaDoubleQuoteAfter
   Map n g,'P <Plug>UnconditionalPasteCommaSingleQuoteBefore
   Map n g,'p <Plug>UnconditionalPasteCommaSingleQuoteAfter
   Map n g,P  <Plug>UnconditionalPasteCommaBefore
   Map n g,p  <Plug>UnconditionalPasteCommaAfter
   Map n gbP  <Plug>UnconditionalPasteBlockBefore
   Map n gbp  <Plug>UnconditionalPasteBlockAfter
   Map n glP  <Plug>UnconditionalPasteLineBefore
   Map n glp  <Plug>UnconditionalPasteLineAfter
   Map n gcP  <Plug>UnconditionalPasteCharBefore
   Map n gcp  <Plug>UnconditionalPasteCharAfter

 "}}} _UnconditionalPaste

 " vim-copy-as-rtf {{{

 call dein#add( 'zerowidth/vim-copy-as-rtf', {'on_cmd': ['CopyRTF']} )

 "}}} _vim-copy-as-rtf

 " Single-edits
 " switch.vim {{{

   call dein#add( 'AndrewRadev/switch.vim', {'on_cmd':  ['Switch']} )

 "}}} _switch.vim
 " vim-exchange {{{

   call dein#add( 'tommcdo/vim-exchange', {'on_cmd':  ['ExchangeClear'] , 'on_map': ['<Plug>(Exchange']} )
   xmap c<cr><cr>     <Plug>(Exchange)
   nmap c<cr>l    <Plug>(ExchangeLine)
   nmap c<cr>c    <Plug>(ExchangeClear)
   nmap c<cr><bs> <Plug>(ExchangeClear)
   nmap c<cr><cr> <Plug>(Exchange)

 "}}} _vim-exchange

 " ReplaceWithRegister{{{
 call dein#add('vim-scripts/ReplaceWithRegister', { 'on_map': ['<Plug>ReplaceWithRegister']})
 "}}} _ReplaceWithRegister

 " vim-lion {{{

   call dein#add( 'tommcdo/vim-lion' )

 "}}} _vim-lion
 " EasyAlign {{{

   call dein#add( 'junegunn/vim-easy-align',          {'on_cmd':  ['EasyAlign'], 'on_map':[ '<Plug>(EasyAlign)']} )

   " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
   vmap <Enter> <Plug>(EasyAlign)
   " Start interactive EasyAlign for a motion/text object (e.g. gaip)
   nmap g<cr> <Plug>(EasyAlign)
   let g:easy_align_ignore_comment = 0 " align comments


 "}}}
 " tabular {{{

   call dein#add( 'godlygeek/tabular', {'on_cmd': ['Tabularize']} )

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


 "}}} _tabular
 " vim-surround {{{
 " ----------------------------------------------------------------------------
 call dein#add( 't9md/vim-surround_custom_mapping' )
 call dein#add( 'tpope/vim-surround', {
                           \   'on_map' :[
                           \      '<Plug>Dsurround' , '<Plug>Csurround',
                           \      '<Plug>Ysurround' , '<Plug>YSurround',
                           \      '<Plug>Yssurround', '<Plug>YSsurround',
                           \      '<Plug>YSsurround', '<Plug>VgSurround',
                           \      '<Plug>VSurround' , '<Plug>ISurround',
                           \      ['i', '<Plug>Isurround'],
                           \      ['i', '<Plug>ISurround']
                           \ ]} )
   let g:surround_no_mappings=1
   nmap dS <Plug>Dsurround
   nmap cS <Plug>Csurround
   nmap c<cr> <Plug>Csurround
   nmap ys <Plug>Ysurround
   nmap yS <Plug>YSurround
   nmap yss <Plug>Yssurround
   nmap ySs <Plug>YSsurround
   nmap ySS <Plug>YSsurround
   xmap S <Plug>VSurround
   xmap gS <Plug>VgSurround
   "Original mappings
   "=================
   "nmap ds  <Plug>Dsurround
   "nmap cs  <Plug>Csurround
   "nmap cS  <Plug>CSurround
   "nmap ys  <Plug>Ysurround
   "nmap yS  <Plug>YSurround
   "nmap yss <Plug>Yssurround
   "nmap ySs <Plug>YSsurround
   "nmap ySS <Plug>YSsurround
   "xmap S   <Plug>VSurround
   "xmap gS  <Plug>VgSurround

   imap <C-G>s <Plug>Isurround
   imap <C-G>S <Plug>ISurround
   imap <C-S> <Plug>Isurround

 "}}}
 " splitjoin.vim {{{

   call dein#add( 'AndrewRadev/splitjoin.vim' , {'on_map':['gS', 'gJ']} )

 "}}} _splitjoin.vim
 " vim-sort-motion {{{

  call dein#add( 'christoomey/vim-sort-motion', {'on_map': ['<Plug>Sort']} )
  map  gs  <Plug>SortMotion
  map  gss <Plug>SortLines
  vmap gs  <Plug>SortMotionVisual

 "}}} _vim-sort-motion
 " vim-tag-comment {{{
   " Comment out HTML properly
   call dein#add( 'mvolkmann/vim-tag-comment', {'on_cmd': ['ElementComment', 'ElementUncomment', 'TagComment', 'TagUncomment']} )
   nmap <leader>tc :ElementComment<cr>
   nmap <leader>tu :ElementUncomment<cr>
   nmap <leader>tC :TagComment<cr>
   nmap <leader>tU :TagUncomment<cr>

 "}}} _vim-tag-comment

 " Comments
 " nerdcommenter {{{

 "Don't lazyload as doing so will fragile
  call dein#add( 'scrooloose/nerdcommenter', {'on_map': [ '<Plug>NERDCommenter' ]} )
  "call s:SetUpForNewFiletype(&filetype, 1)

  Map nx  <leader>c<Space>     <Plug>NERDCommenterToggle
  Map nx  <leader>ca           <Plug>NERDCommenterAltDelims
  Map nx  <leader>cb           <Plug>NERDCommenterAlignBoth
  Map nx  <leader>ci           <Plug>NERDCommenterInvert
  Map nx  <leader>cl           <Plug>NERDCommenterAlignLeft
  Map nx  <leader>cm           <Plug>NERDCommenterMinimal
  Map nx  <leader>cn           <Plug>NERDCommenterNested
  Map nx  <leader>cs           <Plug>NERDCommenterSexy
  Map nx  <leader>cu           <Plug>NERDCommenterUncomment
  Map nx  <leader>cy           <Plug>NERDCommenterYank
  Map nx  <leader>cc           <Plug>NERDCommenterComment
  Map n   <leader>cA           <Plug>NERDCommenterAppend
  Map n   <leader>c$           <Plug>NERDCommenterToEOL

 "}}} _nerdcommenter
 " vim-commentary {{{
 call dein#add ('tpope/vim-commentary',
       \ {
       \ 'on_map':
       \ [
       \  '<Plug>Commentary',
       \  '<Plug>CommentaryLine',
       \  '<Plug>ChangeCommentary'
       \ ],
       \ 'on_cmd': [ 'Commentary' ]
       \ })
 xmap gc  <Plug>Commentary
 nmap gc  <Plug>Commentary
 omap gc  <Plug>Commentary
 nmap gcc <Plug>CommentaryLine
 nmap cgc <Plug>ChangeCommentary
 nmap gcu <Plug>Commentary<Plug>Commentary
 " }}} _vim-commentary
   " Plug 'tomtom/tcomment_vim'

 " Auto-manipulators
 " vim-endwise {{{
   "Plug 'tpope/vim-endwise', {'on': []}

   ""Lazy load endwise
   "augroup load_endwise
     "autocmd!
     "autocmd InsertEnter * call plug#load('vim-endwise') | autocmd! load_endwise
   "augroup END

 "}}} _vim-endwise
 " vim-closer {{{

   call dein#add( 'rstacruz/vim-closer' )

 "}}} _vim-closer
 " delimitmate {{{

 "XXXX
 call dein#add( 'Raimondi/delimitMate', {'on_event': ['InsertEnter']} )
   " au FileType blade let b:delimitMate_autoclose = 0

 "}}}

 "}}}
 " ----------------------------------------------------------------------------
 " Utils {{{
 " ----------------------------------------------------------------------------


 " pipe.vim {{{

   "Pipe !command output to vim
   call dein#add( 'NLKNguyen/pipe.vim' )

 "}}} _pipe.vim

 "vim-signature {{{
   call dein#add('kshenoy/vim-signature')
 "}}} _vim-signature'

 " tinymode.vim {{{

 call dein#add( 'vim-scripts/tinymode.vim' )

 "}}} _tinymode.vim
 " tinykeymap_vim {{{

 "TODO XXX find away to make use of tinykeymap
 call dein#add( 'tomtom/tinykeymap_vim', {'lazy': 1} )

 "}}} _tinykeymap_vim
 " vim-submode {{{
   "call dein#add( 'kana/vim-submode' )
   call dein#add( 'khalidchawtany/vim-submode' )
   let g:submode_timeout=0

   au VimEnter * call BindSubModes()
   function! BindSubModes()
     " Window resize {{{
       call submode#enter_with('h/l', 'n', '', '<C-w>h', '<C-w><')
       call submode#enter_with('h/l', 'n', '', '<C-w>l', '<C-w>>')
       call submode#map('h/l', 'n', '', 'h', '<C-w><')
       call submode#map('h/l', 'n', '', 'l', '<C-w>>')
       call submode#enter_with('j/k', 'n', '', '<C-w>j', '<C-w>-')
       call submode#enter_with('j/k', 'n', '', '<C-w>k', '<C-w>+')
       call submode#map('j/k', 'n', '', 'j', '<C-w>-')
       call submode#map('j/k', 'n', '', 'k', '<C-w>+')
     "}}} _Window resize

     "Toggles FOLD {{{
       call submode#enter_with('toggle-fold', 'n', 's', 'cof', ':<C-U>exe "call ToggleFoldMethod()"<cr>')
       call submode#leave_with('toggle-fold', 'n', 's', '<Esc>')
       call submode#map(       'toggle-fold', 'n', 's', 'f', ':<C-U>exe "call ToggleFoldMethod()"<cr>')
       call submode#map(       'toggle-fold', 'n', 's', 'n', ':<C-U>exe "call ToggleFoldMethod()"<cr>')
       call submode#map(       'toggle-fold', 'n', 's', 'p', ':<C-U>exe "call ToggleFoldMethod(1)"<cr>')
       call submode#map(       'toggle-fold', 'n', 's', 's', ':<C-U>set foldmethod=syntax<cr>')
       call submode#map(       'toggle-fold', 'n', 's', 'i', ':<C-U>set foldmethod=indent<cr>')
       call submode#map(       'toggle-fold', 'n', 's', 'm', ':<C-U>set foldmethod=manual<cr>')
       call submode#map(       'toggle-fold', 'n', 's', '{', ':<C-U>set foldmethod=manual<cr>')
     "}}} _Toogles FOLD

     ""Toggles FoleMarker {{{
       "call submode#enter_with('toggle-marker', 'n', '', 'com', ':<C-U>exe "call ToggleFoldMarker()"<cr>')
       "call submode#leave_with('toggle-marker', 'n', '', '<Esc>')
       "call submode#map(       'toggle-marker', 'n', '', 'm', ':<C-U>exe "call ToggleFoldMarker()"<cr>')
       "call submode#map(       'toggle-marker', 'n', '', 'n', ':<C-U>exe "call ToggleFoldMarker()"<cr>')
       "call submode#map(       'toggle-marker', 'n', '', 'p', ':<C-U>exe "call ToggleFoldMarker()"<cr>')
     ""}}} _Toogles FoleMarker

     "Toggles {{{
       call submode#enter_with('toggle-mode', 'n', '', 'coo', ':<C-U>echo ""<cr>')
       call submode#leave_with('toggle-mode', 'n', '', '<Esc>')
       call submode#map(       'toggle-mode', 'n', '', 'f', ':<C-U>exe "call ToggleFoldMethod()"<cr>')
       call submode#map(       'toggle-mode', 'n', '', '{', ':<C-U>exe "call ToggleFoldMarker()"<cr>')
       call submode#map(       'toggle-mode', 'n', '', 'm', ':<C-U>exe "call ToggleMouseFunction()"<cr>')
       call submode#map(       'toggle-mode', 'n', '', ';', ':<C-U>set showcmd!<cr>')
       call submode#map(       'toggle-mode', 'n', '', ':', ':<C-U>set showcmd!<cr>')
       call submode#map(       'toggle-mode', 'n', '', 't', ':<C-U>exe "set showtabline=" . (&showtabline+2)%3<cr>')
       call submode#map(       'toggle-mode', 'n', '', '<space>', ':<C-U>exe "set laststatus=" . (&laststatus+2)%3<cr>')
       call submode#map(       'toggle-mode', 'n', '', 'q', ':<C-U>QFix<cr>')

     "}}} _Toggles

     "Undo/Redo {{{
       call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
       call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
       call submode#leave_with('undo/redo', 'n', '', '<Esc>')
       call submode#map('undo/redo', 'n', '', '-', 'g-')
       call submode#map('undo/redo', 'n', '', '+', 'g+')
     "}}} _Undo/Redo

     "Buffer {{{
       ""call submode#enter_with('buf', 'n', 's', ']b', ':<C-U>exe "bnext<Bar>hi Normal guibg=red"<cr>')
       ""call submode#enter_with('buf', 'n', 's', '[b', ':<C-U>exe "bprevious<Bar>hi Normal guibg=red"<cr>')
       "call submode#enter_with('buf', 'n', 's', ']b', ':<C-U>exe "bnext"<cr>')
       "call submode#enter_with('buf', 'n', 's', '[b', ':<C-U>exe "bprevious"<cr>')
       "call submode#map('buf', 'n', 's', ']', ':<C-U>exe "bnext"<cr>')
       "call submode#map('buf', 'n', 's', 'd', ':<C-U>exe "bdelete"<cr>')
       "call submode#map('buf', 'n', 's', 'k', ':<C-U>exe "bdelete!"<cr>')
       "call submode#map('buf', 'n', 's', 'o', ':<C-U>exe "BufOnly"<cr>')
       "call submode#map('buf', 'n', 's', '[', ':<C-U>exe "bprevious"<cr>')
       "call submode#map('buf', 'n', 's', 'l', ':<C-U>exe "buffers"<cr>')
       "autocmd! User buf_leaving :hi Normal guibg=#1B1D1E<cr>
     "}}} _Buffer

     "Jump/Edit {{{
       call submode#enter_with('Jump/Edit', 'n', 's', 'coj', ':<C-U>exe "silent! normal g,zO"<cr>')
       call submode#enter_with('Jump/Edit', 'n', 's', 'coe', ':<C-U>exe "silent! normal g,zO"<cr>')
       call submode#enter_with('Jump/Edit', 'n', 's', ']j', ':<C-U>exe "silent! normal g,zO"<cr>')
       call submode#enter_with('Jump/Edit', 'n', 's', '[j', ':<C-U>exe "silent! normal g;zO"<cr>')
       call submode#map('Jump/Edit', 'n', 's', ']', ':<C-U>exe "silent! normal g,zO"<cr>')
       call submode#map('Jump/Edit', 'n', 's', '[', ':<C-U>exe "silent! normal g;zO"<cr>')
       call submode#map('Jump/Edit', 'n', 's', 'n', ':<C-U>exe "silent! normal g,zO"<cr>')
       call submode#map('Jump/Edit', 'n', 's', 'p', ':<C-U>exe "silent! normal g;zO"<cr>')
       call submode#map('Jump/Edit', 'n', 's', 'j', ':<C-U>exe "silent! normal g,zO"<cr>')
       call submode#map('Jump/Edit', 'n', 's', 'k', ':<C-U>exe "silent! normal g;zO"<cr>')
     "}}} _Jum/Edit

   endfunction

 "}}}
 " vim-hopper {{{

   "Plug 'LFDM/vim-hopper'
   call dein#add( 'khalidchawtany/vim-hopper')
   "let g:hopper_prefix = '<esc>'
   let g:hopper_prefix = ','
   let g:hopper_file_opener = [ 'angular' ]

 "}}} _vim-hopper


 " vim-unimpaired {{{

 call dein#add( 'tpope/vim-unimpaired' )

 "}}} _vim-unimpaired
 " vim-man {{{

   call dein#add( 'bruno-/vim-man', {'on_cmd': ['Man', 'SMan', 'VMan', 'Mangrep']} )

 "}}} _vim-man
 " vim-rsi {{{

   call dein#add( 'tpope/vim-rsi' )

 "}}} _vim-rsi
 " capture.vim {{{

   "Capture EX-commad in a buffer
   call dein#add( 'tyru/capture.vim', {'on_cmd': 'Capture'} )

 "}}} _capture.vim
 " vim-eunuch {{{

   call dein#add( 'tpope/vim-eunuch', {'on_cmd': [ 'Remove', 'Unlink', 'Move', 'Rename',
       \ 'Chmod', 'Mkdir', 'Find', 'Locate', 'SudoEdit', 'SudoWrite', 'Wall', 'W' ]})

 "}}} _vim-eunuch
 "call dein#add( 'duggiefresh/vim-easydir' )

 " vim-capslock {{{

 call dein#add( 'tpope/vim-capslock' ,{
       \ 'on_map':[
       \  ['i', '<Plug>CapsLockToggle'],
       \  ['i', '<Plug>(CapsLockEnable)'],
       \  ['i', '<Plug>(CapsLockDisable)]']
       \ ]})
   imap <c-l>o <C-O><Plug>CapsLockToggle
   imap <c-l>e <C-O><Plug>CapsLockEnable
   imap <c-l>d <C-O><Plug>CapsLockDisable
 "}}} _vim-capslock

 " vim-characterize {{{

   call dein#add( 'tpope/vim-characterize', {'on_map':['<Plug>(characterize)']} )

 "}}} _vim-characterize
 " unicode {{{

   call dein#add( 'chrisbra/unicode.vim', {'on_cmd':['Diagraphs', 'SearchUnicode', 'UnicodeName', 'UnicodeTable']} )

   " :Digraphs        - Search for specific digraph char
   " :SearchUnicode   - Search for specific unicode char
   " :UnicodeName     - Identify character under cursor (like ga command)
   " :UnicodeTable    - Print Unicode Table in new window
   " :DownloadUnicode - Download (or update) Unicode data
   " <C-X><C-G>  - Complete Digraph char
   " <C-X><C-Z>  - Complete Unicode char
   " <F4>        - Combine characters into digraphs

 "}}}
 " Plug 'seletskiy/vim-nunu'           "Disable relative numbers on cursor move

 " vim-repeat {{{

 call dein#add( 'tpope/vim-repeat' )

 "}}} _vim-repeat
 " Plug 'vim-scripts/confirm-quit'
 " undofile_warn.vim {{{

   " This breaks Magit :(
   " Plug 'vim-scripts/undofile_warn.vim'

 "}}} _undofile_warn.vim
 " vim-obsession {{{

   call dein#add( 'tpope/vim-obsession', {'on_cmd':['Obsess']} )

 "}}} _vim-obsession
 " vim-scriptease {{{

   call dein#add( 'tpope/vim-scriptease', {'on_ft': ['vim']} )

 "}}} _vim-scriptease
 " vim-autoswap {{{

   call dein#add( 'gioele/vim-autoswap' )

 "}}} _vim-autoswap


 call dein#add( 'KabbAmine/vCoolor.vim')
 call dein#add('sunaku/vim-shortcut')
 " vim-hardtime {{{

   call dein#add( 'takac/vim-hardtime', {'on_cmd': ['HardTimeOn', 'HardTimeToggle']} )

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


 "}}} _vim-hardtime
 " investigate.vim {{{

 call dein#add( 'keith/investigate.vim', {'on_map': ['gK']} )
 let g:investigate_dash_for_blade="laravel"
 let g:investigate_dash_for_php="laravel"
 let g:investigate_use_dash=1

 "}}} _investigate.vim

 "}}}
 " ----------------------------------------------------------------------------
 " languages {{{
 " ----------------------------------------------------------------------------

 "Python
 call dein#add( 'tweekmonster/braceless.vim', {'on_ft': ['python']} )

 " Java
 " Plug 'tpope/vim-classpath'

 "C#
 " omnisharp {{{

   " let g:OmniSharp_server_type = 'roslyn'
   let g:OmniSharp_server_path = "/Volumes/Home/.config/nvim/plugged/Omnisharp/server/Omnisharp/bin/Debug/OmniSharp.exe"
   call dein#add( 'nosami/Omnisharp', {'on_ft': ['cs']} )

   " Plug 'khalidchawtany/omnisharp-vim', {'branch': 'nUnitQuickFix'}

   let g:OmniSharp_selecter_ui = 'ctrlp'

   let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']

   "let g:OmniSharp_server_type = 'roslyn'
   autocmd Filetype cs,cshtml.html call SetOmniSharpOptions()

   function! SetOmniSharpOptions()

     if exists("g:SetOmniSharpOptionsIsSet")
       return
     endif

     source ~/.config/nvim/scripts/make_cs_solution.vim
     autocmd BufWritePost *.cs BuildCSharpSolution

     nnoremap <leader>oo :BuildCSharpSolution<cr>

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
     nnoremap <localleader>b :wa!<cr>:OmniSharpBuildAsync<cr>
     nnoremap <localleader>tt :OmniSharpRunTests<cr>
     nnoremap <localleader>tf :OmniSharpRunTestFixture<cr>
     nnoremap <localleader>ta :OmniSharpRunAllTests<cr>
     nnoremap <localleader>tl :OmniSharpRunLastTests<cr>

     nnoremap <localleader>gd :OmniSharpGotoDefinition<cr>
     nnoremap <localleader>gi :OmniSharpFindImplementations<cr>
     nnoremap <localleader>gt :OmniSharpFindType<cr>
     nnoremap <localleader>gs :OmniSharpFindSymbol<cr>
     nnoremap <localleader>gu :OmniSharpFindUsages<cr>
     nnoremap <localleader>gm :OmniSharpFindMembers<cr>

     " cursor can be anywhere on the line containing an issue
     nnoremap <localleader>fi  :OmniSharpFixIssue<cr>
     nnoremap <localleader>fu :OmniSharpFixUsings<cr>

     nnoremap <localleader>tl :OmniSharpTypeLookup<cr>
     " Add syntax highlighting for types and interfaces
     nnoremap <localleader>ht :OmniSharpHighlightTypes<cr>

     nnoremap <localleader>d :OmniSharpDocumentation<cr>
     "navigate up by method/property/field
     nnoremap <localleader>nk :OmniSharpNavigateUp<cr>
     "navigate down by method/property/field
     nnoremap <localleader>nj :OmniSharpNavigateDown<cr>

     " Contextual code actions (requires CtrlP or unite.vim)
     nnoremap <localleader>a :OmniSharpGetCodeActions<cr>
     " Run code actions with text selected in visual mode to extract method
     vnoremap <localleader>a :call OmniSharp#GetCodeActions('visual')<cr>

     " rename with dialog
     nnoremap <localleader>rn :OmniSharpRename<cr>
     " rename without dialog - with cursor on the symbol to rename... ':Rename newname'

     " Force OmniSharp to reload the solution. Useful when switching branches etc.
     nnoremap <localleader>rs :OmniSharpReloadSolution<cr>
     nnoremap <localleader>= :OmniSharpCodeFormat<cr>
     " Load the current .cs file to the nearest project
     nnoremap <localleader>i :OmniSharpAddToProject<cr>

     " (Experimental - uses vim-dispatch or vimproc plugin) - Start the omnisharp server for the current solution
     nnoremap <localleader>ss :OmniSharpStartServer<cr>
     nnoremap <localleader>st :OmniSharpStopServer<cr>


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
 " vim-csharp {{{

   call dein#add( 'OrangeT/vim-csharp', {'on_ft': ['cs']} )

 "}}} _vim-csharp

 " applescript
 " applescript {{{

   "call dein#add( 'vim-scripts/applescript.vim' ,     {'on_ft': ['applescript']} )
   call dein#add( 'vim-scripts/applescript.vim' )

 "}}} _applescript

 " markdown
 " vim-markdown {{{

   "call dein#add( 'tpope/vim-markdown', {'on_ft':['markdown']} )
   call dein#add( 'tpope/vim-markdown' )

 "}}} _vim-markdown

 " CSV
 call dein#add( 'chrisbra/csv.vim', {'on_ft': ['csv']} )

 " PHP
 " phpcomplete.vim {{{

   "Plug 'shawncplus/phpcomplete.vim'

 "}}} _phpcomplete.vim
 " phpcomplete-extended {{{

    "Plug 'm2mdas/phpcomplete-extended'
    "let g:phpcomplete_index_composer_command = "composer"
    "autocmd  FileType  php setlocal omnifunc=phpcomplete_extended#CompletePHP

 "}}}
  "Plug 'm2mdas/phpcomplete-extended-laravel'
  "call dein#add( 'vim-scripts/phpfolding.vim', {'on_ft': ['php']} )
 " pdv {{{

   "call dein#add( 'tobyS/vmustache', {'on_ft': ['PHP']} )
   call dein#add( 'tobyS/vmustache' )
   "call dein#add( 'tobyS/pdv', {'on_ft': ['PHP']} )
   call dein#add( 'tobyS/pdv' )
   let g:pdv_template_dir = $HOME ."/.config/nvim/plugged/pdv/templates_snip"
   nnoremap <buffer> <C-p> :call pdv#DocumentWithSnip()<CR>

 "}}} _pdv

 " phpcd.vim {{{

   call dein#add( 'phpvim/phpcd.vim', {'on_ft': ['php'], 'build': 'composer update'} )
   "call dein#add( 'vim-scripts/progressbar-widget', {'on_source': 'phpcd.vim'} ) " used for showing the index progress
   call dein#add( 'vim-scripts/progressbar-widget' )


   "Set PHP Completion options
   "autocmd FileType php setlocal completeopt+=preview | setlocal omnifunc=phpcd#CompletePHP
   autocmd FileType php setlocal completeopt+=preview | setlocal omnifunc=phpcd#CompletePHP

   "Close Omni-Completion perview tip window to close when a selection is made
   autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

   "This on may cause slowness
   "autocmd CursorMovedI * if pumvisible() == 0|pclose|endif

 "}}} _phpcd.vim
 " PHP-Indenting-for-VIm {{{

   "call dein#add( '2072/PHP-Indenting-for-VIm', {'on_ft': ['php']} )
   call dein#add( '2072/PHP-Indenting-for-VIm' )

 "}}} _PHP-Indenting-for-VIm
 " phpfolding.vim {{{

   "call dein#add( 'phpvim/phpfolding.vim', {'on_ft': ['php']} )
   call dein#add( 'phpvim/phpfolding.vim' )

 "}}} _phpfolding.vim
 " tagbar-phpctags.vim {{{

   call dein#add( 'vim-php/tagbar-phpctags.vim', {'on_ft': ['php']} )

 "}}} _tagbar-phpctags.vim

 "Go
 call dein#add( 'fatih/vim-go', {'on_ft': ['go']} )
 call dein#add( 'zchee/deoplete-go', { 'on_ft': ['go'], 'build': 'make'} )

 "Rust
 " vim-racer {{{

 call dein#add( 'racer-rust/vim-racer', {'on_ft': ['rust']} )
 let g:racer_cmd = "/Volumes/Home/.cargo/bin/racer"
 let $RUST_SRC_PATH="/Volumes/Home/Development/Applications/rust/src/"

 "}}} _vim-racer

 " blade
 " vim-blade {{{

   "call dein#add( 'xsbeats/vim-blade', {'on_ft':['blade'] } )
   call dein#add( 'xsbeats/vim-blade' )
   "au BufNewFile,BufRead *.blade.php set filetype=html
   au BufNewFile,BufRead *.blade.php set filetype=blade

 "}}}

 " Web Dev
 " breeze.vim {{{

   call dein#add( 'gcmt/breeze.vim', {'on_map':
       \   [
       \       '<Plug>(breeze-jump-tag-forward)',
       \       '<Plug>(breeze-jump-tag-backward)',
       \       '<Plug>(breeze-jump-attribute-forward)',
       \       '<Plug>(breeze-jump-attribute-backward)',
       \       '<Plug>(breeze-next-tag)',
       \       '<Plug>(breeze-prev-tag)',
       \       '<Plug>(breeze-next-attribute)',
       \       '<Plug>(breeze-prev-attribute)'
       \ ] ,
       \'on_ft': ['php', 'blade', 'html', 'xhtml', 'xml']})


   au FileType html,blade,php,xml,xhtml call MapBreezeKeys()

   function! MapBreezeKeys()
     nmap <buffer> <leader>sj <Plug>(breeze-jump-tag-forward)
     nmap <buffer> <leader>sk <Plug>(breeze-jump-tag-backward)
     nmap <buffer> <leader>sl <Plug>(breeze-jump-attribute-forward)
     nmap <buffer> <leader>sh <Plug>(breeze-jump-attribute-backward)

     nmap <buffer> <c-s><c-j> <Plug>(breeze-next-tag)
     nmap <buffer> <c-s><c-k> <Plug>(breeze-prev-tag)
     nmap <buffer> <c-s><c-l> <Plug>(breeze-next-attribute)
     nmap <buffer> <c-s><c-h> <Plug>(breeze-prev-attribute)

     " <Plug>(breeze-next-tag-hl)
     " <Plug>(breeze-prev-tag-hl)
     " <Plug>(breeze-next-attribute-hl)
     " <Plug>(breeze-prev-attribute-hl)


   endfunction

 "}}}
 " emmet {{{

   call dein#add( 'mattn/emmet-vim', {'on_ft':['html','xml','xsl','xslt','xsd','css','sass','scss','less','mustache', 'blade', 'php']} )

   let g:user_emmet_mode='a'         "enable all function in all mode.
   " let g:user_emmet_mode='i'         "enable all function in all mode.
   let g:user_emmet_leader_key='◊Ú'
   vmap <c-'><c-;>c           <Plug>(emmet-code-pretty)
   vmap <c-'><c-;>m           <Plug>(emmet-merge-lines)
   nmap <c-'><c-;>A           <Plug>(emmet-anchorize-summary)
   nmap <c-'><c-;>a           <Plug>(emmet-anchorize-url)
   nmap <c-'><c-;>k           <Plug>(emmet-remove-tag)
   nmap <c-'><c-;>j           <Plug>(emmet-split-join-tag)
   nmap <c-'><c-;>/           <Plug>(emmet-toggle-comment)
   nmap <c-'><c-;>i           <Plug>(emmet-image-size)
   nmap <c-'><c-;>N           <Plug>(emmet-move-prev)
   nmap <c-'><c-;>n           <Plug>(emmet-move-next)
   vmap <c-'><c-;>D           <Plug>(emmet-balance-tag-outword)
   nmap <c-'><c-;>D           <Plug>(emmet-balance-tag-outword)
   vmap <c-'><c-;>d           <Plug>(emmet-balance-tag-inward)
   nmap <c-'><c-;>d           <Plug>(emmet-balance-tag-inward)
   nmap <c-'><c-;>u           <Plug>(emmet-update-tag)
   nmap <c-'><c-;>;           <Plug>(emmet-expand-word)
   vmap <c-'><c-;>,           <Plug>(emmet-expand-abbr)
   nmap <c-'><c-;>,           <Plug>(emmet-expand-abbr)

 "}}}
 " vim-hyperstyle {{{

   call dein#add( 'rstacruz/vim-hyperstyle', {'on_ft': ['css']} )

 "}}} _vim-hyperstyle
 " vim-closetag {{{

    "This plugin uses > of the clos tag to work in insert mode
    "<table|   => press > to have <table>|<table>
    "press > again to have <table>|<table>
    call dein#add( 'alvan/vim-closetag', {'on_ft': ['html', 'xml', 'blade', 'php']} )
    " # filenames like *.xml, *.html, *.xhtml, ...
    let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.blade.php,*.php"


 "}}}
 " closetag {{{

   "Ctrl+_ to close next unimpared tag
   call dein#add( 'vim-scripts/closetag.vim' , {'on_ft':['html','xml','xsl','xslt','xsd', 'blade', 'php', 'blade.php']} )

 "}}}
 " MatchTagAlways {{{

   call dein#add( 'Valloric/MatchTagAlways' , {'on_ft':['html', 'php','xhtml','xml','blade']} )
   let g:mta_filetypes = {
       \ 'html' : 1,
       \ 'xhtml' : 1,
       \ 'xml' : 1,
       \ 'jinja' : 1,
       \ 'blade' : 1,
       \}
   nnoremap <leader>% :MtaJumpToOtherTag<cr>

 "}}}"Always match html tag

 " vim-ragtag {{{

  call dein#add( 'tpope/vim-ragtag', {'on_ft':['html','xml','xsl','xslt','xsd', 'blade', 'php', 'blade.php']} )
  let g:ragtag_global_maps = 1

 "}}} _vim-ragtag

 " Compilers
 " vimproc.vim {{{

   call dein#add( 'Shougo/vimproc.vim', {'build': 'make'} )

 "}}} _vimproc.vim
 " vim-dispatch {{{

   call dein#add( 'tpope/vim-dispatch' )

 "}}} _vim-dispatch
 " neomake {{{

   call dein#add( 'benekastah/neomake', {'on_cmd': ['Neomake']} )

   " autocmd! BufWritePost * Neomake
   " let g:neomake_airline = 0
   let g:neomake_error_sign = { 'text': '✘', 'texthl': 'ErrorSign' }
   let g:neomake_warning_sign = { 'text': ':(', 'texthl': 'WarningSign' }


 "}}} _neomake
 " vim-accio {{{

   call dein#add( 'pgdouyon/vim-accio', {'on_cmd': ['Accio']} )

 "}}} _vim-accio
 " syntastic {{{

 call dein#add( 'scrooloose/syntastic', {'on_cmd': ['SyntasticCheck']} )

   let g:syntastic_scala_checkers=['']
   let g:syntastic_always_populate_loc_list = 1
   let g:syntastic_check_on_open = 1
   let g:syntastic_error_symbol = "✗"
   let g:syntastic_warning_symbol = "⚠"

 "}}} _syntastic
 " vim-test {{{

   call dein#add( 'janko-m/vim-test', {'on_cmd': [ 'TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit' ]} )

 "}}} _vim-test

 " vim-fetch {{{
   call dein#add( 'kopischke/vim-fetch' )              "Fixes how vim handles FN(LN:CN)
 "}}} _vim-fetch

 "}}}
 " ----------------------------------------------------------------------------
 " Snippets {{{
 " ----------------------------------------------------------------------------

 " xptemplate {{{

   let g:xptemplate_key = '<c-\>'
   let g:xptemplate_nav_next = '<C-j>'
   let g:xptemplate_nav_prev = '<C-k>'
   call dein#add( 'drmingdrmer/xptemplate')
   set runtimepath+=/Volumes/Home/.config/nvim/xpt-personal

   "call dein#add( 'drmingdrmer/xptemplate', { 'on_func': ['XPTemplateStart', 'XPTemplatePreWrap'] })
   "inoremap  <C-\>           <C-R>=XPTemplateStart(0,{'k':'<C-\++'})<CR>
   "inoremap  <C-R><C-\>      <C-R>=XPTemplateStart(0,{'k':'<C-r++<C-\++','forcePum':1})<CR>
   "inoremap  <C-R><C-R><C-\> <C-R>=XPTemplateStart(0,{'k':'<C-r++<C-r++<C-\++','popupOnly':1})<CR>
   "snoremap  <C-\>           <C-C>`>a<C-R>=XPTemplateStart(0,{'k':'<C-\++'})<CR>
   "xnoremap  <C-\>           "0s<C-R>=XPTemplatePreWrap(@0)<CR>

 "}}}
 " UltiSnips {{{

   "Don't lazy load using go to inser mode as this makes vim very slow
   call dein#add( 'SirVer/ultisnips') ", {
        "\ 'lazy': 1,
        "\ 'on_map': [ ['i', '‰'], ['i', '<c-cr>'] ],
        "\ 'on_cmd': ['UltiSnipsEdit'],
        "\ 'hook_post_source': 'call UltiSnips#FileTypeChanged()'
        "\ })
   "au VimEnter * au! UltiSnipsFileType
   ""augroup UltiSnipsFileType
   ""    autocmd!
   ""    autocmd FileType * call UltiSnips#FileTypeChanged()
   ""augroup END

   let g:UltiSnipsEnableSnipMate = 0

   let g:UltiSnipsExpandTrigger = "‰"            "ctrl+enter
   let g:UltiSnipsJumpForwardTrigger = "‰"       "ctrl+enter
   let g:UltiSnipsJumpBackwardTrigger = "⌂"      "alt+enter

   inoremap  ‰ <C-R>=UltiSnips#ExpandSnippetOrJump()<CR>
   inoremap  <c-cr> <C-R>=UltiSnips#ExpandSnippetOrJump()<CR>
   xnoremap  ‰ :call UltiSnips#SaveLastVisualSelection()<CR>gvs
   xnoremap  <c-cr> :call UltiSnips#SaveLastVisualSelection()<CR>gvs
   snoremap  ‰ <Esc>:call UltiSnips#ExpandSnippetOrJump()<CR>
   snoremap  <c-cr> <Esc>:call UltiSnips#ExpandSnippetOrJump()<CR>

   let g:ultisnips_java_brace_style="nl"
   let g:Ultisnips_java_brace_style="nl"
   let g:UltiSnipsSnippetsDir="~/.config/nvim/UltiSnips"
   "let g:UltiSnipsSnippetDirectories = [ "/Volumes/Home/.config/nvim/plugged/vim-snippets/UltiSnips"]

 "}}}
 " vim-snippets {{{

   call dein#add( 'honza/vim-snippets', {'on_source': ['ultiSnips']} )
   "call dein#add( 'honza/vim-snippets' )

 "}}} _vim-snippets

 "}}}
 " ----------------------------------------------------------------------------
 " AutoCompletion {{{
 " ----------------------------------------------------------------------------

 "deoplete
 " deoplete.nvim {{{

 call dein#add( 'Shougo/deoplete.nvim',
       \ {
       \ 'on_event': ['InsertEnter'],
       \ 'hook_post_source' : " call deoplete#custom#set('_', 'matchers', ['matcher_full_fuzzy'])"
       \ })

   "let g:deoplete#omni_patterns = {} //This disables all features
   let g:deoplete#enable_fuzzy_completion = 1
   let g:deoplete#auto_completion_start_length = 1
   let g:deoplete#enable_at_startup = 1
   let g:deoplete#enable_ignore_case = 1
   let g:deoplete#enable_smart_case = 1
   let g:deoplete#enable_camel_case = 1
   "let g:deoplete#enable_refresh_always = 1
   let g:deoplete#max_abbr_width = 0
   let g:deoplete#max_menu_width = 0
   let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})
   let g:deoplete#omni#input_patterns.java = [ '[^. \t0-9]\.\w*', '[^. \t0-9]\->\w*', '[^. \t0-9]\::\w*', ]
   "let g:deoplete#omni#input_patterns.php = '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
   let g:deoplete#omni#input_patterns.php = [ '[^. \t0-9]\.\w*', '[^. \t0-9]\->\w*', '[^. \t0-9]\::\w*', ]
   let g:deoplete#ignore_sources = {}
   let g:deoplete#ignore_sources._ = ['javacomplete2']
   inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
   inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"
   set isfname-==

   "My Settings
   "let g:deoplete#omni#input_patterns.php = [ '[^. \t0-9]\.\w*', '[^. \t0-9]\->\w*', '[^. \t0-9]\::\w*', ]
   "let g:deoplete#sources = {}
   "let g:deoplete#sources._ = ['buffer']
   "let g:deoplete#sources.php = ['omni', 'buffer', 'ultisnips', 'tag', 'member', 'file']
   "let g:deoplete#delimiters = ['/', '.', '::', ':', '#', '->']


 "}}} _deoplete.nvim
 " neoinclude.vim {{{

   call dein#add( 'Shougo/neoinclude.vim' )

 "}}} _neoinclude.vim
 " neco-syntax {{{

   call dein#add( 'Shougo/neco-syntax' )

 "}}} _neco-syntax
 " neco-vim {{{

   call dein#add( 'Shougo/neco-vim' )

 "}}} _neco-vim
 " echodoc.vim {{{

   call dein#add( 'Shougo/echodoc.vim' )

 "}}} _echodoc.vim
 call dein#add('ujihisa/neco-look')

 " YouCompleteMe {{{
   " Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --gocode-completer --omnisharp-completer' }

   " " make YCM compatible with UltiSnips (using supertab)
   " let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
   " let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
   " let g:SuperTabDefaultCompletionType = '<C-n>'


 "}}}

 " Command line
 " ambicmd {{{

 "XXXXX
 call dein#add( 'thinca/vim-ambicmd', {'on': []} )

 "Prevent ambicmd original mapping
 let g:vim_ambicmd_mapped = 1

 cnoremap ‰ <CR>
 cnoremap <c-cr> <CR>
 function! MapAmbiCMD()
   call dein#source('vim-ambicmd')
   cnoremap <expr> <Space> ambicmd#expand("\<Space>")
   cnoremap <expr> <CR>    ambicmd#expand("\<CR>")
   call feedkeys(':', 'n')
   nnoremap ; :
 endfunction
 nnoremap <silent>; :call MapAmbiCMD()<cr>

"}}}

"}}}
 " ----------------------------------------------------------------------------
 " Operators {{{
 " ----------------------------------------------------------------------------

 " operator-usr {{{

   call dein#add( 'kana/vim-operator-user' )

   nmap <leader>oal  <Plug>(operator-align-left)
   nmap <leader>oar  <Plug>(operator-align-right)
   nmap <leader>oac  <Plug>(operator-align-center)


 "}}}

 " operator-camelize {{{

   call dein#add( 'tyru/operator-camelize.vim' )
   nmap <leader>ou <Plug>(operator-camelize)
   nmap <leader>oU <Plug>(operator-decamelize)


 "}}}

 " operator-blockwise {{{

   call dein#add( 'osyo-manga/vim-operator-blockwise', {'on_map': ['<Plug>(operator-blockwise-']} )
   nmap <leader>oY <Plug>(operator-blockwise-yank-head)
   nmap <leader>oD <Plug>(operator-blockwise-delete-head)
   nmap <leader>oC <Plug>(operator-blockwise-change-head)


 "}}}

 " operator-jerk {{{

   call dein#add( 'machakann/vim-operator-jerk' )
   nmap <leader>o>  <Plug>(operator-jerk-forward)
   nmap <leader>o>> <Plug>(operator-jerk-forward-partial)
   nmap <leader>o<  <Plug>(operator-jerk-backward)
   nmap <leader>o<< <Plug>(operator-jerk-backward-partial)


 "}}}

 "}}}
 " ----------------------------------------------------------------------------
 " text-objects {{{
 " ----------------------------------------------------------------------------
 call dein#add( 'jeetsukumaran/vim-indentwise' )

 " vim-swap {{{
   call dein#add( 'machakann/vim-swap', {'on_map': ['<Plug>(swap-'] } )
   let g:swap_no_default_key_mappings = 1
   nmap g<   <Plug>(swap-prev)
   nmap g>   <Plug>(swap-next)
   nmap g\|   <Plug>(swap-interactive)

 " _vim-swap }}}
 " argumentative {{{

   call dein#add( 'PeterRincker/vim-argumentative', {'on_map': ['<Plug>Argumentative_']} )

   "Move and manipultae arguments of a function
   nmap [; <Plug>Argumentative_Prev
   nmap ]; <Plug>Argumentative_Next
   xmap [; <Plug>Argumentative_XPrev
   xmap ]; <Plug>Argumentative_XNext
   nmap <; <Plug>Argumentative_MoveLeft
   nmap >; <Plug>Argumentative_MoveRight
   " Targets does a better job for handling args
   "============================================
   " xmap i; <Plug>Argumentative_InnerTextObject
   " xmap a; <Plug>Argumentative_OuterTextObject
   " omap i; <Plug>Argumentative_OpPendingInnerTextObject
   " omap a; <Plug>Argumentative_OpPendingOuterTextObject


 "}}}
 " argwrap {{{
   call dein#add( 'FooSoft/vim-argwrap', {'on_cmd': ['ArgWrap']} )

   nnoremap <silent> g;w :ArgWrap<CR>
   let g:argwrap_padded_braces = '[{('


 "}}}
 " sideways {{{

   call dein#add( 'AndrewRadev/sideways.vim',
                           \ {'on_cmd': ['SidewaysLeft', 'SidewaysRight',
                           \ 'SidewaysJumpLeft', 'SidewaysJumpRight']}
                           \)

   nnoremap s;k :SidewaysJumpRight<cr>
   nnoremap s;j :SidewaysJumpLeft<cr>
   nnoremap s;l :SidewaysJumpRight<cr>
   nnoremap s;h :SidewaysJumpLeft<cr>

   nnoremap c;k :SidewaysRight<cr>
   nnoremap c;j :SidewaysLeft<cr>
   nnoremap c;l :SidewaysRight<cr>
   nnoremap c;h :SidewaysLeft<cr>


 "}}}
 " vim-after-textobj {{{

   call dein#add( 'junegunn/vim-after-object' )
   " autocmd VimEnter * call after_object#enable('=', ':', '-', '#', ' ')
   " ]= and [= instead of a= and aa=
   autocmd VimEnter * call after_object#enable([']', '['], '=', ':', '-', '#', ' ', '>', '<')


 "}}}
 " targets.vim {{{

  call dein#add( 'wellle/targets.vim' )
  let g:targets_pairs = '()b {}b []b <>b'

  "for c
  "Some samples:
  " cin)   Change inside next parens
  " cil)   Change inside last parens
  " da,    Delete about comma seperated stuff [, . ; : + - = ~ _ * # / | \ & $]
  " v2i)   Select between |'s (|a(b)c|)
  " cin), cIn), can), cAn), cA), cI), cAt, A-, I-, a-, i-,
  " caa, cia => Arguments

  " Options availabel for customization:
  "=====================================
  "g:targets_aiAI
  "g:targets_nlNL
  "g:targets_pairs
  "g:targets_quotes
  "g:targets_separators
  "g:targets_tagTrigger
  "let g:targets_argTrigger="a"
  "g:targets_argOpening
  "g:targets_argClosing
  "g:targets_argSeparator
  "g:targets_seekRanges

"}}} _targets.vim

 " CamelCaseMotion {{{

   call dein#add( 'bkad/CamelCaseMotion' )

 "}}} _CamelCaseMotion

  call dein#add( 'kana/vim-textobj-user' )
  " let g:textobj_blockwise_enable_default_key_mapping =0
  " Plug 'kana/vim-niceblock'

  " vim-textobj-line does this too :)
  " Plug 'rhysd/vim-textobj-continuous-line'                "iv, av          for continuous line
  call dein#add( 'reedes/vim-textobj-sentence' )            "is, as, ), (,   For real english sentences
                                                                             "also adds g) and g( for
                                                                             "sentence navigation
  " vim-textobj-function {{{
     " Plug 'kana/vim-textobj-function'
     call PlugTextObj( 'kana/vim-textobj-function', 'f' )
     let g:textobj_function_no_default_key_mappings =1
     Map vo iF <Plug>(textobj-function-I)
     Map vo aF <Plug>(textobj-function-A)
  " }}} _vim-textobj-function
  " vim-textobj-functioncall {{{
     call PlugTextObj( 'machakann/vim-textobj-functioncall', 'C' )
     let g:textobj_functioncall_no_default_key_mappings =1
  " }}} _vim-textobj-functioncall

  "Doubles the following to avoid overlap with targets.vim
  " vim-textobj-parameter {{{
  "i,, a,  ai2,         for parameter
  call PlugTextObj( 'sgur/vim-textobj-parameter', ',' )
  Map vo i2, <Plug>(textobj-parameter-greedy-i)

  "}}} _vim-textobj-parameter
  " vim-textobj-line {{{

  "il, al          for line
  call PlugTextObj( 'kana/vim-textobj-line', 'll' )

  "}}} _vim-textobj-line
  " vim-textobj-number {{{
  "in, an          for numbers
  call PlugTextObj( 'haya14busa/vim-textobj-number', 'n' )

  "}}} _vim-textobj-number
  " vim-textobj-between {{{
  "ibX, abX                     for between two chars
  "changed to isX, asX          for between two chars
  call PlugTextObj( 'thinca/vim-textobj-between', 's' )
  let g:textobj_between_no_default_key_mappings =1

 "}}}
  " vim-textobj-any {{{
  "ia, aa          for (, {, [, ', ", <
  call PlugTextObj( 'rhysd/vim-textobj-anyblock', ';' )
  call PlugTextObj( 'rhysd/vim-textobj-anyblock', '<cr>' )
  let g:textobj_anyblock_no_default_key_mappings =1

  "}}}

  "Don't try to lazyload this (Dein lazyloaded delimited :) )
  call dein#add( 'osyo-manga/vim-textobj-blockwise' ) "<c-v>iw, cIw    for block selection

  " vim-textobj-delimited {{{

    "id, ad, iD, aD   for Delimiters takes numbers d2id
    call dein#add( 'machakann/vim-textobj-delimited', {'on_map': ['<Plug>(textobj-delimited-']} )
    Map vo id <Plug>(textobj-delimited-forward-i)
    Map vo id <Plug>(textobj-delimited-forward-i)
    Map vo ad <Plug>(textobj-delimited-forward-a)
    Map vo ad <Plug>(textobj-delimited-forward-a)
    Map vo iD <Plug>(textobj-delimited-backward-i)
    Map vo iD <Plug>(textobj-delimited-backward-i)
    Map vo aD <Plug>(textobj-delimited-backward-a)
    Map vo aD <Plug>(textobj-delimited-backward-a)
  "}}} _vim-textobj-delimited
  " vim-textobj-pastedtext {{{

    "gb              for pasted text
    call dein#add( 'saaguero/vim-textobj-pastedtext', {'on_map': ['<Plug>(textobj-pastedtext-text)']} )
    Map vo gb <Plug>(textobj-pastedtext-text)

  "}}} _vim-textobj-pastedtext
  " vim-textobj-syntax {{{

    "iy, ay          for Syntax
    call PlugTextObj( 'kana/vim-textobj-syntax', 'y' )

  "}}} _vim-textobj-syntax
  " vim-textobj-url {{{

    "iu, au          for URL
    call PlugTextObj( 'mattn/vim-textobj-url', 'u')

  "}}} _vim-textobj-url
  " vim-textobj-doublecolon {{{
    "i:, a:          for ::
    call PlugTextObj( 'vimtaku/vim-textobj-doublecolon', ':' )

  "}}} _vim-textobj-doublecolon
  " vim-textobj-comment {{{

    "ic, ac, aC  for comment
    call PlugTextObj( 'glts/vim-textobj-comment', 'c' )
    Map vo aC <Plug>(textobj-comment-big-a)

  "}}} _vim-textobj-comment
  " vim-textobj-indblock {{{

    "io, ao, iO, aO  for indented blocks
    call PlugTextObj( 'glts/vim-textobj-indblock', 'o' )
    Map vo iO <Plug>(textobj-indblock-i)
    Map vo aO <Plug>(textobj-indblock-a)

  "}}} _vim-textobj-indblock
  " vim-textobj-indent {{{

    "ii, ai, iI, aI  for Indent
    call PlugTextObj( 'kana/vim-textobj-indent', 'i' )
    Map vo iI <Plug>(textobj-indent-same-i)
    Map vo aI <plug>(textobj-indent-same-a)

  "}}} _vim-textobj-indent
  " vim-textobj-dash {{{

    "i-, a-          for dashes
    call PlugTextObj("khalidchawtany/vim-textobj-dash", "-")

  "}}} _vim-textobj-dash
  " vim-textobj-underscore {{{

    "i_, a_          for underscore
    call PlugTextObj ("lucapette/vim-textobj-underscore", "_")

  "}}} _vim-textobj-underscore
  " vim-textobj-brace {{{

    "ij, aj          for all kinds of brces
    call PlugTextObj ("Julian/vim-textobj-brace", "j")

  "}}} _vim-textobj-brace
  " vim-textobj-fold {{{
    "iz, az          for folds
    call PlugTextObj ("kana/vim-textobj-fold", "z")

  "}}} _vim-textobj-fold
  " vim-textobj-variable-segment {{{

    "iv, av          for variable segment goO|rCome
    call PlugTextObj ("Julian/vim-textobj-variable-segment", "v")

  "}}} _vim-textobj-variable-segment
  " vim-textobj-lastpat {{{

    "i/, a/, i?, a?  for Searched pattern
    call dein#add( 'kana/vim-textobj-lastpat' , {'on_map': ['<Plug>(textobj-lastpat-n)', '<Plug>(textobj-lastpat-n)']} )
    Map vo i/ <Plug>(textobj-lastpat-n)
    Map vo i? <Plug>(textobj-lastpat-N)

  "}}} _vim-textobj-lastpat
  " vim-textobj-quote {{{

  " "TODO these mappings are fake
  " "iq, aq, iQ, aQ  for Curely quotes
  " call PlugTextObj( 'reedes/vim-textobj-quote', 'q' )

  " let g:textobj#quote#educate = 0               " 0=disable, 1=enable (def) autoconvert to curely

 "}}}
  " vim-textobj-xml {{{

    "ixa, axa        for XML attributes
    call dein#add( 'akiyan/vim-textobj-xml-attribute', {'on_map': ['<Plug>(textobj-xmlattribute-']} )

    let g:textobj_xmlattribute_no_default_key_mappings=1
    Map vo ax <Plug>(textobj-xmlattribute-xmlattribute)
    Map vo ix <Plug>(textobj-xmlattribute-xmlattributenospace)


  "}}}
  " vim-textobj-path {{{

    "i|, a|, i\, a\          for Path
    call dein#add( 'paulhybryant/vim-textobj-path', {'on_map': ['<Plug>(textobj-path-']} )

    let g:textobj_path_no_default_key_mappings =1

    Map vo a\\ <Plug>(textobj-path-next_path-a)
    Map vo i\\ <Plug>(textobj-path-next_path-i)
    Map vo a\\| <Plug>(textobj-path-prev_path-a)
    Map vo i\\| <Plug>(textobj-path-prev_path-i)

  "}}}
  " vim-textobj-datetime {{{

    "igda, agda,      or dates auto
    " igdd, igdf, igdt, igdz  means
    " date, full, time, timerzone
    call dein#add( 'kana/vim-textobj-datetime', {'on_map': ['<Plug>(textobj-datetime-']} )

    let g:textobj_datetime_no_default_key_mappings=1
    Map vo agda <Plug>(textobj-datetime-auto)
    Map vo agdd <Plug>(textobj-datetime-date)
    Map vo agdf <Plug>(textobj-datetime-full)
    Map vo agdt <Plug>(textobj-datetime-time)
    Map vo agdz <Plug>(textobj-datetime-tz)

    Map vo igda <Plug>(textobj-datetime-auto)
    Map vo igdd <Plug>(textobj-datetime-date)
    Map vo igdf <Plug>(textobj-datetime-full)
    Map vo igdt <Plug>(textobj-datetime-time)
    Map vo igdz <Plug>(textobj-datetime-tz)

  "}}}
  " vim-textobj-postexpr {{{
    "ige, age        for post expression
    call PlugTextObj( 'syngan/vim-textobj-postexpr', 'ge' )
    let g:textobj_postexpr_no_default_key_mappings =1

  "}}}
  " vim-textobj-multi {{{

    call PlugTextObj( 'osyo-manga/vim-textobj-multitextobj', 'm' )

    let g:textobj_multitextobj_textobjects_i = [
          \   "\<Plug>(textobj-url-i)",
          \   "\<Plug>(textobj-multiblock-i)",
          \   "\<Plug>(textobj-function-i)",
          \   "\<Plug>(textobj-entire-i)",
          \]


  "}}}
  " vim-textobj-keyvalue {{{

    call dein#add( 'vimtaku/vim-textobj-keyvalue', {'on_map': ['<Plug>(textobj-key-', '<Plug>(textobj-value-']} )

    let g:textobj_key_no_default_key_mappings=1
    Map vo ak  <Plug>(textobj-key-a)
    Map vo ik  <Plug>(textobj-key-i)
    Map vo aK  <Plug>(textobj-value-a)
    Map vo iK  <Plug>(textobj-value-i)


  "}}}
  " vim-textobj-space {{{

    "iS, aS i<Space> for contineous spaces
    call PlugTextObj( 'saihoooooooo/vim-textobj-space', '<Space>' )
    let g:textobj_space_no_default_key_mappings =1

  "}}}
  " vim-textobj-entire {{{
    "iG, aG          for entire document
    call PlugTextObj( 'kana/vim-textobj-entire', 'G' )
    let g:textobj_entire_no_default_key_mappings =1

  "}}}
  " vim-textobj-php {{{

    "i<, a<        for <?php ?>
    call PlugTextObj( 'akiyan/vim-textobj-php', '?' )
    let g:textobj_php_no_default_key_mappings =1


  "}}}
 "}}}
 " ----------------------------------------------------------------------------
 " Navigation {{{
 " ----------------------------------------------------------------------------

 " File
 " denite.vim{{{
   call dein#add( 'Shougo/denite.nvim' )
 " }}} _dnite.vim
 " unite.vim {{{

 call dein#add( 'Shougo/unite.vim', { 'on_cmd': ['Unite', 'UniteWithCursorWord'] })
   "Plug 'Shougo/unite.vim'
   call dein#add( 'Shougo/unite-outline' )
   call dein#add( 'Shougo/unite-build' )
   call dein#add( 'Shougo/unite-help' )
   call dein#add( 'Shougo/unite-sudo' )
   call dein#add( 'Shougo/unite-session' )
   "Plug 'Shougo/neoyank.vim'   "Breaks a lazyloading on some plugins like sort-motion
   call dein#add( 'tsukkee/unite-tag' )
   " unite-bookmark-file {{{

   call dein#add( 'liquidz/unite-bookmark-file' )
   ":Unite bookmark/file
   let g:unite_bookmark_file = '~/.config/nvim/.cache/unite-bookmark-file'

   "}}} _unite-bookmark-file
   call dein#add( 'ujihisa/unite-colorscheme' )
   call dein#add( 'ujihisa/unite-locate' )
   call dein#add( 'sgur/unite-everything' )
   call dein#add( 'tacroe/unite-mark' )
   call dein#add( 'tacroe/unite-alias' )
   call dein#add( 'hakobe/unite-script' )
   call dein#add( 'soh335/unite-qflist' )
   call dein#add( 'thinca/vim-unite-history' )
   call dein#add( 'sgur/unite-qf' )
   call dein#add( 'oppara/vim-unite-cake' )
   call dein#add( 't9md/vim-unite-ack' )
   call dein#add( 'Sixeight/unite-grep' )
   call dein#add( 'kannokanno/unite-todo' )
   call dein#add( 'osyo-manga/unite-fold' )
   call dein#add( 'osyo-manga/unite-highlight' )
   " unite-fasd.vim {{{

   call dein#add( 'critiqjo/unite-fasd.vim' )
   " Path to fasd script (must be set)
   let g:unite_fasd#fasd_path = '/usr/local/bin/fasd'
   " Path to fasd cache -- defaults to '~/.fasd'
   let g:unite_fasd#fasd_cache = '~/.fasd'
   " Allow `fasd -A` on `BufRead`
   let g:unite_fasd#read_only = 0
   "Unite fasd OR Unite fasd:mru

   "}}} _unite-fasd.vim


   autocmd! User unite.vim  call SetUpUniteMenus()
   "au VimEnter * call SetUpUniteMenus()
   function! SetUpUniteMenus()

     " Enable fuzzy matching and sorting in all Unite functions
     call unite#filters#matcher_default#use(['matcher_fuzzy'])
     " call unite#filters#sorter_default#use(['sorter_rank'])
     call unite#filters#sorter_default#use(['sorter_selecta'])

     let g:unite_source_menu_menus = {} " Useful when building interfaces at appropriate places

     " More Unite menus {{{
     " Interface for OS interaction
     let g:unite_source_menu_menus.osinteract = {
           \ 'description' : 'OS interaction and configs',
           \}
     let g:unite_source_menu_menus.osinteract.command_candidates = [
           \[' alternate file', 'A'],
           \[' generate tags in buffer dir', 'cd %:p:h | Dispatch! ctags .'],
           \[' cd to buffer directory', 'cd %:p:h'],
           \[' cd to project directory', 'Rooter'],
           \[' create .projections.json', 'cd %:p:h | e .projections.json'],
           \[' Battery status', 'Unite -buffer-name=ubattery output:echo:system("~/battery")'],
           \[' Scratch notes', 'Unite -buffer-name=unotes -start-insert junkfile'],
           \[' Source vimrc', 'so $MYVIMRC'],
           \[' Edit vimrc', 'e $MYVIMRC'],
           \]
     nnoremap <silent> ÚÚ<c-l> :Unite -silent -buffer-name=osinteract -quick-match menu:osinteract<CR>
     nnoremap <silent> <c-;><c-;><c-l> :Unite -silent -buffer-name=osinteract -quick-match menu:osinteract<CR>
     "}}}

   endfunction



   let g:unite_data_directory=$HOME.'/.config/nvim/.cache/unite'

   " Execute help.
   nnoremap ÚÚh  :<C-u>Unite -start-insert help<CR>
   nnoremap <c-;><c-;>h  :<C-u>Unite -start-insert help<CR>
   nnoremap ÚÚ‰  :<C-u>Unite -start-insert command<CR>
   nnoremap ÚÚ<c-cr>  :<C-u>Unite -start-insert command<CR>
   nnoremap <c-;><c-;>‰  :<C-u>Unite -start-insert command<CR>
   nnoremap <c-;><c-;><c-cr>  :<C-u>Unite -start-insert command<CR>
   " Execute help by cursor keyword.
   nnoremap <silent> ÚÚ<C-h>  :<C-u>UniteWithCursorWord help<CR>
   nnoremap <silent> <c-;><c-;><C-h>  :<C-u>UniteWithCursorWord help<CR>

   "call unite#custom#source('buffer,file,file_rec',
   "\ 'sorters', 'sorter_length')

   let g:unite_force_overwrite_statusline = 0
   let g:unite_winheight = 10
   let g:unite_data_directory='~/.config/nvim/.cache/unite'
   let g:unite_enable_start_insert=1
   let g:unite_source_history_yank_enable=1
   let g:unite_prompt='» '
   let g:unite_split_rule = 'botright'

   if executable('ag')
     let g:unite_source_grep_command='ag'
     let g:unite_source_grep_default_opts='--nocolor --nogroup -S -C4'
     let g:unite_source_grep_recursive_opt=''
     let g:unite_source_rec_async_command=['ag --nocolor --nogroup --ignore ".hg" --ignore ".svn" --ignore ".git" --ignore ".bzr" --hidden -g ""']
   endif

   " Custom mappings for the unite buffer
   autocmd FileType unite call s:unite_settings()
   function! s:unite_settings()
     " Play nice with supertab
     let b:SuperTabDisabled=1
     " Enable navigation with control-j and control-k in insert mode
     imap <buffer> <C-j>   <Plug>(unite_select_next_line)
     imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
     nmap <buffer> <bs> <Plug>(unite_delete_backward_path)
     nmap <silent> <buffer> <esc> <Plug>(unite_all_exit) " Close Unite view
   endfunction

   function! Open_current_file_dir(args)
     let [args, options] = unite#helper#parse_options_args(a:args)
     let path = expand('%:h')
     let options.path = path
     call unite#start(args, options)
   endfunction

   nnoremap ÚÚcd :call Open_current_file_dir('-no-split file')<cr>
   nnoremap <c-;><c-;>cd :call Open_current_file_dir('-no-split file')<cr>

   "CtrlP & NerdTree combined
   nnoremap <silent> ÚÚF :Unite -auto-resize file/async  file_rec/async<cr>
   nnoremap <silent> <c-;><c-;>F :Unite -auto-resize file/async  file_rec/async<cr>
   nnoremap <silent> ÚÚf :Unite -auto-resize file_rec/async<cr>
   nnoremap <silent> <c-;><c-;>f :Unite -auto-resize file_rec/async<cr>
   nnoremap <silent> ÚÚ<c-f> :Unite -auto-resize file_rec/async<cr>
   nnoremap <silent> <c-;><c-;><c-f> :Unite -auto-resize file_rec/async<cr>

   nnoremap <silent> ÚÚd :Unite -auto-resize directory_rec/async<cr>
   nnoremap <silent> <c-;><c-;>d :Unite -auto-resize directory_rec/async<cr>
   nnoremap <silent> ÚÚo :Unite -auto-resize file_mru<cr>
   nnoremap <silent> <c-;><c-;>o :Unite -auto-resize file_mru<cr>

   nnoremap <silent> ÚÚl :Unite -auto-resize outline<cr>
   nnoremap <silent> <c-;><c-;>l :Unite -auto-resize outline<cr>

   "Grep commands
   nnoremap <silent> ÚÚg :Unite -auto-resize grep:.<cr>
   nnoremap <silent> <c-;><c-;>g :Unite -auto-resize grep:.<cr>
   nnoremap <silent> ÚÚ<c-g> :Unite -auto-resize grep:/<cr>
   nnoremap <silent> <c-;><c-;><c-g> :Unite -auto-resize grep:/<cr>
   "Content search like Ag anc Ack
   nnoremap ÚÚ/ :Unite grep:.<cr>
   nnoremap <c-;><c-;>/ :Unite grep:.<cr>

   "Hostory & YankRing
   let g:unite_source_history_yank_enable = 1
   nnoremap ÚÚy :Unite history/yank<cr>
   nnoremap <c-;><c-;>y :Unite history/yank<cr>
   nnoremap ÚÚ: :Unite history/command<cr>
   nnoremap <c-;><c-;>: :Unite history/command<cr>
   nnoremap ÚÚ/ :Unite history/search<cr>
   nnoremap <c-;><c-;>/ :Unite history/search<cr>

   nnoremap ÚÚ? :Unite mapping<cr>
   nnoremap <c-;><c-;>? :Unite mapping<cr>

   "LustyJuggler
   nnoremap ÚÚb :Unite -quick-match buffer<cr>
   nnoremap <c-;><c-;>b :Unite -quick-match buffer<cr>
   nnoremap ÚÚ<c-b> :Unite buffer<cr>
   nnoremap <c-;><c-;><c-b> :Unite buffer<cr>

   "LustyJuggler
   nnoremap ÚÚt :Unite -quick-match tab<cr>
   nnoremap <c-;><c-;>t :Unite -quick-match tab<cr>
   nnoremap ÚÚ<c-t> :Unite tab<cr>
   nnoremap <c-;><c-;><c-t> :Unite tab<cr>

   "Line Search
   nnoremap ÚÚl :Unite line<cr>
   nnoremap <c-;><c-;>l :Unite line<cr>
   nnoremap ÚÚL :Unite -quick-match line<cr>
   nnoremap <c-;><c-;>L :Unite -quick-match line<cr>

 "}}} _unite.vim
 " ctrlp.vim {{{

   " " Plug 'kien/ctrlp.vim'
   " Plug 'ctrlpvim/ctrlp.vim', {'on': ['CtrlP']}
   " Plug 'sgur/ctrlp-extensions.vim'
   " Plug 'fisadev/vim-ctrlp-cmdpalette'
   " Plug 'ivalkeen/vim-ctrlp-tjump'
   " Plug 'suy/vim-ctrlp-commandline'
   " Plug 'tacahiroy/ctrlp-funky'
   " Plug '/Volumes/Home/.config/nvim/plugged/ctrlp-my-notes'    "Locate my notes
   " Plug '/Volumes/Home/.config/nvim/plugged/ctrlp-dash-helper' "dash helper
   " Plug 'JazzCore/ctrlp-cmatcher'                       "ctrl-p matcher
   " " Plug 'FelikZ/ctrlp-py-matcher'                     "ctrl-p matcher
   " " Plug 'nixprime/cpsm'                               "ctrl-p matcher

   " command! CtrlPCommandLine call ctrlp#init(ctrlp#commandline#id())
   " cnoremap <silent> <C-p> <C-c>:call ctrlp#init(ctrlp#commandline#id())<CR>

   " "'vim-ctrlp-tjump',
   " let g:ctrlp_extensions = [
         " \ 'tag', 'buffertag', 'quickfix', 'dir', 'rtscript', 'dashhelper',
         " \ 'vimnotes', 'undo', 'line', 'changes', 'mixed', 'bookmarkdir',
         " \ 'funky', 'commandline'
         " \ ]

   " "Open window in NERDTree if available
   " let g:ctrlp_reuse_window = 'netrw\|help\|NERD\|startify'

   " " Make Ctrl+P indexing faster by using ag silver searcher
   " let g:ctrlp_lazy_update = 350

   " "Enable caching to make it fast
   " let g:ctrlp_use_caching = 1

   " "Don't clean cache on exit else it will take alot to regenerate RTP
   " let g:ctrlp_clear_cache_on_exit = 0

   " let g:ctrlp_cache_dir = $HOME.'/.config/nvim/.cache/ctrlp'

   " let g:ctrlp_max_files = 0
   " if executable("ag")
     " set grepprg=ag\ --nogroup\ --nocolor
     " let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
           " \ --ignore .git
           " \ --ignore .svn
           " \ --ignore .hg
           " \ --ignore .DS_Store
           " \ --ignore "**/*.pyc"
           " \ --ignore vendor
           " \ --ignore node_modules
           " \ -g ""'

   " endif

   " let g:ctrlp_switch_buffer = 'e'

   " "When I press C-P run CtrlP from root of my project regardless of the current
   " "files path
   " let g:ctrlp_cmd='CtrlPRoot'
   " let g:ctrlp_map = '<c-p><c-p>'

   " " Make Ctrl+P matching faster by using pymatcher
   " " let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
   " let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
   " " let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}

   " nnoremap <c-p>j :CtrlPtjump<cr>
   " vnoremap <c-p>j :CtrlPtjumpVisual<cr>
   " nnoremap <c-p>b :CtrlPBuffer<cr>
   " nnoremap <c-p>cd :CtrlPDir .<cr>
   " nnoremap <c-p>d :CtrlPDir<cr>
   " nnoremap <c-p><c-[> :CtrlPFunky<Cr>
   " nnoremap <c-p><c-]> :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
   " nnoremap <c-p>f :execute ":CtrlP " . expand('%:p:h')<cr>
   " "nnoremap <c-p>m :CtrlPMixed<cr>
   " nnoremap <c-p>q :CtrlPQuickfix<cr>
   " nnoremap <c-p>y :CtrlPYankring<cr>
   " "nnoremap <c-p>r :CtrlPRoot<cr>
   " nnoremap <c-p>w :CtrlPCurWD<cr>

   " nnoremap <c-p>t :CtrlPTag<cr>
   " nnoremap <c-p>[ :CtrlPBufTag<cr>
   " nnoremap <c-p>] :CtrlPBufTagAll<cr>
   " nnoremap <c-p>u :CtrlPUndo<cr>
   " " nnoremap <c-p>\\ :CtrlPRTS<cr>
   " ""nnoremap <c-p><CR> :CtrlPCmdline<cr>
   " nnoremap <c-p>; :CtrlPCmdPalette<cr>
   " nnoremap <c-p><CR> :CtrlPCommandLine<cr>
   " nnoremap <c-p><BS> :CtrlPClearCache<cr>
   " nnoremap <c-p><Space> :CtrlPClearAllCache<cr>
   " nnoremap <c-p>p :CtrlPLastMode<cr>
   " nnoremap <c-p>i :CtrlPChange<cr>
   " nnoremap <c-p><c-i> :CtrlPChangeAll<cr>
   " nnoremap <c-p>l :CtrlPLine<cr>
   " nnoremap <c-p>` :CtrlPBookmarkDir<cr>
   " nnoremap <c-p>@ :CtrlPBookmarkDirAdd<cr>
   " nnoremap <c-p>o :CtrlPMRU<cr>

   " let g:ctrlp_prompt_mappings = {
         " \ 'PrtBS()':              ['<bs>', '<c-]>'],
         " \ 'PrtDelete()':          ['<del>'],
         " \ 'PrtDeleteWord()':      ['<c-w>'],
         " \ 'PrtClear()':           ['<c-u>'],
         " \ 'PrtSelectMove("j")':   ['<c-j>', '<down>'],
         " \ 'PrtSelectMove("k")':   ['<c-k>', '<up>'],
         " \ 'PrtSelectMove("t")':   ['<Home>', '<kHome>'],
         " \ 'PrtSelectMove("b")':   ['<End>', '<kEnd>'],
         " \ 'PrtSelectMove("u")':   ['<PageUp>', '<kPageUp>'],
         " \ 'PrtSelectMove("d")':   ['<PageDown>', '<kPageDown>'],
         " \ 'PrtHistory(-1)':       ['<c-n>'],
         " \ 'PrtHistory(1)':        ['<c-p>'],
         " \ 'AcceptSelection("e")': ['<cr>', '<2-LeftMouse>'],
         " \ 'AcceptSelection("h")': ['<c-x>', '<c-cr>', '<c-s>'],
         " \ 'AcceptSelection("t")': ['<c-t>'],
         " \ 'AcceptSelection("v")': ['<c-v>', '<RightMouse>'],
         " \ 'ToggleFocus()':        ['<s-tab>'],
         " \ 'ToggleRegex()':        ['<c-r>'],
         " \ 'ToggleByFname()':      ['<c-d>'],
         " \ 'ToggleType(1)':        ['<c-f>'],
         " \ 'ToggleType(-1)':       ['<c-b>'],
         " \ 'PrtExpandDir()':       ['<tab>'],
         " \ 'PrtInsert("c")':       ['<MiddleMouse>', '<insert>'],
         " \ 'PrtInsert()':          ['<c-\>'],
         " \ 'PrtCurStart()':        ['<c-a>'],
         " \ 'PrtCurEnd()':          ['<c-e>'],
         " \ 'PrtCurLeft()':         ['<c-h>', '<left>', '<c-^>'],
         " \ 'PrtCurRight()':        ['<c-l>', '<right>'],
         " \ 'PrtClearCache()':      ['<F5>', 'ÚÚ'],
         " \ 'PrtClearCache()':      ['<F5>', '<c-;><c-;>'],
         " \ 'PrtDeleteEnt()':       ['<F7>'],
         " \ 'CreateNewFile()':      ['<c-y>'],
         " \ 'MarkToOpen()':         ['<c-z>'],
         " \ 'OpenMulti()':          ['<c-o>'],
         " \ 'PrtExit()':            ['<esc>', '<c-c>', '<c-g>'],
         " \ }

 "}}} _ctrlp.vim
 " FZF {{{
   "call dein#add('junegunn/fzf', { 'on_source': ['fzf.vim'] })
   "call dein#add('junegunn/fzf', { 'build': './install -all', 'rtp': '' })
   "call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })

    let g:fzf_layout = { 'window': 'execute (tabpagenr()-1)."tabnew"' }

    let $FZF_DEFAULT_OPTS="--bind '::jump,;:jump-accept'"

    let $FZF_DEFAULT_COMMAND='ag -l -g ""'
    "set rtp+=/usr/local/Cellar/fzf/HEAD
    set rtp+=/usr/local/opt/fzf
    call dein#add( 'junegunn/fzf.vim',
          \ {
          \   'on_map':
          \ [
          \   '<plug>(fzf-',
          \   ['i', '<plug>(fzf-complete-word)'],
          \   ['i', '<plug>(fzf-complete-path)'],
          \   ['i', '<plug>(fzf-complete-file-ag)'],
          \   ['i', '<plug>(fzf-complete-line)'],
          \   ['i', '<plug>(fzf-complete-buffer-line)'],
          \   ['i', '<plug>(fzf-complete-file)']
          \ ],
          \   'on_cmd': ['Files', 'GitFiles', 'Buffers', 'Colors', 'Ag', 'Lines',
          \               'BLines', 'Tags', 'BTags', 'Maps', 'Marks', 'Windows',
          \               'Locate', 'History', 'History:', 'History/', 'Snippets',
          \               'Commits', 'BCommits', 'Commands', 'Helptags']
          \ })

   " [Buffers] Jump to the existing window if possible
   let g:fzf_buffers_jump = 1

   " Command          | List
   " ---              | ---
   " `Files [PATH]`   | Files (similar to `:FZF`)
   " `GitFiles`       | Git files
   " `Buffers`        | Open buffers
   " `Colors`         | Color schemes
   " `Ag [PATTERN]`   | [ag][ag] search result (`ALT-A` to select all, `ALT-D` to deselect all)
   " `Lines`          | Lines in loaded buffers
   " `BLines`         | Lines in the current buffer
   " `Tags [QUERY]`   | Tags in the project (`ctags -R`)
   " `BTags [QUERY]`  | Tags in the current buffer
   " `Marks`          | Marks
   " `Windows`        | Windows
   " `Locate PATTERN` | `locate` command output
   " `History`        | `v:oldfiles` and open buffers
   " `History:`       | Command history
   " `History/`       | Search history
   " `Snippets`       | Snippets ([UltiSnips][us])
   " `Commits`        | Git commits (requires [fugitive.vim][f])
   " `BCommits`       | Git commits for the current buffer
   " `Commands`       | Commands
   " `Maps`           | Normal mode mappings
   " `Helptags`       | Help tags <sup id="a1">[1](#helptags)</sup>
   " `Filetypes`      | File types

   function! s:find_git_root()
     return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
   endfunction

   function! Map_FZF(cmd, key, options, cword)
     exe "nnoremap <c-p><c-" . a:key . "> :" . a:cmd . a:options . "<cr>"
    "This type is where no args passed
     if a:cword == 0
       exe "nnoremap <c-p>" . a:key . " :" . a:cmd . a:options . "<cr>"

    "This type is where -q used pass args
     elseif a:cword == 1
       exe "nnoremap <c-p>" . a:key . " :" . a:cmd . a:options .
             \ " -q <c-r>=shellescape(expand('<cword>'))<cr>" . "<cr>"
       exe "vnoremap <c-p>" . a:key . " :<c-u>" . a:cmd . a:options .
             \ " -q <c-r>=shellescape(GetVisualSelection())<cr>" . "<cr>"

    "This type is where 'word DOES produce results
     elseif a:cword == 2
       exe "nnoremap <c-p>" . a:key . " :" . a:cmd . a:options .
             \ " '<c-r>=expand('<cword>')<cr><cr>"
       exe "vnoremap <c-p>" . a:key . " :<c-u>" . a:cmd . a:options .
             \ " '<c-r>=GetVisualSelection()<cr><cr>"

    "This type is where 'word does NOT produce results
     elseif a:cword == 3
       exe "nnoremap <c-p>" . a:key . " :" . a:cmd . a:options .
             \ " <c-r>=expand('<cword>')<cr><cr>"
       exe "vnoremap <c-p>" . a:key . " :<c-u>" . a:cmd . a:options .
             \ " <c-r>=GetVisualSelection()<cr><cr>"
     endif
     exe "tnoremap <c-p><c-" . a:key . "> <c-\\><c-n>:" . a:cmd . a:options "<cr>"

   endfunction


  "call Map_FZF("COMMAND", "KEY", "OPTIONS"                             , cw )
   call Map_FZF("FZF! ", "d", " --reverse %:p:h "                       ,  0 )
   call Map_FZF("FZF! ", "r", " --reverse <c-r>=FindGitDirOrRoot()<cr>" ,  0 )
   call Map_FZF("FZF! ", "p", " --reverse"                              ,  1 )
   call Map_FZF("Buffers", "b", ""                                      ,  0 )
   call Map_FZF("Ag!", "a", ""                                          ,  3 )
   call Map_FZF("Lines!", "L", ""                                       ,  2 )
   call Map_FZF("BLines!", "l", ""                                      ,  2 )
   call Map_FZF("BTags!", "t", ""                                       ,  0 )
   call Map_FZF("Tags!", "]", ""                                        ,  0 )
   "call Map_FZF("Locate", "<cr>", "--reverse  %:p:h"                   ,  0 )
   call Map_FZF("GitFiles", "v", ""                                     ,  0 )
   call Map_FZF("Commits!", "g", ""                                     ,  0 )
   call Map_FZF("BCommits!", "G", ""                                    ,  0 )
   call Map_FZF("Snippets!", "s", ""                                    ,  0 )
   call Map_FZF("Marks!", "◊", ""                                       ,  0 )
   call Map_FZF("Marks!", "'", ""                                       ,  0 )
   call Map_FZF("Windows!", "w", ""                                     ,  0 )
   call Map_FZF("Helptags!", "k", ""                                    ,  0 )


   "nmap <c-p><c-i> <plug>(fzf-maps-n)
   nnoremap <c-p><c-m> :Maps!<cr>
   xmap <c-p><c-m> <plug>(fzf-maps-x)
   omap <c-p><c-m> <plug>(fzf-maps-o)

   imap <c-x><c-k> <plug>(fzf-complete-word)
   imap <c-x><c-f> <plug>(fzf-complete-path)
   imap <c-x><c-a> <plug>(fzf-complete-file-ag)
   imap <c-x><c-l> <plug>(fzf-complete-line)
   imap <c-x><c-i> <plug>(fzf-complete-buffer-line)
   imap <c-x><c-\> <plug>(fzf-complete-file)

   function GetDirectories()
     call fzf#run({"source":"ag -l --nocolor -g \"\" | awk 'NF{NF-=1};1' FS=/ OFS=/ | sort -u | uniq" , "sink":"NERDTree"})
    "find . -type d   -not -iwholename \"./.phpcd*\" -not -iwholename \"./node_modules*\" -not -iwholename \".\" -not -iwholename \"./vendor*\" -not -iwholename \"./.git*\"
    "ag -l --nocolor -g "" | awk 'NF{NF-=1};1' FS=/ OFS=/ | sort -u | uniq
   endfunction
   nnoremap <c-p>[ :call fzf#run({"source":"find . -type d", "sink":"NERDTree"})<cr>
   nnoremap <silent> <c-p><c-[> :cal GetDirectories()<cr>

   " Replace the default dictionary completion with fzf-based fuzzy completion
   " inoremap <expr> <c-x><c-k> fzf#complete('cat /usr/share/dict/words')

   function! PrintPathFunction(myParam)
     execute ":normal i".a:myParam
   endfunction
   command! -nargs=1 PrintPath call PrintPathFunction(<f-args>)

   function! PrintPathInNextLineFunction(myParam)
     put=a:myParam
   endfunction

   command! -nargs=1 PrintPathInNextLine call PrintPathInNextLineFunction(<f-args>)

   let g:fzf_action = {
         \ 'ctrl-m': 'e!',
         \ 'ctrl-t': 'tabedit!',
         \ 'ctrl-x': 'split',
         \ 'ctrl-o': 'PrintPathInNextLine',
         \ 'ctrl-i': 'PrintPath',
         \ 'ctrl-v': 'vsplit' }

   " Tabs {{{
   function! s:tablist()
     redir => tabs
     silent tabs
     redir END
     let new_tabs = filter(split(tabs, '\n'), 'v:val =~ "Tab page"')
     let i = 0
     while i < len(new_tabs)
       let current_tab_buffers = map(tabpagebuflist(i + 1), "bufname(v:val)")
       let current_tab_buffers = map(current_tab_buffers, "substitute(v:val, 'term:.*', ':term:', '') ")
       let current_tab_buffers = map(current_tab_buffers, "substitute(v:val, '^.*/', '', '')")
       let new_tabs[i] = new_tabs[i] . '             '.join(current_tab_buffers, ' | ')
       let i = i + 1
     endwhile
     return new_tabs
   endfunction

   function! s:tabopen(e)
     "echomsg 'bufname='bufname("")
     "echomsg ':normal! '. matchstr(a:e, 'Tab page \zs[0-9]*\ze .*$').'gt'
     "execute 'normal! ' . matchstr(a:e, 'Tab page \zs[0-9]*\ze .*$').'gt'
     execute ':tabnext ' . matchstr(a:e, 'Tab page \zs[0-9]*\ze .*$')
     "let g:fzf_cmd='normal! ' . matchstr(a:e, 'Tab page \zs[0-9]*\ze .*$').'gt'
     "call timer_start(50, '<sid>SwitchTab', {'repeat': 1})
   endfunction
   "func! s:SwitchTab(timer)
   "execute g:fzf_cmd
   "endfunc

   tmap <c-p><c-i> <c-\><c-n><c-p><c-i>

   nnoremap <silent> <c-p><c-i> :call fzf#run({
         \   'source':  reverse(<sid>tablist()),
         \   'sink':    function('<sid>tabopen'),
         \   'options': " --preview-window right:50%  --preview 'echo {}'  --bind ?:toggle-preview",
         \   'down':    len(<sid>tablist()) + 2
         \ })<cr>

   "}}} _Tabs

   "open_buffers -term {{{
   function! s:buflist()
     redir => ls
     silent ls
     redir END
     "get all buffers excpt the ones that has term:// in them
     return  filter(split(ls, '\n'), 'v:val !~ "term://"')
   endfunction

   function! s:bufopen(e)
     execute 'buffer' matchstr(a:e, '^[ 0-9]*')
   endfunction

   nnoremap <silent> <c-p><c-o> :call fzf#run({
         \   'source':  reverse(<sid>buflist()),
         \   'sink':    function('<sid>bufopen'),
         \   'options': '+m',
         \   'down':    len(<sid>buflist()) + 2
         \ })<CR>

   "}}} _open_buffers -term

   "open_terms {{{
   function! s:termlist()
     redir => ls
     silent ls!
     redir END
     "get term:// buffers
     return  filter(filter(split(ls, '\n'), 'v:val =~ "term://"'), 'v:val !~ "fzf"')
   endfunction

   function! s:termtabopen(e)
     let l:term_buffer_id = str2nr(matchstr(a:e, '^[ 0-9]*'))
     echomsg l:term_buffer_id
     let l:buffers_parent_tab = -1
			for i in range(tabpagenr('$'))
			   if (index(tabpagebuflist(i + 1), l:term_buffer_id) >= 0)
           let l:buffers_parent_tab = i + 1
         endif
			endfor
      if (buffers_parent_tab >= 0)
        execute "tabnext " l:buffers_parent_tab
        execute bufwinnr(l:term_buffer_id) "wincmd w"
      else
        execute 'buffer' l:term_buffer_id
      endif
   endfunction
   nnoremap <silent> <c-p><c-;> :call fzf#run({
         \   'source':  reverse(<sid>termlist()),
         \   'sink':    function('<sid>termtabopen'),
         \   'options': '+m',
         \   'down':    len(<sid>termlist()) + 2
         \ })<CR>

   "}}} _open_terms

 " }}}
 " }}}

 " ranger.vim {{{

   call dein#add( 'francoiscabrol/ranger.vim' )
   call dein#add( 'rbgrouleff/bclose.vim' )
   let g:ranger_map_keys = 0
   nnoremap <leader>fr :call OpenRanger()<CR>

 "}}} _ranger.vim
 " vim-dirvish {{{

   call dein#add( 'justinmk/vim-dirvish' )         " {-} file browser

 "}}} _vim-dirvish
 " vim-vinegar {{{

   call dein#add( 'tpope/vim-vinegar' )           

 "}}} _vim-vinegar
 " vimfiler.vim {{{
       "\     'on_map': [['n', '<Plug>']],
 call dein#add( 'Shougo/vimfiler.vim', {
       \     'depends': 'unite.vim',
       \     'on_cmd': ['VimFiler', 'VimFilerBufferDir', 'VimFilerCurrentDir']
       \ })
  "let g:loaded_netrw       = 1 "Disable Netrw
  "let g:loaded_netrwPlugin = 1 "Disable Netrw
  let g:vimfiler_as_default_explorer=1

  let g:vimfiler_ignore_pattern=[ '\.ncb$', '\.suo$', '\.vcproj\.RIMNET', '\.obj$',
        \ '\.ilk$', '^BuildLog.htm$', '\.pdb$', '\.idb$',
        \ '\.embed\.manifest$', '\.embed\.manifest.res$',
        \ '\.intermediate\.manifest$', '^mt.dep$', '^.OpenIDE$', '^.git$', '^TestResult.xml$', '^.paket$', '^paket.dependencies$','^paket.lock$', '^paket.template$', '^.agignore$', '^.AutoTest.config$',
        \ '^.gitignore$', '^.idea$' , '^tags$']

  "Force vimfiler Enter to toggle expand/collapse
  autocmd! FileType vimfiler call s:my_vimfiler_settings()
  function! s:my_vimfiler_settings()
    nmap <silent><buffer> <cr> <Plug>(vimfiler_expand_or_edit)
    nmap <silent><buffer> <cr> <Plug>(vimfiler_expand_or_edit)
  endfunction

  au User vimfiler.vim call MapVimFiler()

  function! MapVimFiler()
    nnoremap <silent> Ú<c-l><c-l> :VimFiler -simple -split -winwidth=33 -force-hide<cr>
    nnoremap <silent> <c-;><c-l><c-l> :VimFiler -simple -split -winwidth=33 -force-hide<cr>
    nnoremap <silent> Ú<c-l><c-f> :VimFilerBufferDir -simple -split -winwidth=33 -force-hide<cr>
    nnoremap <silent> <c-;><c-l><c-f> :VimFilerBufferDir -simple -split -winwidth=33 -force-hide<cr>
    nnoremap <silent> Ú<c-l><c-d> :VimFilerCurrentDir -simple -split -winwidth=33 -force-hide<cr>
    nnoremap <silent> <c-;><c-l><c-d> :VimFilerCurrentDir -simple -split -winwidth=33 -force-hide<cr>
  endfunction

 "}}} _vimfiler.vim
 " NERDTree {{{

   call dein#add( 'scrooloose/nerdtree', {'on_cmd':  ['NERDTreeToggle', 'NERDTreeCWD', 'NERDTreeFind', 'NERDTree'] } )
   "Plug 'scrooloose/nerdtree'
  "Plug 'jistr/vim-nerdtree-tabs'

   "let g:loaded_netrw       = 1 "Disable Netrw
   "let g:loaded_netrwPlugin = 1 "Disable Netrw

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
   " nnoremap <c-;><c-l> :NERDTreeTabsToggle<cr>
   nnoremap Ú<c-l><c-l> :NERDTreeToggle<cr>
   nnoremap <c-;><c-l><c-l> :NERDTreeToggle<cr>
   nnoremap Ú<c-l><c-d> :NERDTreeCWD<cr>
   nnoremap <c-;><c-l><c-d> :NERDTreeCWD<cr>
   nnoremap Ú<c-l><c-f> :NERDTreeFind<cr>
   nnoremap <c-;><c-l><c-f> :NERDTreeFind<cr>


   function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
     exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
     exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
   endfunction

   call NERDTreeHighlightFile('jade', 'green', 'none', 'green', 'none')
   call NERDTreeHighlightFile('md', 'blue', 'none', '#6699CC', 'none')
   call NERDTreeHighlightFile('config', 'yellow', 'none', '#d8a235', 'none')
   call NERDTreeHighlightFile('conf', 'yellow', 'none', '#d8a235', 'none')
   call NERDTreeHighlightFile('json', 'green', 'none', '#d8a235', 'none')
   call NERDTreeHighlightFile('html', 'yellow', 'none', '#d8a235', 'none')
   call NERDTreeHighlightFile('css', 'cyan', 'none', '#5486C0', 'none')
   call NERDTreeHighlightFile('scss', 'cyan', 'none', '#5486C0', 'none')
   call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', 'none')
   call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', 'none')
   call NERDTreeHighlightFile('ts', 'Blue', 'none', '#6699cc', 'none')
   call NERDTreeHighlightFile('ds_store', 'Gray', 'none', '#686868', 'none')
   call NERDTreeHighlightFile('gitconfig', 'black', 'none', '#686868', 'none')
   call NERDTreeHighlightFile('gitignore', 'Gray', 'none', '#7F7F7F', 'none')

 "}}}

 " vim-projectionist {{{

 " Plug 'tpope/vim-projectionist'

 "}}} _vim-projectionist
 " vim-dotenv {{{

   call dein#add( 'tpope/vim-dotenv', {'on_cmd':['Dotenv']} )

 "}}} _vim-dotenv

 " Content
 " vim-evanesco {{{

 " "may replace vim-oblique one day :)

 " " Plug 'pgdouyon/vim-evanesco'
 " Plug 'khalidchawtany/vim-evanesco'
 " autocmd! user Evanesco       AnzuUpdateSearchStatusOutput
 " autocmd! user EvanescoStar   AnzuUpdateSearchStatusOutput
 " autocmd! user EvanescoRepeat AnzuUpdateSearchStatusOutput

 "}}} _vim-evanesco

 " vim-pseudocl {{{

   call dein#add( 'junegunn/vim-pseudocl' ) "Required by oblique & fnr

 "}}} _vim-pseudocl

 " incsearch.vim {{{

 call dein#add( 'haya14busa/incsearch.vim' )
 call dein#add( 'haya14busa/incsearch-fuzzy.vim' )
 "Many more options Look at HELP
 "map /  <Plug>(incsearch-forward)
 "map ?  <Plug>(incsearch-backward)
 "map g/ <Plug>(incsearch-stay)

 "}}} _incsearch.vim
 " vim-oblique {{{
 let g:oblique#enable_cmap=0
 call dein#add( 'junegunn/vim-oblique', {'on_map': [ '<Plug>(Oblique-' ]} )


 Map nx  #  <Plug>(Oblique-#)
 Map nx  *  <Plug>(Oblique-*)
 Map nox /  <Plug>(Oblique-/)
 Map nox ?  <Plug>(Oblique-?)
 Map n   g# <Plug>(Oblique-g#)
 Map n   g* <Plug>(Oblique-g*)
 Map nox z/ <Plug>(Oblique-F/)
 Map nox z? <Plug>(Oblique-F?)

 "Make n/N move forward/backwards regardless of search direction
 "Map nx  n  <Plug>(Oblique-n)
 "Map nx  N  <Plug>(Oblique-N)
 "noremap <expr> n 'Nn'[v:searchforward]
 "noremap <expr> N 'nN'[v:searchforward]
 nmap <expr>n ['<Plug>(Oblique-N)','<Plug>(Oblique-n)'][v:searchforward]
 nmap <expr>N ['<Plug>(Oblique-n)','<Plug>(Oblique-N)'][v:searchforward]

 autocmd! User Oblique       AnzuUpdateSearchStatusOutput
 autocmd! User ObliqueStar   AnzuUpdateSearchStatusOutput
 autocmd! User ObliqueRepeat AnzuUpdateSearchStatusOutput

 let g:oblique#enable_cmap=0

 "}}}
 "scalpel {{{
   call dein#add('wincent/scalpel', {'on_cmd': ['Scalpel'], 'on_map': ['<Plug>(Scalpel)']})
   nmap  g;r <Plug>(Scalpel)
 "}}} _scalpel

 " IndexedSearch {{{

   " Plug 'khalidchawtany/IndexedSearch', {'on':['<Plug>(ShowSearchIndex_', 'ShowSearchIndex']}

   " let g:IndexedSearch_SaneRegEx = 1
   " let g:IndexedSearch_AutoCenter = 1
   " let g:IndexedSearch_No_Default_Mappings = 1

   " " nmap <silent>n <Plug>(ShowSearchIndex_n)zv
   " " nmap <silent>N <Plug>(ShowSearchIndex_N)zv
   " " nmap <silent>* <Plug>(ShowSearchIndex_Star)zv
   " " nmap <silent># <Plug>(ShowSearchIndex_Pound)zv

   " " nmap / <Plug>(ShowSearchIndex_Forward)
   " " nmap ? <Plug>(ShowSearchIndex_Backward)

 "}}} _IndexedSearch
 " vim-anzu {{{

 call dein#add( 'osyo-manga/vim-anzu', {'on_cmd': ['AnzuUpdateSearchStatusOutput']} )
 "Let anzu display numbers only. The search is already displayed by Oblique
 let g:anzu_status_format = ' (%i/%l)'

 "}}} _vim-anzu
 " vim-fuzzysearch {{{

   call dein#add( 'ggVGc/vim-fuzzysearch', {'on_cmd': ['FuzzySearch']} )
   nnoremap g\f :FuzzySearch<cr>


 "}}} _vim-fuzzysearch
 " grepper {{{

 call dein#add( 'mhinz/vim-grepper', {'on_cmd': [ 'Grepper'], 'on_map': [ '<plug>(Grepper' ]} )

   xmap g\g <plug>(Grepper)
   cmap <c-g>n <plug>(GrepperNext)
   nmap g\g <plug>(GrepperMotion)
   xmap g\g <plug>(GrepperMotion)

   let g:grepper              = {}
   let g:grepper.programs     = ['ag', 'git', 'grep']
   let g:grepper.use_quickfix = 1
   let g:grepper.do_open      = 1
   let g:grepper.do_switch    = 1
   let g:grepper.do_jump      = 0


 "}}}
 "vim-side-search{{{
 call dein#add('ddrscott/vim-side-search', {'on_cmd':['SideSearch']})
 " How should we execute the search?
 " --heading and --stats are required!
 let g:side_search_prg = 'ag --word-regexp'
       \. " --ignore='*.js.map'"
       \. " --heading --stats -B 1 -A 4"

 " Can use `vnew` or `new`
 let g:side_search_splitter = 'vnew'

 " I like 40% splits, change it if you don't
 let g:side_search_split_pct = 0.4

 " SideSearch current word and return to original window
 nnoremap g\s :SideSearch <C-r><C-w><CR> | wincmd p
 " Create an shorter `SS` command
 command! -complete=file -nargs=+ SS execute 'SideSearch <args>'
 " or command abbreviation
 cabbrev SS SideSearch

 "}}}_vim-side-search

 " Clever-f {{{

   call dein#add( 'rhysd/clever-f.vim' , {'on_map': [ '<Plug>(clever-f-' ]})

   Map nox F     <Plug>(clever-f-F)
   Map nox T     <Plug>(clever-f-T)
   Map nox f     <Plug>(clever-f-f)
   Map nox t     <Plug>(clever-f-t)
   "The following makes fFtF useless because of the time out
   "Map n   f<BS> <Plug>(clever-f-reset)


 "}}}
 " vim-easymotion {{{

   call dein#add( 'Lokaltog/vim-easymotion', {'on_map': ['<Plug>(easymotion-']} )

   map s         <Plug>(easymotion-prefix)
   map s;        <Plug>(easymotion-s2)
   map ss;       <Plug>(easymotion-sn)

   map sl        <Plug>(easymotion-lineforward)
   map sh        <Plug>(easymotion-linebackward)
   map s<space>  <Plug>(easymotion-lineanywhere)

   map ssf       <Plug>(easymotion-bd-f)
   map sst       <Plug>(easymotion-bd-t)
   map ssw       <Plug>(easymotion-bd-w)
   map ssW       <Plug>(easymotion-bd-W)
   map ssw       <Plug>(easymotion-bd-e)
   map ssE       <Plug>(easymotion-bd-E)
   map ssj       <Plug>(easymotion-bd-jk)
   map ssk       <Plug>(easymotion-bd-jk)
   map ssl       <Plug>(easymotion-bd-jk)
   map ssn       <Plug>(easymotion-bd-n)
   map ssa       <Plug>(easymotion-jumptoanywhere)
   map s<cr>       <Plug>(easymotion-repeat)

   map <c-s>L    <Plug>(easymotion-eol-bd-jk)
   map <c-s>H    <Plug>(easymotion-sol-bd-jk)

   map <c-s>f    <Plug>(easymotion-overwin-f)
   map <c-s>;    <Plug>(easymotion-overwin-f2)
   map <c-s>w    <Plug>(easymotion-overwin-w)
   map <c-s>l    <Plug>(easymotion-overwin-line)


" Default Maps {{{
"   Default Mapping      | Details
"   ---------------------|----------------------------------------------
"   <Leader>f{char}      | Find {char} to the right. See |f|.
"   <Leader>F{char}      | Find {char} to the left. See |F|.
"   <Leader>t{char}      | Till before the {char} to the right. See |t|.
"   <Leader>T{char}      | Till after the {char} to the left. See |T|.
"   <Leader>w            | Beginning of word forward. See |w|.
"   <Leader>W            | Beginning of WORD forward. See |W|.
"   <Leader>b            | Beginning of word backward. See |b|.
"   <Leader>B            | Beginning of WORD backward. See |B|.
"   <Leader>e            | End of word forward. See |e|.
"   <Leader>E            | End of WORD forward. See |E|.
"   <Leader>ge           | End of word backward. See |ge|.
"   <Leader>gE           | End of WORD backward. See |gE|.
"   <Leader>j            | Line downward. See |j|.
"   <Leader>k            | Line upward. See |k|.
"   <Leader>n            | Jump to latest "/" or "?" forward. See |n|.
"   <Leader>N            | Jump to latest "/" or "?" backward. See |N|.
"   <Leader>s            | Find(Search) {char} forward and backward.
"                        | See |f| and |F|.
" Unused Maps
"   More <Plug> Mapping Table         | (No assignment by default)
"   ----------------------------------|---------------------------------
"   <Plug>(easymotion-bd-f)           | See |<Plug>(easymotion-s)|
"   <Plug>(easymotion-bd-t)           | See |<Plug>(easymotion-bd-t)|
"   <Plug>(easymotion-bd-w)           | See |<Plug>(easymotion-bd-w)|
"   <Plug>(easymotion-bd-W)           | See |<Plug>(easymotion-bd-W)|
"   <Plug>(easymotion-bd-e)           | See |<Plug>(easymotion-bd-e)|
"   <Plug>(easymotion-bd-E)           | See |<Plug>(easymotion-bd-E)|
"   <Plug>(easymotion-bd-jk)          | See |<Plug>(easymotion-bd-jk)|
"   <Plug>(easymotion-bd-n)           | See |<Plug>(easymotion-bd-n)|
"   <Plug>(easymotion-jumptoanywhere) | See |<Plug>(easymotion-jumptoanywhere)|
"   <Plug>(easymotion-repeat)         | See |<Plug>(easymotion-repeat)|
"   <Plug>(easymotion-next)           | See |<Plug>(easymotion-next)|
"   <Plug>(easymotion-prev)           | See |<Plug>(easymotion-prev)|
"   <Plug>(easymotion-sol-j)          | See |<Plug>(easymotion-sol-j)|
"   <Plug>(easymotion-sol-k)          | See |<Plug>(easymotion-sol-k)|
"   <Plug>(easymotion-eol-j)          | See |<Plug>(easymotion-eol-j)|
"   <Plug>(easymotion-eol-k)          | See |<Plug>(easymotion-eol-k)|
"   <Plug>(easymotion-iskeyword-w)    | See |<Plug>(easymotion-iskeyword-w)|
"   <Plug>(easymotion-iskeyword-b)    | See |<Plug>(easymotion-iskeyword-b)|
"   <Plug>(easymotion-iskeyword-bd-w) | See |<Plug>(easymotion-iskeyword-bd-w)|
"   <Plug>(easymotion-iskeyword-e)    | See |<Plug>(easymotion-iskeyword-e)|
"   <Plug>(easymotion-iskeyword-ge)   | See |<Plug>(easymotion-iskeyword-ge)|
"   <Plug>(easymotion-iskeyword-bd-e) | See |<Plug>(easymotion-iskeyword-bd-e)|
"   <Plug>(easymotion-vim-n)          | See |<Plug>(easymotion-vim-n)|
"   <Plug>(easymotion-vim-N)          | See |<Plug>(easymotion-vim-N)|
"                                     |
"   Within Line Motion                | See |easymotion-within-line|
"   ----------------------------------|---------------------------------
"   <Plug>(easymotion-sl)             | See |<Plug>(easymotion-sl)|
"   <Plug>(easymotion-fl)             | See |<Plug>(easymotion-fl)|
"   <Plug>(easymotion-Fl)             | See |<Plug>(easymotion-Fl)|
"   <Plug>(easymotion-bd-fl)          | See |<Plug>(easymotion-sl)|
"   <Plug>(easymotion-tl)             | See |<Plug>(easymotion-tl)|
"   <Plug>(easymotion-Tl)             | See |<Plug>(easymotion-Tl)|
"   <Plug>(easymotion-bd-tl)          | See |<Plug>(easymotion-bd-tl)|
"   <Plug>(easymotion-wl)             | See |<Plug>(easymotion-wl)|
"   <Plug>(easymotion-bl)             | See |<Plug>(easymotion-bl)|
"   <Plug>(easymotion-bd-wl)          | See |<Plug>(easymotion-bd-wl)|
"   <Plug>(easymotion-el)             | See |<Plug>(easymotion-el)|
"   <Plug>(easymotion-gel)            | See |<Plug>(easymotion-gel)|
"   <Plug>(easymotion-bd-el)          | See |<Plug>(easymotion-bd-el)|
"   <Plug>(easymotion-lineforward)    | See |<Plug>(easymotion-lineforward)|
"   <Plug>(easymotion-linebackward)   | See |<Plug>(easymotion-linebackward)|
"   <Plug>(easymotion-lineanywhere)   | See |<Plug>(easymotion-lineanywhere)|
"                                     |
"   Multi Input Find Motion           | See |easymotion-multi-input|
"   ----------------------------------|---------------------------------
"   <Plug>(easymotion-s2)             | See |<Plug>(easymotion-s2)|
"   <Plug>(easymotion-f2)             | See |<Plug>(easymotion-f2)|
"   <Plug>(easymotion-F2)             | See |<Plug>(easymotion-F2)|
"   <Plug>(easymotion-bd-f2)          | See |<Plug>(easymotion-s2)|
"   <Plug>(easymotion-t2)             | See |<Plug>(easymotion-t2)|
"   <Plug>(easymotion-T2)             | See |<Plug>(easymotion-T2)|
"   <Plug>(easymotion-bd-t2)          | See |<Plug>(easymotion-bd-t2)|
"                                     |
"   <Plug>(easymotion-sl2)            | See |<Plug>(easymotion-sl2)|
"   <Plug>(easymotion-fl2)            | See |<Plug>(easymotion-fl2)|
"   <Plug>(easymotion-Fl2)            | See |<Plug>(easymotion-Fl2)|
"   <Plug>(easymotion-tl2)            | See |<Plug>(easymotion-tl2)|
"   <Plug>(easymotion-Tl2)            | See |<Plug>(easymotion-Tl2)|
"                                     |
"   <Plug>(easymotion-sn)             | See |<Plug>(easymotion-sn)|
"   <Plug>(easymotion-fn)             | See |<Plug>(easymotion-fn)|
"   <Plug>(easymotion-Fn)             | See |<Plug>(easymotion-Fn)|
"   <Plug>(easymotion-bd-fn)          | See |<Plug>(easymotion-sn)|
"   <Plug>(easymotion-tn)             | See |<Plug>(easymotion-tn)|
"   <Plug>(easymotion-Tn)             | See |<Plug>(easymotion-Tn)|
"   <Plug>(easymotion-bd-tn)          | See |<Plug>(easymotion-bd-tn)|
"                                     |
"   <Plug>(easymotion-sln)            | See |<Plug>(easymotion-sln)|
"   <Plug>(easymotion-fln)            | See |<Plug>(easymotion-fln)|
"   <Plug>(easymotion-Fln)            | See |<Plug>(easymotion-Fln)|
"   <Plug>(easymotion-bd-fln)         | See |<Plug>(easymotion-sln)|
"   <Plug>(easymotion-tln)            | See |<Plug>(easymotion-tln)|
"   <Plug>(easymotion-Tln)            | See |<Plug>(easymotion-Tln)|
"   <Plug>(easymotion-bd-tln)         | See |<Plug>(easymotion-bd-tln)|
"
"   Over Window Motion                | (No assignment by default)
"   ----------------------------------|---------------------------------
"   <Plug>(easymotion-overwin-f)      | See |<Plug>(easymotion-overwin-f)|
"   <Plug>(easymotion-overwin-f2)     | See |<Plug>(easymotion-overwin-f2)|
"   <Plug>(easymotion-overwin-line)   | See |<Plug>(easymotion-overwin-line)|
"   <Plug>(easymotion-overwin-w)      | See |<Plug>(easymotion-overwin-w)|
"
"-----------------------------------------------------------------------------
"}}}

   " keep cursor colum when JK motion
   let g:EasyMotion_startofline = 0
   let g:EasyMotion_force_csapprox = 1

 "}}} _vim-easymotion
 " columnmove {{{

   "Plug 'machakann/vim-columnmove', {'on': ['<Plug>(columnmove-']}

   "let g:columnmove_no_default_key_mappings = 1

   "nmap Sf <Plug>(columnmove-f)
   "nmap St <Plug>(columnmove-t)
   "nmap SF <Plug>(columnmove-F)
   "nmap ST <Plug>(columnmove-T)
   "nmap S; <Plug>(columnmove-;)
   "nmap S, <Plug>(columnmove-,)

   "nmap Sw <Plug>(columnmove-w)
   "nmap Sb <Plug>(columnmove-b)
   "nmap Se <Plug>(columnmove-e)
   "nmap Sge <Plug>(columnmove-ge)

   "nmap SW <Plug>(columnmove-W)
   "nmap SB <Plug>(columnmove-B)
   "nmap SE <Plug>(columnmove-E)
   "nmap SgE <Plug>(columnmove-gE)

 "}}}
 " vim-skipit {{{

   "use <c-l>l to skip ahead forward in insert mode
   call dein#add( 'habamax/vim-skipit', {
         \ 'on_map':
         \ [
         \   ['i' , '<Plug>SkipItForward'], ['i' , '<Plug>SkipAllForward'],
         \   ['i' , '<Plug>SkipItBack'],    ['i' , '<Plug>SkipAllBack']
         \ ]
         \ })
   imap <C-s>j <Plug>SkipItForward
   imap <C-s>l <Plug>SkipAllForward
   imap <C-s>k <Plug>SkipItBack
   imap <C-s>h <Plug>SkipAllBack

 "}}} _vim-skipit
 " patternjump {{{

   call dein#add( 'machakann/vim-patternjump', {'on_map': ['<Plug>(patternjump-']} )
   let g:patternjump_no_default_key_mappings = 1
   map <c-s>l <Plug>(patternjump-forward)
   map <c-s>h <Plug>(patternjump-backward)

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
 " TaskList.vim {{{

   call dein#add( 'vim-scripts/TaskList.vim', {'on_cmd':  ['TaskList']} )
   nnoremap <leader>tl :TaskList<cr>

 "}}} _TaskList.vim
 " Tagbar {{{

   call dein#add( 'majutsushi/tagbar', {'on_cmd':  [ 'Tagbar', 'TagbarToggle', ] } )
   nnoremap <silent> <leader>tb :TagbarToggle<CR>


 "}}}
 " accelerated-jk {{{

   "Plug 'rhysd/accelerated-jk'
   "nmap j <Plug>(accelerated_jk_gj)
   "nmap k <Plug>(accelerated_jk_gk)
   "nmap j <Plug>(accelerated_jk_gj_position)
   "nmap k <Plug>(accelerated_jk_gk_position)

 "}}} _accelerated-jk

 " History
 " undotree {{{

   call dein#add( 'mbbill/undotree', {'on_cmd': ['UndotreeShow', 'UndotreeFocus', 'UndotreeToggle']} )

   let g:undotree_WindowLayout = 2
   nnoremap <leader>ut :UndotreeToggle<cr>
   nnoremap <leader>us :UndotreeShow<cr>


 "}}} _undotree

 " Buffers
 " vim-bufsurf {{{

 call dein#add( 'ton/vim-bufsurf') ", {'on_cmd': ['BufSurfBack', 'BufSurfForward', 'BufSurfList']} )
 nnoremap ]h :BufSurfForward<cr>
 nnoremap [h :BufSurfBack<cr>
 nnoremap coB :BufSurfList<cr>

 "}}} _vim-bufsurf

 " vim_drawer {{{
   call dein#add('samuelsimoes/vim-drawer', {'on_cmd': ['VimDrawer']} )
   let g:vim_drawer_spaces = [
         \["model", "app"],
         \["controller", "Http\/Controllers"],
         \["view", "\.html\.erb$|\.blade\.php$"],
         \["asset", "\.[js|css]$"],
         \["term", "^term"]
         \]
   nnoremap <C-w><Space> :VimDrawer<CR>
 "}}} _vim-drawer
 "{{{ vim-ctrlspace
 call dein#add( 'szw/vim-ctrlspace', {'on_cmd': ['CtrlSpace']} )

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

 "}}} _vim-ctrlspace
 " zoomwintab.vim {{{

   call dein#add( 'troydm/zoomwintab.vim', {'on_cmd': ['ZoomWinTabToggle']} )

   let g:zoomwintab_remap = 0
   " zoom with <META-O> in any mode
   nnoremap <silent> <c-w><c-o> :ZoomWinTabToggle<cr>
   inoremap <silent> <c-w><c-o> <c-\><c-n>:ZoomWinTabToggle<cr>a
   vnoremap <silent> <c-w><c-o> <c-\><c-n>:ZoomWinTabToggle<cr>gv

 "}}} _zoomwintab.vim

 " Finder
 " gtfo {{{

   call dein#add( 'justinmk/vim-gtfo', {'on_map': ['gof', 'got', 'goF', 'goT']} )
   let g:gtfo#terminals = { 'mac' : 'iterm' }
   nnoremap <silent> gof :<c-u>call gtfo#open#file("%:p")<cr>
   nnoremap <silent> got :<c-u>call gtfo#open#term("%:p:h", "")<cr>
   nnoremap <silent> goF :<c-u>call gtfo#open#file(getcwd())<cr>
   nnoremap <silent> goT :<c-u>call gtfo#open#term(getcwd(), "")<cr>

 "}}}

 " tmux
 " tmux-navigator {{{

   if exists('$TMUX')
     call dein#add( 'christoomey/vim-tmux-navigator' )

     let g:tmux_navigator_no_mappings = 1
     nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
     nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
     nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
     nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
     nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>
   endif

 "}}}

 " terminal
 " nvimux {{{
    call dein#add('hkupty/nvimux')
    let g:nvimux_prefix='<C-cr>'
 "}}} _nvimux
 " neoterm {{{

 call dein#add( 'kassio/neoterm',
       \ {
       \ 'on_func': [ 'neoterm#test#libs#add', 'neoterm#repl#set'],
       \ 'on_cmd':
       \   [
       \     'T',
       \     'Tnew',
       \     'Tmap',
       \     'Tpos',
       \     'TTestSetTerm',
       \     'TTestLib',
       \     'TTestClearStatus',
       \     'TREPLSetTerm',
       \     'REPLSend',
       \     'REPLSendFile',
       \     'Topen',
       \     'Tclose',
       \     'Ttoggle'
       \   ]
       \ }
       \)

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

 "}}} _neoterm

 "}}}
 " ----------------------------------------------------------------------------
 " Folds {{{
 " ----------------------------------------------------------------------------

 " FastFold {{{

   call dein#add( 'Konfekt/FastFold' )
   "Update folds manually using zuz
   let g:fastfold_savehook = 0

 "}}} _FastFold

 " vim-foldfocus {{{

   call dein#add( 'vasconcelloslf/vim-foldfocus', {'on_func': ['FoldFocus']} )
   nnoremap <leader>z<cr> :call FoldFocus('vnew')<CR>
   nnoremap <leader>zz<cr>  :call FoldFocus('e')<CR>

 "}}}} _vim-foldfocus

 " Volumes/Home/.config/nvim/plugged/foldsearches.vim {{{


   call dein#add( '/Volumes/Home/.config/nvim/plugged/foldsearches.vim' )

 "}}} _Volumes/Home/.config/nvim/plugged/foldsearches.vim

 " searchfold.vim {{{

   call dein#add( 'khalidchawtany/searchfold.vim' , {'on_map':  ['<Plug>SearchFold']} )

   " Search and THEN Fold the search term containig lines using <leader>z
   " or the the inverse using <leader>iz or restore original fold using <leader>Z
   nmap <Leader>zs   <Plug>SearchFoldNormal
   nmap <Leader>zi   <Plug>SearchFoldInverse
   nmap <Leader>ze   <Plug>SearchFoldRestore
   nmap <Leader>zw   <Plug>SearchFoldCurrentWord

 "}}} _searchfold.vim

 " foldsearch {{{

  call dein#add( 'khalidchawtany/foldsearch',
       \ { 'on_cmd': ['Fw', 'Fs', 'Fp', 'FS', 'Fl', 'Fc', 'Fi', 'Fd', 'Fe']} )
         " \ [
         " \ '<leader>fs', '<leader>fw', '<leader>fl', '<leader>fS',
         " \ '<leader>fi', '<leader>fd', '<leader>fe'
         " \ ]

 "}}} _foldsearch


 "}}}
 " ----------------------------------------------------------------------------
 "Database {{{
 " ----------------------------------------------------------------------------

 " dbext.vim {{{

   call dein#add( 'vim-scripts/dbext.vim' )
   let g:dbext_default_profile_mysql_local = 'type=MYSQL:user=root:passwd=root:dbname=younesdb:extra=-t'

 "}}} _dbext.vim

 " pipe-mysql.vim {{{
   call dein#add( 'NLKNguyen/pipe-mysql.vim' )
 "}}} _pipe-mysql.vim

 "}}}
 " ----------------------------------------------------------------------------
 " neovim-qt {{{
   call dein#add( 'equalsraf/neovim-gui-shim' )
 " }}}
 " ----------------------------------------------------------------------------
 " Nyaovim {{{
 " ----------------------------------------------------------------------------
 if exists('g:nyaovim_version')
   call dein#add( 'rhysd/nyaovim-popup-tooltip' )
   call dein#add( 'rhysd/nyaovim-mini-browser' )
   call dein#add( 'rhysd/nyaovim-markdown-preview' )
 endif
"}}}
 " ----------------------------------------------------------------------------
 " Themeing {{{
 " ----------------------------------------------------------------------------

 " vim-startify {{{
  call dein#add( 'mhinz/vim-startify' )
  nnoremap <F1> :Startify<cr>
  let g:startify_list_order = ['files', 'dir', 'bookmarks', 'sessions']
  let g:startify_files_number = 5

  "Make bookmarks for fast nav
  let g:startify_bookmarks = [ {'c': '~/.vimrc'}, '~/.zshrc' ]
  let g:startify_session_dir = '~/.config/nvim/.cache/startify/session'

  let g:startify_custom_header = [] "Remove the Cow
  "function! s:filter_header(lines) abort
    "let longest_line   = max(map(copy(a:lines), 'len(v:val)'))
    "let centered_lines = map(copy(a:lines),
          "\ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
    "return centered_lines
  "endfunction

  "let g:startify_custom_header =
        "\ s:filter_header(map(split(system('fortune -s| cowsay'), '\n'), '"   ". v:val') + ['',''])
 "}}}

 " goyo.vim {{{

   call dein#add( 'junegunn/goyo.vim',      { 'on_cmd': 'Goyo'} )

   autocmd! User GoyoEnter Limelight
   autocmd! User GoyoLeave Limelight!

 "}}} _goyo.vim
 " limelight.vim {{{

   call dein#add( 'junegunn/limelight.vim', { 'on_cmd': 'Limelight'} )
   let g:limelight_conceal_guifg="#C2B294"

 "}}} _limelight.vim
 " vim-lambdify {{{

 "call dein#add( 'calebsmith/vim-lambdify', {'on_ft': ['javascript']} )
 call dein#add( 'calebsmith/vim-lambdify' )

 "}}} _vim-lambdify
 " vim-css-color {{{

   "call dein#add( 'ap/vim-css-color',            { 'on_ft':['css','scss','sass','less','styl']} )
   call dein#add( 'ap/vim-css-color' )
   au BufWinEnter *.vim call css_color#init('hex', '', 'vimHiGuiRgb,vimComment,vimLineComment,vimString')
   au BufWinEnter *.blade.php call css_color#extend('htmlString,htmlCommentPart,phpStringSingle')

 "}}} _vim-css-color
 "vim-stylus {{{
  "call dein#add('wavded/vim-stylus', {'on_ft': 'stylus'})
  call dein#add('wavded/vim-stylus')
  autocmd BufNewFile,BufRead *.styl setlocal filetype=stylus
 "}}}_vim-stylus
 " vim-better-whitespace {{{

   call dein#add( 'ntpeters/vim-better-whitespace' )
   let g:better_whitespace_filetypes_blacklist=['diff', 'qf', 'gitcommit', 'unite', 'vimfiler', 'help', 'leaderGuide']
   autocmd FileType unite DisableWhitespace
   autocmd FileType vimfiler DisableWhitespace

 "}}}

 " vim-indentLine {{{

    "call dein#add( 'Yggdroot/indentLine' )
    "let g:indentLine_char = ''
    "" let g:indentLine_color_term=""
    "" let g:indentLine_color_gui=""
    "let g:indentLine_fileType=[] "Means all filetypes
    "let g:indentLine_fileTypeExclude=[]
    "let g:indentLine_bufNameExclude=[]


 "}}}
 " rainbow parentheses {{{

   call dein#add( 'junegunn/rainbow_parentheses.vim', {'on_cmd':  ['RainbowParentheses']} )
   nnoremap <leader>xp :RainbowParentheses!!<CR>

 "}}}
   call dein#add( 'ryanoasis/vim-devicons' )
   call dein#add( 'reedes/vim-thematic' )


 "Golden Ratio
 " golden-ratio {{{

   call dein#add( 'roman/golden-ratio' )
   nnoremap cog :<c-u>GoldenRatioToggle<cr>

 "}}} _golden-ratio
 " GoldenView.Vim {{{

   "Plug 'zhaocai/GoldenView.Vim'
   "let g:goldenview__enable_default_mapping = 0

 "}}} _GoldenView.Vim
 " vim-eighties {{{

   "call dein#add( 'justincampbell/vim-eighties' )

 "}}} _vim-eighties

 " visual-split.vim {{{

   call dein#add( 'wellle/visual-split.vim' ) ", {'on': ['VSResize', 'VSSplit', 'VSSplitAbove', 'VSSplitBelow']}

 "}}} _visual-split.vim

   " Plug 'tpope/vim-flagship'
 " lightline {{{
   call dein#add( 'itchyny/lightline.vim' )


         "\   'fileformat': 'LightLineFileformat',
         "\   'filetype': 'LightLineFiletype',

   let g:lightline = {
         \ 'active': {
         \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
         \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
         \ },
         \ 'component_function': {
         \   'fugitive': 'LightLineFugitive',
         \   'filename': 'LightLineFilename',
         \   'filetype': 'MyFiletype',
         \   'fileformat': 'MyFileformat',
         \   'fileencoding': 'LightLineFileencoding',
         \   'mode': 'LightLineMode',
         \ },
         \ 'component_type': {
         \   'syntastic': 'error',
         \ },
         \ 'subseparator': { 'left': '', 'right': '' }
         \ }

         "\ 'component_expand': {
         "\   'syntastic': 'SyntasticStatuslineFlag',
         "\ },
        function! MyFiletype()
          return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() . "\u00A0" : 'no ft') : ''
        endfunction

        function! MyFileformat()
          "return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
          let fileformat = ""

          if &fileformat == "dos"
            let fileformat = ""
          elseif &fileformat == "unix"
              "let fileformat = ""
              let fileformat = ""
          elseif &fileformat == "mac"
            let fileformat = ""
          endif

           "Temporary (hopefully) fix for glyph issues in gvim (proper fix is with the
           "actual font patcher)
          let artifactFix = "\u00A0"
          let tabText = ""
          if(tabpagenr('$')>1)
            let tabText = tabpagenr('$') . "   " . ""
          endif
          "call system("set_iterm_badge_number neovim_tabcount ".tabpagenr('$'))

          return  tabText . artifactFix . fileformat
          "return fileformat
        endfunction

   call dein#add( 'shinchu/lightline-gruvbox.vim' )
   call dein#add( 'khalidchawtany/lightline-material.vim' )
   "let g:lightline.colorscheme = 'gruvbox'
   "let g:lightline.colorscheme = 'wombat'
   let g:lightline.colorscheme = 'material'

   function! LightLineModified()
     return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
   endfunction

   function! LightLineReadonly()
     return &ft !~? 'help' && &readonly ? '' : ''
   endfunction

   function! LightLineFilename()
     let fname = expand('%:t')
     if fname == 'zsh'
       return "  "
     endif
     return fname == '__Tagbar__' ? g:lightline.fname :
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
         let mark = ' '  " edit here for cool mark     
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
           \ fname == '__Gundo__' ? 'Gundo' :
           \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
           \ &ft == 'unite' ? 'Unite' :
           \ &ft == 'vimfiler' ? 'VimFiler' :
           \ &ft == 'vimshell' ? 'VimShell' :
           \ winwidth(0) > 60 ? lightline#mode() : ''
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
   " Plug 'ap/vim-buftabline'

 "colorschemes
   call dein#add( 'mswift42/vim-themes' )
   call dein#add( 'tomasr/molokai' )
   call dein#add('kristijanhusak/vim-hybrid-material')
   call dein#add('jdkanani/vim-material-theme')
   call dein#add('Wutzara/vim-materialtheme')
   call dein#add('joshdick/onedark.vim')
   call dein#add( 'KabbAmine/yowish.vim' )
   call dein#add( 'romainl/Apprentice' )
 " gruvbox {{{
   call dein#add( 'morhetz/gruvbox' )

   let g:gruvbox_contrast_dark='medium'          "soft, medium, hard"
   let g:gruvbox_contrast_light='medium'         "soft, medium, hard"

 "}}}
 " vim-lucius {{{

  call dein#add( 'jonathanfilip/vim-lucius' )

 "}}} _vim-lucius
 " vim-github-colorscheme {{{

   call dein#add('endel/vim-github-colorscheme')

 "}}} _vim-github-colorscheme
 " neovim-colors-solarized-truecolor-only {{{

   call dein#add( 'frankier/neovim-colors-solarized-truecolor-only' )

 "}}} _neovim-colors-solarized-truecolor-only

 "}}}
 " ----------------------------------------------------------------------------
 " Presenters :) {{{
 " ----------------------------------------------------------------------------

 " vim-follow-my-lead {{{

   ",fml
   call dein#add( 'ktonga/vim-follow-my-lead', {'on_map': ['<Plug>(FollowMyLead)']} )
   nnoremap <leader>fml <Plug>(FollowMyLead)
   let g:fml_all_sources=1 "1 for all sources, 0(Default) for $MYVIMRC.

 "}}} _vim-follow-my-lead
 " vim-leader-guide {{{
    call dein#add('hecal3/vim-leader-guide')

    call leaderGuide#register_prefix_descriptions("<Space>", "g:lmap")
    nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
    vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>


    " Define prefix dictionary
    let g:lmap =  {}
    " Second level dictionaries:
    let g:lmap.f = { 'name' : 'File Menu' }
    let g:lmap.o = { 'name' : 'Open Stuff' }
    " 'name' is a special field. It will define the name of the group.
    " leader-f is the "File Menu" group.
    " Unnamed groups will show a default string

    "No relative line numbers in ledare guide
    au FileType leaderGuide set norelativenumber

    let g:leaderGuide_sort_horizontal=0

    " Create new menus not based on existing mappings:
    let g:lmap.g = {
          \'name' : 'Git Menu',
          \'m':  ['Magit',      'Magit'],
          \'l':  ['GV',         'Log'],
          \'s':  ['Gstatus',    'Status'],
          \'c':  ['Gcommit',    'Commit'],
          \'ds': ['Gdiff',      'Diff'],
          \'dv': ['Gvdiff',     'V-Diff'],
          \'p':  ['Gpull',      'Pull'],
          \'u':  ['Gpush',      'Push'],
          \'r':  ['Gread',      'Read'],
          \'w':  ['Gwrite',     'Write'],
          \}

    " If you use NERDCommenter:
    let g:lmap.c = { 'name' : 'Comments' }
    " Define some descriptions
    let g:lmap.c.c = ['call feedkeys("\<Plug>NERDCommenterComment")','Comment']
    let g:lmap.c[' '] = ['call feedkeys("\<Plug>NERDCommenterToggle")','Toggle']
    " The Descriptions for other mappings defined by NerdCommenter, will default
    " to their respective commands.

    function! s:my_displayfunc()
      let g:leaderGuide#displayname =
            \ substitute(g:leaderGuide#displayname, '\c<cr>$', '', '')
      let g:leaderGuide#displayname = 
            \ substitute(g:leaderGuide#displayname, '^<Plug>', '', '')
    endfunction
    let g:leaderGuide_displayfunc = [function("s:my_displayfunc")]

 " _vim-leader-guide }}}

 "}}}
 " ----------------------------------------------------------------------------

" DEIN END{{{
" Required:
call dein#end()

" Required:
filetype plugin indent on

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------
"}}} _DEIN END
"}}}
" ============================================================================
" COMMANDS {{{
" ============================================================================
  command! SyntaxLoadedFrom :echo join(map(map(split(&runtimepath, ','), "split(v:val, '/') + ['syntax']"), "'/' . join(v:val, '/')"), "\n")<cr>

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

  command! Cclear cclose <Bar> call setqflist([])
  nnoremap co<bs> :Cclear<cr>

  command! -range CreateFoldableComment <line1>,<line2>call CreateFoldableCommentFunction()

" }}}
" ============================================================================
" MAPPINGS {{{
" ============================================================================

  " Utils {{{
  "===============================================================================
  "
  nnoremap <leader>ss :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

  "Shift-Enter is like ]<space>
  inoremap <silent> <s-cr> <esc>m`o<esc>``a

  " toggle the last search pattern register between the last two search patterns
  function! s:ToggleSearchPattern()
    let next_search_pattern_index = -1
    if @/ ==# histget('search', -1)
      let next_search_pattern_index = -2
    endif
    let @/ = histget('search', next_search_pattern_index)
  endfunction
  nnoremap <silent> co/ :<C-u>call <SID>ToggleSearchPattern()<CR>


    nnoremap <leader>ha :call HighlightAllOfWord(1)<cr>
    nnoremap <leader>hA :call HighlightAllOfWord(0)<cr>

    nnoremap <silent> <BS> :nohlsearch \| redraw! \| diffupdate \| normal \<Plug>(clever-f-reset) \| normal \<Plug>(FastFoldUpdate) \| echo ""<cr>

    nnoremap <F12> :call ToggleMouseFunction()<cr>

    vnoremap . :norm.<CR>

    " { and } skip over closed folds
    nnoremap <expr> } foldclosed(search('^$', 'Wn')) == -1 ? "}" : "}j}"
    nnoremap <expr> { foldclosed(search('^$', 'Wnb')) == -1 ? "{" : "{k{"

    " Jump to next/previous merge conflict marker
    nnoremap <silent> ]> /\v^(\<\|\=\|\>){7}([^=].+)?$<CR>
    nnoremap <silent> [> ?\v^(\<\|\=\|\>){7}([^=].+)\?$<CR>

    " Move visual lines
    nmap <silent> j gj
    nmap <silent> k gk

    noremap  H ^
    vnoremap H ^
    onoremap H ^
    noremap  L $
    vnoremap L g_
    onoremap L $


    "nnoremap ; : "ambicmd does remap this properly
    nnoremap : ;
    vnoremap ; :
    vnoremap : ;

    "Make completion more comfortable
    inoremap <c-j> <c-n>
    inoremap <c-k> <c-p>

    inoremap <C-U> <C-G>u<C-U>

    if !exists('$TMUX')
      nnoremap <silent> <c-h> <c-w><c-h>
      nnoremap <silent> <c-j> <c-w><c-j>
      nnoremap <silent> <c-k> <c-w><c-k>
      nnoremap <silent> <c-l> <c-w><c-l>
    endif


    "" Highlight TODO markers
    "hi todo cterm=bold ctermfg=231 ctermbg=232 gui=bold guifg=#FFFFFF guibg=bg
    "match todo '\v^(\<|\=|\>){7}([^=].+)?$'
    "match todo '\v^(\<|\=|\>){7}([^=].+)?$'

  "}}}

  " Folds {{{
  "===============================================================================

    " Close all folds except this
    nnoremap z<Space> zMzv
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

    autocmd Filetype neosnippet,cs call ToggleFoldMarker()
  "}}}

  " Terminal {{{
  "===============================================================================
    tnoremap <c-o> <c-\><c-n>
    "tnoremap <expr> <esc> &filetype == 'fzf' ? "\<esc>" : "\<c-\>\<c-n>"
  "}}}

  " Window & Buffer {{{
  "===============================================================================

  " Shrink to fit number of lines
  nmap <silent> <c-w>S :execute ":resize " . line('$')<cr>

  " Maximize current split
  nnoremap <c-w>M <C-w>_<C-w><Bar>

  " Buffer deletion commands {{{

    nnoremap <c-w>O :BufOnly<cr>

    nnoremap  Úwa :bufdo execute ":bw"<cr>
    nnoremap  <c-;>wa :bufdo execute ":bw"<cr>
    nnoremap  ÚÚwa :bufdo execute ":bw!"<cr>
    nnoremap  <c-;><c-;>wa :bufdo execute ":bw!"<cr>
    "nnoremap  Úww :bw<cr>
    "nnoremap  <c-;>ww :bw<cr>
    nmap Úww <Plug>BW
    nmap <c-;>ww <Plug>BW

    nnoremap  ÚÚww :bw!<cr>
    nnoremap  <c-;><c-;>ww :bw!<cr>
  "}}}


  "}}}

  " Text editting {{{
  "===============================================================================
  "nnoremap <leader>b :center 80<CR>hhv0r#A<SPACE><ESC>40A#<ESC>d80<BAR>YppVr#kk.

  "TODO: conflicts with script-ease
  command! SplitLine :normal! i<CR><ESC>,ss<cr>
  nnoremap <c-g>K :call Preserve('SplitLine')<cr>
  nnoremap <c-g><c-K> :call Preserve('SplitLine')<cr>

  " Put empty line around (requires UnImpaired)
  nnoremap \<Space> :normal [ ] <cr>

  " Suck from below/above
  nnoremap <C-g>j i<Esc>+y$ddgi<c-r>0<Esc>
  nnoremap <C-g>k i<Esc>-y$ddgi<c-r>0<Esc>

  " Uppercase from insert mode while you are at the end of a word
  inoremap <C-u> <esc>mzgUiw`za

  "Remove ^M from a file
  nnoremap <leader>e<cr> :e ++ff=dos

  "Retab file
  nnoremap <leader>e<Tab> :retab<cr>

  "Strip whitespace
  nnoremap <leader>e<space> :call StripWhitespace()<CR>

  " Underline {{{

    " underline the current line
    nnoremap <leader>U= :t.\|s/./=<cr>:nohls<cr>
    nnoremap <leader>U- :t.\|s/./-<cr>:nohls<cr>
    nnoremap <leader>U~ :t.\|s/./\\~<cr>:nohls<cr>

    "only underline from H to L
    nnoremap <leader>u= "zyy"zp<c-v>$r=
    nnoremap <leader>u- "zyy"zp<c-v>$r-
    nnoremap <leader>u~ "zyy"zp<c-v>$r~

  "}}}

  " Better copy/cut/paste {{{
   noremap <leader>d "_d
   noremap <leader>y "+y
   noremap <leader>p "+p
  "}}}

  " Indentation {{{
    " indent visually without coming back to normal mode
    vmap > >gv
    vmap < <gv
    nmap <leader>ii :call IndentToNextBraceInLineAbove()<cr>
  "}}}

  " Move visual block
  vnoremap <c-j> :m '>+1<CR>gv=gv
  vnoremap <c-k> :m '<-2<CR>gv=gv

  " select last matched item
  nnoremap <c-g>/ //e<Enter>v??<Enter>
  nnoremap <c-g>sl //e<Enter>v??<Enter>

  " Reselect the text you just entered
  nnoremap gV `[v`]
  nnoremap <c-g>si `[v`]
  "}}}

  " Writting and Quitting {{{
  "===============================================================================

  nnoremap <leader>qq :q<cr>
  nnoremap <leader>qa :qall<cr>
  nnoremap <leader>wq :wq<cr>
  nnoremap <leader>ww :w<cr>
  nnoremap <leader>w<Leader> :update<cr>
  nnoremap <leader>wu :update<cr>
  nnoremap <leader>wa :wall<cr>
  nnoremap <Leader>`` :qa!<cr>

  " save as root
  noremap <leader>W :w !sudo tee % > /dev/null<CR>

  "Discard changes
  nnoremap <leader>e<bs> :e! \| echo 'changes discarded'<cr>
  nnoremap <c-g>e<bs> :e! \| echo 'changes discarded'<cr>
  "}}}

  " Path & File {{{

  autocmd Filetype netrw nnoremap q :quit<cr>

  "CD into:
  "current buffer file dir
  nnoremap cdf :lcd %:p:h<cr>:pwd<cr>
  "current working dir
  nnoremap cdc :lcd <c-r>=expand("%:h")<cr>/
  "git dir ROOT
  nnoremap cdg :lcd <c-r>=FindGitDirOrRoot()<cr><cr>

  "Open current directory in Finder
  "nnoremap gof :silent !open .<cr>

  nnoremap ycd :!mkdir -p %:p:h<CR>

  "Go to alternate file
  nnoremap go <C-^>

  " edit in the path of current file
  nnoremap <leader>ef :e <C-R>=escape(expand('%:p:h'), ' ').'/'<CR>
  nnoremap <leader>ep :e <c-r>=escape(getcwd(), ' ').'/'<cr>

  " <c-y>f Copy the full path of the current file to the clipboard
  nnoremap <silent> ycf :let @+=expand("%:p")<cr>:echo "Copied current file
        \ path '".expand("%:p")."' to clipboard"<cr>

  " rename current buffers file
  nnoremap <Leader>rn :call RenameFile()<cr>

  " Edit todo list for project
  nnoremap <leader>tp :e <c-r>=FindGitDirOrRoot()<cr>/todo.org<cr>

  " Edit GLOBAL todo list
  nnoremap <leader>to :e ~/org/todo.org<cr>

  " Edit the vimrc (init.vim) file
  nnoremap <silent> <leader>ev :e $MYVIMRC<CR>

  " evaluate selected vimscript | line | whole vimrc (init.vim)
  vnoremap <Leader>s; "vy:@v<CR>
  nnoremap <Leader>s; "vyy:@v<CR>
  nnoremap <silent> <leader>sv :unlet g:VIMRC_SOURCED<cr>:so $MYVIMRC<CR>
  "}}}

  " Toggles {{{
  "===============================================================================


  "toggle tabline
  nnoremap <silent> cot  :execute "set  showtabline=" . (&showtabline+2)%3<cr>

  "toggle showcmd
  nnoremap co: :set showcmd!<cr>
  nnoremap co; :set showcmd!<cr>

  "Toggle laststatus (statusline | statusbar)
  nnoremap <silent> co<space> :execute "set laststatus=" . (&laststatus+2)%3<cr>


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
  "}}}

  " Command-line Mode Key Mappings {{{
  "===============================================================================

  cnoremap <c-a> <home>
  cnoremap <c-e> <end>
  cnoremap <c-j> <down>
  cnoremap <c-k> <up>
  cnoremap <c-h> <left>
  cnoremap <c-l> <right>
  cnoremap <c-g>p <C-\>egetcwd()<CR>
  cnoremap <c-g>f <C-r>=expand("%")<CR>


"}}}

  " Languages {{{
  "===============================================================================

  " Laravel
  nnoremap Úlv :e ./app/views/<cr>
  nnoremap <c-;>lv :e ./app/views/<cr>
  nnoremap Úlc :e ./app/views/partials/<cr>
  nnoremap <c-;>lc :e ./app/views/partials/<cr>
  nnoremap Úlp :e ./public/<cr>
  nnoremap <c-;>lp :e ./public/<cr>

  " Java
  "nnoremap  <leader>ej : exe "!cd " . shellescape(expand("%:h")) . " && javac " . expand ("%:t") . " && java " . expand("%:t:r")<cr>
  nnoremap  <leader>ej :w<cr>:exe "tab term cd " . shellescape(expand("%:h")) . " && javac " . expand ("%:t") . " && java " . expand("%:t:r")<cr><cr>

  " HTML
  au FileType html,blade inoremap <buffer> >>     ></<C-X><C-O><Esc>%i
  au FileType html,blade inoremap <buffer> >><CR> ></<C-X><C-O><Esc>%i<CR><ESC>O

  "}}}

  nnoremap <silent> [I :call List("i", 0, 0)<CR>
  nnoremap <silent> ]I :call List("i", 0, 1)<CR>
  xnoremap <silent> [I :<C-u>call List("i", 1, 0)<CR>
  xnoremap <silent> ]I :<C-u>call List("i", 1, 1)<CR>
  nnoremap <silent> [D :call List("d", 0, 0)<CR>
  nnoremap <silent> ]D :call List("d", 0, 1)<CR>
  xnoremap <silent> [D :<C-u>call List("d", 1, 0)<CR>
  xnoremap <silent> ]D :<C-u>call List("d", 1, 1)<CR>

  "noremap <F4> :call DiffMe()<CR>

"}}}
" ============================================================================
" AUTOCMD {{{
" ============================================================================

" Jump back to last file of a specific type or path
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  autocmd BufLeave *.css,*.less,*.scss normal! mS
  autocmd BufLeave *.js,*.coffee       normal! mJ
  autocmd BufLeave *.html              normal! mH
  autocmd BufLeave app/*.php           normal! mP
  autocmd BufLeave */migrations/*      normal! mM
  autocmd BufLeave */seeds/*           normal! mD
  autocmd BufLeave */controllers/*     normal! mC
  autocmd BufLeave */test/*,*/spec/*   normal! mT
  autocmd BufLeave */Http/routes.*     normal! mR
  autocmd BufLeave *.blade.php
        \ | if (expand("<afile>")) =~ "*layout.*"
        \ | execute 'normal! mL'
        \ | else
        \ | execute 'normal! mV'
        \ | endif


  "Unless the file name has test in it mark it C for *.cs
  "if the file name has test in it mark it T for *.cs
  autocmd BufLeave *.cs
        \ | if (expand("<afile>")) =~ ".*test.*"
        \ | execute 'normal! mT'
        \ | else
        \ | execute 'normal! mC'
        \ | endif


  " Enable file type detection
  filetype on
  " Treat .json files as .js
  autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
  " Treat .md files as Markdown
  autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
  " au BufNewFile,BufRead *.blade.php


  au filetype blade
        \ let b:match_words ='<:>,<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'
        \ | let b:match_ignorecase = 1


  augroup ensure_directory_exists
    autocmd!
    autocmd BufNewFile * call s:EnsureDirectoryExists()
  augroup END

  augroup global_settings
    au!
    au VimResized * :wincmd = " resize windows when vim is resized

    " return to the same line when file is reopened
    au BufReadPost *
          \ let s:path=expand("%:path") |
          \ if exists('g:current_file_path') |
          \   if g:current_file_path != s:path |
          \     if line("'\"") > 0 && line("'\"") <= line("$") |
          \       execute 'normal! g`"zvzz' |
          \       let g:current_file_path=s:path |
          \     endif |
          \   endif |
          \ else |
          \     if line("'\"") > 0 && line("'\"") <= line("$") |
          \       execute 'normal! g`"zvzz' |
          \       let g:current_file_path=s:path |
          \     endif |
          \ endif
  augroup END


  " "Restore cursor, fold, and options on re-open.
  " au BufWinLeave *.* mkview
  " au VimEnter *.* silent loadview

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


  ""Make cusrsorline visible only in the current window
  "augroup highlight_follows_focus
    "autocmd!
    "autocmd WinEnter * set cursorline
    "autocmd WinLeave * set nocursorline
  "augroup END

  "augroup highligh_follows_vim
    "autocmd!
    "autocmd FocusGained * set cursorline
    "autocmd FocusLost * set nocursorline
  "augroup END

  ""Make numbers visible for current window only
  "augroup active_relative_number
    "au!
    "au BufEnter * :setlocal number relativenumber
    "au WinEnter * :setlocal number relativenumber
    "au BufLeave * :setlocal nonumber norelativenumber
    "au WinLeave * :setlocal nonumber norelativenumber
  "augroup END

  ""disable numbers in insert mode
  "augroup toggle_relative_number  " can be toggled normally with 'cor'
    "autocmd!
    "autocmd InsertEnter * :setlocal norelativenumber
    "autocmd InsertLeave * :setlocal relativenumber
  "augroup END

  ""open quickfix/locationlist on each relevant operatgion
  "augroup autoquickfix
    "autocmd!
    "autocmd QuickFixCmdPost [^l]* cwindow
    "autocmd QuickFixCmdPost    l* lwindow
  "augroup END


  "Term {{{
  "Enter insert mode on switch to term and on leave leave insert mode
  "------------------------------------------------------------------
  augroup term_buf
    autocmd!
    "The following causes vimux to have an i inserted :(
    "autocmd BufWinEnter term://*  call feedkeys('i')
    autocmd TermOpen * autocmd BufEnter <buffer> startinsert
    autocmd! BufLeave term://* stopinsert

    "Prevent listing terminal buffers in ls command
    "autocmd Filetype term set nobuflisted
    autocmd TermOpen * set nobuflisted
  augroup END
   "}}}




" }}}
" ============================================================================
" SETTINGS {{{
" ============================================================================

  "Keep diffme function state
  let $diff_me=0

  " Specify path to your Uncrustify configuration file.
  let g:uncrustify_cfg_file_path =
        \ shellescape(fnamemodify('~/.uncrustify.cfg', ':p'))


set background=dark
"colorscheme molokai
colorscheme hybrid_reverse
"colorscheme material-theme
"colorscheme materialtheme

"set rulerformat to include line:col filename +|''
"set rulerformat=%<%(%p%%\ %)%l%<%(:%c\ %)%=%t%<\ %M
set rulerformat=%l:%<%c%=%p%%\ %R\ %m


" set background=light
" colorscheme gruvbox

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

" Centralize backups, swapfiles and undo history
set backupdir=~/.config/nvim/.cache/backups

"How should I decide to take abackup
set backupcopy=auto

set directory=~/.config/nvim/.cache/swaps
set viewdir=~/.config/nvim/.cache/views

if exists("&undodir")
set undodir=~/.config/nvim/.cache/undo
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
"TODO: tpope sets smarttab
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
set nocursorline "Use iTerm cursorline instead

set hlsearch
set ignorecase
set smartcase
set matchtime=2                       " time in decisecons to jump back from matching bracket
set incsearch                         " Highlight dynamically as pattern is typed
set history=1000

"Show the left side fold indicator
set foldcolumn=1
set foldmethod=marker
" These commands open folds
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo


" Set a nicer foldtext function
"au BufEnter,BufWinEnter *.vim set foldtext=MyFoldText()
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

  let sub =  '<U+E729> ' . sub . "                                                                                                "
  "let sub = sub . "<U+E776> <U+E729> <U+F1BE>  <U+F476> <U+F48C> <U+F432> <U+F458> <U+F261> <U+F41A>  <U+F205>  <U+F260>                                                                                                  "
  let num_w = getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' )
  let fold_w = getwinvar( 0, '&foldcolumn' )
  let sub = strpart( sub, 0, winwidth(0) - strlen( info ) - num_w - fold_w - 1 )

  let s:foldlevel = v:foldlevel
  while (s:foldlevel > 1)
    let sub = ' '.sub
    let s:foldlevel = s:foldlevel-1
  endwhile

  return  sub . info
endfunction


set nowrap

set timeout timeoutlen=500
"NeoVim handles ESC keys as alt+key set this to solve the problem
set ttimeout ttimeoutlen=0

" Show the filename in the window titlebar
set title "titlestring=

syntax on
set virtualedit=all
set mouse=                            " Let the term control mouse selection
set hidden
set laststatus=2                      " force status line display
set showtabline=0                     " hide tabline
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

"set cpoptions+=ces$                    " CW wrap W with $ instead of delete
set cpo+=n                             " Draw color for lines that has number only

set showmode                          " Show the current mode

if !exists('neovim_dot_app')
  set showcmd                           " Makes OS X slow, if lazy redraw set
endif

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
" COLORS {{{
" ============================================================================
"#D35636
  "hi Visual guibg=#FBBC05 guifg=#0F0F0F
  hi Visual guibg=#D45438 guifg=white
  hi PmenuSel guibg=#D45438 guifg=white

  hi FoldColumn guibg=none guifg=#373b41
  hi Folded ctermfg=243 ctermbg=234 guifg=#707880 guibg=#151515

  hi NERDTreeCurrentNode guibg=#B34826 guifg=white
  hi MatchParen gui=underline ctermfg=234 ctermbg=60 guifg=#1d1f21 guibg=#D95D63

  set laststatus=0
  set nolist
  set foldlevelstart=2

  " vim-buftabline support
  hi! SLIdentifier guibg=#151515 guifg=#ffb700 gui=bold cterm=bold ctermbg=233i ctermfg=214
  hi! SLCharacter guibg=#151515 guifg=#e6db74 ctermbg=233 ctermfg=227
  hi! SLType guibg=#151515 guifg=#66d9ae gui=bold cterm=bold ctermbg=233 ctermfg=81
  hi! link BufTabLineFill StatusLine
  hi! link BufTabLineCurrent SLIdentifier
  hi! link BufTabLineActive SLCharacter
  hi! link BufTabLineHidden SLType

  "hi Folded ctermfg=250 ctermbg=236 guifg=#B04A2F guibg=#232526
  "hi FoldColumn ctermfg=250 ctermbg=236 guifg=#465457 guibg=#232526
  hi Folded ctermfg=250 ctermbg=236 guifg=#00F0FF guibg=#232526
  hi FoldColumn ctermfg=250 ctermbg=236 guifg=#00F0FF guibg=#232526

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
  let g:terminal_color_7  = '#FBBC05'


  "Multiedit highlight colors
  "This makes it faster too!
  hi! MultieditRegions guibg=#AF1469
  hi! MultieditFirstRegion guibg=#ED3F6C

" }}}
" ============================================================================
" OVER_RIDES {{{
" ============================================================================
" Align_operator {{{
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

function! SetProjectPath()"{{{
  lcd ~/Development/Projects/PHP/younesagha/younesagha
  cd ~/Development/Projects/PHP/younesagha/younesagha
  pwd
  set path+=public/**
endfunction

nnoremap <silent> <c-p><c-\> :call SetProjectPath()<cr>"}}}

" function! neomake#makers#ft#cs#EnabledMakers()"{{{
"   if neomake#utils#Exists('mcs')
"     return ['mcs']
"   end
" endfunction

" function! neomake#makers#ft#cs#mcs()
"   return {
"         \ 'args': ['--parse', '--unsafe'],
"         \ 'errorformat': '%f(%l\,%c): %trror %m',
"         \ }
" endfunction"}}}

" }}}
" ============================================================================

