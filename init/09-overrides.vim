function! SetProjectPath(path)"{{{
  execute "tcd "  a:path
  pwd
  set path+=public/**
endfunction
"}}}


let g:projects = [
      \ "~/Development/Applications/Oni",
      \ "~/Projects/go/bfmysql/",
      \ "~/Projects/PHP/AssetManager/",
      \ "~/Projects/PHP/ERP/",
      \ "~/Projects/React/DebtManager",
      \ "/Volumes/Dev/ERP/",
      \ "~/Projects/PHP/karaba/",
      \ "~/Projects/PHP/Knights/",
      \ "~/Projects/PHP/create_laravel_package/blog/",
      \ "~/Projects/PHP/create_laravel_package/blog/packages/knights/datatables/" ,
      \ "~/Projects/PHP/koga/www/",
      \ "~/Projects/PHP/my-react-app-backend/",
      \ "~/Projects/React/my-react-app/",
      \ "/Volumes/Data/Research/ImageProcessing",
      \ "/Volumes/Data/Research/Math_Miran/mathjs",
      \ "/Volumes/Data/Research/Math_Miran/react-math",
      \ "/Volumes/Data/Research/Math_Miran/react-popmotion-animation-example",
      \ "/Volumes/Data/Research/Math_Miran/Math"
      \]

command! -nargs=? CdP :call SetProjectPath('<args>')

LMap N! <c-p><c-\> <Plug>FzfProjects <cmd>call fzf#run({"source": g:projects , "sink":"CdP", "window" :{ 'width': 0.9, 'height': 0.6 }})<cr>

LMap N! <leader>ed <Plug>EditDevDrive <cmd>e /Volumes/Dev<cr>

function! RegenerateHelpTags()
    silent! !rm ~/.config/nvim/dein/.dein/doc/webdevicons.txt
    silent! !rm ~/.config/nvim/dein/.dein/doc/hyperstyle.txt
    silent! helptags ~/.config/nvim/dein/.dein/doc/
    helptags /Users/juju/.config/nvim/dein/.cache/init.vim/.dein/doc/
endfunction

"hi FoldColumn ctermfg=4 ctermbg=248 guifg=#00008B guibg=#e0e0e0
hi FoldColumn ctermfg=4 ctermbg=248 guifg=#0087af guibg=NONE
hi SignColumn ctermfg=4 ctermbg=248 guifg=#0087af guibg=NONE
hi LineNr ctermfg=130 guifg=lightgray guibg=NONE
hi IncSearch guifg=orange

command! -nargs=1 LightLineColorScheme :let g:lightline.colorscheme = '<args>'  |  call lightline#init() | call lightline#update()

set background=light
colorscheme PaperColor
" hi SignatureMarkText guibg=white guifg=lightgray
" hi EndOfBuffer guibg=white
" hi CursorLineNr guibg=white
" hi CursorLine guibg=white
" hi CursorColumn guibg=white
" hi LineNr guibg=white
" hi NonText guibg=white
" hi Normal guibg=white
" hi FoldColumn guibg=white guifg=lightblue

let g:colorschemes = {
            \ 'light': {'togglebg': 'dark','colorscheme': 'PaperColor', 'lightline': 'one'},
            \ 'dark':  {'togglebg': 'light','colorscheme': 'palenight',  'lightline': 'onedark'}
            \ }

command! ToggleDarkAndLight
            \  exe 'set background='.g:colorschemes[&background].togglebg
            \| exe 'colorscheme' g:colorschemes[&background].colorscheme
            \| exe 'LightLineColorScheme' g:colorschemes[&background].lightline
            \| exe 'call SetClapFuzzyMatches()'


 nnoremap cob <cmd>ToggleDarkAndLight<cr>


 function! SetClapFuzzyMatches()
     hi ClapFuzzyMatches1 cterm=bold ctermfg=118 gui=bold guifg=#87ff00
     hi ClapFuzzyMatches2 cterm=bold ctermfg=82 gui=bold guifg=#5fff00
     hi ClapFuzzyMatches3 cterm=bold ctermfg=46 gui=bold guifg=#00ff00
     hi ClapFuzzyMatches4 cterm=bold ctermfg=47 gui=bold guifg=#00ff5f
     hi ClapFuzzyMatches5 cterm=bold ctermfg=48 gui=bold guifg=#00ff87
     hi ClapFuzzyMatches6 cterm=bold ctermfg=49 gui=bold guifg=#00ffaf
     hi ClapFuzzyMatches7 cterm=bold ctermfg=50 gui=bold guifg=#00ffd7
     hi ClapFuzzyMatches8 cterm=bold ctermfg=51 gui=bold guifg=#00ffff
     hi ClapFuzzyMatches9 cterm=bold ctermfg=87 gui=bold guifg=#5fffff
     hi ClapFuzzyMatches10 cterm=bold ctermfg=123 gui=bold guifg=#87ffff
     hi ClapFuzzyMatches11 cterm=bold ctermfg=159 gui=bold guifg=#afffff
     hi ClapFuzzyMatches12 cterm=bold ctermfg=195 gui=bold guifg=#d7ffff
 endfunction

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
        execute "g/<div\\|\<style/normal lma%zf'a"
        execute "g/columns: \\[\\[/normal 0maf[%zf'a"
        execute "g/function\\|.edatagrid({\\|{ field:\\|{field:/normal 0maf{%zf'a"
    endif
    if &ft == 'php'
        execute "g/protected \\$fillable = \\[/normal 0f[zf%"
        execute "g/protected \\$dates = \\[/normal 0f[zf%"
        execute "g/public function/normal 0maf{%zf'a"
        execute "g/protected function/normal 0maf{%zf'a"
        execute "g/private function/normal 0maf{%zf'a"
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

" ToggleDarkAndLight

hi NormalFloat guibg=white

if has('win64')
    nnoremap <leader><s-e><cr> :execute "au BufWinEnter *.php match Ignore /\r$/"<cr>

    nnoremap <silent> <c-p><c-p> :CocList files<cr>
    nnoremap <silent> <c-p><c-r> :CocList mru<cr>
    nnoremap <silent> <c-p><c-o> :CocList buffers<cr>
    nnoremap <silent> <c-p><c-[> :CocList outline<cr>
endif

set linespace=20
set guifont=Operator\ Mono\ Lig:h20
