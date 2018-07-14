function! SetProjectPath(path)"{{{
  execute "lcd " a:path
  execute "cd "  a:path
  pwd
  set path+=public/**
endfunction
"}}}


let g:projects = ["~/Projects/PHP/my-react-app-backend/",
      \ "~/Projects/React/my-react-app/",
      \ "~/Projects/PHP/koga/www/",
      \ "~/Projects/PHP/Knights/",
      \ "~/Development/Applications/Oni"] 


command! -nargs=? CdP :call SetProjectPath('<args>')

nnoremap <c-p><c-\> :call fzf#run({"source": g:projects , "sink":"CdP"})<cr>


function! RegenerateHelpTags()
  silent! !rm ~/.config/nvim/dein/.dein/doc/webdevicons.txt
  silent! !rm ~/.config/nvim/dein/.dein/doc/hyperstyle.txt
  silent! helptags ~/.config/nvim/dein/.dein/doc/
endfunction

if exists('g:gui_oni')
  set noshowcmd
  set noruler
  set nolist
  set nowrap
  nnoremap  <leader>eg :e ~/.config/oni/_config.js<cr>
endif

