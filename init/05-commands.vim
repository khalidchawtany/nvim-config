
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


command! ProfileMe :profile start ~/Desktop/profile.log <bar> profile func * <bar> profile file *
command! ProfileStop :profile pause
