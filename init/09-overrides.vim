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
      \ "~/Projects/React/my-react-app/",
      \ "~/Research/Math_Miran/mathjs",
      \ "~/Research/Math_Miran/react-math",
      \ "~/Research/Math_Miran/react-popmotion-animation-example",
      \ "~/Research/Math_Miran/Math"
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



LMap nExpr <leader>- <Plug>NerdTreeCurFile  expand('%')==''? "\<c-;>\<c-l>\<c-d>" : "\<c-;>\<c-l>\<c-f>"
" nmap <expr> <leader>- expand('%')==''? "\<c-;>\<c-l>\<c-d>" : "\<c-;>\<c-l>\<c-f>"

command! SetLightLine :let g:lightline.colorscheme = "onedark" |  call lightline#init() | call lightline#update()



 function! s:term_gf()
    let procid = matchstr(bufname(""), '\(://.*/\)\@<=\(\d\+\)')
    let proc_cwd = resolve('/proc/'.procid.'/cwd')
    exe 'lcd '.proc_cwd
    exe 'e <cfile>'
endfunction

au TermOpen * nmap <buffer> gf :call <SID>term_gf()<cr>


LMap n <leader>zf <Plug>format-functions <cmd>g/function\\|.edatagrid({\\|{field:/normal 0maf{%zf'a<cr>
LMap n <leader>zi <Plug>format-indent <cmd>set fdm=indent<cr><cmd>set fdm=manual<cr>

" let g:terminal_color_2 = '#62AA0D' "path color
" let g:terminal_color_7 = '#000000' "foreground color
" let g:terminal_color_foreground = '#000000' "foreground color
" let g:terminal_color_11 = 'darkorange' "Prompt icons
" let g:terminal_color_10 = 'green' "git branch color
" let g:terminal_color_13='#87638D' "git stash color
" let g:terminal_color_3='#CCAF14' " git log hash colors
" let g:terminal_color_4='#4B79B3' " >la directory colors
" let g:terminal_color_6='#2FA8AA'






 if exists('veonim')

let g:vn_font = 'Operator Mono'
let g:vn_font_size = 28
let g:vn_line_height = '1.5'

" extensions for web dev
VeonimExt 'veonim/ext-css'
VeonimExt 'veonim/ext-json'
VeonimExt 'veonim/ext-html'
VeonimExt 'vscode:extension/sourcegraph.javascript-typescript'



set guicursor=n:block-CursorNormal,i:hor10-CursorInsert,v:block-CursorVisual
hi! CursorNormal guibg=#f3a082
hi! CursorInsert guibg=#f3a082
hi! CursorVisual guibg=#6d33ff

let g:vn_explorer_ignore_dirs = ['.git']
let g:vn_explorer_ignore_files = ['.DS_Store']

" workspace management
let g:vn_project_root = '~/Projects'
nno <silent> <c-t>p :call Veonim('vim-create-dir', g:vn_project_root)<cr>
nno <silent> ,r :call Veonim('change-dir', g:vn_project_root)<cr>

" multiplexed vim instance management
nno <silent> <c-t>c :Veonim vim-create<cr>
nno <silent> <c-g> :Veonim vim-switch<cr>
nno <silent> <c-t>, :Veonim vim-rename<cr>

" workspace functions
nno <silent> ,f :Veonim files<cr>
nno <silent> ,e :Veonim explorer<cr>
nno <silent> ,b :Veonim buffers<cr>
nno <silent> ,d :Veonim change-dir<cr>

" searching text
nno <silent> <space>fw :Veonim grep-word<cr>
vno <silent> <space>fw :Veonim grep-selection<cr>
nno <silent> <space>fa :Veonim grep<cr>
nno <silent> <space>ff :Veonim grep-resume<cr>
nno <silent> <space>fb :Veonim buffer-search<cr>

" color picker
nno <silent> sc :Veonim pick-color<cr>

" language server functions
nno <silent> sr :Veonim rename<cr>
nno <silent> sd :Veonim definition<cr>
nno <silent> st :Veonim type-definition<cr>
nno <silent> si :Veonim implementation<cr>
nno <silent> sf :Veonim references<cr>
nno <silent> sh :Veonim hover<cr>
nno <silent> sl :Veonim symbols<cr>
nno <silent> so :Veonim workspace-symbols<cr>
nno <silent> sq :Veonim code-action<cr>
nno <silent> sp :Veonim show-problem<cr>
nno <silent> sk :Veonim highlight<cr>
nno <silent> sK :Veonim highlight-clear<cr>
nno <silent> <c-n> :Veonim next-problem<cr>
nno <silent> <c-p> :Veonim prev-problem<cr>
nno <silent> ,n :Veonim next-usage<cr>
nno <silent> ,p :Veonim prev-usage<cr>
nno <silent> <space>pt :Veonim problems-toggle<cr>
nno <silent> <space>pf :Veonim problems-focus<cr>
nno <silent> <d-o> :Veonim buffer-prev<cr>
nno <silent> <d-i> :Veonim buffer-next<cr>

endif
 autocmd FileType php setlocal omnifunc=phpactor#Complete
