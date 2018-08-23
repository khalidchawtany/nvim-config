function! SetProjectPath(path)"{{{
  execute "lcd " a:path
  execute "cd "  a:path
  pwd
  set path+=public/**
endfunction
"}}}


let g:projects = [
      \ "~/Development/Applications/Oni",
      \ "~/Projects/PHP/Knights/",
      \ "~/Projects/PHP/create_laravel_package/blog/",
      \ "~/Projects/PHP/create_laravel_package/blog/packages/knights/datatables/" ,
      \ "~/Projects/PHP/koga/www/",
      \ "~/Projects/PHP/my-react-app-backend/",
      \ "~/Projects/React/my-react-app/"
      \]

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




"hi FoldColumn ctermfg=4 ctermbg=248 guifg=#00008B guibg=#e0e0e0
hi FoldColumn ctermfg=4 ctermbg=248 guifg=#0087af guibg=NONE
hi SignColumn ctermfg=4 ctermbg=248 guifg=#0087af guibg=NONE
hi LineNr ctermfg=130 guifg=lightgray guibg=NONE

