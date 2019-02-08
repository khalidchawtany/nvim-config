function! SetProjectPath(path)"{{{
  execute "lcd " a:path
  execute "cd "  a:path
  pwd
  set path+=public/**
endfunction
"}}}


let g:projects = [
      \ "~/Development/Applications/Oni",
      \ "~/Projects/PHP/karaba/",
      \ "~/Projects/PHP/Knights/",
      \ "~/Projects/PHP/create_laravel_package/blog/",
      \ "~/Projects/PHP/create_laravel_package/blog/packages/knights/datatables/" ,
      \ "~/Projects/PHP/koga/www/",
      \ "~/Projects/PHP/my-react-app-backend/",
      \ "~/Projects/React/my-react-app/",
      \ "~/Research/Math_Miran/mathjs",
      \ "~/Research/Math_Miran/react-math",
      \ "~/Research/Math_Miran/react-popmotion-animation-example",
      \ "~/Research/Math_Miran/Math"
      \]

command! -nargs=? CdP :call SetProjectPath('<args>')

LMap N! <c-p><c-\> <Plug>FzfProjects <cmd>call fzf#run({"source": g:projects , "sink":"CdP"})<cr>

function! RegenerateHelpTags()
  silent! !rm ~/.config/nvim/dein/.dein/doc/webdevicons.txt
  silent! !rm ~/.config/nvim/dein/.dein/doc/hyperstyle.txt
  silent! helptags ~/.config/nvim/dein/.dein/doc/
endfunction

"hi FoldColumn ctermfg=4 ctermbg=248 guifg=#00008B guibg=#e0e0e0
hi FoldColumn ctermfg=4 ctermbg=248 guifg=#0087af guibg=NONE
hi SignColumn ctermfg=4 ctermbg=248 guifg=#0087af guibg=NONE
hi LineNr ctermfg=130 guifg=lightgray guibg=NONE

command! -nargs=1 LightLineColorScheme :let g:lightline.colorscheme = '<args>'  |  call lightline#init() | call lightline#update()

let g:colorschemes = {
            \ 'light': {'togglebg': 'dark','colorscheme': 'PaperColor', 'lightline': 'one'},
            \ 'dark':  {'togglebg': 'light','colorscheme': 'palenight',  'lightline': 'onedark'}
            \ }

command! ToggleDarkAndLight
            \  exe 'set background='.g:colorschemes[&background].togglebg
            \| exe 'colorscheme' g:colorschemes[&background].colorscheme
            \| exe 'LightLineColorScheme' g:colorschemes[&background].lightline

 nnoremap cob <cmd>ToggleDarkAndLight<cr>

 function! s:term_gf()
    let procid = matchstr(bufname(""), '\(://.*/\)\@<=\(\d\+\)')
    let proc_cwd = resolve('/proc/'.procid.'/cwd')
    exe 'lcd '.proc_cwd
    exe 'e <cfile>'
endfunction

au TermOpen * nmap <buffer> gf :call <SID>term_gf()<cr>


function! FoldFunction()
    set foldmethod=manual
    if &ft == 'blade'
        execute "g/function\\|.edatagrid({\\|{ field:\\|\<div\\|\<style\\|\@can(/normal 0maf{%zf'a"
    endif
    if &ft == 'php'
        execute "g/protected \\$fillable = \\[/normal 0f[zf%"
        execute "g/protected \\$dates = \\[/normal 0f[zf%"
        execute "g/function/normal 0maf{%zf'a"
        execute "g/\\/\\*\\*/normal mazf%'a"
        normal zM
    endif
endfunction

LMap n <leader>zf <Plug>fold-functions <cmd>call FoldFunction()<cr>
LMap n <leader>zi <Plug>fold-indent <cmd>set fdm=indent<cr><cmd>set fdm=manual<cr>

" let g:terminal_color_2 = '#62AA0D' "path color
" let g:terminal_color_7 = '#000000' "foreground color
" let g:terminal_color_foreground = '#000000' "foreground color
" let g:terminal_color_11 = 'darkorange' "Prompt icons
" let g:terminal_color_10 = 'green' "git branch color
" let g:terminal_color_13='#87638D' "git stash color
" let g:terminal_color_3='#CCAF14' " git log hash colors
" let g:terminal_color_4='#4B79B3' " >la directory colors
" let g:terminal_color_6='#2FA8AA'

