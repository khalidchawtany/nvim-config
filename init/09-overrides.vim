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

nnoremap <c-p><c-\> <cmd>call fzf#run({"source": g:projects , "sink":"CdP"})<cr>


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



nmap <expr> <leader>- expand('%')==''? "\<c-;>\<c-l>\<c-d>" : "\<c-;>\<c-l>\<c-f>"

command! SetLightLine :let g:lightline.colorscheme = "palenight" |  call lightline#init() | call lightline#update()



 function! s:term_gf()
    let procid = matchstr(bufname(""), '\(://.*/\)\@<=\(\d\+\)')
    let proc_cwd = resolve('/proc/'.procid.'/cwd')
    exe 'lcd '.proc_cwd
    exe 'e <cfile>'
endfunction

au TermOpen * nmap <buffer> gf :call <SID>term_gf()<cr>


nmap <leader>zf <cmd>g/function\\|.edatagrid({\\|{field:/normal 0maf{%zf'a<cr>
nmap <leader>zi <cmd>set fdm=indent<cr><cmd>set fdm=manual<cr>

" let g:terminal_color_2 = '#62AA0D' "path color
" let g:terminal_color_7 = '#000000' "foreground color
" let g:terminal_color_foreground = '#000000' "foreground color
" let g:terminal_color_11 = 'darkorange' "Prompt icons
" let g:terminal_color_10 = 'green' "git branch color
" let g:terminal_color_13='#87638D' "git stash color
" let g:terminal_color_3='#CCAF14' " git log hash colors
" let g:terminal_color_4='#4B79B3' " >la directory colors
" let g:terminal_color_6='#2FA8AA'

