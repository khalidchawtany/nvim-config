function! CleanEmptyBuffers() "{{{
  let buffers = filter(range(0, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0')
  if !empty(buffers)
    exe 'bw '.join(buffers, ' ')
  endif
endfunction
command! Cls call CleanEmptyBuffers()
nnoremap <c-w>e call CleanEmptyBuffers()
"}}}

function! s:InitRepeatRegisterQ() "{{{
  if PM_ISS('vim-repeat')
    call repeat#set("\<Plug>(ExecuteRegisterQ)")
  endif

  return 'q'
endfunction
au VimEnter * nnoremap <silent> <Plug>(ExecuteRegisterQ)
      \ :<C-u>execute 'normal! ' . v:count1 . '@q'
      \ \| call repeat#set("\<Plug>(ExecuteRegisterQ)")<CR>
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

command! WipeoutUnmodified call s:wipeout()

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
    if (a:char == ' ' || a:char == '')
        let s:char_to_find = strpart(trim(s:line), 0)
    else
        let s:char_to_find  = a:char
    endif
        let s:pos  = stridx(s:line, s:char_to_find, s:cur_col)
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

 inoremap <silent> <C-g><c-space> <C-[>:call InsertSpaces()<CR>A
 inoremap <silent> <C-g><space> <C-[>:call InsertSpaces()<CR>A

"}}}

" The following function takes a command such as the following
" >>   Map !NV key <plug-name> command
"      !       -indiucates that the mapping is silent
"      CAPS    -capital letters indicate noremap
function! Map(mode, key, ...) abort"{{{
  let ops=""
  for op in a:000
    let ops = ops . ' ' .op
  endfor

  "echomsg a:mode "-" a:key "-" ops
  let silent=""
  for c in split(a:mode, '\zs')
    if c == "!"                       | let silent="<silent>"      | continue | endif
    if type(c)==1 && tolower(c) !=# c | let c=tolower(c)."noremap" | else     | let c=tolower(c)."map" | endif
    if stridx(c, "t") == 0 && !has("nvim") | continue | endif
    execute c silent a:key ops
    let silent=""
  endfor
endfunction

command! -nargs=* Map call Map(<f-args>)

"}}}
" The following function takes a command such as the following, this applies the
" plug and SID for showing with leader guide
" >>   LMap !NVExpr key <plug|SID-name> command
"      !       -indiucates that the mapping is silent
"      Expr    -indiucates that the mapping is expression
"      CAPS    -capital letters indicate noremap
function! LMap(mode, key, pluginfo, ...) abort"{{{
  let ops=""
  for op in a:000
    let ops = ops . ' ' .op
  endfor

  " echomsg a:mode "~" a:key "~" a:pluginfo "~" ops

  let mode=a:mode
  let silent=""
  let expr=""
  let isExpr = a:mode[-4:]=='Expr'
  if isExpr
      let mode = a:mode[0:-5]
  endif
  for c in split(mode, '\zs')
    let cc = tolower(c)."map"
    if c == "!"                       | let silent="<silent>"      | continue | endif
    if isExpr                         | let expr="<expr>"                     | endif
    if type(c)==1 && tolower(c) !=# c | let c=tolower(c)."noremap" | else     | let c=tolower(c)."map" | endif
    if stridx(c, "t") == 0 && !has("nvim") | continue | endif
    execute c silent expr a:pluginfo ops
    execute cc silent a:key a:pluginfo
    let silent=""
  endfor
endfunction

command! -nargs=* LMap call LMap(<f-args>)

LMap N <leader>fd <Plug>open-vimrc :e $MYVIMRC<CR>

"}}}

function! PlugTextObj(repo, key, ...)"{{{
  let lazy = (a:0 >= 2) ? a:1 : 1
  let name = a:repo
  let name = substitute(name, ".*/vim-textobj-", "", "")
  if lazy ==1
    execute  "call PM( '" . a:repo . "', {'on_map': ['<Plug>(textobj-" . name . "-']})"
  else
    execute  "call PM( '" . a:repo . "')"
  endif
  execute "Map vo" "i".a:key "<Plug>(textobj-" . name . "-i)"
  execute "Map vo" "a".a:key "<Plug>(textobj-" . name . "-a)"
endfunction"}}}

function! CreateFoldableCommentFunction() range"{{{

  echo "firstline ".a:firstline." lastline ".a:lastline

  for lineno in range(a:firstline, a:lastline)
    let line = getline(lineno)

    "Find the line contains the Plug as it's first word
    if get(split(line, " "), 0, 'Default') !=# 'call' && get(split(line, " "), 0, 'Default') !=# 'if'
      continue
    endif

    let name_start = stridx(line, "/") + 1
    let name_length = stridx(line, "'", name_start) - name_start

    let name = strpart(line, name_start, name_length)

    let res = append(a:firstline - 1, " \" " . name . " {{{")
    " let res = append(a:firstline, "")

    " let res = append(a:lastline + 2, "")
    let res = append(a:lastline + 1, " \"}}} _ " . name)

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
  let bufname = bufname()
  if stridx(bufname, 'fern:' != 0)
    let start = stridx(bufname, 'file:')
    let end = stridx(bufname, ';')
    let curdir = strcharpart(bufname, start+7, end-start-7)
  else
    let curdir = expand('%:p:h')
  endif
  let gitdir = finddir('.git', curdir . ';')
  if gitdir == '.git'
    return '.'
  endif
  if gitdir != ''
      if has('mac')
          return substitute(gitdir, '\/\.git$', '', '')
      elseif has('win64')
          return substitute(gitdir, '\\.git$', '', '')
      endif
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

function! EnsureDirectoryExists() "{{{
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

  "if buffer == -1
  "  echohl ErrorMsg
  "  echomsg "No matching buffer for" a:buffer
  "  echohl None
  "  return
  "endif

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

"{{{ miniyank-fzf
 function! FZFYankList() abort
  function! KeyValue(key, val)
    let line = join(a:val[0], '\n')
    if (a:val[1] ==# 'V')
      let line = '\n'.line
    endif
    return a:key.' '.line
  endfunction
  return map(miniyank#read(), function('KeyValue'))
endfunction

function! FZFYankHandler(opt, line) abort
  let key = substitute(a:line, ' .*', '', '')
  if !empty(a:line)
    let yanks = miniyank#read()[key]
    call miniyank#drop(yanks, a:opt)
  endif
endfunction

command! FzfYanksAfter call fzf#run(fzf#wrap('FzfYanksAfter', {
\ 'source':  FZFYankList(),
\ 'sink':    function('FZFYankHandler', ['p']),
\ 'options': '--no-sort --prompt="Yanks-p> "',
\ }))

command! FzfYanksBefore call fzf#run(fzf#wrap('FzfYanksBefore', {
\ 'source':  FZFYankList(),
\ 'sink':    function('FZFYankHandler', ['P']),
\ 'options': '--no-sort --prompt="Yanks-P> "',
\ }))

nnoremap <c-p><c-y> :FzfYanksAfter<cr>
nnoremap <c-p><c-y> :FzfYanksBefore<cr>
"}}}

"{{{ fzf-registers
 function! s:get_registers() abort
  redir => l:regs
  silent registers
  redir END

  return split(l:regs, '\n')[1:]
endfunction

function! s:registers(...) abort
  let l:opts = {
        \ 'source': s:get_registers(),
        \ 'sink': {x -> feedkeys(matchstr(x, '\v^\S+\ze.*') . (a:1 ? 'P' : 'p'), 'x')},
        \ 'options': '--prompt="Reg> "'
        \ }
  call fzf#run(fzf#wrap(l:opts))
endfunction

command! -bang FzfRegisters call s:registers('<bang>' ==# '!')
nnoremap <c-p><c-"> <cmd>FzfRegisters<cr>
"}}}


" Split teminal on right side
set splitright
" send paragraph under curso to terminal
function! Exec_on_term(cmd)
  if a:cmd=="normal"
    exec "normal mk\"vyip"
  else
    exec "normal gv\"vy"
  endif
  if !exists("g:last_terminal_chan_id")
    vs
    terminal
    let g:last_terminal_chan_id = b:terminal_job_id
    wincmd p
  endif

  if getreg('"v') =~ "^\n"
    call chansend(g:last_terminal_chan_id, expand("%:p")."\n")
  else
    call chansend(g:last_terminal_chan_id, @v)
  endif
  exec "normal `k"
endfunction

nnoremap <F6> :call Exec_on_term("normal")<CR>
vnoremap <F6> :<c-u>call Exec_on_term("visual")<CR>
