" ============================================================================
" init {{{
" ============================================================================
"prevent neovim-dot-app to source me twice {{{
if exists('neovim_dot_app')
  if exists('g:vimrc_sourced')
    finish
  endif
  let g:vimrc_sourced=1
endif
"}}}

let g:python_host_prog='/usr/local/bin/python'
let g:python3_host_prog='/usr/local/bin/python3'
let g:python_host_skip_check = 1
let g:python3_host_skip_check = 1

set termguicolors
let $nvim_tui_enable_true_color=1
let $nvim_tui_enable_cursor_shape=1
" leader keys {{{
  let mapleader = "\<space>"
  let g:mapleader = "\<space>"
  let localleader = "\\"
  let g:loaclleader = "\\"
"}}}
"}}} _init
" ============================================================================
" functions {{{
" ============================================================================
function! Plug(plugin, dict )
  if(g:plugin_manager == "plug")
    call dein#add(a:plugin, dict)
  else
    execute "Plug '" . a:plug ."''"
  endif

endfunction

function! s:cleanemptybuffers() "{{{
  let buffers = filter(range(0, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0')
  if !empty(buffers)
    exe 'bw '.join(buffers, ' ')
  endif
endfunction
command! cls <sid>cleanemptybuffers()
nnoremap <c-w>e <sid>cleanemptybuffers()
"}}}


function! s:initrepeatregisterq() "{{{
    call repeat#set("\<plug>(executeregisterq)")
    return 'q'
endfunction
au vimenter * nnoremap <silent> <plug>(executeregisterq)  :<c-u>execute 'normal! ' . v:count1 . '@q' \| call repeat#set("\<plug>(executeregisterq)")<cr>
nnoremap <expr> q <sid>initrepeatregisterq()

"}}}

function s:bw(bwstage) "{{{
"here is a more exotic version of my original bw script
"delete the buffer; keep windows; create a scratch buffer if no buffers left
  if(a:bwstage == 1)
    if(!buflisted(winbufnr(0)))
      bd!
      return
    endif
    let s:bwbufnum = bufnr("%")
    let s:bwwinnum = winnr()
    windo call s:bw(2)
    execute s:bwwinnum . 'wincmd w'
    let s:buflistedleft = 0
    let s:buffinaljump = 0
    let l:nbufs = bufnr("$")
    let l:i = 1
    while(l:i <= l:nbufs)
      if(l:i != s:bwbufnum)
        if(buflisted(l:i))
          let s:buflistedleft = s:buflistedleft + 1
        else
          if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:buffinaljump)
            let s:buffinaljump = l:i
          endif
        endif
      endif
      let l:i = l:i + 1
    endwhile
    if(!s:buflistedleft)
      if(s:buffinaljump)
        windo if(buflisted(winbufnr(0))) | execute "b! " . s:buffinaljump | endif
      else
        enew
        let l:newbuf = bufnr("%")
        windo if(buflisted(winbufnr(0))) | execute "b! " . l:newbuf | endif
      endif
      execute s:bwwinnum . 'wincmd w'
    endif
    if(buflisted(s:bwbufnum) || s:bwbufnum == bufnr("%"))
      execute "bd! " . s:bwbufnum
    endif
    if(!s:buflistedleft)
      set buflisted
      set bufhidden=delete
      set buftype=
      setlocal noswapfile
    endif
  else
    if(bufnr("%") == s:bwbufnum)
      let prevbufvar = bufnr("#")
      if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:bwbufnum)
        b #
      else
        bn
      endif
    endif
  endif
endfunction "}}}

command! bw call s:bw(1)
nnoremap <silent> <plug>bw :<c-u>bw<cr>

function! s:wipeout() "{{{
  "wipe unmodified buffers|tabs|windows
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

command! wipeout call s:wipeout()

"}}}

 " <c-g> insert mode align ( = , : ) {{{
function! charsneeded(char)
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

function! insertspaces()
  let s:char = getline(".")[-1:]
  let s:nspace = charsneeded(s:char)
  if s:nspace > -1
    call setline(".", getline(".")[:-2] . repeat(" ", s:nspace) . s:char)
  endif
  echom "no `" . s:char . "' found in the previous lines."
endfunction

inoremap <silent> <c-g> <c-[>:call insertspaces()<cr>a
"}}}

 function! map(mode, key, op)"{{{
   "echomsg a:mode "-" a:key "-" a:op
   let silent=""
   for c in split(a:mode, '\zs')
     if c == "!"                       | let silent="<silent>"      | continue | endif
     if type(c)==1 && tolower(c) !=# c | let c=tolower(c)."noremap" | else     | let c=tolower(c)."map" | endif
     execute c silent a:key a:op
     let silent=""
   endfor
 endfunction

 command! -nargs=* map call map(<f-args>)
"}}}

  function! plugtextobj(repo, key)"{{{
    let name = a:repo
    let name = substitute(name, ".*/vim-textobj-", "", "")
    execute  "call dein#add( '" . a:repo . "', {'on_map': ['<plug>(textobj-" . name . "-']})"
    execute "map vo" "i".a:key "<plug>(textobj-" . name . "-i)"
    execute "map vo" "a".a:key "<plug>(textobj-" . name . "-a)"
  endfunction"}}}

  function! createfoldablecommentfunction() range"{{{

    echo "firstline ".a:firstline." lastline ".a:lastline

    for lineno in range(a:firstline, a:lastline)
      let line = getline(lineno)

      "find the line contains the plug as it's first word
      if ( get(split(line, " "), 0, 'default') !=# 'call')
        continue
      endif

      let name_start = stridx(line, "/") + 1
      let name_length = stridx(line, "'", name_start) - name_start

      let name = strpart(line, name_start, name_length)

      let res = append(a:firstline - 1, " \" " . name . " {{{")
      let res = append(a:firstline, "")

      let res = append(a:lastline + 2, "")
      let res = append(a:lastline + 3, " \"}}} _" . name)

      " let cleanline = substitute(lifirstlinene, '\(\s\| \)\+$', '', 'e')
      " call setline(lineno, cleanline)
      break
    endfor

  endfunction"}}}

  function! highlightallofword(onoff)"{{{
    if a:onoff == 1
      :augroup highlight_all
      :au!
      :au cursormoved * silent! exe printf('match search /\<%s\>/', expand('<cword>'))
      :augroup end
    else
      :au! highlight_all
      match none /\<%s\>/
    endif
  endfunction"}}}

  function! togglemousefunction()"{{{
    if  &mouse=='a'
      set mouse=
      echo "shell has it"
    else
      set mouse=a
      echo "vim has it"
    endif
  endfunction"}}}

  function! stripwhitespace()"{{{
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
  endfunction"}}}

  function! findgitdirorroot()"{{{
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

  function! indenttonextbraceinlineabove()"{{{
    :normal 0wk
    :normal "vyf(
    let @v = substitute(@v, '.', ' ', 'g')
    :normal j"vpl
  endfunction"}}}

  function! list(command, selection, start_at_cursor, ...)"{{{

  " this is an updated, more powerful, version of the function discussed here:
  " http://www.reddit.com/r/vim/comments/1rzvsm/do_any_of_you_redirect_results_of_i_to_the/
  " that shows ]i, [i, ]d, [d, :ilist and :dlist results in the quickfix window, even spanning multiple files.
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
      redir end
    else
      redir => output
      silent! execute 'normal! ' . (a:start_at_cursor ? ']' : '[') . normcmd
      redir end
    endif

    " clean up the output
    let lines = split(output, '\n')

    " bail out on errors
    if lines[0] =~ '^error detected'
      echomsg 'could not find "' . (a:selection ? search_pattern : expand("<cword>")) . '".'
      return
    endif

    " our results may span multiple files so we need to build a relatively
    " complex list based on file names
    let filename   = ""
    let qf_entries = []
    for line in lines
      if line =~ '^\s'
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

  function! preserve(command)"{{{
    " save the last search.
    let search = @/

    " save the current cursor position.
    let cursor_position = getpos('.')

    " save the current window position.
    normal! h
    let window_position = getpos('.')
    call setpos('.', cursor_position)

    " execute the command.
    execute a:command

    " restore the last search.
    let @/ = search

    " restore the previous window position.
    call setpos('.', window_position)
    normal! zt

    " restore the previous cursor position.
    call setpos('.', cursor_position)
  endfunction"}}}

  function! uncrustify(language) "{{{

  " don't forget to add uncrustify executable to $path (on unix) or
  " %path% (on windows) for this command to work.

    call preserve(':silent %!uncrustify'
          \ . ' -q '
          \ . ' -l ' . a:language
          \ . ' -c ' . g:uncrustify_cfg_file_path)
  endfunction"}}}

  function! openhelpincurrentwindow(topic) "{{{
    view $vimruntime/doc/help.txt
    setl filetype=help
    setl buftype=help
    setl nomodifiable
    exe 'keepjumps help ' . a:topic
  endfunction "}}}

" scratchpad {{{
  augroup scratchpad
    au!
    au bufnewfile,bufread .scratchpads/scratchpad.* call scratchpadload()
  augroup end

  function! scratchpadsave() "{{{
    let ftype = matchstr(expand('%'), 'scratchpad\.\zs\(.\+\)$')
    if ftype == ''
      return
    endif
    write
  endfunction "}}}

  function! scratchpadload() "{{{
    nnoremap <silent> <buffer> q :w<cr>:close<cr>
    setlocal bufhidden=hide buflisted noswapfile
  endfunction "}}}

  function! openscratchpad(ftype) "{{{
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
      echoerr 'scratchpad need a filetype'
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
      " scratch buffer is already created. check whether it is open
      " in one of the windows
      let scr_winnum = bufwinnr(scr_bufnum)
      if scr_winnum != -1
        " jump to the window which has the scratchpad if we are not
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

  function! getvisualselection() "{{{
  " why is this not a built-in vim script function?!
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    return join(lines, "\n")
  endfunction "}}}

  function! renamefile() "{{{
    let old_name = expand('%')
    let new_name = input('new file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
      exec ':saveas ' . new_name
      exec ':silent !rm ' . old_name
      redraw!
    endif
  endfunction "}}}

  function! searchforcallsitescursor() "{{{
  "find references of this function (function calls)
    let searchterm = expand("<cword>")
    call searchforcallsites(searchterm)
  endfunction "}}}

  function! searchforcallsites(term) "{{{
  " search for call sites for term (excluding its definition) and
  " load into the quickfix list.
    cexpr system('ag ' . shellescape(a:term) . '\| grep -v def')
  endfunction "}}}

  function! s:ensuredirectoryexists() "{{{
    let required_dir = expand("%:h")

    if !isdirectory(required_dir)
      " remove this if-clause if you don't need the confirmation
      if !confirm("directory '" . required_dir . "' doesn't exist. create it?")
        return
      endif

      try
        call mkdir(required_dir, 'p')
      catch
        echoerr "can't create '" . required_dir . "'"
      endtry
    endif
  endfunction "}}}

  function! diffme() "{{{
  " toggle the diff of currently open buffers/splits.
    windo diffthis
    if $diff_me>0
      let $diff_me=0
    else
      windo diffoff
      let $diff_me=1
    endif
  endfunction "}}}

  fu! relativepathstring(file) "{{{
  "get relative path to this file
    if strlen(a:file) == 0
      retu "[no name]"
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

  function! reg() "{{{
  ":reg shows and prompts to select from a reg
    reg
    echo "register: "
    let char = nr2char(getchar())
    if char != "\<esc>"
      execute "normal! \"".char."p"
    endif
    redraw
  endfunction "}}}

  function! createlaravelgeneratorfunction()"{{{
    "generate laravel generator command

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

    "if --fields is not already provided
    if stridx(command, '--fields') ==? "-1"

      "get the command part
      let cmd_shortform = strpart(command, 0,stridx(command, " "))
      "the list of commands that require --fields
      let cmd_require_fields = ['mi', 'r', 's' ]

      "if the command is not one of the above
      if index(cmd_require_fields, cmd_shortform) !=? "-1"
        let fields = input( "!g:" . command . ' --fields= ')
        let command = command . ' --fields="' . fields . '"'
      endif "command requires --fields

    endif " --fields is not provided

    if strlen(command) !=? "0"
      "prepend cmd with required stuff
      let command = "g:" . command
    endif

    return command

  endfunction"}}}

  function! executelaravelgeneratorcmd()"{{{
    let cmd = createlaravelgeneratorfunction()
    call vimuxruncommand(cmd)
    call vimuxzoomrunner()
  endfunction"}}}

  function! bufonly(buffer, bang) "{{{
    if a:buffer == ''
      " no buffer provided, use the current buffer.
      let buffer = bufnr('%')
    elseif (a:buffer + 0) > 0
      " a buffer number was provided.
      let buffer = bufnr(a:buffer + 0)
    else
      " a buffer name was provided.
      let buffer = bufnr(a:buffer)
    endif

    if buffer == -1
      echohl errormsg
      echomsg "no matching buffer for" a:buffer
      echohl none
      return
    endif

    let last_buffer = bufnr('$')

    let delete_count = 0
    let n = 1
    while n <= last_buffer
      if n != buffer && buflisted(n)
        if a:bang == '' && getbufvar(n, '&modified')
          echohl errormsg
          echomsg 'no write since last change for buffer'
                \ n '(add ! to override)'
          echohl none
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

  function! togglefoldmethod(...) "{{{
    let l:fm = ['syntax', 'manual', 'marker', 'indent', 'off']
    let l:index = &foldenable>0 ? index(l:fm, &foldmethod) : 0
    let l:next_fm = l:fm[ l:index + 1 * ( len(a:000)>0?-1:1) ]
    if l:next_fm=="off"
      set nofoldenable
    else
      set foldenable
      execute "set foldmethod=".l:next_fm
    endif
    let g:submode_toggle_fold = &foldenable==0? "off": &foldmethod
  endfunction "}}}

  function! togglefoldmarker() "{{{
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
" plug-ins {{{
" ============================================================================

"clean unused plugins uninstall
"call map(dein#check_clean(), "delete(v:val, 'rf')")

"dein start {{{
"dein scripts-----------------------------
if &compatible
  set nocompatible               " be improved
endif

" required:
set runtimepath^=/volumes/home/.config/nvim/dein/repos/github.com/shougo/dein.vim

" required:
call dein#begin(expand('/volumes/home/.config/nvim/dein'))

" let dein manage dein
" required:
call dein#add('shougo/dein.vim')
"}}} _dein start

" ----------------------------------------------------------------------------
" libraries {{{
" ----------------------------------------------------------------------------
 " revital.vim {{{

call dein#add( 'haya14busa/revital.vim' )

 "}}} _revital.vim

 " vital.vim {{{

 call dein#add( 'vim-jp/vital.vim' )

 "}}} _vital.vim

"}}}
 " ----------------------------------------------------------------------------
 " version control & diff {{{
 " ----------------------------------------------------------------------------

 " vim-fugitive {{{

 call dein#add( 'tpope/vim-fugitive'
       \ , { 'on_cmd': [
       \     'git', 'gcd',     'glcd',   'gstatus',
       \     'gcommit',  'gmerge',  'gpull',  'gpush',
       \     'gfetch',   'ggrep',   'glgrep', 'glog',
       \     'gllog',    'gedit',   'gsplit', 'gvsplit',
       \     'gtabedit', 'gpedit',  'gread',  'gwrite',
       \     'gwq',      'gdiff',   'gsdiff', 'gvdiff',
       \     'gmove', 'gremove', 'gblame', 'gbrowse' ],
       \  'hook_post_source': "call fugitive#detect(expand('%:p'))"
       \ })

 autocmd user fugitive
       \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
       \   nnoremap <buffer> .. :edit %:h<cr> |
       \ endif
 autocmd bufreadpost fugitive://* set bufhidden=delete
 " set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%v%)\ %p

 "}}} _vim-fugitive
 " gv.vim {{{

   "requires vim-fugitive
   call dein#add( 'junegunn/gv.vim', {
         \ 'depends': 'vim-fugitive',
         \ 'on_cmd': ['gv', 'gv!', 'gv?']
         \ })

 "}}} _gv.vim
 " vim-gitgutter {{{

   call dein#add( 'airblade/vim-gitgutter' )

 "}}} _vim-gitgutter
 " vimagit {{{

   call dein#add( 'jreybert/vimagit', {'on': ['magit'], 'rev': 'next'} )
   " don't show help as it can be toggled by h
   let g:magit_show_help=0
   "nnoremap <leader>g :magit<cr>
   let g:magit_show_magit_mapping=''
 "}}} _vimagit

 " dirdiff.vim {{{

   call dein#add( 'vim-scripts/dirdiff.vim', {'on_cmd': ['dirdiff']} )

 "}}} _dirdiff.vim
 " vim-diff-enhanced {{{

  call dein#add( 'chrisbra/vim-diff-enhanced' )
  " started in diff-mode set diffexpr (plugin not loaded yet)
  if &diff
    let &diffexpr='enhanceddiff#diff("git diff", "--diff-algorithm=patience")'
  endif
 "}}} _vim-diff-enhanced
 " recover-with-diff{{{

 call dein#add( 'chrisbra/recover.vim' )

 "}}} _recover-with-diff

 call dein#add('rickhowe/diffchar.vim')

 "}}}
 " ----------------------------------------------------------------------------
 " content editor {{{
 " ----------------------------------------------------------------------------

 " org
 " vim-speeddating {{{

   call dein#add( 'tpope/vim-speeddating', {'on_ft': ['org'],'on_map': ['<plug>speeddatingup', '<plug>speeddatingdown']} )

 "}}} _vim-speeddating
 " vim-orgmode {{{

   "call dein#add( 'jceb/vim-orgmode', {'on_ft': 'org'} )
   call dein#add( 'jceb/vim-orgmode' )
   let g:org_agenda_files=['~/org/index.org']
   let g:org_todo_keywords=['todo', 'feedback', 'verify', 'wip', '|', 'done', 'delegated']
   let g:org_heading_shade_leading_stars = 1   "hide the star noise

 "}}} _vim-orgmode
 "syntaxrange {{{

    call dein#add('syntaxrange')

 "}}} _syntaxrange
 "utl.vim{{{
   call dein#add( 'utl.vim' )
 "_utl.vim}}}
 " lazylist.vim {{{

   call dein#add( 'kabbamine/lazylist.vim', {'on_cmd': ['lazylist']} )

   let g:lazylist_omap = 'igll'
   nnoremap glli :lazylist
   vnoremap glli :lazylist
   nnoremap glli :lazylist<cr>
   vnoremap glli :lazylist<cr>
   nnoremap gll- :lazylist '- '<cr>
   vnoremap gll- :lazylist '- '<cr>
   nnoremap gll. :lazylist '%1%. '<cr>
   vnoremap gll. :lazylist '%1%. '<cr>

   nnoremap gll* :lazylist '* '<cr>
   vnoremap gll* :lazylist '* '<cr>

   nnoremap gllt :lazylist '- [ ] '<cr>
   vnoremap gllt :lazylist '- [ ] '<cr>

 "}}} _lazylist.vim
 " vim-simple-todo {{{

 call dein#add( 'vitalk/vim-simple-todo', {
       \ 'on_ft': ['org'],
       \ 'hook_post_source' : " 
         \ |  nmap <leader>i <plug>(simple-todo-new)
         \ |  nmap <leader>i <plug>(simple-todo-new-start-of-line)
         \ |  nmap <leader>o <plug>(simple-todo-below)
         \ |  nmap <leader>o <plug>(simple-todo-above)
         \ |  nmap <leader>x <plug>(simple-todo-mark-as-done)
         \ |  nmap <leader>x <plug>(simple-todo-mark-as-undone) "
       \ })
       "\ 'on_map': ['<plug>(simple-todo-']

   " disable default key bindings
   let g:simple_todo_map_keys = 0

   let g:simple_todo_tick_symbol = 'y'



 "}}} _vim-simple-todo
 "vim-dotoo {{{
    call dein#add('dhruvasagar/vim-dotoo', {'on_ft': ['org']} )
 "}}} _vim-todo
 " vim-table-mode {{{

   call dein#add( 'dhruvasagar/vim-table-mode', {'on_cmd': ['tabelmodeenable', 'tablemodetoggle', 'tableize']} )
   let g:table_mode_corner_corner="+"
   let g:table_mode_header_fillchar="="

 "}}} _vim-table-mode
 " calendar.vim {{{

   call dein#add( 'itchyny/calendar.vim', {'on_cmd': ['calendar'] } )
   let g:calendar_date_month_name = 1

 "}}} _calendar.vim
 " calendar-vim {{{

   call dein#add( 'mattn/calendar-vim', {'on_cmd': ['calendarh', 'calendart'] } )

 "}}} _calendar-vim
 " vim-journal {{{

   "call dein#add( 'junegunn/vim-journal', {'on_ft': ['journal']} )
   call dein#add( 'junegunn/vim-journal' )

 "}}} _vim-journal
 " vimwiki {{{

   call dein#add( 'vimwiki/vimwiki' )
   let g:vimwiki_map_prefix = '<leader>v'

 "}}} _vimwiki
 " junkfile.vim {{{

   call dein#add( 'shougo/junkfile.vim', {'on_cmd': ['junkfileopen']} )
   let g:junkfile#directory = $home . '/.config/nvim/cache/junkfile'

   nnoremap <leader>jo :junkfileopen

 "}}}

 " multi-edits
 " vim-fnr {{{


   "requires pseudocl
   call dein#add( 'junegunn/vim-fnr', {'on_map': ['<plug>(fnr)','<plug>(fnr%)']} )

   " defaults
   let g:fnr_flags   = 'gc'
   let g:fnr_hl_from = 'todo'
   let g:fnr_hl_to   = 'incsearch'

   "custom mapping
   nmap g;s <plug>(fnr)
   xmap g;s <plug>(fnr)
   nmap g;s <plug>(fnr%)
   xmap g;s <plug>(fnr%)

   " special keys

   " tab
       " i - case-insensitive match
       " w - word-boundary match (\<string\>)
       " g - substitute all occurrences
       " c - confirm each substitution
       " tab or enter to return
   " ctrl-n or ctrl-p
       " auto-completion


 "}}}
 " vim-over {{{

   " plug 'osyo-manga/vim-over', {'on': ['overcommandline']}

   "use vim-fnr instead
   " nmap <leader>/ :overcommandline<cr>
   " nnoremap g;s :<c-u>overcommandline<cr>%s/
   " xnoremap g;s :<c-u>overcommandline<cr>%s/\%v

 "}}} _vim-over
 " vim-enmasse {{{

   call dein#add( 'wolfy87/vim-enmasse',         { 'on_cmd': 'enmasse'} )
   " enmass the sublime like search and edit then save back to corresponding files

 "}}} _vim-enmasse
 " vim-swoop {{{

   call dein#add( 'pelodelfuego/vim-swoop', {'on_cmd': ['swoop']} )
   let g:swoopusedefaultkeymap = 0

   " nmap <leader>ml :call swoopmulti()<cr>
   " vmap <leader>ml :call swoopmultiselection()<cr>
   " nmap <leader>l :call swoop()<cr>
   " vmap <leader>l :call swoopselection()<cr>

   function! multiple_cursors_before()
     if exists('*swoopfreezecontext') != 0
       call swoopfreezecontext()
     endif
   endfunction

   function! multiple_cursors_after()
     if exists('*swoopunfreezecontext') != 0
       call swoopunfreezecontext()
     endif
   endfunction

 "}}} _vim-swoop
 " vim-ags {{{

 call dein#add( 'gabesoft/vim-ags', {'on_cmd': ['ags']} )

 "}}} _vim-ags
 " inline_edit.vim {{{

   call dein#add( 'andrewradev/inline_edit.vim', { 'on_cmd': ['inlineedit']} )

 "}}} _inline_edit.vim
 " vim-multiple-cursors {{{

 "todo: set some mapping
   call dein#add( 'terryma/vim-multiple-cursors' )

   let g:multi_cursor_use_default_mapping=0
   "use ctrl-n to select next instance

 "}}} _vim-multiple-cursors
 " vim-markmultiple {{{

 call dein#add( 'adinapoli/vim-markmultiple', {'on_func':['markmultiple']} )
 let g:mark_multiple_trigger = "<c-n>"

 nnoremap <c-n>  :call markmultiple()<cr>
 xnoremap <c-n>  :call markmultiple()<cr>

 "if effect remains on screen clear with "call markmultipleclean()"
 "map <c-bs>
 map  nv ą :call\ markmultipleclean()<cr>


 "}}} _vim-markmultiple
 " multichange.vim {{{

 call dein#add( 'andrewradev/multichange.vim' )
 let g:multichange_mapping        = 'sm'
 let g:multichange_motion_mapping = 'm'

 "}}} _multichange.vim
 " vim-multiedit {{{

 call dein#add( 'hlissner/vim-multiedit' , { 'on_cmd': [
       \   'multieditaddmark', 'multieditaddregion',
       \   'multieditrestore', 'multiedithop', 'multiedit',
       \   'multieditclear', 'multieditreset'
       \ ] } )

   let g:multiedit_no_mappings = 1
   let g:multiedit_auto_reset = 1

   "force multiedit key bindings and make it faster :)
   au vimenter * call bindmultieditkeys()
   "au user vim-multiedit call bindmultieditkeys()

   function! bindmultieditkeys()

     " insert a disposable marker after the cursor
     nnoremap <leader>ma :multieditaddmark a<cr>

     " insert a disposable marker before the cursor
     nnoremap <leader>mi :multieditaddmark i<cr>

     " make a new line and insert a marker
     nnoremap <leader>mo o<esc>:multieditaddmark i<cr>
     nnoremap <leader>mo o<esc>:multieditaddmark i<cr>

     " insert a marker at the end/start of a line
     nnoremap <leader>ma $:multieditaddmark a<cr>
     nnoremap <leader>mi ^:multieditaddmark i<cr>

     " make the current selection/word an edit region
     vnoremap <leader>m :multieditaddregion<cr>
     nnoremap <leader>mm viw:multieditaddregion<cr>

     " restore the regions from a previous edit session
     nnoremap <leader>mu :multieditrestore<cr>

     " move cursor between regions n times
     noremap ]gc :multiedithop 1<cr>
     noremap [gc :multiedithop -1<cr>

     " start editing!
     nnoremap <leader>ms :multiedit<cr>

     " clear the word and start editing
     nnoremap <leader>mc :multiedit!<cr>

     " unset the region under the cursor
     nnoremap <silent> <leader>md :multieditclear<cr>

     " unset all regions
     nnoremap <silent> <leader>mr :multieditreset<cr>

     nmap <silent> <leader>mn <leader>mm/<c-r>=expand("<cword>")<cr><cr>
     nmap <silent> <leader>mp <leader>mm?<c-r>=expand("<cword>")<cr><cr>

   endfunction

 "}}} _vim-multiedit
 " vim-abolish {{{

   call dein#add( 'tpope/vim-abolish',           { 'on_cmd': ['s','subvert', 'abolish']} )

 "}}} _vim-abolish
 " vim-rengbang {{{

   call dein#add( 'deris/vim-rengbang',          { 'on_cmd': [ 'rengbang', 'rengbanguseprev' ] } )

   "use instead of increment it is much powerfull
   " rengbang \(\d\+\) start# increment# select# %03d => 001, 002

 "}}} _vim-rengbang
 " vim-rectinsert {{{

   call dein#add( 'deris/vim-rectinsert',        { 'on_cmd': ['rectinsert', 'rectreplace'] } )

 "}}} _vim-rectinsert

 " isolate
 " nrrwrgn {{{

 call dein#add( 'chrisbra/nrrwrgn', {
       \ 'on_cmd':
       \   [
       \    'nr', 'narrowregion', 'nw', 'narrowwindow', 'widenregion',
       \    'nrv', 'nud', 'nrprepare', 'nrp', 'nrmulti', 'nrm',
       \    'nrs', 'nrnosynconwrite', 'nrn', 'nrl', 'nrsynconwrite'
       \   ],
       \ 'on_map': ['<plug>nrrwrgn']
       \ })

 nmap <leader>nr <plug>nrrwrgndo

 "}}} _nrrwrgn

 " yank
 " yankring {{{

   " plug 'vim-scripts/yankring.vim'

   " let g:yankring_min_element_length = 2
   " let g:yankring_max_element_length = 548576 " 4m
   " let g:yankring_dot_repeat_yank = 1
   " " let g:yankring_window_use_horiz = 0  " use vertical split
   " " let g:yankring_window_height = 8
   " " let g:yankring_window_width = 30
   " " let g:yankring_window_increment = 50   "in vertical press space to toggle width
   " " let g:yankring_ignore_operator = 'g~ gu gu ! = gq g? > < zf g@'
   " let g:yankring_history_dir = '~/.config/nvim/.cache/yankring'
   " " let g:yankring_clipboard_monitor = 0   "detect when copying from outside
   " " :yrtoggle    " toggles it
   " " :yrtoggle 1  " enables it
   " " :yrtoggle 0  " disables it
   " nnoremap sd :yrtoggle

   " nnoremap <silent> <f11> :yrshow<cr>


 "}}}
 " vim-yankstack {{{

   " plug 'maxbrunsfeld/vim-yankstack'

   " let g:yankstack_map_keys = 0
   " " let g:yankstack_yank_keys = ['y', 'd']
   " nmap <leader>p <plug>yankstack_substitute_older_paste
   " nmap <leader>p <plug>yankstack_substitute_newer_paste

 "}}} _vim-yankstack
 " yankmatches {{{

   " plug '~/.config/nvim/plugged/yankmatches.vim'

   " nnoremap <silent>  dm :     call forallmatches('delete', {})<cr>
   " nnoremap <silent>  dm :     call forallmatches('delete', {'inverse':1})<cr>
   " nnoremap <silent>  ym :     call forallmatches('yank',   {})<cr>
   " nnoremap <silent>  ym :     call forallmatches('yank',   {'inverse':1})<cr>
   " vnoremap <silent>  dm :<c-u>call forallmatches('delete', {'visual':1})<cr>
   " vnoremap <silent>  dm :<c-u>call forallmatches('delete', {'visual':1, 'inverse':1})<cr>
   " vnoremap <silent>  ym :<c-u>call forallmatches('yank',   {'visual':1})<cr>
   " vnoremap <silent>  ym :<c-u>call forallmatches('yank',   {'visual':1, 'inverse':1})<cr>


 " }}}
 " vim-peekaboo {{{

   call dein#add( 'junegunn/vim-peekaboo' )

   " default peekaboo window
   let g:peekaboo_window = 'vertical botright 30new'

   " delay opening of peekaboo window (in ms. default: 0)
   let g:peekaboo_delay = 200

   " compact display; do not display the names of the register groups
   let g:peekaboo_compact = 1


 "}}} _vim-peekaboo
 " unconditionalpaste {{{

   call dein#add( 'vim-scripts/unconditionalpaste', {'on_map': ['<plug>unconditionalpaste']} )
   map n gpp  <plug>unconditionalpastegplusbefore
   map n gpp  <plug>unconditionalpastegplusafter
   map n gpp  <plug>unconditionalpasteplusbefore
   map n gpp  <plug>unconditionalpasteplusafter
   map n gup  <plug>unconditionalpasterecallunjoinbefore
   map n gup  <plug>unconditionalpasterecallunjoinafter
   map n gup  <plug>unconditionalpasteunjoinbefore
   map n gup  <plug>unconditionalpasteunjoinafter
   map n gqp  <plug>unconditionalpasterecallqueriedbefore
   map n gqp  <plug>unconditionalpasterecallqueriedafter
   map n gqp  <plug>unconditionalpastequeriedbefore
   map n gqp  <plug>unconditionalpastequeriedafter
   map n gqbp <plug>unconditionalpasterecalldelimitedbefore
   map n gqbp <plug>unconditionalpasterecalldelimitedafter
   map n gqbp <plug>unconditionalpastedelimitedbefore
   map n gqbp <plug>unconditionalpastedelimitedafter
   map n gbp  <plug>unconditionalpastejaggedbefore
   map n gbp  <plug>unconditionalpastejaggedafter
   map n gsp  <plug>unconditionalpastespacedbefore
   map n gsp  <plug>unconditionalpastespacedafter
   map n g#p  <plug>unconditionalpastecommentedbefore
   map n g#p  <plug>unconditionalpastecommentedafter
   map n g>p  <plug>unconditionalpasteshiftedbefore
   map n g>p  <plug>unconditionalpasteshiftedafter
   map n g[[p <plug>unconditionalpastelessindentbefore
   map n g[[p <plug>unconditionalpastelessindentafter
   map n g]]p <plug>unconditionalpastemoreindentbefore
   map n g]]p <plug>unconditionalpastemoreindentafter
   map n g]p  <plug>unconditionalpasteindentedafter
   map n g[p  <plug>unconditionalpasteindentedbefore
   map n g[p  <plug>unconditionalpasteindentedbefore
   map n g]p  <plug>unconditionalpasteindentedbefore
   map n g,"p <plug>unconditionalpastecommadoublequotebefore
   map n g,"p <plug>unconditionalpastecommadoublequoteafter
   map n g,'p <plug>unconditionalpastecommasinglequotebefore
   map n g,'p <plug>unconditionalpastecommasinglequoteafter
   map n g,p  <plug>unconditionalpastecommabefore
   map n g,p  <plug>unconditionalpastecommaafter
   map n gbp  <plug>unconditionalpasteblockbefore
   map n gbp  <plug>unconditionalpasteblockafter
   map n glp  <plug>unconditionalpastelinebefore
   map n glp  <plug>unconditionalpastelineafter
   map n gcp  <plug>unconditionalpastecharbefore
   map n gcp  <plug>unconditionalpastecharafter

 "}}} _unconditionalpaste

 " vim-copy-as-rtf {{{

 call dein#add( 'zerowidth/vim-copy-as-rtf', {'on_cmd': ['copyrtf']} )

 "}}} _vim-copy-as-rtf

 " single-edits
 " switch.vim {{{

   call dein#add( 'andrewradev/switch.vim', {'on_cmd':  ['switch']} )

 "}}} _switch.vim
 " vim-exchange {{{

   call dein#add( 'tommcdo/vim-exchange', {'on_cmd':  ['exchangeclear'] , 'on_map': ['<plug>(exchange']} )
   xmap c<cr><cr>     <plug>(exchange)
   nmap c<cr>l    <plug>(exchangeline)
   nmap c<cr>c    <plug>(exchangeclear)
   nmap c<cr><bs> <plug>(exchangeclear)
   nmap c<cr><cr> <plug>(exchange)

 "}}} _vim-exchange

 " replacewithregister{{{
 call dein#add('vim-scripts/replacewithregister', { 'on_map': ['<plug>replacewithregister']})
 "}}} _replacewithregister

 " vim-lion {{{

   call dein#add( 'tommcdo/vim-lion' )

 "}}} _vim-lion
 " easyalign {{{

   call dein#add( 'junegunn/vim-easy-align',          {'on_cmd':  ['easyalign'], 'on_map':[ '<plug>(easyalign)']} )

   " start interactive easyalign in visual mode (e.g. vip<enter>)
   vmap <enter> <plug>(easyalign)
   " start interactive easyalign for a motion/text object (e.g. gaip)
   nmap g<cr> <plug>(easyalign)
   let g:easy_align_ignore_comment = 0 " align comments


 "}}}
 " tabular {{{

   call dein#add( 'godlygeek/tabular', {'on_cmd': ['tabularize']} )

   nnoremap <leader>a& :tabularize /&<cr>
   vnoremap <leader>a& :tabularize /&<cr>
   nnoremap <leader>a= :tabularize /=<cr>
   vnoremap <leader>a= :tabularize /=<cr>
   nnoremap <leader>a: :tabularize /:<cr>
   vnoremap <leader>a: :tabularize /:<cr>
   nnoremap <leader>a:: :tabularize /:\zs<cr>
   vnoremap <leader>a:: :tabularize /:\zs<cr>
   nnoremap <leader>a> :tabularize /=><cr>
   vnoremap <leader>a> :tabularize /=><cr>
   nnoremap <leader>a, :tabularize /,<cr>
   vnoremap <leader>a, :tabularize /,<cr>
   nnoremap <leader>a<bar> :tabularize /<bar><cr>
   vnoremap <leader>a<bar> :tabularize /<bar><cr>
   nnoremap <leader>aa :tabularize
   vnoremap <leader>aa :tabularize


 "}}} _tabular
 " vim-surround {{{
 " ----------------------------------------------------------------------------
 call dein#add( 't9md/vim-surround_custom_mapping' )
 call dein#add( 'tpope/vim-surround', {
                           \   'on_map' :[
                           \      '<plug>dsurround' , '<plug>csurround',
                           \      '<plug>ysurround' , '<plug>ysurround',
                           \      '<plug>yssurround', '<plug>yssurround',
                           \      '<plug>yssurround', '<plug>vgsurround',
                           \      '<plug>vsurround' , '<plug>isurround',
                           \      ['i', '<plug>isurround'],
                           \      ['i', '<plug>isurround']
                           \ ]} )
   let g:surround_no_mappings=1
   nmap ds <plug>dsurround
   nmap cs <plug>csurround
   nmap c<cr> <plug>csurround
   nmap ys <plug>ysurround
   nmap ys <plug>ysurround
   nmap yss <plug>yssurround
   nmap yss <plug>yssurround
   nmap yss <plug>yssurround
   xmap s <plug>vsurround
   xmap gs <plug>vgsurround
   "original mappings
   "=================
   "nmap ds  <plug>dsurround
   "nmap cs  <plug>csurround
   "nmap cs  <plug>csurround
   "nmap ys  <plug>ysurround
   "nmap ys  <plug>ysurround
   "nmap yss <plug>yssurround
   "nmap yss <plug>yssurround
   "nmap yss <plug>yssurround
   "xmap s   <plug>vsurround
   "xmap gs  <plug>vgsurround

   imap <c-g>s <plug>isurround
   imap <c-g>s <plug>isurround
   imap <c-s> <plug>isurround

 "}}}
 " splitjoin.vim {{{

   call dein#add( 'andrewradev/splitjoin.vim' , {'on_map':['gs', 'gj']} )

 "}}} _splitjoin.vim
 " vim-sort-motion {{{

  call dein#add( 'christoomey/vim-sort-motion', {'on_map': ['<plug>sort']} )
  map  gs  <plug>sortmotion
  map  gss <plug>sortlines
  vmap gs  <plug>sortmotionvisual

 "}}} _vim-sort-motion
 " vim-tag-comment {{{
   " comment out html properly
   call dein#add( 'mvolkmann/vim-tag-comment', {'on_cmd': ['elementcomment', 'elementuncomment', 'tagcomment', 'taguncomment']} )
   nmap <leader>tc :elementcomment<cr>
   nmap <leader>tu :elementuncomment<cr>
   nmap <leader>tc :tagcomment<cr>
   nmap <leader>tu :taguncomment<cr>

 "}}} _vim-tag-comment

 " comments
 " nerdcommenter {{{

 "don't lazyload as doing so will fragile
  call dein#add( 'scrooloose/nerdcommenter', {'on_map': [ '<plug>nerdcommenter' ]} )
  "call s:setupfornewfiletype(&filetype, 1)

  map nx  <leader>c<space>     <plug>nerdcommentertoggle
  map nx  <leader>ca           <plug>nerdcommenteraltdelims
  map nx  <leader>cb           <plug>nerdcommenteralignboth
  map nx  <leader>ci           <plug>nerdcommenterinvert
  map nx  <leader>cl           <plug>nerdcommenteralignleft
  map nx  <leader>cm           <plug>nerdcommenterminimal
  map nx  <leader>cn           <plug>nerdcommenternested
  map nx  <leader>cs           <plug>nerdcommentersexy
  map nx  <leader>cu           <plug>nerdcommenteruncomment
  map nx  <leader>cy           <plug>nerdcommenteryank
  map nx  <leader>cc           <plug>nerdcommentercomment
  map n   <leader>ca           <plug>nerdcommenterappend
  map n   <leader>c$           <plug>nerdcommentertoeol

 "}}} _nerdcommenter
 " vim-commentary {{{
 call dein#add ('tpope/vim-commentary',
       \ {
       \ 'on_map':
       \ [
       \  '<plug>commentary',
       \  '<plug>commentaryline',
       \  '<plug>changecommentary'
       \ ],
       \ 'on_cmd': [ 'commentary' ]
       \ })
 xmap gc  <plug>commentary
 nmap gc  <plug>commentary
 omap gc  <plug>commentary
 nmap gcc <plug>commentaryline
 nmap cgc <plug>changecommentary
 nmap gcu <plug>commentary<plug>commentary
 " }}} _vim-commentary
   " plug 'tomtom/tcomment_vim'

 " auto-manipulators
 " vim-endwise {{{
   "plug 'tpope/vim-endwise', {'on': []}

   ""lazy load endwise
   "augroup load_endwise
     "autocmd!
     "autocmd insertenter * call plug#load('vim-endwise') | autocmd! load_endwise
   "augroup end

 "}}} _vim-endwise
 " vim-closer {{{

   call dein#add( 'rstacruz/vim-closer' )

 "}}} _vim-closer
 " delimitmate {{{

 "xxxx
 call dein#add( 'raimondi/delimitmate', {'on_event': ['insertenter']} )
   " au filetype blade let b:delimitmate_autoclose = 0

 "}}}

 "}}}
 " ----------------------------------------------------------------------------
 " utils {{{
 " ----------------------------------------------------------------------------


 " pipe.vim {{{

   "pipe !command output to vim
   call dein#add( 'nlknguyen/pipe.vim' )

 "}}} _pipe.vim

 "vim-signature {{{
   call dein#add('kshenoy/vim-signature')
 "}}} _vim-signature'

 " tinymode.vim {{{

 call dein#add( 'vim-scripts/tinymode.vim' )

 "}}} _tinymode.vim
 " tinykeymap_vim {{{

 "todo xxx find away to make use of tinykeymap
 call dein#add( 'tomtom/tinykeymap_vim', {'lazy': 1} )

 "}}} _tinykeymap_vim
 " vim-submode {{{
   "call dein#add( 'kana/vim-submode' )
   call dein#add( 'khalidchawtany/vim-submode' )
   let g:submode_timeout=0

   au vimenter * call bindsubmodes()
   function! bindsubmodes()
     " window resize {{{
       call submode#enter_with('h/l', 'n', '', '<c-w>h', '<c-w><')
       call submode#enter_with('h/l', 'n', '', '<c-w>l', '<c-w>>')
       call submode#map('h/l', 'n', '', 'h', '<c-w><')
       call submode#map('h/l', 'n', '', 'l', '<c-w>>')
       call submode#enter_with('j/k', 'n', '', '<c-w>j', '<c-w>-')
       call submode#enter_with('j/k', 'n', '', '<c-w>k', '<c-w>+')
       call submode#map('j/k', 'n', '', 'j', '<c-w>-')
       call submode#map('j/k', 'n', '', 'k', '<c-w>+')
     "}}} _window resize

     "toggles fold {{{
       call submode#enter_with('toggle-fold', 'n', 's', 'cof', ':<c-u>exe "call togglefoldmethod()"<cr>')
       call submode#leave_with('toggle-fold', 'n', 's', '<esc>')
       call submode#map(       'toggle-fold', 'n', 's', 'f', ':<c-u>exe "call togglefoldmethod()"<cr>')
       call submode#map(       'toggle-fold', 'n', 's', 'n', ':<c-u>exe "call togglefoldmethod()"<cr>')
       call submode#map(       'toggle-fold', 'n', 's', 'p', ':<c-u>exe "call togglefoldmethod(1)"<cr>')
       call submode#map(       'toggle-fold', 'n', 's', 's', ':<c-u>set foldmethod=syntax<cr>')
       call submode#map(       'toggle-fold', 'n', 's', 'i', ':<c-u>set foldmethod=indent<cr>')
       call submode#map(       'toggle-fold', 'n', 's', 'm', ':<c-u>set foldmethod=manual<cr>')
       call submode#map(       'toggle-fold', 'n', 's', '{', ':<c-u>set foldmethod=manual<cr>')
     "}}} _toogles fold

     ""toggles folemarker {{{
       "call submode#enter_with('toggle-marker', 'n', '', 'com', ':<c-u>exe "call togglefoldmarker()"<cr>')
       "call submode#leave_with('toggle-marker', 'n', '', '<esc>')
       "call submode#map(       'toggle-marker', 'n', '', 'm', ':<c-u>exe "call togglefoldmarker()"<cr>')
       "call submode#map(       'toggle-marker', 'n', '', 'n', ':<c-u>exe "call togglefoldmarker()"<cr>')
       "call submode#map(       'toggle-marker', 'n', '', 'p', ':<c-u>exe "call togglefoldmarker()"<cr>')
     ""}}} _toogles folemarker

     "toggles {{{
       call submode#enter_with('toggle-mode', 'n', '', 'coo', ':<c-u>echo ""<cr>')
       call submode#leave_with('toggle-mode', 'n', '', '<esc>')
       call submode#map(       'toggle-mode', 'n', '', 'f', ':<c-u>exe "call togglefoldmethod()"<cr>')
       call submode#map(       'toggle-mode', 'n', '', '{', ':<c-u>exe "call togglefoldmarker()"<cr>')
       call submode#map(       'toggle-mode', 'n', '', 'm', ':<c-u>exe "call togglemousefunction()"<cr>')
       call submode#map(       'toggle-mode', 'n', '', ';', ':<c-u>set showcmd!<cr>')
       call submode#map(       'toggle-mode', 'n', '', ':', ':<c-u>set showcmd!<cr>')
       call submode#map(       'toggle-mode', 'n', '', 't', ':<c-u>exe "set showtabline=" . (&showtabline+2)%3<cr>')
       call submode#map(       'toggle-mode', 'n', '', '<space>', ':<c-u>exe "set laststatus=" . (&laststatus+2)%3<cr>')
       call submode#map(       'toggle-mode', 'n', '', 'q', ':<c-u>qfix<cr>')

     "}}} _toggles

     "undo/redo {{{
       call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
       call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
       call submode#leave_with('undo/redo', 'n', '', '<esc>')
       call submode#map('undo/redo', 'n', '', '-', 'g-')
       call submode#map('undo/redo', 'n', '', '+', 'g+')
     "}}} _undo/redo

     "buffer {{{
       ""call submode#enter_with('buf', 'n', 's', ']b', ':<c-u>exe "bnext<bar>hi normal guibg=red"<cr>')
       ""call submode#enter_with('buf', 'n', 's', '[b', ':<c-u>exe "bprevious<bar>hi normal guibg=red"<cr>')
       "call submode#enter_with('buf', 'n', 's', ']b', ':<c-u>exe "bnext"<cr>')
       "call submode#enter_with('buf', 'n', 's', '[b', ':<c-u>exe "bprevious"<cr>')
       "call submode#map('buf', 'n', 's', ']', ':<c-u>exe "bnext"<cr>')
       "call submode#map('buf', 'n', 's', 'd', ':<c-u>exe "bdelete"<cr>')
       "call submode#map('buf', 'n', 's', 'k', ':<c-u>exe "bdelete!"<cr>')
       "call submode#map('buf', 'n', 's', 'o', ':<c-u>exe "bufonly"<cr>')
       "call submode#map('buf', 'n', 's', '[', ':<c-u>exe "bprevious"<cr>')
       "call submode#map('buf', 'n', 's', 'l', ':<c-u>exe "buffers"<cr>')
       "autocmd! user buf_leaving :hi normal guibg=#1b1d1e<cr>
     "}}} _buffer

     "jump/edit {{{
       call submode#enter_with('jump/edit', 'n', 's', 'coj', ':<c-u>exe "silent! normal g,zo"<cr>')
       call submode#enter_with('jump/edit', 'n', 's', 'coe', ':<c-u>exe "silent! normal g,zo"<cr>')
       call submode#enter_with('jump/edit', 'n', 's', ']j', ':<c-u>exe "silent! normal g,zo"<cr>')
       call submode#enter_with('jump/edit', 'n', 's', '[j', ':<c-u>exe "silent! normal g;zo"<cr>')
       call submode#map('jump/edit', 'n', 's', ']', ':<c-u>exe "silent! normal g,zo"<cr>')
       call submode#map('jump/edit', 'n', 's', '[', ':<c-u>exe "silent! normal g;zo"<cr>')
       call submode#map('jump/edit', 'n', 's', 'n', ':<c-u>exe "silent! normal g,zo"<cr>')
       call submode#map('jump/edit', 'n', 's', 'p', ':<c-u>exe "silent! normal g;zo"<cr>')
       call submode#map('jump/edit', 'n', 's', 'j', ':<c-u>exe "silent! normal g,zo"<cr>')
       call submode#map('jump/edit', 'n', 's', 'k', ':<c-u>exe "silent! normal g;zo"<cr>')
     "}}} _jum/edit

   endfunction

 "}}}
 " vim-hopper {{{

   "plug 'lfdm/vim-hopper'
   call dein#add( 'khalidchawtany/vim-hopper')
   "let g:hopper_prefix = '<esc>'
   let g:hopper_prefix = ','
   let g:hopper_file_opener = [ 'angular' ]

 "}}} _vim-hopper


 " vim-unimpaired {{{

 call dein#add( 'tpope/vim-unimpaired' )

 "}}} _vim-unimpaired
 " vim-man {{{

   call dein#add( 'bruno-/vim-man', {'on_cmd': ['man', 'sman', 'vman', 'mangrep']} )

 "}}} _vim-man
 " vim-rsi {{{

   call dein#add( 'tpope/vim-rsi' )

 "}}} _vim-rsi
 " capture.vim {{{

   "capture ex-commad in a buffer
   call dein#add( 'tyru/capture.vim', {'on_cmd': 'capture'} )

 "}}} _capture.vim
 " vim-eunuch {{{

   call dein#add( 'tpope/vim-eunuch', {'on_cmd': [ 'remove', 'unlink', 'move', 'rename',
       \ 'chmod', 'mkdir', 'find', 'locate', 'sudoedit', 'sudowrite', 'wall', 'w' ]})

 "}}} _vim-eunuch
 "call dein#add( 'duggiefresh/vim-easydir' )

 " vim-capslock {{{

 call dein#add( 'tpope/vim-capslock' ,{
       \ 'on_map':[
       \  ['i', '<plug>capslocktoggle'],
       \  ['i', '<plug>(capslockenable)'],
       \  ['i', '<plug>(capslockdisable)]']
       \ ]})
   imap <c-l>o <c-o><plug>capslocktoggle
   imap <c-l>e <c-o><plug>capslockenable
   imap <c-l>d <c-o><plug>capslockdisable
 "}}} _vim-capslock

 " vim-characterize {{{

   call dein#add( 'tpope/vim-characterize', {'on_map':['<plug>(characterize)']} )

 "}}} _vim-characterize
 " unicode {{{

   call dein#add( 'chrisbra/unicode.vim', {'on_cmd':['diagraphs', 'searchunicode', 'unicodename', 'unicodetable']} )

   " :digraphs        - search for specific digraph char
   " :searchunicode   - search for specific unicode char
   " :unicodename     - identify character under cursor (like ga command)
   " :unicodetable    - print unicode table in new window
   " :downloadunicode - download (or update) unicode data
   " <c-x><c-g>  - complete digraph char
   " <c-x><c-z>  - complete unicode char
   " <f4>        - combine characters into digraphs

 "}}}
 " plug 'seletskiy/vim-nunu'           "disable relative numbers on cursor move

 " vim-repeat {{{

 call dein#add( 'tpope/vim-repeat' )

 "}}} _vim-repeat
 " plug 'vim-scripts/confirm-quit'
 " undofile_warn.vim {{{

   " this breaks magit :(
   " plug 'vim-scripts/undofile_warn.vim'

 "}}} _undofile_warn.vim
 " vim-obsession {{{

   call dein#add( 'tpope/vim-obsession', {'on_cmd':['obsession']} )

 "}}} _vim-obsession

 " vim-autoswap {{{

   call dein#add( 'gioele/vim-autoswap' )

 "}}} _vim-autoswap

 " vim-scriptease {{{

   call dein#add( 'tpope/vim-scriptease', {'on_ft': ['vim']} )

 "}}} _vim-scriptease
 " vim-debugger {{{
 call dein#add('haya14busa/vim-debugger',
       \ {'on_cmd': ['debugon', 'debugger', 'debug', 'stacktrace', 'callstack', 'callstackreport']})
 " }}} _vim-debugger

 call dein#add( 'kabbamine/vcoolor.vim')
 call dein#add('sunaku/vim-shortcut')
 " vim-hardtime {{{

   call dein#add( 'takac/vim-hardtime', {'on_cmd': ['hardtimeon', 'hardtimetoggle']} )

   let g:hardtime_timeout = 1000

   let g:hardtime_allow_different_key = 1
   let g:hardtime_maxcount = 1
   let g:hardtime_default_on = 0
   let g:hardtime_showmsg = 1

   let g:list_of_normal_keys = ["h", "j", "k", "l", "-", "+", "<up>", "<down>", "<left>", "<right>"]
   let g:list_of_visual_keys = ["h", "j", "k", "l", "-", "+", "<up>", "<down>", "<left>", "<right>"]
   let g:list_of_insert_keys = ["<up>", "<down>", "<left>", "<right>"]


   "disable in certain buffers default []
   " let g:hardtime_ignore_buffer_patterns = [ "custompatt[ae]rn", "nerd.*" ]


 "}}} _vim-hardtime
 " investigate.vim {{{

 call dein#add( 'keith/investigate.vim', {'on_map': ['gk']} )
 let g:investigate_dash_for_blade="laravel"
 let g:investigate_dash_for_php="laravel"
 let g:investigate_use_dash=1

 "}}} _investigate.vim

 "}}}
 " ----------------------------------------------------------------------------
 " languages {{{
 " ----------------------------------------------------------------------------

 "python
 call dein#add( 'tweekmonster/braceless.vim', {'on_ft': ['python']} )

 " java
 " plug 'tpope/vim-classpath'

 "c#
 " omnisharp {{{

   " let g:omnisharp_server_type = 'roslyn'
   let g:omnisharp_server_path = "/volumes/home/.config/nvim/plugged/omnisharp/server/omnisharp/bin/debug/omnisharp.exe"
   call dein#add( 'nosami/omnisharp', {'on_ft': ['cs']} )

   " plug 'khalidchawtany/omnisharp-vim', {'branch': 'nunitquickfix'}

   let g:omnisharp_selecter_ui = 'ctrlp'

   let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']

   "let g:omnisharp_server_type = 'roslyn'
   autocmd filetype cs,cshtml.html call setomnisharpoptions()

   function! setomnisharpoptions()

     if exists("g:setomnisharpoptionsisset")
       return
     endif

     source ~/.config/nvim/scripts/make_cs_solution.vim
     autocmd bufwritepost *.cs buildcsharpsolution

     nnoremap <leader>oo :buildcsharpsolution<cr>

     let g:setomnisharpoptionsisset = 1
     "can set preview here also but i found it causes flicker
     "set completeopt=longest,menuone

     "makes enter work like c-y, confirming a popup selection
     "inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"

     setlocal omnifunc=omnisharp#complete

     if exists(":deopleteenable")
       deopleteenable
       let g:deoplete#omni_patterns.cs='.*[^=\);]'
       let g:deoplete#sources.cs=['omni', 'buffer', 'member', 'tag', 'file']
     endif

     " builds can also run asynchronously with vim-dispatch installed
     nnoremap <localleader>b :wa!<cr>:omnisharpbuildasync<cr>
     nnoremap <localleader>tt :omnisharpruntests<cr>
     nnoremap <localleader>tf :omnisharpruntestfixture<cr>
     nnoremap <localleader>ta :omnisharprunalltests<cr>
     nnoremap <localleader>tl :omnisharprunlasttests<cr>

     nnoremap <localleader>gd :omnisharpgotodefinition<cr>
     nnoremap <localleader>gi :omnisharpfindimplementations<cr>
     nnoremap <localleader>gt :omnisharpfindtype<cr>
     nnoremap <localleader>gs :omnisharpfindsymbol<cr>
     nnoremap <localleader>gu :omnisharpfindusages<cr>
     nnoremap <localleader>gm :omnisharpfindmembers<cr>

     " cursor can be anywhere on the line containing an issue
     nnoremap <localleader>fi  :omnisharpfixissue<cr>
     nnoremap <localleader>fu :omnisharpfixusings<cr>

     nnoremap <localleader>tl :omnisharptypelookup<cr>
     " add syntax highlighting for types and interfaces
     nnoremap <localleader>ht :omnisharphighlighttypes<cr>

     nnoremap <localleader>d :omnisharpdocumentation<cr>
     "navigate up by method/property/field
     nnoremap <localleader>nk :omnisharpnavigateup<cr>
     "navigate down by method/property/field
     nnoremap <localleader>nj :omnisharpnavigatedown<cr>

     " contextual code actions (requires ctrlp or unite.vim)
     nnoremap <localleader>a :omnisharpgetcodeactions<cr>
     " run code actions with text selected in visual mode to extract method
     vnoremap <localleader>a :call omnisharp#getcodeactions('visual')<cr>

     " rename with dialog
     nnoremap <localleader>rn :omnisharprename<cr>
     " rename without dialog - with cursor on the symbol to rename... ':rename newname'

     " force omnisharp to reload the solution. useful when switching branches etc.
     nnoremap <localleader>rs :omnisharpreloadsolution<cr>
     nnoremap <localleader>= :omnisharpcodeformat<cr>
     " load the current .cs file to the nearest project
     nnoremap <localleader>i :omnisharpaddtoproject<cr>

     " (experimental - uses vim-dispatch or vimproc plugin) - start the omnisharp server for the current solution
     nnoremap <localleader>ss :omnisharpstartserver<cr>
     nnoremap <localleader>st :omnisharpstopserver<cr>


   endfunction

   augroup omnisharp_commands
     autocmd!

     command! -nargs=1 rename :call omnisharp#renameto("<args>")

     " automatic syntax check on events (textchanged requires vim 7.4)
     autocmd bufenter,textchanged,insertleave *.cs,*.cshtml syntasticcheck

     " automatically add new cs files to the nearest project on save
     autocmd bufwritepost *.cs,*.cshtml call omnisharp#addtoproject()

     "show type information automatically when the cursor stops moving
     "autocmd cursorhold *.cs,*.cshtml call omnisharp#typelookupwithoutdocumentation()
   augroup end

   "set updatetime=500
   " remove 'press enter to continue' message when type information is longer than one line.
   "set cmdheight=2



 "}}}
 " vim-csharp {{{

   call dein#add( 'oranget/vim-csharp', {'on_ft': ['cs']} )

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

 " csv
 call dein#add( 'chrisbra/csv.vim', {'on_ft': ['csv']} )

 " php
 " phpcomplete.vim {{{

   "plug 'shawncplus/phpcomplete.vim'

 "}}} _phpcomplete.vim
 " phpcomplete-extended {{{

    "plug 'm2mdas/phpcomplete-extended'
    "let g:phpcomplete_index_composer_command = "composer"
    "autocmd  filetype  php setlocal omnifunc=phpcomplete_extended#completephp

 "}}}
  "plug 'm2mdas/phpcomplete-extended-laravel'
  "call dein#add( 'vim-scripts/phpfolding.vim', {'on_ft': ['php']} )
 " pdv {{{

   "call dein#add( 'tobys/vmustache', {'on_ft': ['php']} )
   call dein#add( 'tobys/vmustache' )
   "call dein#add( 'tobys/pdv', {'on_ft': ['php']} )
   call dein#add( 'tobys/pdv' )
   let g:pdv_template_dir = $home ."/.config/nvim/plugged/pdv/templates_snip"
   nnoremap <buffer> <c-p> :call pdv#documentwithsnip()<cr>

 "}}} _pdv

 " phpcd.vim {{{

   call dein#add( 'phpvim/phpcd.vim', {'on_ft': ['php'], 'build': 'composer update'} )
   "call dein#add( 'vim-scripts/progressbar-widget', {'on_source': 'phpcd.vim'} ) " used for showing the index progress
   call dein#add( 'vim-scripts/progressbar-widget' )


   "set php completion options
   "autocmd filetype php setlocal completeopt+=preview | setlocal omnifunc=phpcd#completephp
   autocmd filetype php setlocal completeopt-=preview | setlocal omnifunc=phpcd#completephp

   "close omni-completion perview tip window to close when a selection is made
   autocmd insertleave,completedone * if pumvisible() == 0 | pclose | endif

   "this on may cause slowness
   "autocmd cursormovedi * if pumvisible() == 0|pclose|endif

 "}}} _phpcd.vim
 " php-indenting-for-vim {{{

   "call dein#add( '2072/php-indenting-for-vim', {'on_ft': ['php']} )
   call dein#add( '2072/php-indenting-for-vim' )

 "}}} _php-indenting-for-vim
 " phpfolding.vim {{{

   "no more maintained
   "call dein#add( 'phpvim/phpfolding.vim', {'on_ft': ['php']} )
   "call dein#add( 'phpvim/phpfolding.vim' )
   "call dein#add( 'phpvim/phpfold.vim', {'build' : 'composer update'} )


 "}}} _phpfolding.vim
 " tagbar-phpctags.vim {{{

   call dein#add( 'vim-php/tagbar-phpctags.vim', {'on_ft': ['php']} )

 "}}} _tagbar-phpctags.vim

 "go
 call dein#add( 'fatih/vim-go', {'on_ft': ['go']} )

 call dein#add( 'zchee/deoplete-go', {
       \ 'on_ft': ['go'], 'build': 'make',
       \ 'on_event': 'vimenter', 'on_if': 'has("nvim")'
       \ } )

 "rust
 " vim-racer {{{

 call dein#add( 'racer-rust/vim-racer', {'on_ft': ['rust']} )
 let g:racer_cmd = "/volumes/home/.cargo/bin/racer"
 let $rust_src_path="/volumes/home/development/applications/rust/src/"

 "}}} _vim-racer

 " blade
 " vim-blade {{{

   "call dein#add( 'xsbeats/vim-blade', {'on_ft':['blade'] } )
   call dein#add( 'xsbeats/vim-blade' )
   "au bufnewfile,bufread *.blade.php set filetype=html
   au bufnewfile,bufread *.blade.php set filetype=blade

 "}}}

 " web dev
 " breeze.vim {{{

   call dein#add( 'gcmt/breeze.vim', {'on_map':
       \   [
       \       '<plug>(breeze-jump-tag-forward)',
       \       '<plug>(breeze-jump-tag-backward)',
       \       '<plug>(breeze-jump-attribute-forward)',
       \       '<plug>(breeze-jump-attribute-backward)',
       \       '<plug>(breeze-next-tag)',
       \       '<plug>(breeze-prev-tag)',
       \       '<plug>(breeze-next-attribute)',
       \       '<plug>(breeze-prev-attribute)'
       \ ] ,
       \'on_ft': ['php', 'blade', 'html', 'xhtml', 'xml']})


   au filetype html,blade,php,xml,xhtml call mapbreezekeys()

   function! mapbreezekeys()
     nmap <buffer> <leader>sj <plug>(breeze-jump-tag-forward)
     nmap <buffer> <leader>sk <plug>(breeze-jump-tag-backward)
     nmap <buffer> <leader>sl <plug>(breeze-jump-attribute-forward)
     nmap <buffer> <leader>sh <plug>(breeze-jump-attribute-backward)

     nmap <buffer> <c-s><c-j> <plug>(breeze-next-tag)
     nmap <buffer> <c-s><c-k> <plug>(breeze-prev-tag)
     nmap <buffer> <c-s><c-l> <plug>(breeze-next-attribute)
     nmap <buffer> <c-s><c-h> <plug>(breeze-prev-attribute)

     " <plug>(breeze-next-tag-hl)
     " <plug>(breeze-prev-tag-hl)
     " <plug>(breeze-next-attribute-hl)
     " <plug>(breeze-prev-attribute-hl)


   endfunction

 "}}}
 " emmet {{{

   call dein#add( 'mattn/emmet-vim', {'on_ft':['html','xml','xsl','xslt','xsd','css','sass','scss','less','mustache', 'blade', 'php']} )

   let g:user_emmet_mode='a'         "enable all function in all mode.
   " let g:user_emmet_mode='i'         "enable all function in all mode.
   let g:user_emmet_leader_key='◊ú'
   vmap <c-'><c-;>c           <plug>(emmet-code-pretty)
   vmap <c-'><c-;>m           <plug>(emmet-merge-lines)
   nmap <c-'><c-;>a           <plug>(emmet-anchorize-summary)
   nmap <c-'><c-;>a           <plug>(emmet-anchorize-url)
   nmap <c-'><c-;>k           <plug>(emmet-remove-tag)
   nmap <c-'><c-;>j           <plug>(emmet-split-join-tag)
   nmap <c-'><c-;>/           <plug>(emmet-toggle-comment)
   nmap <c-'><c-;>i           <plug>(emmet-image-size)
   nmap <c-'><c-;>n           <plug>(emmet-move-prev)
   nmap <c-'><c-;>n           <plug>(emmet-move-next)
   vmap <c-'><c-;>d           <plug>(emmet-balance-tag-outword)
   nmap <c-'><c-;>d           <plug>(emmet-balance-tag-outword)
   vmap <c-'><c-;>d           <plug>(emmet-balance-tag-inward)
   nmap <c-'><c-;>d           <plug>(emmet-balance-tag-inward)
   nmap <c-'><c-;>u           <plug>(emmet-update-tag)
   nmap <c-'><c-;>;           <plug>(emmet-expand-word)
   vmap <c-'><c-;>,           <plug>(emmet-expand-abbr)
   nmap <c-'><c-;>,           <plug>(emmet-expand-abbr)

 "}}}
 " vim-hyperstyle {{{

   call dein#add( 'rstacruz/vim-hyperstyle', {'on_ft': ['css']} )

 "}}} _vim-hyperstyle
 " vim-closetag {{{

    "this plugin uses > of the clos tag to work in insert mode
    "<table|   => press > to have <table>|<table>
    "press > again to have <table>|<table>
    call dein#add( 'alvan/vim-closetag', {'on_ft': ['html', 'xml', 'blade', 'php']} )
    " # filenames like *.xml, *.html, *.xhtml, ...
    let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.blade.php,*.php"


 "}}}
 " closetag {{{

   "ctrl+_ to close next unimpared tag
   call dein#add( 'vim-scripts/closetag.vim' , {'on_ft':['html','xml','xsl','xslt','xsd', 'blade', 'php', 'blade.php']} )

 "}}}
 " matchtagalways {{{

   call dein#add( 'valloric/matchtagalways' , {'on_ft':['html', 'php','xhtml','xml','blade']} )
   let g:mta_filetypes = {
       \ 'html' : 1,
       \ 'xhtml' : 1,
       \ 'xml' : 1,
       \ 'jinja' : 1,
       \ 'blade' : 1,
       \}
   nnoremap <leader>% :mtajumptoothertag<cr>

 "}}}"always match html tag

 " vim-ragtag {{{

  call dein#add( 'tpope/vim-ragtag', {'on_ft':['html','xml','xsl','xslt','xsd', 'blade', 'php', 'blade.php']} )
  let g:ragtag_global_maps = 1

 "}}} _vim-ragtag

 " compilers
 " vimproc.vim {{{

   call dein#add( 'shougo/vimproc.vim', {'build': 'make'} )

 "}}} _vimproc.vim
 " vim-dispatch {{{

   call dein#add( 'tpope/vim-dispatch' )

 "}}} _vim-dispatch
 " neomake {{{

   call dein#add( 'benekastah/neomake', {'on_cmd': ['neomake']} )

   " autocmd! bufwritepost * neomake
   " let g:neomake_airline = 0
   let g:neomake_error_sign = { 'text': '✘', 'texthl': 'errorsign' }
   let g:neomake_warning_sign = { 'text': ':(', 'texthl': 'warningsign' }


 "}}} _neomake
 " vim-accio {{{

   call dein#add( 'pgdouyon/vim-accio', {'on_cmd': ['accio']} )

 "}}} _vim-accio
 " syntastic {{{

 call dein#add( 'scrooloose/syntastic', {'on_cmd': ['syntasticcheck']} )

   let g:syntastic_scala_checkers=['']
   let g:syntastic_always_populate_loc_list = 1
   let g:syntastic_check_on_open = 1
   let g:syntastic_error_symbol = "✗"
   let g:syntastic_warning_symbol = "⚠"

 "}}} _syntastic
 " vim-test {{{

   call dein#add( 'janko-m/vim-test', {'on_cmd': [ 'testnearest', 'testfile', 'testsuite', 'testlast', 'testvisit' ]} )

 "}}} _vim-test

 " vim-fetch {{{
   call dein#add( 'kopischke/vim-fetch' )              "fixes how vim handles fn(ln:cn)
 "}}} _vim-fetch

 "}}}
 " ----------------------------------------------------------------------------
 " snippets {{{
 " ----------------------------------------------------------------------------

 " xptemplate {{{

   let g:xptemplate_key = '<c-\>'
   let g:xptemplate_nav_next = '<c-j>'
   let g:xptemplate_nav_prev = '<c-k>'
   call dein#add( 'drmingdrmer/xptemplate')
   set runtimepath+=/volumes/home/.config/nvim/xpt-personal

   "call dein#add( 'drmingdrmer/xptemplate', { 'on_func': ['xptemplatestart', 'xptemplateprewrap'] })
   "inoremap  <c-\>           <c-r>=xptemplatestart(0,{'k':'<c-\++'})<cr>
   "inoremap  <c-r><c-\>      <c-r>=xptemplatestart(0,{'k':'<c-r++<c-\++','forcepum':1})<cr>
   "inoremap  <c-r><c-r><c-\> <c-r>=xptemplatestart(0,{'k':'<c-r++<c-r++<c-\++','popuponly':1})<cr>
   "snoremap  <c-\>           <c-c>`>a<c-r>=xptemplatestart(0,{'k':'<c-\++'})<cr>
   "xnoremap  <c-\>           "0s<c-r>=xptemplateprewrap(@0)<cr>

 "}}}
 " ultisnips {{{

   "don't lazy load using go to inser mode as this makes vim very slow
   call dein#add( 'sirver/ultisnips') ", {
        "\ 'lazy': 1,
        "\ 'on_map': [ ['i', '‰'], ['i', '<c-cr>'] ],
        "\ 'on_cmd': ['ultisnipsedit'],
        "\ 'hook_post_source': 'call ultisnips#filetypechanged()'
        "\ })
   "au vimenter * au! ultisnipsfiletype
   ""augroup ultisnipsfiletype
   ""    autocmd!
   ""    autocmd filetype * call ultisnips#filetypechanged()
   ""augroup end

   let g:ultisnipsenablesnipmate = 0

   let g:ultisnipsexpandtrigger = "‰"            "ctrl+enter
   let g:ultisnipsjumpforwardtrigger = "‰"       "ctrl+enter
   let g:ultisnipsjumpbackwardtrigger = "⌂"      "alt+enter

   inoremap  ‰ <c-r>=ultisnips#expandsnippetorjump()<cr>
   inoremap  <c-cr> <c-r>=ultisnips#expandsnippetorjump()<cr>
   xnoremap  ‰ :call ultisnips#savelastvisualselection()<cr>gvs
   xnoremap  <c-cr> :call ultisnips#savelastvisualselection()<cr>gvs
   snoremap  ‰ <esc>:call ultisnips#expandsnippetorjump()<cr>
   snoremap  <c-cr> <esc>:call ultisnips#expandsnippetorjump()<cr>

   let g:ultisnips_java_brace_style="nl"
   let g:ultisnips_java_brace_style="nl"
   let g:ultisnipssnippetsdir="~/.config/nvim/ultisnips"
   "let g:ultisnipssnippetdirectories = [ "/volumes/home/.config/nvim/plugged/vim-snippets/ultisnips"]

 "}}}
 " vim-snippets {{{

   call dein#add( 'honza/vim-snippets', {'on_source': ['ultisnips']} )
   "call dein#add( 'honza/vim-snippets' )

 "}}} _vim-snippets

 "}}}
 " ----------------------------------------------------------------------------
 " autocompletion {{{
 " ----------------------------------------------------------------------------

 "deoplete
 " deoplete.nvim {{{

 call dein#add( 'shougo/deoplete.nvim',
       \ {
       \ 'on_event': ['insertenter', 'vimenter'],
       \ 'on_if': '!has("nvim")' ,
       \ 'hook_post_source' : " call deoplete#custom#set('_', 'matchers', ['matcher_full_fuzzy'])"
       \ })

   let g:deoplete#auto_complete_delay=0

   "let g:deoplete#omni_patterns = {} //this disables all features
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
   let g:deoplete#omni#input_patterns.php = [ '.*', '[^. \t0-9]\.\w*', '[^. \t0-9]\->\w*', '[^. \t0-9]\::\w*', ]
   let g:deoplete#ignore_sources = {}
   let g:deoplete#ignore_sources._ = ['javacomplete2']
   let g:deoplete#ignore_sources.php = ['javacomplete2', 'look']
   "inoremap <expr><c-h> deoplete#mappings#smart_close_popup()."\<c-h>"
   "inoremap <expr><bs> deoplete#mappings#smart_close_popup()."\<c-h>"
   set isfname-==

   "my settings
   "let g:deoplete#omni#input_patterns.php = [ '[^. \t0-9]\.\w*', '[^. \t0-9]\->\w*', '[^. \t0-9]\::\w*', ]
   "let g:deoplete#sources = {}
   "let g:deoplete#sources._ = ['buffer']
   "let g:deoplete#sources.php = ['omni', 'buffer', 'ultisnips', 'tag', 'member', 'file']
   "let g:deoplete#delimiters = ['/', '.', '::', ':', '#', '->']


 "}}} _deoplete.nvim
 " neoinclude.vim {{{

   call dein#add( 'shougo/neoinclude.vim' , { 'on_event': 'vimenter', 'on_if': 'has("nvim")' })

 "}}} _neoinclude.vim
 " neco-syntax {{{

  "slows down php files so much
   "call dein#add( 'shougo/neco-syntax' )

 "}}} _neco-syntax
 " neco-vim {{{

   call dein#add( 'shougo/neco-vim' , { 'on_event': 'vimenter', 'on_if': 'has("nvim")' })

 "}}} _neco-vim
 " echodoc.vim {{{

   call dein#add( 'shougo/echodoc.vim', { 'on_event': 'vimenter', 'on_if': 'has("nvim")' })

 "}}} _echodoc.vim
 " neco-look {{{
 call dein#add('ujihisa/neco-look', { 'on_event': 'vimenter', 'on_if': 'has("nvim")' })
 "}}} _neco-look 


 " youcompleteme {{{
   call dein#add('valloric/youcompleteme',
         \ {
         \ 'build': './install.py --clang-completer --gocode-completer --omnisharp-completer',
         \ 'on_event': 'vimenter', 'on_if': 'has("nvim")'
         \ })

   " make ycm compatible with ultisnips (using supertab)
   let g:ycm_key_list_select_completion = ['<c-n>', '<down>']
   let g:ycm_key_list_previous_completion = ['<c-p>', '<up>']
   let g:supertabdefaultcompletiontype = '<c-n>'


 "}}}

 " command line
 " ambicmd {{{

 "xxxxx
 call dein#add( 'thinca/vim-ambicmd', {'on': []} )

 "prevent ambicmd original mapping
 let g:vim_ambicmd_mapped = 1

 cnoremap ‰ <cr>
 cnoremap <c-cr> <cr>
 function! mapambicmd()
   call dein#source('vim-ambicmd')
   cnoremap <expr> <space> ambicmd#expand("\<space>")
   cnoremap <expr> <cr>    ambicmd#expand("\<cr>")
   call feedkeys(':', 'n')
   nnoremap ; :
 endfunction
 nnoremap <silent>; :call mapambicmd()<cr>

"}}}

"}}}
 " ----------------------------------------------------------------------------
 " operators {{{
 " ----------------------------------------------------------------------------

 " operator-usr {{{

   call dein#add( 'kana/vim-operator-user' )

   nmap <leader>oal  <plug>(operator-align-left)
   nmap <leader>oar  <plug>(operator-align-right)
   nmap <leader>oac  <plug>(operator-align-center)


 "}}}

 " operator-camelize {{{

   call dein#add( 'tyru/operator-camelize.vim' )
   nmap <leader>ou <plug>(operator-camelize)
   nmap <leader>ou <plug>(operator-decamelize)


 "}}}

 " operator-blockwise {{{

   call dein#add( 'osyo-manga/vim-operator-blockwise', {'on_map': ['<plug>(operator-blockwise-']} )
   nmap <leader>oy <plug>(operator-blockwise-yank-head)
   nmap <leader>od <plug>(operator-blockwise-delete-head)
   nmap <leader>oc <plug>(operator-blockwise-change-head)


 "}}}

 " operator-jerk {{{

   call dein#add( 'machakann/vim-operator-jerk' )
   nmap <leader>o>  <plug>(operator-jerk-forward)
   nmap <leader>o>> <plug>(operator-jerk-forward-partial)
   nmap <leader>o<  <plug>(operator-jerk-backward)
   nmap <leader>o<< <plug>(operator-jerk-backward-partial)


 "}}}

 "}}}
 " ----------------------------------------------------------------------------
 " text-objects {{{
 " ----------------------------------------------------------------------------
 call dein#add( 'jeetsukumaran/vim-indentwise' )

 " vim-swap {{{
   call dein#add( 'machakann/vim-swap', {'on_map': ['<plug>(swap-'] } )
   let g:swap_no_default_key_mappings = 1
   nmap g<   <plug>(swap-prev)
   nmap g>   <plug>(swap-next)
   nmap g\|   <plug>(swap-interactive)

 " _vim-swap }}}
 " argumentative {{{

   call dein#add( 'peterrincker/vim-argumentative', {'on_map': ['<plug>argumentative_']} )

   "move and manipultae arguments of a function
   nmap [; <plug>argumentative_prev
   nmap ]; <plug>argumentative_next
   xmap [; <plug>argumentative_xprev
   xmap ]; <plug>argumentative_xnext
   nmap <; <plug>argumentative_moveleft
   nmap >; <plug>argumentative_moveright
   " targets does a better job for handling args
   "============================================
   " xmap i; <plug>argumentative_innertextobject
   " xmap a; <plug>argumentative_outertextobject
   " omap i; <plug>argumentative_oppendinginnertextobject
   " omap a; <plug>argumentative_oppendingoutertextobject


 "}}}
 " argwrap {{{
   call dein#add( 'foosoft/vim-argwrap', {'on_cmd': ['argwrap']} )

   nnoremap <silent> g;w :argwrap<cr>
   let g:argwrap_padded_braces = '[{('


 "}}}
 " sideways {{{

   call dein#add( 'andrewradev/sideways.vim',
                           \ {'on_cmd': ['sidewaysleft', 'sidewaysright',
                           \ 'sidewaysjumpleft', 'sidewaysjumpright']}
                           \)

   nnoremap s;k :sidewaysjumpright<cr>
   nnoremap s;j :sidewaysjumpleft<cr>
   nnoremap s;l :sidewaysjumpright<cr>
   nnoremap s;h :sidewaysjumpleft<cr>

   nnoremap c;k :sidewaysright<cr>
   nnoremap c;j :sidewaysleft<cr>
   nnoremap c;l :sidewaysright<cr>
   nnoremap c;h :sidewaysleft<cr>


 "}}}
 " vim-after-textobj {{{

   call dein#add( 'junegunn/vim-after-object' )
   " autocmd vimenter * call after_object#enable('=', ':', '-', '#', ' ')
   " ]= and [= instead of a= and aa=
   autocmd vimenter * call after_object#enable([']', '['], '=', ':', '-', '#', ' ', '>', '<')


 "}}}
 " targets.vim {{{

  call dein#add( 'wellle/targets.vim' )
  let g:targets_pairs = '()b {}b []b <>b'

  "for c
  "some samples:
  " cin)   change inside next parens
  " cil)   change inside last parens
  " da,    delete about comma seperated stuff [, . ; : + - = ~ _ * # / | \ & $]
  " v2i)   select between |'s (|a(b)c|)
  " cin), cin), can), can), ca), ci), cat, a-, i-, a-, i-,
  " caa, cia => arguments

  " options availabel for customization:
  "=====================================
  "g:targets_aiai
  "g:targets_nlnl
  "g:targets_pairs
  "g:targets_quotes
  "g:targets_separators
  "g:targets_tagtrigger
  "let g:targets_argtrigger="a"
  "g:targets_argopening
  "g:targets_argclosing
  "g:targets_argseparator
  "g:targets_seekranges

"}}} _targets.vim

 " camelcasemotion {{{

   call dein#add( 'bkad/camelcasemotion' )

 "}}} _camelcasemotion

  call dein#add( 'kana/vim-textobj-user' )
  " let g:textobj_blockwise_enable_default_key_mapping =0
  " plug 'kana/vim-niceblock'

  " vim-textobj-line does this too :)
  " plug 'rhysd/vim-textobj-continuous-line'                "iv, av          for continuous line
  call dein#add( 'reedes/vim-textobj-sentence' )            "is, as, ), (,   for real english sentences
                                                                             "also adds g) and g( for
                                                                             "sentence navigation
  " vim-textobj-function {{{
     " plug 'kana/vim-textobj-function'
     call plugtextobj( 'kana/vim-textobj-function', 'f' )
     let g:textobj_function_no_default_key_mappings =1
     map vo if <plug>(textobj-function-i)
     map vo af <plug>(textobj-function-a)
  " }}} _vim-textobj-function
  " vim-textobj-functioncall {{{
     call plugtextobj( 'machakann/vim-textobj-functioncall', 'c' )
     let g:textobj_functioncall_no_default_key_mappings =1
  " }}} _vim-textobj-functioncall

  "doubles the following to avoid overlap with targets.vim
  " vim-textobj-parameter {{{
  "i,, a,  ai2,         for parameter
  call plugtextobj( 'sgur/vim-textobj-parameter', ',' )
  map vo i2, <plug>(textobj-parameter-greedy-i)

  "}}} _vim-textobj-parameter
  " vim-textobj-line {{{

  "il, al          for line
  call plugtextobj( 'kana/vim-textobj-line', 'll' )

  "}}} _vim-textobj-line
  " vim-textobj-number {{{
  "in, an          for numbers
  call plugtextobj( 'haya14busa/vim-textobj-number', 'n' )

  "}}} _vim-textobj-number
  " vim-textobj-between {{{
  "ibx, abx                     for between two chars
  "changed to isx, asx          for between two chars
  call plugtextobj( 'thinca/vim-textobj-between', 's' )
  let g:textobj_between_no_default_key_mappings =1

 "}}}
  " vim-textobj-any {{{
  "ia, aa          for (, {, [, ', ", <
  call plugtextobj( 'rhysd/vim-textobj-anyblock', ';' )
  call plugtextobj( 'rhysd/vim-textobj-anyblock', '<cr>' )
  let g:textobj_anyblock_no_default_key_mappings =1

  "}}}

  "don't try to lazyload this (dein lazyloaded delimited :) )
  call dein#add( 'osyo-manga/vim-textobj-blockwise' ) "<c-v>iw, ciw    for block selection

  " vim-textobj-delimited {{{

    "id, ad, id, ad   for delimiters takes numbers d2id
    call dein#add( 'machakann/vim-textobj-delimited', {'on_map': ['<plug>(textobj-delimited-']} )
    map vo id <plug>(textobj-delimited-forward-i)
    map vo id <plug>(textobj-delimited-forward-i)
    map vo ad <plug>(textobj-delimited-forward-a)
    map vo ad <plug>(textobj-delimited-forward-a)
    map vo id <plug>(textobj-delimited-backward-i)
    map vo id <plug>(textobj-delimited-backward-i)
    map vo ad <plug>(textobj-delimited-backward-a)
    map vo ad <plug>(textobj-delimited-backward-a)
  "}}} _vim-textobj-delimited
  " vim-textobj-pastedtext {{{

    "gb              for pasted text
    call dein#add( 'saaguero/vim-textobj-pastedtext', {'on_map': ['<plug>(textobj-pastedtext-text)']} )
    map vo gb <plug>(textobj-pastedtext-text)

  "}}} _vim-textobj-pastedtext
  " vim-textobj-syntax {{{

    "iy, ay          for syntax
    call plugtextobj( 'kana/vim-textobj-syntax', 'y' )

  "}}} _vim-textobj-syntax
  " vim-textobj-url {{{

    "iu, au          for url
    call plugtextobj( 'mattn/vim-textobj-url', 'u')

  "}}} _vim-textobj-url
  " vim-textobj-doublecolon {{{
    "i:, a:          for ::
    call plugtextobj( 'vimtaku/vim-textobj-doublecolon', ':' )

  "}}} _vim-textobj-doublecolon
  " vim-textobj-comment {{{

    "ic, ac, ac  for comment
    call plugtextobj( 'glts/vim-textobj-comment', 'c' )
    map vo ac <plug>(textobj-comment-big-a)

  "}}} _vim-textobj-comment
  " vim-textobj-indblock {{{

    "io, ao, io, ao  for indented blocks
    call plugtextobj( 'glts/vim-textobj-indblock', 'o' )
    map vo io <plug>(textobj-indblock-i)
    map vo ao <plug>(textobj-indblock-a)

  "}}} _vim-textobj-indblock
  " vim-textobj-indent {{{

    "ii, ai, ii, ai  for indent
    call plugtextobj( 'kana/vim-textobj-indent', 'i' )
    map vo ii <plug>(textobj-indent-same-i)
    map vo ai <plug>(textobj-indent-same-a)

  "}}} _vim-textobj-indent
  " vim-textobj-dash {{{

    "i-, a-          for dashes
    call plugtextobj("khalidchawtany/vim-textobj-dash", "-")

  "}}} _vim-textobj-dash
  " vim-textobj-underscore {{{

    "i_, a_          for underscore
    call plugtextobj ("lucapette/vim-textobj-underscore", "_")

  "}}} _vim-textobj-underscore
  " vim-textobj-brace {{{

    "ij, aj          for all kinds of brces
    call plugtextobj ("julian/vim-textobj-brace", "j")

  "}}} _vim-textobj-brace
  " vim-textobj-fold {{{
    "iz, az          for folds
    call plugtextobj ("kana/vim-textobj-fold", "z")

  "}}} _vim-textobj-fold
  " vim-textobj-variable-segment {{{

    "iv, av          for variable segment goo|rcome
    call plugtextobj ("julian/vim-textobj-variable-segment", "v")

  "}}} _vim-textobj-variable-segment
  " vim-textobj-lastpat {{{

    "i/, a/, i?, a?  for searched pattern
    call dein#add( 'kana/vim-textobj-lastpat' , {'on_map': ['<plug>(textobj-lastpat-n)', '<plug>(textobj-lastpat-n)']} )
    map vo i/ <plug>(textobj-lastpat-n)
    map vo i? <plug>(textobj-lastpat-n)

  "}}} _vim-textobj-lastpat
  " vim-textobj-quote {{{

  " "todo these mappings are fake
  " "iq, aq, iq, aq  for curely quotes
  " call plugtextobj( 'reedes/vim-textobj-quote', 'q' )

  " let g:textobj#quote#educate = 0               " 0=disable, 1=enable (def) autoconvert to curely

 "}}}
  " vim-textobj-xml {{{

    "ixa, axa        for xml attributes
    call dein#add( 'akiyan/vim-textobj-xml-attribute', {'on_map': ['<plug>(textobj-xmlattribute-']} )

    let g:textobj_xmlattribute_no_default_key_mappings=1
    map vo ax <plug>(textobj-xmlattribute-xmlattribute)
    map vo ix <plug>(textobj-xmlattribute-xmlattributenospace)


  "}}}
  " vim-textobj-path {{{

    "i|, a|, i\, a\          for path
    call dein#add( 'paulhybryant/vim-textobj-path', {'on_map': ['<plug>(textobj-path-']} )

    let g:textobj_path_no_default_key_mappings =1

    map vo a\\ <plug>(textobj-path-next_path-a)
    map vo i\\ <plug>(textobj-path-next_path-i)
    map vo a\\| <plug>(textobj-path-prev_path-a)
    map vo i\\| <plug>(textobj-path-prev_path-i)

  "}}}
  " vim-textobj-datetime {{{

    "igda, agda,      or dates auto
    " igdd, igdf, igdt, igdz  means
    " date, full, time, timerzone
    call dein#add( 'kana/vim-textobj-datetime', {'on_map': ['<plug>(textobj-datetime-']} )

    let g:textobj_datetime_no_default_key_mappings=1
    map vo agda <plug>(textobj-datetime-auto)
    map vo agdd <plug>(textobj-datetime-date)
    map vo agdf <plug>(textobj-datetime-full)
    map vo agdt <plug>(textobj-datetime-time)
    map vo agdz <plug>(textobj-datetime-tz)

    map vo igda <plug>(textobj-datetime-auto)
    map vo igdd <plug>(textobj-datetime-date)
    map vo igdf <plug>(textobj-datetime-full)
    map vo igdt <plug>(textobj-datetime-time)
    map vo igdz <plug>(textobj-datetime-tz)

  "}}}
  " vim-textobj-postexpr {{{
    "ige, age        for post expression
    call plugtextobj( 'syngan/vim-textobj-postexpr', 'ge' )
    let g:textobj_postexpr_no_default_key_mappings =1

  "}}}
  " vim-textobj-multi {{{

    call plugtextobj( 'osyo-manga/vim-textobj-multitextobj', 'm' )

    let g:textobj_multitextobj_textobjects_i = [
          \   "\<plug>(textobj-url-i)",
          \   "\<plug>(textobj-multiblock-i)",
          \   "\<plug>(textobj-function-i)",
          \   "\<plug>(textobj-entire-i)",
          \]


  "}}}
  " vim-textobj-keyvalue {{{

    call dein#add( 'vimtaku/vim-textobj-keyvalue', {'on_map': ['<plug>(textobj-key-', '<plug>(textobj-value-']} )

    let g:textobj_key_no_default_key_mappings=1
    map vo ak  <plug>(textobj-key-a)
    map vo ik  <plug>(textobj-key-i)
    map vo ak  <plug>(textobj-value-a)
    map vo ik  <plug>(textobj-value-i)


  "}}}
  " vim-textobj-space {{{

    "is, as i<space> for contineous spaces
    call plugtextobj( 'saihoooooooo/vim-textobj-space', '<space>' )
    let g:textobj_space_no_default_key_mappings =1

  "}}}
  " vim-textobj-entire {{{
    "ig, ag          for entire document
    call plugtextobj( 'kana/vim-textobj-entire', 'g' )
    let g:textobj_entire_no_default_key_mappings =1

  "}}}
  " vim-textobj-php {{{

    "i<, a<        for <?php ?>
    call plugtextobj( 'akiyan/vim-textobj-php', '?' )
    let g:textobj_php_no_default_key_mappings =1


  "}}}
 "}}}
 " ----------------------------------------------------------------------------
 " navigation {{{
 " ----------------------------------------------------------------------------

 " file
 " denite.vim{{{
   call dein#add( 'shougo/denite.nvim' )
 " }}} _dnite.vim
 " unite.vim {{{

 call dein#add( 'shougo/unite.vim', { 'on_cmd': ['unite', 'unitewithcursorword'] })
   "plug 'shougo/unite.vim'
   call dein#add( 'shougo/unite-outline' )
   call dein#add( 'shougo/unite-build' )
   call dein#add( 'shougo/unite-help' )
   call dein#add( 'shougo/unite-sudo' )
   call dein#add( 'shougo/unite-session' )
   "plug 'shougo/neoyank.vim'   "breaks a lazyloading on some plugins like sort-motion
   call dein#add( 'tsukkee/unite-tag' )
   " unite-bookmark-file {{{

   call dein#add( 'liquidz/unite-bookmark-file' )
   ":unite bookmark/file
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
   call dein#add( 'sixeight/unite-grep' )
   call dein#add( 'kannokanno/unite-todo' )
   call dein#add( 'osyo-manga/unite-fold' )
   call dein#add( 'osyo-manga/unite-highlight' )
   " unite-fasd.vim {{{

   call dein#add( 'critiqjo/unite-fasd.vim' )
   " path to fasd script (must be set)
   let g:unite_fasd#fasd_path = '/usr/local/bin/fasd'
   " path to fasd cache -- defaults to '~/.fasd'
   let g:unite_fasd#fasd_cache = '~/.fasd'
   " allow `fasd -a` on `bufread`
   let g:unite_fasd#read_only = 0
   "unite fasd or unite fasd:mru

   "}}} _unite-fasd.vim


   autocmd! user unite.vim  call setupunitemenus()
   "au vimenter * call setupunitemenus()
   function! setupunitemenus()

     " enable fuzzy matching and sorting in all unite functions
     call unite#filters#matcher_default#use(['matcher_fuzzy'])
     " call unite#filters#sorter_default#use(['sorter_rank'])
     call unite#filters#sorter_default#use(['sorter_selecta'])

     let g:unite_source_menu_menus = {} " useful when building interfaces at appropriate places

     " more unite menus {{{
     " interface for os interaction
     let g:unite_source_menu_menus.osinteract = {
           \ 'description' : 'os interaction and configs',
           \}
     let g:unite_source_menu_menus.osinteract.command_candidates = [
           \[' alternate file', 'a'],
           \[' generate tags in buffer dir', 'cd %:p:h | dispatch! ctags .'],
           \[' cd to buffer directory', 'cd %:p:h'],
           \[' cd to project directory', 'rooter'],
           \[' create .projections.json', 'cd %:p:h | e .projections.json'],
           \[' battery status', 'unite -buffer-name=ubattery output:echo:system("~/battery")'],
           \[' scratch notes', 'unite -buffer-name=unotes -start-insert junkfile'],
           \[' source vimrc', 'so $myvimrc'],
           \[' edit vimrc', 'e $myvimrc'],
           \]
     nnoremap <silent> úú<c-l> :unite -silent -buffer-name=osinteract -quick-match menu:osinteract<cr>
     nnoremap <silent> <c-;><c-;><c-l> :unite -silent -buffer-name=osinteract -quick-match menu:osinteract<cr>
     "}}}

   endfunction



   let g:unite_data_directory=$home.'/.config/nvim/.cache/unite'

   " execute help.
   nnoremap úúh  :<c-u>unite -start-insert help<cr>
   nnoremap <c-;><c-;>h  :<c-u>unite -start-insert help<cr>
   nnoremap úú‰  :<c-u>unite -start-insert command<cr>
   nnoremap úú<c-cr>  :<c-u>unite -start-insert command<cr>
   nnoremap <c-;><c-;>‰  :<c-u>unite -start-insert command<cr>
   nnoremap <c-;><c-;><c-cr>  :<c-u>unite -start-insert command<cr>
   " execute help by cursor keyword.
   nnoremap <silent> úú<c-h>  :<c-u>unitewithcursorword help<cr>
   nnoremap <silent> <c-;><c-;><c-h>  :<c-u>unitewithcursorword help<cr>

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
     let g:unite_source_grep_default_opts='--nocolor --nogroup -s -c4'
     let g:unite_source_grep_recursive_opt=''
     let g:unite_source_rec_async_command=['ag --nocolor --nogroup --ignore ".hg" --ignore ".svn" --ignore ".git" --ignore ".bzr" --hidden -g ""']
   endif

   " custom mappings for the unite buffer
   autocmd filetype unite call s:unite_settings()
   function! s:unite_settings()
     " play nice with supertab
     let b:supertabdisabled=1
     " enable navigation with control-j and control-k in insert mode
     imap <buffer> <c-j>   <plug>(unite_select_next_line)
     imap <buffer> <c-k>   <plug>(unite_select_previous_line)
     nmap <buffer> <bs> <plug>(unite_delete_backward_path)
     nmap <silent> <buffer> <esc> <plug>(unite_all_exit) " close unite view
   endfunction

   function! open_current_file_dir(args)
     let [args, options] = unite#helper#parse_options_args(a:args)
     let path = expand('%:h')
     let options.path = path
     call unite#start(args, options)
   endfunction

   nnoremap úúcd :call open_current_file_dir('-no-split file')<cr>
   nnoremap <c-;><c-;>cd :call open_current_file_dir('-no-split file')<cr>

   "ctrlp & nerdtree combined
   nnoremap <silent> úúf :unite -auto-resize file/async  file_rec/async<cr>
   nnoremap <silent> <c-;><c-;>f :unite -auto-resize file/async  file_rec/async<cr>
   nnoremap <silent> úúf :unite -auto-resize file_rec/async<cr>
   nnoremap <silent> <c-;><c-;>f :unite -auto-resize file_rec/async<cr>
   nnoremap <silent> úú<c-f> :unite -auto-resize file_rec/async<cr>
   nnoremap <silent> <c-;><c-;><c-f> :unite -auto-resize file_rec/async<cr>

   nnoremap <silent> úúd :unite -auto-resize directory_rec/async<cr>
   nnoremap <silent> <c-;><c-;>d :unite -auto-resize directory_rec/async<cr>
   nnoremap <silent> úúo :unite -auto-resize file_mru<cr>
   nnoremap <silent> <c-;><c-;>o :unite -auto-resize file_mru<cr>

   nnoremap <silent> úúl :unite -auto-resize outline<cr>
   nnoremap <silent> <c-;><c-;>l :unite -auto-resize outline<cr>

   "grep commands
   nnoremap <silent> úúg :unite -auto-resize grep:.<cr>
   nnoremap <silent> <c-;><c-;>g :unite -auto-resize grep:.<cr>
   nnoremap <silent> úú<c-g> :unite -auto-resize grep:/<cr>
   nnoremap <silent> <c-;><c-;><c-g> :unite -auto-resize grep:/<cr>
   "content search like ag anc ack
   nnoremap úú/ :unite grep:.<cr>
   nnoremap <c-;><c-;>/ :unite grep:.<cr>

   "hostory & yankring
   let g:unite_source_history_yank_enable = 1
   nnoremap úúy :unite history/yank<cr>
   nnoremap <c-;><c-;>y :unite history/yank<cr>
   nnoremap úú: :unite history/command<cr>
   nnoremap <c-;><c-;>: :unite history/command<cr>
   nnoremap úú/ :unite history/search<cr>
   nnoremap <c-;><c-;>/ :unite history/search<cr>

   nnoremap úú? :unite mapping<cr>
   nnoremap <c-;><c-;>? :unite mapping<cr>

   "lustyjuggler
   nnoremap úúb :unite -quick-match buffer<cr>
   nnoremap <c-;><c-;>b :unite -quick-match buffer<cr>
   nnoremap úú<c-b> :unite buffer<cr>
   nnoremap <c-;><c-;><c-b> :unite buffer<cr>

   "lustyjuggler
   nnoremap úút :unite -quick-match tab<cr>
   nnoremap <c-;><c-;>t :unite -quick-match tab<cr>
   nnoremap úú<c-t> :unite tab<cr>
   nnoremap <c-;><c-;><c-t> :unite tab<cr>

   "line search
   nnoremap úúl :unite line<cr>
   nnoremap <c-;><c-;>l :unite line<cr>
   nnoremap úúl :unite -quick-match line<cr>
   nnoremap <c-;><c-;>l :unite -quick-match line<cr>

 "}}} _unite.vim
 " ctrlp.vim {{{

   " " plug 'kien/ctrlp.vim'
   " plug 'ctrlpvim/ctrlp.vim', {'on': ['ctrlp']}
   " plug 'sgur/ctrlp-extensions.vim'
   " plug 'fisadev/vim-ctrlp-cmdpalette'
   " plug 'ivalkeen/vim-ctrlp-tjump'
   " plug 'suy/vim-ctrlp-commandline'
   " plug 'tacahiroy/ctrlp-funky'
   " plug '/volumes/home/.config/nvim/plugged/ctrlp-my-notes'    "locate my notes
   " plug '/volumes/home/.config/nvim/plugged/ctrlp-dash-helper' "dash helper
   " plug 'jazzcore/ctrlp-cmatcher'                       "ctrl-p matcher
   " " plug 'felikz/ctrlp-py-matcher'                     "ctrl-p matcher
   " " plug 'nixprime/cpsm'                               "ctrl-p matcher

   " command! ctrlpcommandline call ctrlp#init(ctrlp#commandline#id())
   " cnoremap <silent> <c-p> <c-c>:call ctrlp#init(ctrlp#commandline#id())<cr>

   " "'vim-ctrlp-tjump',
   " let g:ctrlp_extensions = [
         " \ 'tag', 'buffertag', 'quickfix', 'dir', 'rtscript', 'dashhelper',
         " \ 'vimnotes', 'undo', 'line', 'changes', 'mixed', 'bookmarkdir',
         " \ 'funky', 'commandline'
         " \ ]

   " "open window in nerdtree if available
   " let g:ctrlp_reuse_window = 'netrw\|help\|nerd\|startify'

   " " make ctrl+p indexing faster by using ag silver searcher
   " let g:ctrlp_lazy_update = 350

   " "enable caching to make it fast
   " let g:ctrlp_use_caching = 1

   " "don't clean cache on exit else it will take alot to regenerate rtp
   " let g:ctrlp_clear_cache_on_exit = 0

   " let g:ctrlp_cache_dir = $home.'/.config/nvim/.cache/ctrlp'

   " let g:ctrlp_max_files = 0
   " if executable("ag")
     " set grepprg=ag\ --nogroup\ --nocolor
     " let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
           " \ --ignore .git
           " \ --ignore .svn
           " \ --ignore .hg
           " \ --ignore .ds_store
           " \ --ignore "**/*.pyc"
           " \ --ignore vendor
           " \ --ignore node_modules
           " \ -g ""'

   " endif

   " let g:ctrlp_switch_buffer = 'e'

   " "when i press c-p run ctrlp from root of my project regardless of the current
   " "files path
   " let g:ctrlp_cmd='ctrlproot'
   " let g:ctrlp_map = '<c-p><c-p>'

   " " make ctrl+p matching faster by using pymatcher
   " " let g:ctrlp_match_func = { 'match': 'pymatcher#pymatch' }
   " let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
   " " let g:ctrlp_match_func = {'match': 'cpsm#ctrlpmatch'}

   " nnoremap <c-p>j :ctrlptjump<cr>
   " vnoremap <c-p>j :ctrlptjumpvisual<cr>
   " nnoremap <c-p>b :ctrlpbuffer<cr>
   " nnoremap <c-p>cd :ctrlpdir .<cr>
   " nnoremap <c-p>d :ctrlpdir<cr>
   " nnoremap <c-p><c-[> :ctrlpfunky<cr>
   " nnoremap <c-p><c-]> :execute 'ctrlpfunky ' . expand('<cword>')<cr>
   " nnoremap <c-p>f :execute ":ctrlp " . expand('%:p:h')<cr>
   " "nnoremap <c-p>m :ctrlpmixed<cr>
   " nnoremap <c-p>q :ctrlpquickfix<cr>
   " nnoremap <c-p>y :ctrlpyankring<cr>
   " "nnoremap <c-p>r :ctrlproot<cr>
   " nnoremap <c-p>w :ctrlpcurwd<cr>

   " nnoremap <c-p>t :ctrlptag<cr>
   " nnoremap <c-p>[ :ctrlpbuftag<cr>
   " nnoremap <c-p>] :ctrlpbuftagall<cr>
   " nnoremap <c-p>u :ctrlpundo<cr>
   " " nnoremap <c-p>\\ :ctrlprts<cr>
   " ""nnoremap <c-p><cr> :ctrlpcmdline<cr>
   " nnoremap <c-p>; :ctrlpcmdpalette<cr>
   " nnoremap <c-p><cr> :ctrlpcommandline<cr>
   " nnoremap <c-p><bs> :ctrlpclearcache<cr>
   " nnoremap <c-p><space> :ctrlpclearallcache<cr>
   " nnoremap <c-p>p :ctrlplastmode<cr>
   " nnoremap <c-p>i :ctrlpchange<cr>
   " nnoremap <c-p><c-i> :ctrlpchangeall<cr>
   " nnoremap <c-p>l :ctrlpline<cr>
   " nnoremap <c-p>` :ctrlpbookmarkdir<cr>
   " nnoremap <c-p>@ :ctrlpbookmarkdiradd<cr>
   " nnoremap <c-p>o :ctrlpmru<cr>

   " let g:ctrlp_prompt_mappings = {
         " \ 'prtbs()':              ['<bs>', '<c-]>'],
         " \ 'prtdelete()':          ['<del>'],
         " \ 'prtdeleteword()':      ['<c-w>'],
         " \ 'prtclear()':           ['<c-u>'],
         " \ 'prtselectmove("j")':   ['<c-j>', '<down>'],
         " \ 'prtselectmove("k")':   ['<c-k>', '<up>'],
         " \ 'prtselectmove("t")':   ['<home>', '<khome>'],
         " \ 'prtselectmove("b")':   ['<end>', '<kend>'],
         " \ 'prtselectmove("u")':   ['<pageup>', '<kpageup>'],
         " \ 'prtselectmove("d")':   ['<pagedown>', '<kpagedown>'],
         " \ 'prthistory(-1)':       ['<c-n>'],
         " \ 'prthistory(1)':        ['<c-p>'],
         " \ 'acceptselection("e")': ['<cr>', '<2-leftmouse>'],
         " \ 'acceptselection("h")': ['<c-x>', '<c-cr>', '<c-s>'],
         " \ 'acceptselection("t")': ['<c-t>'],
         " \ 'acceptselection("v")': ['<c-v>', '<rightmouse>'],
         " \ 'togglefocus()':        ['<s-tab>'],
         " \ 'toggleregex()':        ['<c-r>'],
         " \ 'togglebyfname()':      ['<c-d>'],
         " \ 'toggletype(1)':        ['<c-f>'],
         " \ 'toggletype(-1)':       ['<c-b>'],
         " \ 'prtexpanddir()':       ['<tab>'],
         " \ 'prtinsert("c")':       ['<middlemouse>', '<insert>'],
         " \ 'prtinsert()':          ['<c-\>'],
         " \ 'prtcurstart()':        ['<c-a>'],
         " \ 'prtcurend()':          ['<c-e>'],
         " \ 'prtcurleft()':         ['<c-h>', '<left>', '<c-^>'],
         " \ 'prtcurright()':        ['<c-l>', '<right>'],
         " \ 'prtclearcache()':      ['<f5>', 'úú'],
         " \ 'prtclearcache()':      ['<f5>', '<c-;><c-;>'],
         " \ 'prtdeleteent()':       ['<f7>'],
         " \ 'createnewfile()':      ['<c-y>'],
         " \ 'marktoopen()':         ['<c-z>'],
         " \ 'openmulti()':          ['<c-o>'],
         " \ 'prtexit()':            ['<esc>', '<c-c>', '<c-g>'],
         " \ }

 "}}} _ctrlp.vim
 " fzf {{{
   "call dein#add('junegunn/fzf', { 'on_source': ['fzf.vim'] })
   "call dein#add('junegunn/fzf', { 'build': './install -all', 'rtp': '' })
   "call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })

    let g:fzf_layout = { 'window': 'execute (tabpagenr()-1)."tabnew"' }

    let $fzf_default_opts="--bind '::jump,;:jump-accept'"

    let $fzf_default_command='ag -l -g ""'
    "set rtp+=/usr/local/cellar/fzf/head
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
          \   'on_cmd': ['files', 'gitfiles', 'buffers', 'colors', 'ag', 'lines',
          \               'blines', 'tags', 'btags', 'maps', 'marks', 'windows',
          \               'locate', 'history', 'history:', 'history/', 'snippets',
          \               'commits', 'bcommits', 'commands', 'helptags']
          \ })

   " [buffers] jump to the existing window if possible
   let g:fzf_buffers_jump = 1

   " command          | list
   " ---              | ---
   " `files [path]`   | files (similar to `:fzf`)
   " `gitfiles`       | git files
   " `buffers`        | open buffers
   " `colors`         | color schemes
   " `ag [pattern]`   | [ag][ag] search result (`alt-a` to select all, `alt-d` to deselect all)
   " `lines`          | lines in loaded buffers
   " `blines`         | lines in the current buffer
   " `tags [query]`   | tags in the project (`ctags -r`)
   " `btags [query]`  | tags in the current buffer
   " `marks`          | marks
   " `windows`        | windows
   " `locate pattern` | `locate` command output
   " `history`        | `v:oldfiles` and open buffers
   " `history:`       | command history
   " `history/`       | search history
   " `snippets`       | snippets ([ultisnips][us])
   " `commits`        | git commits (requires [fugitive.vim][f])
   " `bcommits`       | git commits for the current buffer
   " `commands`       | commands
   " `maps`           | normal mode mappings
   " `helptags`       | help tags <sup id="a1">[1](#helptags)</sup>
   " `filetypes`      | file types

   function! s:find_git_root()
     return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
   endfunction

   function! map_fzf(cmd, key, options, cword)
     exe "nnoremap <c-p><c-" . a:key . "> :" . a:cmd . a:options . "<cr>"
    "this type is where no args passed
     if a:cword == 0
       exe "nnoremap <c-p>" . a:key . " :" . a:cmd . a:options . "<cr>"

    "this type is where -q used pass args
     elseif a:cword == 1
       exe "nnoremap <c-p>" . a:key . " :" . a:cmd . a:options .
             \ " -q <c-r>=shellescape(expand('<cword>'))<cr>" . "<cr>"
       exe "vnoremap <c-p>" . a:key . " :<c-u>" . a:cmd . a:options .
             \ " -q <c-r>=shellescape(getvisualselection())<cr>" . "<cr>"

    "this type is where 'word does produce results
     elseif a:cword == 2
       exe "nnoremap <c-p>" . a:key . " :" . a:cmd . a:options .
             \ " '<c-r>=expand('<cword>')<cr><cr>"
       exe "vnoremap <c-p>" . a:key . " :<c-u>" . a:cmd . a:options .
             \ " '<c-r>=getvisualselection()<cr><cr>"

    "this type is where 'word does not produce results
     elseif a:cword == 3
       exe "nnoremap <c-p>" . a:key . " :" . a:cmd . a:options .
             \ " <c-r>=expand('<cword>')<cr><cr>"
       exe "vnoremap <c-p>" . a:key . " :<c-u>" . a:cmd . a:options .
             \ " <c-r>=getvisualselection()<cr><cr>"
     endif
     if has('nvim')
       exe "tnoremap <c-p><c-" . a:key . "> <c-\\><c-n>:" . a:cmd . a:options "<cr>"
     endif

   endfunction


  "call map_fzf("command", "key", "options"                             , cw )
   call map_fzf("fzf! ", "d", " --reverse %:p:h "                       ,  0 )
   call map_fzf("fzf! ", "r", " --reverse <c-r>=findgitdirorroot()<cr>" ,  0 )
   call map_fzf("fzf! ", "p", " --reverse"                              ,  1 )
   call map_fzf("buffers", "b", ""                                      ,  0 )
   call map_fzf("ag!", "a", ""                                          ,  3 )
   call map_fzf("lines!", "l", ""                                       ,  2 )
   call map_fzf("blines!", "l", ""                                      ,  2 )
   call map_fzf("btags!", "t", ""                                       ,  0 )
   call map_fzf("tags!", "]", ""                                        ,  0 )
   "call map_fzf("locate", "<cr>", "--reverse  %:p:h"                   ,  0 )
   call map_fzf("gitfiles", "v", ""                                     ,  0 )
   call map_fzf("commits!", "g", ""                                     ,  0 )
   call map_fzf("bcommits!", "g", ""                                    ,  0 )
   call map_fzf("snippets!", "s", ""                                    ,  0 )
   call map_fzf("marks!", "◊", ""                                       ,  0 )
   call map_fzf("marks!", "'", ""                                       ,  0 )
   call map_fzf("windows!", "w", ""                                     ,  0 )
   call map_fzf("helptags!", "k", ""                                    ,  0 )


   "nmap <c-p><c-i> <plug>(fzf-maps-n)
   nnoremap <c-p><c-m> :maps!<cr>
   xmap <c-p><c-m> <plug>(fzf-maps-x)
   omap <c-p><c-m> <plug>(fzf-maps-o)

   imap <c-x><c-k> <plug>(fzf-complete-word)
   imap <c-x><c-f> <plug>(fzf-complete-path)
   imap <c-x><c-a> <plug>(fzf-complete-file-ag)
   imap <c-x><c-l> <plug>(fzf-complete-line)
   imap <c-x><c-i> <plug>(fzf-complete-buffer-line)
   imap <c-x><c-\> <plug>(fzf-complete-file)

   function getdirectories()
     call fzf#run({"source":"ag -l --nocolor -g \"\" | awk 'nf{nf-=1};1' fs=/ ofs=/ | sort -u | uniq" , "sink":"nerdtree"})
    "find . -type d   -not -iwholename \"./.phpcd*\" -not -iwholename \"./node_modules*\" -not -iwholename \".\" -not -iwholename \"./vendor*\" -not -iwholename \"./.git*\"
    "ag -l --nocolor -g "" | awk 'nf{nf-=1};1' fs=/ ofs=/ | sort -u | uniq
   endfunction
   nnoremap <c-p>[ :call fzf#run({"source":"find . -type d", "sink":"nerdtree"})<cr>
   nnoremap <silent> <c-p><c-[> :cal getdirectories()<cr>

   " replace the default dictionary completion with fzf-based fuzzy completion
   " inoremap <expr> <c-x><c-k> fzf#complete('cat /usr/share/dict/words')

   function! printpathfunction(myparam)
     execute ":normal i".a:myparam
   endfunction
   command! -nargs=1 printpath call printpathfunction(<f-args>)

   function! printpathinnextlinefunction(myparam)
     put=a:myparam
   endfunction

   command! -nargs=1 printpathinnextline call printpathinnextlinefunction(<f-args>)

   let g:fzf_action = {
         \ 'ctrl-m': 'e!',
         \ 'ctrl-t': 'tabedit!',
         \ 'ctrl-x': 'split',
         \ 'ctrl-o': 'printpathinnextline',
         \ 'ctrl-i': 'printpath',
         \ 'ctrl-v': 'vsplit' }

   " tabs {{{
   function! s:tablist()
     redir => tabs
     silent tabs
     redir end
     let new_tabs = filter(split(tabs, '\n'), 'v:val =~ "tab page"')
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
     "echomsg ':normal! '. matchstr(a:e, 'tab page \zs[0-9]*\ze .*$').'gt'
     "execute 'normal! ' . matchstr(a:e, 'tab page \zs[0-9]*\ze .*$').'gt'
     execute ':tabnext ' . matchstr(a:e, 'tab page \zs[0-9]*\ze .*$')
     "let g:fzf_cmd='normal! ' . matchstr(a:e, 'tab page \zs[0-9]*\ze .*$').'gt'
     "call timer_start(50, '<sid>switchtab', {'repeat': 1})
   endfunction
   "func! s:switchtab(timer)
   "execute g:fzf_cmd
   "endfunc

   if has('nvim')
     tmap <c-p><c-i> <c-\><c-n><c-p><c-i>
   endif

   nnoremap <silent> <c-p><c-i> :call fzf#run({
         \   'source':  reverse(<sid>tablist()),
         \   'sink':    function('<sid>tabopen'),
         \   'options': " --preview-window right:50%  --preview 'echo {}'  --bind ?:toggle-preview",
         \   'down':    len(<sid>tablist()) + 2
         \ })<cr>

   "}}} _tabs

   "open_buffers -term {{{
   function! s:buflist()
     redir => ls
     silent ls
     redir end
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
         \ })<cr>

   "}}} _open_buffers -term

   "open_terms {{{
   function! s:termlist()
     redir => ls
     silent ls!
     redir end
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
         \ })<cr>

   "}}} _open_terms

 " }}}
 " }}}

 " ranger.vim {{{

   call dein#add( 'francoiscabrol/ranger.vim' )
   call dein#add( 'rbgrouleff/bclose.vim' )
   let g:ranger_map_keys = 0
   nnoremap <leader>fr :call openranger()<cr>

 "}}} _ranger.vim
 " vim-dirvish {{{

   call dein#add( 'justinmk/vim-dirvish' )         " {-} file browser

 "}}} _vim-dirvish
 " vim-vinegar {{{

   call dein#add( 'tpope/vim-vinegar' )

 "}}} _vim-vinegar
 " vimfiler.vim {{{
       "\     'on_map': [['n', '<plug>']],
 call dein#add( 'shougo/vimfiler.vim', {
       \     'depends': 'unite.vim',
       \     'on_cmd': ['vimfiler', 'vimfilerbufferdir', 'vimfilercurrentdir']
       \ })
  "let g:loaded_netrw       = 1 "disable netrw
  "let g:loaded_netrwplugin = 1 "disable netrw
  let g:vimfiler_as_default_explorer=1

  let g:vimfiler_ignore_pattern=[ '\.ncb$', '\.suo$', '\.vcproj\.rimnet', '\.obj$',
        \ '\.ilk$', '^buildlog.htm$', '\.pdb$', '\.idb$',
        \ '\.embed\.manifest$', '\.embed\.manifest.res$',
        \ '\.intermediate\.manifest$', '^mt.dep$', '^.openide$', '^.git$', '^testresult.xml$', '^.paket$', '^paket.dependencies$','^paket.lock$', '^paket.template$', '^.agignore$', '^.autotest.config$',
        \ '^.gitignore$', '^.idea$' , '^tags$']

  "force vimfiler enter to toggle expand/collapse
  autocmd! filetype vimfiler call s:my_vimfiler_settings()
  function! s:my_vimfiler_settings()
    nmap <silent><buffer> <cr> <plug>(vimfiler_expand_or_edit)
    nmap <silent><buffer> <cr> <plug>(vimfiler_expand_or_edit)
  endfunction

  au user vimfiler.vim call mapvimfiler()

  function! mapvimfiler()
    nnoremap <silent> ú<c-l><c-l> :vimfiler -simple -split -winwidth=33 -force-hide<cr>
    nnoremap <silent> <c-;><c-l><c-l> :vimfiler -simple -split -winwidth=33 -force-hide<cr>
    nnoremap <silent> ú<c-l><c-f> :vimfilerbufferdir -simple -split -winwidth=33 -force-hide<cr>
    nnoremap <silent> <c-;><c-l><c-f> :vimfilerbufferdir -simple -split -winwidth=33 -force-hide<cr>
    nnoremap <silent> ú<c-l><c-d> :vimfilercurrentdir -simple -split -winwidth=33 -force-hide<cr>
    nnoremap <silent> <c-;><c-l><c-d> :vimfilercurrentdir -simple -split -winwidth=33 -force-hide<cr>
  endfunction

 "}}} _vimfiler.vim
 " nerdtree {{{

   call dein#add( 'scrooloose/nerdtree', {'on_cmd':  ['nerdtreetoggle', 'nerdtreecwd', 'nerdtreefind', 'nerdtree'] } )
   "plug 'scrooloose/nerdtree'
  "plug 'jistr/vim-nerdtree-tabs'

   "let g:loaded_netrw       = 1 "disable netrw
   "let g:loaded_netrwplugin = 1 "disable netrw

   "let g:nerdtree_tabs_open_on_gui_startup = 0
   let g:nerdtree_tabs_open_on_gui_startup = !$nvim_tui_enable_true_color


   let nerdtreequitonopen=1
   let nerdtreewinsize = 23

   " don't display these kinds of files
   let nerdtreeignore=[ '\.ncb$', '\.suo$', '\.vcproj\.rimnet', '\.obj$',
         \ '\.ilk$', '^buildlog.htm$', '\.pdb$', '\.idb$',
         \ '\.embed\.manifest$', '\.embed\.manifest.res$',
         \ '\.intermediate\.manifest$', '^mt.dep$', '^.openide$', '^.git$', '^testresult.xml$', '^.paket$', '^paket.dependencies$','^paket.lock$', '^paket.template$', '^.agignore$', '^.autotest.config$',
         \ '^.gitignore$', '^.idea$' , '^tags$']

   let nerdtreeshowhidden=1
   let nerdtreeshowbookmarks=1

   " nnoremap ú<c-l> :nerdtreetabstoggle<cr>
   " nnoremap <c-;><c-l> :nerdtreetabstoggle<cr>
   nnoremap ú<c-l><c-l> :nerdtreetoggle<cr>
   nnoremap <c-;><c-l><c-l> :nerdtreetoggle<cr>
   nnoremap ú<c-l><c-d> :nerdtreecwd<cr>
   nnoremap <c-;><c-l><c-d> :nerdtreecwd<cr>
   nnoremap ú<c-l><c-f> :nerdtreefind<cr>
   nnoremap <c-;><c-l><c-f> :nerdtreefind<cr>


   function! nerdtreehighlightfile(extension, fg, bg, guifg, guibg)
     exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
     exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
   endfunction

   call nerdtreehighlightfile('jade', 'green', 'none', 'green', 'none')
   call nerdtreehighlightfile('md', 'blue', 'none', '#6699cc', 'none')
   call nerdtreehighlightfile('config', 'yellow', 'none', '#d8a235', 'none')
   call nerdtreehighlightfile('conf', 'yellow', 'none', '#d8a235', 'none')
   call nerdtreehighlightfile('json', 'green', 'none', '#d8a235', 'none')
   call nerdtreehighlightfile('html', 'yellow', 'none', '#d8a235', 'none')
   call nerdtreehighlightfile('css', 'cyan', 'none', '#5486c0', 'none')
   call nerdtreehighlightfile('scss', 'cyan', 'none', '#5486c0', 'none')
   call nerdtreehighlightfile('coffee', 'red', 'none', 'red', 'none')
   call nerdtreehighlightfile('js', 'red', 'none', '#ffa500', 'none')
   call nerdtreehighlightfile('ts', 'blue', 'none', '#6699cc', 'none')
   call nerdtreehighlightfile('ds_store', 'gray', 'none', '#686868', 'none')
   call nerdtreehighlightfile('gitconfig', 'black', 'none', '#686868', 'none')
   call nerdtreehighlightfile('gitignore', 'gray', 'none', '#7f7f7f', 'none')

 "}}}

 " vim-projectionist {{{

 " plug 'tpope/vim-projectionist'

 "}}} _vim-projectionist
 " vim-dotenv {{{

   call dein#add( 'tpope/vim-dotenv', {'on_cmd':['dotenv']} )

 "}}} _vim-dotenv

 " content
 " vim-evanesco {{{

 " "may replace vim-oblique one day :)

 " " plug 'pgdouyon/vim-evanesco'
 " plug 'khalidchawtany/vim-evanesco'
 " autocmd! user evanesco       anzuupdatesearchstatusoutput
 " autocmd! user evanescostar   anzuupdatesearchstatusoutput
 " autocmd! user evanescorepeat anzuupdatesearchstatusoutput

 "}}} _vim-evanesco

 " vim-pseudocl {{{

   call dein#add( 'junegunn/vim-pseudocl' ) "required by oblique & fnr

 "}}} _vim-pseudocl

 " incsearch.vim {{{

 call dein#add( 'haya14busa/incsearch.vim' )
 call dein#add( 'haya14busa/incsearch-fuzzy.vim' )
 "many more options look at help
 "map /  <plug>(incsearch-forward)
 "map ?  <plug>(incsearch-backward)
 "map g/ <plug>(incsearch-stay)

 "}}} _incsearch.vim
 " vim-oblique {{{
 let g:oblique#enable_cmap=0
 call dein#add( 'junegunn/vim-oblique', {'on_map': [ '<plug>(oblique-' ]} )


 map nx  #  <plug>(oblique-#)
 map nx  *  <plug>(oblique-*)
 map nox /  <plug>(oblique-/)
 map nox ?  <plug>(oblique-?)
 map n   g# <plug>(oblique-g#)
 map n   g* <plug>(oblique-g*)
 map nox z/ <plug>(oblique-f/)
 map nox z? <plug>(oblique-f?)

 "make n/n move forward/backwards regardless of search direction
 "map nx  n  <plug>(oblique-n)
 "map nx  n  <plug>(oblique-n)
 "noremap <expr> n 'nn'[v:searchforward]
 "noremap <expr> n 'nn'[v:searchforward]
 nmap <expr>n ['<plug>(oblique-n)','<plug>(oblique-n)'][v:searchforward]
 nmap <expr>n ['<plug>(oblique-n)','<plug>(oblique-n)'][v:searchforward]

 autocmd! user oblique       anzuupdatesearchstatusoutput
 autocmd! user obliquestar   anzuupdatesearchstatusoutput
 autocmd! user obliquerepeat anzuupdatesearchstatusoutput

 let g:oblique#enable_cmap=0

 "}}}
 "scalpel {{{
   call dein#add('wincent/scalpel', {'on_cmd': ['scalpel'], 'on_map': ['<plug>(scalpel)']})
   nmap  g;r <plug>(scalpel)
 "}}} _scalpel

 " indexedsearch {{{

   " plug 'khalidchawtany/indexedsearch', {'on':['<plug>(showsearchindex_', 'showsearchindex']}

   " let g:indexedsearch_saneregex = 1
   " let g:indexedsearch_autocenter = 1
   " let g:indexedsearch_no_default_mappings = 1

   " " nmap <silent>n <plug>(showsearchindex_n)zv
   " " nmap <silent>n <plug>(showsearchindex_n)zv
   " " nmap <silent>* <plug>(showsearchindex_star)zv
   " " nmap <silent># <plug>(showsearchindex_pound)zv

   " " nmap / <plug>(showsearchindex_forward)
   " " nmap ? <plug>(showsearchindex_backward)

 "}}} _indexedsearch
 " vim-anzu {{{

 call dein#add( 'osyo-manga/vim-anzu', {'on_cmd': ['anzuupdatesearchstatusoutput']} )
 "let anzu display numbers only. the search is already displayed by oblique
 let g:anzu_status_format = ' (%i/%l)'

 "}}} _vim-anzu
 " vim-fuzzysearch {{{

   call dein#add( 'ggvgc/vim-fuzzysearch', {'on_cmd': ['fuzzysearch']} )
   nnoremap g\f :fuzzysearch<cr>


 "}}} _vim-fuzzysearch
 " grepper {{{

 call dein#add( 'mhinz/vim-grepper', {'on_cmd': [ 'grepper'], 'on_map': [ '<plug>(grepper' ]} )

   xmap g\g <plug>(grepper)
   cmap <c-g>n <plug>(greppernext)
   nmap g\g <plug>(greppermotion)
   xmap g\g <plug>(greppermotion)

   let g:grepper              = {}
   let g:grepper.programs     = ['ag', 'git', 'grep']
   let g:grepper.use_quickfix = 1
   let g:grepper.do_open      = 1
   let g:grepper.do_switch    = 1
   let g:grepper.do_jump      = 0


 "}}}
 "vim-side-search{{{
 call dein#add('ddrscott/vim-side-search', {'on_cmd':['sidesearch']})
 " how should we execute the search?
 " --heading and --stats are required!
 let g:side_search_prg = 'ag --word-regexp'
       \. " --ignore='*.js.map'"
       \. " --heading --stats -b 1 -a 4"

 " can use `vnew` or `new`
 let g:side_search_splitter = 'vnew'

 " i like 40% splits, change it if you don't
 let g:side_search_split_pct = 0.4

 " sidesearch current word and return to original window
 nnoremap g\s :sidesearch <c-r><c-w><cr> | wincmd p
 " create an shorter `ss` command
 command! -complete=file -nargs=+ ss execute 'sidesearch <args>'
 " or command abbreviation
 cabbrev ss sidesearch

 "}}}_vim-side-search

 " clever-f {{{

   call dein#add( 'rhysd/clever-f.vim' , {'on_map': [ '<plug>(clever-f-' ]})

   map nox f     <plug>(clever-f-f)
   map nox t     <plug>(clever-f-t)
   map nox f     <plug>(clever-f-f)
   map nox t     <plug>(clever-f-t)
   "the following makes fftf useless because of the time out
   "map n   f<bs> <plug>(clever-f-reset)


 "}}}
 " vim-easymotion {{{

   call dein#add( 'lokaltog/vim-easymotion', {'on_map': ['<plug>(easymotion-']} )

   map s         <plug>(easymotion-prefix)
   map s;        <plug>(easymotion-s2)
   map ss;       <plug>(easymotion-sn)

   map sl        <plug>(easymotion-lineforward)
   map sh        <plug>(easymotion-linebackward)
   map s<space>  <plug>(easymotion-lineanywhere)

   map ssf       <plug>(easymotion-bd-f)
   map sst       <plug>(easymotion-bd-t)
   map ssw       <plug>(easymotion-bd-w)
   map ssw       <plug>(easymotion-bd-w)
   map ssw       <plug>(easymotion-bd-e)
   map sse       <plug>(easymotion-bd-e)
   map ssj       <plug>(easymotion-bd-jk)
   map ssk       <plug>(easymotion-bd-jk)
   map ssl       <plug>(easymotion-bd-jk)
   map ssn       <plug>(easymotion-bd-n)
   map ssa       <plug>(easymotion-jumptoanywhere)
   map s<cr>       <plug>(easymotion-repeat)

   map <c-s>l    <plug>(easymotion-eol-bd-jk)
   map <c-s>h    <plug>(easymotion-sol-bd-jk)

   map <c-s>f    <plug>(easymotion-overwin-f)
   map <c-s>;    <plug>(easymotion-overwin-f2)
   map <c-s>w    <plug>(easymotion-overwin-w)
   map <c-s>l    <plug>(easymotion-overwin-line)


" default maps {{{
"   default mapping      | details
"   ---------------------|----------------------------------------------
"   <leader>f{char}      | find {char} to the right. see |f|.
"   <leader>f{char}      | find {char} to the left. see |f|.
"   <leader>t{char}      | till before the {char} to the right. see |t|.
"   <leader>t{char}      | till after the {char} to the left. see |t|.
"   <leader>w            | beginning of word forward. see |w|.
"   <leader>w            | beginning of word forward. see |w|.
"   <leader>b            | beginning of word backward. see |b|.
"   <leader>b            | beginning of word backward. see |b|.
"   <leader>e            | end of word forward. see |e|.
"   <leader>e            | end of word forward. see |e|.
"   <leader>ge           | end of word backward. see |ge|.
"   <leader>ge           | end of word backward. see |ge|.
"   <leader>j            | line downward. see |j|.
"   <leader>k            | line upward. see |k|.
"   <leader>n            | jump to latest "/" or "?" forward. see |n|.
"   <leader>n            | jump to latest "/" or "?" backward. see |n|.
"   <leader>s            | find(search) {char} forward and backward.
"                        | see |f| and |f|.
" unused maps
"   more <plug> mapping table         | (no assignment by default)
"   ----------------------------------|---------------------------------
"   <plug>(easymotion-bd-f)           | see |<plug>(easymotion-s)|
"   <plug>(easymotion-bd-t)           | see |<plug>(easymotion-bd-t)|
"   <plug>(easymotion-bd-w)           | see |<plug>(easymotion-bd-w)|
"   <plug>(easymotion-bd-w)           | see |<plug>(easymotion-bd-w)|
"   <plug>(easymotion-bd-e)           | see |<plug>(easymotion-bd-e)|
"   <plug>(easymotion-bd-e)           | see |<plug>(easymotion-bd-e)|
"   <plug>(easymotion-bd-jk)          | see |<plug>(easymotion-bd-jk)|
"   <plug>(easymotion-bd-n)           | see |<plug>(easymotion-bd-n)|
"   <plug>(easymotion-jumptoanywhere) | see |<plug>(easymotion-jumptoanywhere)|
"   <plug>(easymotion-repeat)         | see |<plug>(easymotion-repeat)|
"   <plug>(easymotion-next)           | see |<plug>(easymotion-next)|
"   <plug>(easymotion-prev)           | see |<plug>(easymotion-prev)|
"   <plug>(easymotion-sol-j)          | see |<plug>(easymotion-sol-j)|
"   <plug>(easymotion-sol-k)          | see |<plug>(easymotion-sol-k)|
"   <plug>(easymotion-eol-j)          | see |<plug>(easymotion-eol-j)|
"   <plug>(easymotion-eol-k)          | see |<plug>(easymotion-eol-k)|
"   <plug>(easymotion-iskeyword-w)    | see |<plug>(easymotion-iskeyword-w)|
"   <plug>(easymotion-iskeyword-b)    | see |<plug>(easymotion-iskeyword-b)|
"   <plug>(easymotion-iskeyword-bd-w) | see |<plug>(easymotion-iskeyword-bd-w)|
"   <plug>(easymotion-iskeyword-e)    | see |<plug>(easymotion-iskeyword-e)|
"   <plug>(easymotion-iskeyword-ge)   | see |<plug>(easymotion-iskeyword-ge)|
"   <plug>(easymotion-iskeyword-bd-e) | see |<plug>(easymotion-iskeyword-bd-e)|
"   <plug>(easymotion-vim-n)          | see |<plug>(easymotion-vim-n)|
"   <plug>(easymotion-vim-n)          | see |<plug>(easymotion-vim-n)|
"                                     |
"   within line motion                | see |easymotion-within-line|
"   ----------------------------------|---------------------------------
"   <plug>(easymotion-sl)             | see |<plug>(easymotion-sl)|
"   <plug>(easymotion-fl)             | see |<plug>(easymotion-fl)|
"   <plug>(easymotion-fl)             | see |<plug>(easymotion-fl)|
"   <plug>(easymotion-bd-fl)          | see |<plug>(easymotion-sl)|
"   <plug>(easymotion-tl)             | see |<plug>(easymotion-tl)|
"   <plug>(easymotion-tl)             | see |<plug>(easymotion-tl)|
"   <plug>(easymotion-bd-tl)          | see |<plug>(easymotion-bd-tl)|
"   <plug>(easymotion-wl)             | see |<plug>(easymotion-wl)|
"   <plug>(easymotion-bl)             | see |<plug>(easymotion-bl)|
"   <plug>(easymotion-bd-wl)          | see |<plug>(easymotion-bd-wl)|
"   <plug>(easymotion-el)             | see |<plug>(easymotion-el)|
"   <plug>(easymotion-gel)            | see |<plug>(easymotion-gel)|
"   <plug>(easymotion-bd-el)          | see |<plug>(easymotion-bd-el)|
"   <plug>(easymotion-lineforward)    | see |<plug>(easymotion-lineforward)|
"   <plug>(easymotion-linebackward)   | see |<plug>(easymotion-linebackward)|
"   <plug>(easymotion-lineanywhere)   | see |<plug>(easymotion-lineanywhere)|
"                                     |
"   multi input find motion           | see |easymotion-multi-input|
"   ----------------------------------|---------------------------------
"   <plug>(easymotion-s2)             | see |<plug>(easymotion-s2)|
"   <plug>(easymotion-f2)             | see |<plug>(easymotion-f2)|
"   <plug>(easymotion-f2)             | see |<plug>(easymotion-f2)|
"   <plug>(easymotion-bd-f2)          | see |<plug>(easymotion-s2)|
"   <plug>(easymotion-t2)             | see |<plug>(easymotion-t2)|
"   <plug>(easymotion-t2)             | see |<plug>(easymotion-t2)|
"   <plug>(easymotion-bd-t2)          | see |<plug>(easymotion-bd-t2)|
"                                     |
"   <plug>(easymotion-sl2)            | see |<plug>(easymotion-sl2)|
"   <plug>(easymotion-fl2)            | see |<plug>(easymotion-fl2)|
"   <plug>(easymotion-fl2)            | see |<plug>(easymotion-fl2)|
"   <plug>(easymotion-tl2)            | see |<plug>(easymotion-tl2)|
"   <plug>(easymotion-tl2)            | see |<plug>(easymotion-tl2)|
"                                     |
"   <plug>(easymotion-sn)             | see |<plug>(easymotion-sn)|
"   <plug>(easymotion-fn)             | see |<plug>(easymotion-fn)|
"   <plug>(easymotion-fn)             | see |<plug>(easymotion-fn)|
"   <plug>(easymotion-bd-fn)          | see |<plug>(easymotion-sn)|
"   <plug>(easymotion-tn)             | see |<plug>(easymotion-tn)|
"   <plug>(easymotion-tn)             | see |<plug>(easymotion-tn)|
"   <plug>(easymotion-bd-tn)          | see |<plug>(easymotion-bd-tn)|
"                                     |
"   <plug>(easymotion-sln)            | see |<plug>(easymotion-sln)|
"   <plug>(easymotion-fln)            | see |<plug>(easymotion-fln)|
"   <plug>(easymotion-fln)            | see |<plug>(easymotion-fln)|
"   <plug>(easymotion-bd-fln)         | see |<plug>(easymotion-sln)|
"   <plug>(easymotion-tln)            | see |<plug>(easymotion-tln)|
"   <plug>(easymotion-tln)            | see |<plug>(easymotion-tln)|
"   <plug>(easymotion-bd-tln)         | see |<plug>(easymotion-bd-tln)|
"
"   over window motion                | (no assignment by default)
"   ----------------------------------|---------------------------------
"   <plug>(easymotion-overwin-f)      | see |<plug>(easymotion-overwin-f)|
"   <plug>(easymotion-overwin-f2)     | see |<plug>(easymotion-overwin-f2)|
"   <plug>(easymotion-overwin-line)   | see |<plug>(easymotion-overwin-line)|
"   <plug>(easymotion-overwin-w)      | see |<plug>(easymotion-overwin-w)|
"
"-----------------------------------------------------------------------------
"}}}

   " keep cursor colum when jk motion
   let g:easymotion_startofline = 0
   let g:easymotion_force_csapprox = 1

 "}}} _vim-easymotion
 " columnmove {{{

   "plug 'machakann/vim-columnmove', {'on': ['<plug>(columnmove-']}

   "let g:columnmove_no_default_key_mappings = 1

   "nmap sf <plug>(columnmove-f)
   "nmap st <plug>(columnmove-t)
   "nmap sf <plug>(columnmove-f)
   "nmap st <plug>(columnmove-t)
   "nmap s; <plug>(columnmove-;)
   "nmap s, <plug>(columnmove-,)

   "nmap sw <plug>(columnmove-w)
   "nmap sb <plug>(columnmove-b)
   "nmap se <plug>(columnmove-e)
   "nmap sge <plug>(columnmove-ge)

   "nmap sw <plug>(columnmove-w)
   "nmap sb <plug>(columnmove-b)
   "nmap se <plug>(columnmove-e)
   "nmap sge <plug>(columnmove-ge)

 "}}}
 " vim-skipit {{{

   "use <c-l>l to skip ahead forward in insert mode
   call dein#add( 'habamax/vim-skipit', {
         \ 'on_map':
         \ [
         \   ['i' , '<plug>skipitforward'], ['i' , '<plug>skipallforward'],
         \   ['i' , '<plug>skipitback'],    ['i' , '<plug>skipallback']
         \ ]
         \ })
   imap <c-s>j <plug>skipitforward
   imap <c-s>l <plug>skipallforward
   imap <c-s>k <plug>skipitback
   imap <c-s>h <plug>skipallback

 "}}} _vim-skipit
 " patternjump {{{

   call dein#add( 'machakann/vim-patternjump', {'on_map': ['<plug>(patternjump-']} )
   let g:patternjump_no_default_key_mappings = 1
   map <c-s>l <plug>(patternjump-forward)
   map <c-s>h <plug>(patternjump-backward)

  "m-h, m=l mappings
  let s:patternjump_patterns = {
       \ '_' : {
       \   'i' : {
       \     'head' : ['^\s*\zs\s', ',', ')', ']', '}'],
       \     'tail' : ['\<\h\k*\>', '.$'],
       \     },
       \   'n' : {
       \     'head' : ['^\s*\zs\s', '\<\h\k*\>', '.$'],
       \     },
       \   'x' : {
       \     'tail' : ['^\s*\zs\s', '\<\h\k*\>', '.$'],
       \     },
       \   'o' : {
       \     'forward'  : {'tail_inclusive' : ['\<\h\k*\>']},
       \     'backward' : {'head_inclusive' : ['\<\h\k*\>']},
       \     },
       \   },
       \ '*' : {
       \   'c' : {
       \     'head' : ['^', ' ', '/', '[a-z]', ',', ')', ']', '}', '$'],
       \     },
       \   },
       \ }

 "}}}
 " tasklist.vim {{{

   call dein#add( 'vim-scripts/tasklist.vim', {'on_cmd':  ['tasklist']} )
   nnoremap <leader>tl :tasklist<cr>

 "}}} _tasklist.vim
 " tagbar {{{

   call dein#add( 'majutsushi/tagbar', {'on_cmd':  [ 'tagbar', 'tagbartoggle', ] } )
   nnoremap <silent> <leader>tb :tagbartoggle<cr>


 "}}}
 " accelerated-jk {{{

   "plug 'rhysd/accelerated-jk'
   "nmap j <plug>(accelerated_jk_gj)
   "nmap k <plug>(accelerated_jk_gk)
   "nmap j <plug>(accelerated_jk_gj_position)
   "nmap k <plug>(accelerated_jk_gk_position)

 "}}} _accelerated-jk

 " history
 " undotree {{{

   call dein#add( 'mbbill/undotree', {'on_cmd': ['undotreeshow', 'undotreefocus', 'undotreetoggle']} )

   let g:undotree_windowlayout = 2
   nnoremap <leader>ut :undotreetoggle<cr>
   nnoremap <leader>us :undotreeshow<cr>


 "}}} _undotree

 " buffers
 " vim-bufsurf {{{

 call dein#add( 'ton/vim-bufsurf') ", {'on_cmd': ['bufsurfback', 'bufsurfforward', 'bufsurflist']} )
 nnoremap ]h :bufsurfforward<cr>
 nnoremap [h :bufsurfback<cr>
 nnoremap cob :bufsurflist<cr>

 "}}} _vim-bufsurf

 " vim_drawer {{{
   call dein#add('samuelsimoes/vim-drawer', {'on_cmd': ['vimdrawer']} )
   let g:vim_drawer_spaces = [
         \["model", "app"],
         \["controller", "http\/controllers"],
         \["view", "\.html\.erb$|\.blade\.php$"],
         \["asset", "\.[js|css]$"],
         \["term", "^term"]
         \]
   nnoremap <c-w><space> :vimdrawer<cr>
 "}}} _vim-drawer
 "{{{ vim-ctrlspace
 call dein#add( 'szw/vim-ctrlspace', {'on_cmd': ['ctrlspace']} )

   if executable("ag")
     let g:ctrlspace_glob_command = 'ag -l --nocolor -g ""'
   endif

   nnoremap <c-space> :ctrlspace<cr>
   autocmd filetype ctrlspace call s:ctrlspace_settings()
   function! s:ctrlspace_settings()
     " enable navigation with control-j and control-k in insert mode
     imap <buffer> <c-j>   :call <sid>move_selection_bar("down")
     imap <buffer> <c-k>   :call <sid>move_selection_bar("up")
   endfunction

   "let g:ctrlspace_use_tabline = 0

 "}}} _vim-ctrlspace
 " zoomwintab.vim {{{

   call dein#add( 'troydm/zoomwintab.vim', {'on_cmd': ['zoomwintabtoggle']} )

   let g:zoomwintab_remap = 0
   " zoom with <meta-o> in any mode
   nnoremap <silent> <c-w><c-o> :zoomwintabtoggle<cr>
   inoremap <silent> <c-w><c-o> <c-\><c-n>:zoomwintabtoggle<cr>a
   vnoremap <silent> <c-w><c-o> <c-\><c-n>:zoomwintabtoggle<cr>gv

 "}}} _zoomwintab.vim

 " finder
 " gtfo {{{

   call dein#add( 'justinmk/vim-gtfo', {'on_map': ['gof', 'got', 'gof', 'got']} )
   let g:gtfo#terminals = { 'mac' : 'iterm' }
   nnoremap <silent> gof :<c-u>call gtfo#open#file("%:p")<cr>
   nnoremap <silent> got :<c-u>call gtfo#open#term("%:p:h", "")<cr>
   nnoremap <silent> gof :<c-u>call gtfo#open#file(getcwd())<cr>
   nnoremap <silent> got :<c-u>call gtfo#open#term(getcwd(), "")<cr>

 "}}}

 " tmux
 " tmux-navigator {{{

     call dein#add( 'christoomey/vim-tmux-navigator' ,
           \ {'on_event': 'vimenter', 'on_if': "exists('$tmux')"}
           \ )

     let g:tmux_navigator_no_mappings = 1
     nnoremap <silent> <c-h> :tmuxnavigateleft<cr>
     nnoremap <silent> <c-j> :tmuxnavigatedown<cr>
     nnoremap <silent> <c-k> :tmuxnavigateup<cr>
     nnoremap <silent> <c-l> :tmuxnavigateright<cr>
     nnoremap <silent> <c-\> :tmuxnavigateprevious<cr>

 "}}}

 " terminal
 " nvimux {{{
    call dein#add('hkupty/nvimux',
          \ {'on_event': 'vimenter', 'on_if': 'has("nvim")'})
    let g:nvimux_prefix='<c-cr>'
    "call dein#add('hkupty/nvimux')
 "}}} _nvimux
 " neoterm {{{

 call dein#add( 'kassio/neoterm',
       \ {
       \ 'on_func': [ 'neoterm#test#libs#add', 'neoterm#repl#set'],
       \ 'on_cmd':
       \   [
       \     't',
       \     'tnew',
       \     'tmap',
       \     'tpos',
       \     'ttestsetterm',
       \     'ttestlib',
       \     'ttestclearstatus',
       \     'treplsetterm',
       \     'replsend',
       \     'replsendfile',
       \     'topen',
       \     'tclose',
       \     'ttoggle'
       \   ]
       \ }
       \)

   let g:neoterm_clear_cmd = "clear; printf '=%.0s' {1..80}; clear"
   let g:neoterm_position = 'vertical'
   let g:neoterm_automap_keys = '<leader>tt'

   nnoremap <silent> <f9> :call neoterm#repl#line()<cr>
   vnoremap <silent> <f9> :call neoterm#repl#selection()<cr>

   " " todo fix these mappings were disabled find alternatives
   " " run set test lib
   " nnoremap <silent> <leader>rt :call neoterm#test#run('all')<cr>
   " nnoremap <silent> <leader>rf :call neoterm#test#run('file')<cr>
   " nnoremap <silent> <leader>rn :call neoterm#test#run('current')<cr>
   " nnoremap <silent> <leader>rr :call neoterm#test#rerun()<cr>

   " " useful maps
   " " closes the all terminal buffers
   " nnoremap <silent> <leader>tc :call neoterm#close_all()<cr>
   " " clear terminal
   " nnoremap <silent> <leader>tl :call neoterm#clear()<cr>

 "}}} _neoterm

 " ----------------------------------------------------------------------------
 " folds {{{
 " ----------------------------------------------------------------------------

 " fastfold {{{

   call dein#add( 'konfekt/fastfold' )
   "update folds manually using zuz
   let g:fastfold_savehook = 0

 "}}} _fastfold

 " vim-foldfocus {{{

   call dein#add( 'vasconcelloslf/vim-foldfocus', {'on_func': ['foldfocus']} )
   nnoremap <leader>z<cr> :call foldfocus('vnew')<cr>
   nnoremap <leader>zz<cr>  :call foldfocus('e')<cr>

 "}}}} _vim-foldfocus

 " volumes/home/.config/nvim/plugged/foldsearches.vim {{{


   call dein#add( '/volumes/home/.config/nvim/plugged/foldsearches.vim' )

 "}}} _volumes/home/.config/nvim/plugged/foldsearches.vim

 " searchfold.vim {{{

   call dein#add( 'khalidchawtany/searchfold.vim' , {'on_map':  ['<plug>searchfold']} )

   " search and then fold the search term containig lines using <leader>z
   " or the the inverse using <leader>iz or restore original fold using <leader>z
   nmap <leader>zs   <plug>searchfoldnormal
   nmap <leader>zi   <plug>searchfoldinverse
   nmap <leader>ze   <plug>searchfoldrestore
   nmap <leader>zw   <plug>searchfoldcurrentword

 "}}} _searchfold.vim

 " foldsearch {{{

  call dein#add( 'khalidchawtany/foldsearch',
       \ { 'on_cmd': ['fw', 'fs', 'fp', 'fs', 'fl', 'fc', 'fi', 'fd', 'fe']} )
         " \ [
         " \ '<leader>fs', '<leader>fw', '<leader>fl', '<leader>fs',
         " \ '<leader>fi', '<leader>fd', '<leader>fe'
         " \ ]

 "}}} _foldsearch


 "}}}
 " ----------------------------------------------------------------------------
 "database {{{
 " ----------------------------------------------------------------------------

 " dbext.vim {{{

   call dein#add( 'vim-scripts/dbext.vim' )
   let g:dbext_default_profile_mysql_local = 'type=mysql:user=root:passwd=root:dbname=younesdb:extra=-t'

 "}}} _dbext.vim

 " pipe-mysql.vim {{{
   call dein#add( 'nlknguyen/pipe-mysql.vim' )
 "}}} _pipe-mysql.vim

 "}}}
 " ----------------------------------------------------------------------------
 " neovim-qt {{{
   call dein#add( 'equalsraf/neovim-gui-shim' )
 " }}}
 " ----------------------------------------------------------------------------
 " nyaovim {{{
 " ----------------------------------------------------------------------------
 if exists('g:nyaovim_version')
   call dein#add( 'rhysd/nyaovim-popup-tooltip' )
   call dein#add( 'rhysd/nyaovim-mini-browser' )
   call dein#add( 'rhysd/nyaovim-markdown-preview' )
 endif
"}}}
 " ----------------------------------------------------------------------------
 " themeing {{{
 " ----------------------------------------------------------------------------

 " vim-startify {{{
  call dein#add( 'mhinz/vim-startify' )
  nnoremap <f1> :startify<cr>
  let g:startify_list_order = ['files', 'dir', 'bookmarks', 'sessions']
  let g:startify_files_number = 5

  "make bookmarks for fast nav
  let g:startify_bookmarks = [ {'c': '~/.vimrc'}, '~/.zshrc' ]
  let g:startify_session_dir = '~/.config/nvim/.cache/startify/session'

  let g:startify_custom_header = [] "remove the cow
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

   call dein#add( 'junegunn/goyo.vim',      { 'on_cmd': 'goyo'} )

   autocmd! user goyoenter limelight
   autocmd! user goyoleave limelight!

 "}}} _goyo.vim
 " limelight.vim {{{

   call dein#add( 'junegunn/limelight.vim', { 'on_cmd': 'limelight'} )
   let g:limelight_conceal_guifg="#c2b294"

 "}}} _limelight.vim
 " vim-lambdify {{{

 "call dein#add( 'calebsmith/vim-lambdify', {'on_ft': ['javascript']} )
 call dein#add( 'calebsmith/vim-lambdify' )

 "}}} _vim-lambdify
 " vim-css-color {{{

   "call dein#add( 'ap/vim-css-color',            { 'on_ft':['css','scss','sass','less','styl']} )
   call dein#add( 'ap/vim-css-color' )
   au bufwinenter *.vim call css_color#init('hex', '', 'vimhiguirgb,vimcomment,vimlinecomment,vimstring')
   au bufwinenter *.blade.php call css_color#extend('htmlstring,htmlcommentpart,phpstringsingle')

 "}}} _vim-css-color
 "vim-stylus {{{
  "call dein#add('wavded/vim-stylus', {'on_ft': 'stylus'})
  call dein#add('wavded/vim-stylus')
  autocmd bufnewfile,bufread *.styl setlocal filetype=stylus
 "}}}_vim-stylus
 " vim-better-whitespace {{{

   call dein#add( 'ntpeters/vim-better-whitespace' )
   let g:better_whitespace_filetypes_blacklist=['diff', 'qf', 'gitcommit', 'unite', 'vimfiler', 'help', 'leaderguide']
   autocmd filetype unite disablewhitespace
   autocmd filetype vimfiler disablewhitespace

 "}}}

 " vim-indentline {{{

    "call dein#add( 'yggdroot/indentline' )
    "let g:indentline_char = ''
    "" let g:indentline_color_term=""
    "" let g:indentline_color_gui=""
    "let g:indentline_filetype=[] "means all filetypes
    "let g:indentline_filetypeexclude=[]
    "let g:indentline_bufnameexclude=[]


 "}}}
 " rainbow parentheses {{{

   call dein#add( 'junegunn/rainbow_parentheses.vim', {'on_cmd':  ['rainbowparentheses']} )
   nnoremap <leader>xp :rainbowparentheses!!<cr>

 "}}}
   call dein#add( 'ryanoasis/vim-devicons' )
   call dein#add( 'reedes/vim-thematic' )


 "golden ratio
 " golden-ratio {{{

   call dein#add( 'roman/golden-ratio' )
   nnoremap cog :<c-u>goldenratiotoggle<cr>

 "}}} _golden-ratio
 " goldenview.vim {{{

   "plug 'zhaocai/goldenview.vim'
   "let g:goldenview__enable_default_mapping = 0

 "}}} _goldenview.vim
 " vim-eighties {{{

   "call dein#add( 'justincampbell/vim-eighties' )

 "}}} _vim-eighties

 " visual-split.vim {{{

   call dein#add( 'wellle/visual-split.vim' ) ", {'on': ['vsresize', 'vssplit', 'vssplitabove', 'vssplitbelow']}

 "}}} _visual-split.vim

   " plug 'tpope/vim-flagship'
 " lightline {{{
   call dein#add( 'itchyny/lightline.vim' )


         "\   'fileformat': 'lightlinefileformat',
         "\   'filetype': 'lightlinefiletype',

   let g:lightline = {
         \ 'active': {
         \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
         \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
         \ },
         \ 'component_function': {
         \   'fugitive': 'lightlinefugitive',
         \   'filename': 'lightlinefilename',
         \   'filetype': 'myfiletype',
         \   'fileformat': 'myfileformat',
         \   'fileencoding': 'lightlinefileencoding',
         \   'mode': 'lightlinemode',
         \ },
         \ 'component_type': {
         \   'syntastic': 'error',
         \ },
         \ 'subseparator': { 'left': '', 'right': '' }
         \ }

         "\ 'component_expand': {
         "\   'syntastic': 'syntasticstatuslineflag',
         "\ },
        function! myfiletype()
          return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . webdeviconsgetfiletypesymbol() . "\u00a0" : 'no ft') : ''
        endfunction

        function! myfileformat()
          "return winwidth(0) > 70 ? (&fileformat . ' ' . webdeviconsgetfileformatsymbol()) : ''
          let fileformat = ""

          if &fileformat == "dos"
            let fileformat = ""
          elseif &fileformat == "unix"
              "let fileformat = ""
              let fileformat = ""
          elseif &fileformat == "mac"
            let fileformat = ""
          endif

           "temporary (hopefully) fix for glyph issues in gvim (proper fix is with the
           "actual font patcher)
          let artifactfix = "\u00a0"
          let tabtext = ""
          if(tabpagenr('$')>1)
            let tabtext = tabpagenr('$') . "   " . ""
          endif
          "call system("set_iterm_badge_number neovim_tabcount ".tabpagenr('$'))

          return  tabtext . artifactfix . fileformat
          "return fileformat
        endfunction

   call dein#add( 'shinchu/lightline-gruvbox.vim' )
   call dein#add( 'khalidchawtany/lightline-material.vim' )
   "let g:lightline.colorscheme = 'gruvbox'
   "let g:lightline.colorscheme = 'wombat'
   let g:lightline.colorscheme = 'material'

   function! lightlinemodified()
     return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
   endfunction

   function! lightlinereadonly()
     return &ft !~? 'help' && &readonly ? '' : ''
   endfunction

   function! lightlinefilename()
     let fname = expand('%:t')
     if fname == 'zsh'
       return "  "
     endif
     return fname == '__tagbar__' ? g:lightline.fname :
           \ fname =~ '__gundo\|nerd_tree' ? '' :
           \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
           \ &ft == 'unite' ? unite#get_status_string() :
           \ &ft == 'vimshell' ? vimshell#get_status_string() :
           \ ('' != lightlinereadonly() ? lightlinereadonly() . ' ' : '') .
           \ ('' != fname ? fname : '[no name]') .
           \ ('' != lightlinemodified() ? ' ' . lightlinemodified() : '')
   endfunction

   function! lightlinefugitive()
     try
       if expand('%:t') !~? 'tagbar\|gundo\|nerd' && &ft !~? 'vimfiler' && exists('*fugitive#head')
         let mark = ' '  " edit here for cool mark     
         let _ = fugitive#head()
         return strlen(_) ? mark._ : ''
       endif
     catch
     endtry
     return ''
   endfunction

   function! lightlinefileformat()
     return winwidth(0) > 70 ? &fileformat : ''
   endfunction

   function! lightlinefiletype()
     return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
   endfunction

   function! lightlinefileencoding()
     return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
   endfunction

   function! lightlinemode()
     let fname = expand('%:t')
     return fname == '__tagbar__' ? 'tagbar' :
           \ fname == '__gundo__' ? 'gundo' :
           \ fname == '__gundo_preview__' ? 'gundo preview' :
           \ &ft == 'unite' ? 'unite' :
           \ &ft == 'vimfiler' ? 'vimfiler' :
           \ &ft == 'vimshell' ? 'vimshell' :
           \ winwidth(0) > 60 ? lightline#mode() : ''
   endfunction

   let g:tagbar_status_func = 'tagbarstatusfunc'

   function! tagbarstatusfunc(current, sort, fname, ...) abort
     let g:lightline.fname = a:fname
     return lightline#statusline(0)
   endfunction

   augroup autosyntastic
     autocmd!
     autocmd bufwritepost *.c,*.cpp call s:syntastic()
   augroup end
   function! s:syntastic()
     syntasticcheck
     call lightline#update()
   endfunction

   let g:unite_force_overwrite_statusline = 0
   let g:vimfiler_force_overwrite_statusline = 0
   let g:vimshell_force_overwrite_statusline = 0


 "}}}
   " plug 'ap/vim-buftabline'

 "colorschemes
   call dein#add( 'mswift42/vim-themes' )
   call dein#add( 'tomasr/molokai' )
   call dein#add('kristijanhusak/vim-hybrid-material')
   call dein#add('jdkanani/vim-material-theme')
   call dein#add('wutzara/vim-materialtheme')
   call dein#add('joshdick/onedark.vim')
   call dein#add( 'kabbamine/yowish.vim' )
   call dein#add( 'romainl/apprentice' )
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
 " presenters :) {{{
 " ----------------------------------------------------------------------------

 " vim-follow-my-lead {{{

   ",fml
   call dein#add( 'ktonga/vim-follow-my-lead', {'on_map': ['<plug>(followmylead)']} )
   nnoremap <leader>fml <plug>(followmylead)
   let g:fml_all_sources=1 "1 for all sources, 0(default) for $myvimrc.

 "}}} _vim-follow-my-lead
 " vim-leader-guide {{{
    call dein#add('hecal3/vim-leader-guide')

    call leaderguide#register_prefix_descriptions("<space>", "g:lmap")
    nnoremap <silent> <leader> :<c-u>leaderguide '<space>'<cr>
    vnoremap <silent> <leader> :<c-u>leaderguidevisual '<space>'<cr>

    "let g:leaderguide_run_map_on_popup = 0
    " define prefix dictionary
    let g:lmap =  {}
    " second level dictionaries:
    let g:lmap.e = { 'name' : 'edit' }
    let g:lmap.f = { 'name' : 'file menu' }
    let g:lmap.o = { 'name' : 'open stuff' }
    let g:lmap.f.m = { 'name' : 'manager' }
    " 'name' is a special field. it will define the name of the group.
    " leader-f is the "file menu" group.
    " unnamed groups will show a default string

    "no relative line numbers in ledare guide
    au filetype leaderguide set norelativenumber

    let g:leaderguide_sort_horizontal=0

    " create new menus not based on existing mappings:
    let g:lmap.g = {
          \'name' : 'git menu',
          \'m':  ['magit',      'magit'],
          \'l':  ['gv',         'log'],
          \'s':  ['gstatus',    'status'],
          \'c':  ['gcommit',    'commit'],
          \'p':  ['gpull',      'pull'],
          \'u':  ['gpush',      'push'],
          \'r':  ['gread',      'read'],
          \'d':
          \     {
          \        'name' : 'diff',
          \        'v': ['gvdiff', 'v-diff'],
          \        's': ['gdiff', 's-diff'],
          \    },
          \'w':  ['gwrite',     'write'],
          \}

    "allow diff has it is own menu
    "let g:lmap.g.d =
          "\ { 'name' : 'diff',
          "\'v': ['gvdiff', 'v-diff'],
          "\'s': ['gdiff', 's-diff'],
          "\ }

    " if you use nerdcommenter:
    let g:lmap.c = { 'name' : 'comments' }
    " define some descriptions
    let g:lmap.c.c = ['call feedkeys("\<plug>nerdcommentercomment")','comment']
    let g:lmap.c[' '] = ['call feedkeys("\<plug>nerdcommentertoggle")','toggle']
    " the descriptions for other mappings defined by nerdcommenter, will default
    " to their respective commands.

    function! s:my_displayfunc()
      let g:leaderguide#displayname =
            \ substitute(g:leaderguide#displayname, '\c<cr>$', '', '')
      let g:leaderguide#displayname =
            \ substitute(g:leaderguide#displayname, '^<plug>', '', '')
    endfunction
    let g:leaderguide_displayfunc = [function("s:my_displayfunc")]

 " _vim-leader-guide }}}

 "}}}
 " ----------------------------------------------------------------------------

" dein end{{{
" required:
call dein#end()

" required:
filetype plugin indent on

" if you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"end dein scripts-------------------------
"}}} _dein end
"}}}
" ============================================================================
" commands {{{
" ============================================================================
  command! syntaxloadedfrom :echo join(map(map(split(&runtimepath, ','), "split(v:val, '/') + ['syntax']"), "'/' . join(v:val, '/')"), "\n")<cr>

  command! -nargs=1 ilist call list("i", 1, 0, <f-args>)
  command! -nargs=1 dlist call list("d", 1, 0, <f-args>)


  command! diffsplits :call diffme()<cr>

  command! -nargs=0 reg call reg()

  command! -nargs=? -complete=buffer -bang bufonly
      \ :call bufonly('<args>', '<bang>')

  " convenient command to see the difference between the current buffer and the
  " file it was loaded from, thus the changes you made.  only define it when not
  " defined already.
  command! difforig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis

  command! -nargs=? -complete=help help call openhelpincurrentwindow(<q-args>)

  command! cclear cclose <bar> call setqflist([])
  nnoremap co<bs> :cclear<cr>

  command! -range createfoldablecomment <line1>,<line2>call createfoldablecommentfunction()

" }}}
" ============================================================================
" mappings {{{
" ============================================================================

  " utils {{{
  "===============================================================================
  "
  nnoremap <leader>ss :echo "hi<" . synidattr(synid(line("."),col("."),1),"name") . '> trans<' . synidattr(synid(line("."),col("."),0),"name") . "> lo<" . synidattr(synidtrans(synid(line("."),col("."),1)),"name") . ">"<cr>

  "shift-enter is like ]<space>
  inoremap <silent> <s-cr> <esc>m`o<esc>``a

  " toggle the last search pattern register between the last two search patterns
  function! s:togglesearchpattern()
    let next_search_pattern_index = -1
    if @/ ==# histget('search', -1)
      let next_search_pattern_index = -2
    endif
    let @/ = histget('search', next_search_pattern_index)
  endfunction
  nnoremap <silent> co/ :<c-u>call <sid>togglesearchpattern()<cr>


    nnoremap <leader>ha :call highlightallofword(1)<cr>
    nnoremap <leader>ha :call highlightallofword(0)<cr>

    nnoremap <silent> <bs> :nohlsearch \| redraw! \| diffupdate \| normal \<plug>(clever-f-reset) \| normal \<plug>(fastfoldupdate) \| echo ""<cr>

    nnoremap <f12> :call togglemousefunction()<cr>

    vnoremap . :norm.<cr>

    " { and } skip over closed folds
    nnoremap <expr> } foldclosed(search('^$', 'wn')) == -1 ? "}" : "}j}"
    nnoremap <expr> { foldclosed(search('^$', 'wnb')) == -1 ? "{" : "{k{"

    " jump to next/previous merge conflict marker
    nnoremap <silent> ]> /\v^(\<\|\=\|\>){7}([^=].+)?$<cr>
    nnoremap <silent> [> ?\v^(\<\|\=\|\>){7}([^=].+)\?$<cr>

    " move visual lines
    nmap <silent> j gj
    nmap <silent> k gk

    noremap  h ^
    vnoremap h ^
    onoremap h ^
    noremap  l $
    vnoremap l g_
    onoremap l $


    "nnoremap ; : "ambicmd does remap this properly
    nnoremap : ;
    vnoremap ; :
    vnoremap : ;

    "make completion more comfortable
    inoremap <c-j> <c-n>
    inoremap <c-k> <c-p>

    inoremap <c-u> <c-g>u<c-u>

    if !exists('$tmux')
      nnoremap <silent> <c-h> <c-w><c-h>
      nnoremap <silent> <c-j> <c-w><c-j>
      nnoremap <silent> <c-k> <c-w><c-k>
      nnoremap <silent> <c-l> <c-w><c-l>
    endif


    "" highlight todo markers
    "hi todo cterm=bold ctermfg=231 ctermbg=232 gui=bold guifg=#ffffff guibg=bg
    "match todo '\v^(\<|\=|\>){7}([^=].+)?$'
    "match todo '\v^(\<|\=|\>){7}([^=].+)?$'

  "}}}

  " folds {{{
  "===============================================================================

    " close all folds except this
    nnoremap z<space> zmzv
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

    autocmd filetype neosnippet,cs call togglefoldmarker()
  "}}}

  " terminal {{{
  "===============================================================================
  if has('nvim')
    tnoremap <c-o> <c-\><c-n>
  endif
    "tnoremap <expr> <esc> &filetype == 'fzf' ? "\<esc>" : "\<c-\>\<c-n>"
  "}}}

  " window & buffer {{{
  "===============================================================================

  " shrink to fit number of lines
  nmap <silent> <c-w>s :execute ":resize " . line('$')<cr>

  " maximize current split
  nnoremap <c-w>m <c-w>_<c-w><bar>

  " buffer deletion commands {{{

    nnoremap <c-w>o :bufonly<cr>

    nnoremap  úwa :bufdo execute ":bw"<cr>
    nnoremap  <c-;>wa :bufdo execute ":bw"<cr>
    nnoremap  úúwa :bufdo execute ":bw!"<cr>
    nnoremap  <c-;><c-;>wa :bufdo execute ":bw!"<cr>
    "nnoremap  úww :bw<cr>
    "nnoremap  <c-;>ww :bw<cr>
    nmap úww <plug>bw
    nmap <c-;>ww <plug>bw

    nnoremap  úúww :bw!<cr>
    nnoremap  <c-;><c-;>ww :bw!<cr>
  "}}}


  "}}}

  " text editting {{{
  "===============================================================================
  "nnoremap <leader>b :center 80<cr>hhv0r#a<space><esc>40a#<esc>d80<bar>yppvr#kk.

  "todo: conflicts with script-ease
  command! splitline :normal! i<cr><esc>,ss<cr>
  nnoremap <c-g>k :call preserve('splitline')<cr>
  nnoremap <c-g><c-k> :call preserve('splitline')<cr>

  " put empty line around (requires unimpaired)
  nnoremap \<space> :normal [ ] <cr>

  " suck from below/above
  nnoremap <c-g>j i<esc>+y$ddgi<c-r>0<esc>
  nnoremap <c-g>k i<esc>-y$ddgi<c-r>0<esc>

  " uppercase from insert mode while you are at the end of a word
  inoremap <c-u> <esc>mzguiw`za

  "remove ^m from a file
  nnoremap <leader>e<cr> :e ++ff=dos

  "retab file
  nnoremap <leader>e<tab> :retab<cr>

  "strip whitespace
  nnoremap <leader>e<space> :call stripwhitespace()<cr>

  " underline {{{

    " underline the current line
    nnoremap <leader>u= :t.\|s/./=<cr>:nohls<cr>
    nnoremap <leader>u- :t.\|s/./-<cr>:nohls<cr>
    nnoremap <leader>u~ :t.\|s/./\\~<cr>:nohls<cr>

    "only underline from h to l
    nnoremap <leader>u= "zyy"zp<c-v>$r=
    nnoremap <leader>u- "zyy"zp<c-v>$r-
    nnoremap <leader>u~ "zyy"zp<c-v>$r~

  "}}}

  " better copy/cut/paste {{{
   noremap <leader>d "_d
   noremap <leader>y "+y
   noremap <leader>p "+p
  "}}}

  " indentation {{{
    " indent visually without coming back to normal mode
    vmap > >gv
    vmap < <gv
    nmap <leader>ii :call indenttonextbraceinlineabove()<cr>
  "}}}

  " move visual block
  vnoremap <c-j> :m '>+1<cr>gv=gv
  vnoremap <c-k> :m '<-2<cr>gv=gv

  " select last matched item
  nnoremap <c-g>/ //e<enter>v??<enter>
  nnoremap <c-g>sl //e<enter>v??<enter>

  " reselect the text you just entered
  nnoremap gv `[v`]
  nnoremap <c-g>si `[v`]
  "}}}

  " writting and quitting {{{
  "===============================================================================

  nnoremap <leader>qq :q<cr>
  nnoremap <leader>qa :qall<cr>
  nnoremap <leader>wq :wq<cr>
  nnoremap <leader>ww :w<cr>
  nnoremap <leader>w<leader> :update<cr>
  nnoremap <leader>wu :update<cr>
  nnoremap <leader>wa :wall<cr>
  nnoremap <leader>`` :qa!<cr>

  " save as root
  noremap <leader>w :w !sudo tee % > /dev/null<cr>

  "discard changes
  nnoremap <leader>e<bs> :e! \| echo 'changes discarded'<cr>
  nnoremap <c-g>e<bs> :e! \| echo 'changes discarded'<cr>
  "}}}

  " path & file {{{

  autocmd filetype netrw nnoremap q :quit<cr>

  "cd into:
  "current buffer file dir
  nnoremap cdf :lcd %:p:h<cr>:pwd<cr>
  "current working dir
  nnoremap cdc :lcd <c-r>=expand("%:h")<cr>/
  "git dir root
  nnoremap cdg :lcd <c-r>=findgitdirorroot()<cr><cr>

  "open current directory in finder
  "nnoremap gof :silent !open .<cr>

  nnoremap ycd :!mkdir -p %:p:h<cr>

  "go to alternate file
  nnoremap go <c-^>

  " edit in the path of current file
  nnoremap <leader>ef :e <c-r>=escape(expand('%:p:h'), ' ').'/'<cr>
  nnoremap <leader>ep :e <c-r>=escape(getcwd(), ' ').'/'<cr>

  " <c-y>f copy the full path of the current file to the clipboard
  nnoremap <silent> ycf :let @+=expand("%:p")<cr>:echo "copied current file
        \ path '".expand("%:p")."' to clipboard"<cr>

  " rename current buffers file
  nnoremap <leader>rn :call renamefile()<cr>

  " edit todo list for project
  nnoremap <leader>tp :e <c-r>=findgitdirorroot()<cr>/todo.org<cr>

  " edit global todo list
  nnoremap <leader>to :e ~/org/todo.org<cr>

  " edit the vimrc (init.vim) file
  nnoremap <silent> <leader>ev :e $myvimrc<cr>

  " evaluate selected vimscript | line | whole vimrc (init.vim)
  vnoremap <leader>s; "vy:@v<cr>
  nnoremap <leader>s; "vyy:@v<cr>
  nnoremap <silent> <leader>sv :unlet g:vimrc_sourced<cr>:so $myvimrc<cr>
  "}}}

  " toggles {{{
  "===============================================================================


  "toggle tabline
  nnoremap <silent> cot  :execute "set  showtabline=" . (&showtabline+2)%3<cr>

  "toggle showcmd
  nnoremap co: :set showcmd!<cr>
  nnoremap co; :set showcmd!<cr>

  "toggle laststatus (statusline | statusbar)
  nnoremap <silent> co<space> :execute "set laststatus=" . (&laststatus+2)%3<cr>


  nnoremap  coq :qfix<cr>
  command! qfix call qfixtoggle()
  function! qfixtoggle()
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

  " command-line mode key mappings {{{
  "===============================================================================

  cnoremap <c-a> <home>
  cnoremap <c-e> <end>
  cnoremap <c-j> <down>
  cnoremap <c-k> <up>
  cnoremap <c-h> <left>
  cnoremap <c-l> <right>
  cnoremap <c-g>p <c-\>egetcwd()<cr>
  cnoremap <c-g>f <c-r>=expand("%")<cr>


"}}}

  " languages {{{
  "===============================================================================

  " laravel
  nnoremap úlv :e ./app/views/<cr>
  nnoremap <c-;>lv :e ./app/views/<cr>
  nnoremap úlc :e ./app/views/partials/<cr>
  nnoremap <c-;>lc :e ./app/views/partials/<cr>
  nnoremap úlp :e ./public/<cr>
  nnoremap <c-;>lp :e ./public/<cr>

  " java
  "nnoremap  <leader>ej : exe "!cd " . shellescape(expand("%:h")) . " && javac " . expand ("%:t") . " && java " . expand("%:t:r")<cr>
  nnoremap  <leader>ej :w<cr>:exe "tab term cd " . shellescape(expand("%:h")) . " && javac " . expand ("%:t") . " && java " . expand("%:t:r")<cr><cr>

  " html
  au filetype html,blade inoremap <buffer> >>     ></<c-x><c-o><esc>%i
  au filetype html,blade inoremap <buffer> >><cr> ></<c-x><c-o><esc>%i<cr><esc>o

  "}}}

  nnoremap <silent> [i :call list("i", 0, 0)<cr>
  nnoremap <silent> ]i :call list("i", 0, 1)<cr>
  xnoremap <silent> [i :<c-u>call list("i", 1, 0)<cr>
  xnoremap <silent> ]i :<c-u>call list("i", 1, 1)<cr>
  nnoremap <silent> [d :call list("d", 0, 0)<cr>
  nnoremap <silent> ]d :call list("d", 0, 1)<cr>
  xnoremap <silent> [d :<c-u>call list("d", 1, 0)<cr>
  xnoremap <silent> ]d :<c-u>call list("d", 1, 1)<cr>

  "noremap <f4> :call diffme()<cr>

"}}}
" ============================================================================
" autocmd {{{
" ============================================================================

" jump back to last file of a specific type or path
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  autocmd bufleave *.css,*.less,*.scss normal! ms
  autocmd bufleave *.js,*.coffee       normal! mj
  autocmd bufleave *.html              normal! mh
  autocmd bufleave app/*.php           normal! mp
  autocmd bufleave */migrations/*      normal! mm
  autocmd bufleave */seeds/*           normal! md
  autocmd bufleave */controllers/*     normal! mc
  autocmd bufleave */test/*,*/spec/*   normal! mt
  autocmd bufleave */http/routes.*     normal! mr
  autocmd bufleave *.blade.php
        \ | if (expand("<afile>")) =~ "*layout.*"
        \ | execute 'normal! ml'
        \ | else
        \ | execute 'normal! mv'
        \ | endif


  "unless the file name has test in it mark it c for *.cs
  "if the file name has test in it mark it t for *.cs
  autocmd bufleave *.cs
        \ | if (expand("<afile>")) =~ ".*test.*"
        \ | execute 'normal! mt'
        \ | else
        \ | execute 'normal! mc'
        \ | endif


  " enable file type detection
  filetype on
  " treat .json files as .js
  autocmd bufnewfile,bufread *.json setfiletype json syntax=javascript
  " treat .md files as markdown
  autocmd bufnewfile,bufread *.md setlocal filetype=markdown
  " au bufnewfile,bufread *.blade.php


  au filetype blade
        \ let b:match_words ='<:>,<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'
        \ | let b:match_ignorecase = 1


  augroup ensure_directory_exists
    autocmd!
    autocmd bufnewfile * call s:ensuredirectoryexists()
  augroup end

  augroup global_settings
    au!
    au vimresized * :wincmd = " resize windows when vim is resized

    " return to the same line when file is reopened
    au bufreadpost *
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
  augroup end


  " "restore cursor, fold, and options on re-open.
  " au bufwinleave *.* mkview
  " au vimenter *.* silent loadview

  "only restore folds and cursor position
  set viewoptions="folds,cursor"

  au filetype qf call adjustwindowheight(3, 10)
  function! adjustwindowheight(minheight, maxheight)
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


  ""make cusrsorline visible only in the current window
  "augroup highlight_follows_focus
    "autocmd!
    "autocmd winenter * set cursorline
    "autocmd winleave * set nocursorline
  "augroup end

  "augroup highligh_follows_vim
    "autocmd!
    "autocmd focusgained * set cursorline
    "autocmd focuslost * set nocursorline
  "augroup end

  ""make numbers visible for current window only
  "augroup active_relative_number
    "au!
    "au bufenter * :setlocal number relativenumber
    "au winenter * :setlocal number relativenumber
    "au bufleave * :setlocal nonumber norelativenumber
    "au winleave * :setlocal nonumber norelativenumber
  "augroup end

  ""disable numbers in insert mode
  "augroup toggle_relative_number  " can be toggled normally with 'cor'
    "autocmd!
    "autocmd insertenter * :setlocal norelativenumber
    "autocmd insertleave * :setlocal relativenumber
  "augroup end

  ""open quickfix/locationlist on each relevant operatgion
  "augroup autoquickfix
    "autocmd!
    "autocmd quickfixcmdpost [^l]* cwindow
    "autocmd quickfixcmdpost    l* lwindow
  "augroup end


  "term {{{
  "enter insert mode on switch to term and on leave leave insert mode
  "------------------------------------------------------------------
  if has('nvim')
    augroup term_buf
      autocmd!
      "the following causes vimux to have an i inserted :(
      "autocmd bufwinenter term://*  call feedkeys('i')
      autocmd termopen * autocmd bufenter <buffer> startinsert
      autocmd! bufleave term://* stopinsert

      "prevent listing terminal buffers in ls command
      "autocmd filetype term set nobuflisted
      autocmd termopen * set nobuflisted
    augroup end
  endif
   "}}}




" }}}
" ============================================================================
" settings {{{
" ============================================================================

  "keep diffme function state
  let $diff_me=0

  " specify path to your uncrustify configuration file.
  let g:uncrustify_cfg_file_path =
        \ shellescape(fnamemodify('~/.uncrustify.cfg', ':p'))


set background=dark
"colorscheme molokai
colorscheme hybrid_reverse
"colorscheme material-theme
"colorscheme materialtheme

"set rulerformat to include line:col filename +|''
"set rulerformat=%<%(%p%%\ %)%l%<%(:%c\ %)%=%t%<\ %m
set rulerformat=%l:%<%c%=%p%%\ %r\ %m


" set background=light
" colorscheme gruvbox

" enhance command-line completion
set wildmenu
set wildmode=longest,list,full

" types of files to ignore when autocompleting things
set wildignore+=*.o,*.class,*.git,*.svn

" fuzzy finder: ignore stuff that can't be opened, and generated files
let g:fuzzy_ignore = "*.png;*.png;*.jpg;*.jpg;*.gif;*.gif;vendor/**;coverage/**;tmp/**;rdoc/**"

set grepprg=ag\ --nogroup\ --nocolor

set formatoptions-=t                  " stop autowrapping my code

" set ambiwidth=double                " don't this fucks airline

"don't autoselect first item in omnicomplete,show if only one item(for preview)
"set completeopt=longest,menuone,preview
set completeopt=noinsert,menuone,noselect

set pumheight=15                      " limit completion menu height

" when completing by tag, show the whole tag, not just the function name
set showfulltag

"**** do not use ****  ruins arrow keys & all esc based keys
" allow cursor keys in insert mode
"set esckeys

set nrformats-=octal

set backspace=indent,eol,start        " allow backspace in insert mode
"set gdefault                          " make g default for search confuses me :(
set magic                             " magic matching

set nolazyredraw

" set formatoptions+=j                " delete comment character when joining commented lines

"set these only at startup
if !exists('g:vimrc_sourced')
  set encoding=utf-8 nobomb
endif

set termencoding=utf-8
scriptencoding utf-8

if has('vim')
  " small tweaks
  set ttyfast                       " indicate a fast terminal connection
  set tf                            " improve redrawing for newer computers
endif

"how should i decide to take abackup
set backupcopy=auto

" centralize backups, swapfiles and undo history
if has('nvim')
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

set undofile                          " save undo's after file closes
"set undodir=$home/.vim/.cache/undo   " where to save undo histories
set undolevels=1000                   " how many undos
set undoreload=10000                  " number of lines to save for undo

" if available, store temporary files in shared memory
if isdirectory('/run/shm')
  let $tmpdir = '/run/shm'
elseif isdirectory('/dev/shm')
  let $tmpdir = '/dev/shm'
endif

set shell=/usr/local/bin/zsh

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

set tags=./tags,tags;$home            " help vim find my tags
set backupskip=/tmp/*,/private/tmp/*  " don't back up these
set autoread                          " read files on change

set fileformats+=mac

set binary
set noeol                             " don’t add empty newlines at file end

"set clipboard=unnamed,unnamedplus

" allow color schemes to do bright colors without forcing bold.
if &t_co == 8 && $term !~# '^linux'
  set t_co=16
endif


if &tabpagemax < 50
  set tabpagemax=50
endif

if !empty(&viminfo)
  set viminfo^=!
endif

set sessionoptions-=options

set noswapfile
"dont warn me about swap files existence
"set shortmess+=a

" set shortmess=ati                    " don’t show the intro message when starting vim

"prevent completion message flickers
set shortmess+=c


" respect modeline in files
set modeline
set modelines=4

" enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure

set number
set relativenumber


set autoindent
set smartindent
set tabstop=2
set expandtab
"todo: tpope sets smarttab
set nosmarttab

set shiftwidth=2
set shiftround                        " when at 3 spaces i hit >> go to 4 not 5

set guifont=sauce\ code\ powerline\ light:h18
set textwidth=80
set wrap                              " wrap long lines
set breakindent                       " proper indenting for long lines

set linebreak                         "don't linebreak in the middle of words

set printoptions=header:0,duplex:long,paper:letter

let &showbreak = '↳ '                 " add linebreak sign
set wrapscan                          " set the search scan to wrap lines

"allow these to move to next/prev line when at the last/first char
set whichwrap+=h,l,<,>,[,]


" show “invisible” characters
set listchars=tab:▸\ ,extends:❯,precedes:❮,trail:.,eol:¬,nbsp:×
" set listchars=tab:▸\ ,extends:❯,precedes:❮,trail:.,eol:¬,nbsp:␣
" set listchars=tab:•·,trail:·,extends:❯,precedes:❮,nbsp:×
set list

"set the fillchar of the inactive window to something i can see
set fillchars=stlnc:\-

" add ignorance of whitespace to diff
set diffopt+=iwhite
syntax on
set nocursorline "use iterm cursorline instead

set hlsearch
set ignorecase
set smartcase
set matchtime=2                       " time in decisecons to jump back from matching bracket
set incsearch                         " highlight dynamically as pattern is typed
set history=1000

"show the left side fold indicator
set foldcolumn=1
set foldmethod=marker
" these commands open folds
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo


" set a nicer foldtext function
"au bufenter,bufwinenter *.vim set foldtext=myfoldtext()
function! myfoldtext()
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

  let sub =  '<u+e729> ' . sub . "                                                                                                "
  "let sub = sub . "<u+e776> <u+e729> <u+f1be>  <u+f476> <u+f48c> <u+f432> <u+f458> <u+f261> <u+f41a>  <u+f205>  <u+f260>                                                                                                  "
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
"neovim handles esc keys as alt+key set this to solve the problem
set ttimeout ttimeoutlen=0

" show the filename in the window titlebar
set title "titlestring=

syntax on
set virtualedit=all
set mouse=                            " let the term control mouse selection
set hidden
set laststatus=2                      " force status line display
set showtabline=0                     " hide tabline
set noerrorbells visualbell t_vb=     " disable error bells
set nostartofline                     " don’t reset cursor to start of line when moving around
set ruler                             " show the cursor position
set showmode                          " show the current mode
set shortmess=ati                     " don’t show the intro message when starting vim

if !&scrolloff
  set scrolloff=3                       " keep cursor in screen by value
endif
if !&sidescrolloff
  set sidescrolloff=5
endif

"set cpoptions+=ces$                    " cw wrap w with $ instead of delete
set cpo+=n                             " draw color for lines that has number only

set showmode                          " show the current mode

if !exists('neovim_dot_app')
  set showcmd                           " makes os x slow, if lazy redraw set
endif

set display+=lastline

set mousehide                         " hide mouse while typing

set synmaxcol=200                     " max syntax highlight chars

set splitbelow                        " put horizontal splits below

set splitright                        " put vertical splits to the right

let g:netrw_liststyle=3               "make netrw look like nerdtree

highlight colorcolumn ctermbg=darkblue guibg=#e1340f guifg=#111111
call matchadd('colorcolumn', '\%81v', 100)

" use a blinking upright bar cursor in insert mode, a solid block in normal
" and a blinking underline in replace mode
  let &t_si = "\<esc>[5 q"
  let &t_sr = "\<esc>[3 q"
  let &t_ei = "\<esc>[2 q"


" }}}
" ============================================================================
" colors {{{
" ============================================================================
"#d35636
  "hi visual guibg=#fbbc05 guifg=#0f0f0f
  hi visual guibg=#d45438 guifg=white
  hi pmenusel guibg=#d45438 guifg=white

  hi foldcolumn guibg=#1d1f21 guifg=#373b41
  hi folded ctermfg=243 ctermbg=234 guifg=#707880 guibg=#151515

  hi nerdtreecurrentnode guibg=#b34826 guifg=white
  hi matchparen gui=underline ctermfg=234 ctermbg=60 guifg=#1d1f21 guibg=#d95d63

  set laststatus=0
  set nolist
  set foldlevelstart=2

  " vim-buftabline support
  hi! slidentifier guibg=#151515 guifg=#ffb700 gui=bold cterm=bold ctermbg=233i ctermfg=214
  hi! slcharacter guibg=#151515 guifg=#e6db74 ctermbg=233 ctermfg=227
  hi! sltype guibg=#151515 guifg=#66d9ae gui=bold cterm=bold ctermbg=233 ctermfg=81
  hi! link buftablinefill statusline
  hi! link buftablinecurrent slidentifier
  hi! link buftablineactive slcharacter
  hi! link buftablinehidden sltype

  "hi folded ctermfg=250 ctermbg=236 guifg=#b04a2f guibg=#232526
  "hi foldcolumn ctermfg=250 ctermbg=236 guifg=#465457 guibg=#232526
  hi folded ctermfg=250 ctermbg=236 guifg=#00f0ff guibg=#232526
  hi foldcolumn ctermfg=250 ctermbg=236 guifg=#00f0ff guibg=#232526

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

  "make the bright gray font black in terminal
  let g:terminal_color_7  = '#fbbc05'


  "multiedit highlight colors
  "this makes it faster too!
  hi! multieditregions guibg=#af1469
  hi! multieditfirstregion guibg=#ed3f6c

" }}}
" ============================================================================
" over_rides {{{
" ============================================================================
" align_operator {{{
call operator#user#define('align-left', 'op_command', 'call set_op_command("left")')
call operator#user#define('align-right', 'op_command', 'call set_op_command("right")')
call operator#user#define('align-center', 'op_command', 'call set_op_command("center")')

let s:op_command_command = ''

function! set_op_command(command)
  let s:op_command_command = a:command
endfunction

function! op_command(motion_wiseness)
  execute "'[,']" s:op_command_command
endfunction
"}}} _align

function! setprojectpath()"{{{
  lcd ~/development/projects/php/younesagha/younesagha
  cd ~/development/projects/php/younesagha/younesagha
  pwd
  set path+=public/**
endfunction

nnoremap <silent> <c-p><c-\> :call setprojectpath()<cr>"}}}

" function! neomake#makers#ft#cs#enabledmakers()"{{{
"   if neomake#utils#exists('mcs')
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


"      e ~/.config/nvim/dein/.dein/autoload/leaderguide.vim
"     cunmap <cr>
"     cunmap <space>
"      debug leaderguide ' '"
"nnoremap <leader>dd :silent! exe "cunmap <cr>" \| silent! exe "cunmap <space>" \| debug call leaderguide#start_by_prefix('0', ' ')<cr>
nnoremap <leader>dd :silent! nnoremap ; :<cr>:silent! cunmap <lt>cr><cr>:silent! cunmap <lt>space><cr>:debug call leaderguide#start_by_prefix('0', ' ')<cr>
