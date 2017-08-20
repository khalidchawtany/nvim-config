function! SetProjectPath(path)"{{{
  execute "lcd " a:path
  execute "cd "  a:path
  pwd
  set path+=public/**
endfunction

nnoremap <silent> <c-p><c-\>y :call SetProjectPath("~/Projects/PHP/younesagha/younesagha")<cr>
nnoremap <silent> <c-p><c-\>z :call SetProjectPath("~/Projects/C\\#/SuperMarket")<cr>
nnoremap <silent> <c-p><c-\>g :call SetProjectPath("~/Sites/gigant//")<cr>
nnoremap <silent> <c-p><c-\><c-g> :call SetProjectPath("~/Sites/gigant//")<cr>
"}}}



function! RegenerateHelpTags()
  silent! !rm ~/.config/nvim/dein/.dein/doc/webdevicons.txt
  silent! helptags ~/.config/nvim/dein/.dein/doc/
endfunction
