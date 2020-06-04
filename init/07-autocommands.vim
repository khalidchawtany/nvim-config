
"Return to previous tab on closing this one
function! s:PreviousTab_StoreState()
  let s:tab_current = tabpagenr()
  let s:tab_last = tabpagenr('$')
endfunction
function! s:PreviousTab_TabClosed()
  if s:tab_current > 1 && s:tab_current < s:tab_last
    exec 'tabp'
  endif
endfunction
autocmd TabEnter,TabLeave * call s:PreviousTab_StoreState()
autocmd TabClosed * call s:PreviousTab_TabClosed()

autocmd BufEnter *.php :syntax sync fromstart
"autocmd BufEnter *.php :syntax sync minlines=100

" Jump back to last file of a specific type or path
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" autocmd BufLeave *.css,*.less,*.scss mark S
" autocmd BufLeave *.js,*.coffee       mark J
" autocmd BufLeave *.html              mark H
" autocmd BufLeave app/*.php           mark P
" autocmd BufLeave */migrations/*      mark M
" autocmd BufLeave */seeds/*           mark D
" autocmd BufLeave */Controllers/*     mark C
" autocmd BufLeave */test/*,*/spec/*   mark T
" autocmd BufLeave */Http/routes.*     mark R
" autocmd BufLeave *.blade.php silent!
"       \ | if expand("<afile>") =~ "*layout.*"
"         \ | mark L
"         \ | else
"           \ | mark V
"           \ | endif

"Unless the file name has test in it mark it C for *.cs
"if the file name has test in it mark it T for *.cs
" autocmd BufLeave *.cs silent!
"       \ | if (expand("<afile>")) =~ ".*test.*"
"         \ | mark T
"         \ | else
"           \ | mark C
"           \ | endif

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

"augroup ensure_directory_exists
"autocmd!
"autocmd BufNewFile * call EnsureDirectoryExists()
"augroup END

augroup global_settings
  au!
  au VimResized * :wincmd = " resize windows when vim is resized
augroup END

"Only restore folds and cursor position
set viewoptions=cursor,folds

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

"Term {{{
"Enter insert mode on switch to term and on leave leave insert mode
"------------------------------------------------------------------
if has('nvim')
  augroup term_buf
    autocmd!
    "The following causes vimux to have an i inserted :(
    "autocmd BufWinEnter term://*  call feedkeys('i')
    autocmd TermOpen * autocmd BufEnter <buffer> startinsert
    autocmd! BufLeave term://* stopinsert

    "Prevent listing terminal buffers in ls command
    autocmd TermOpen * setlocal nobuflisted
          \| setlocal nonumber
          \| setlocal norelativenumber
          \| setlocal scrolloff=0
          \| setlocal sidescrolloff=0
  augroup END
endif
"}}}

 " Highlight yanked area
 augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 1000)
augroup END
