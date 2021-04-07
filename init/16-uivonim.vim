
if !exists('g:uivonim')
  finish
endif

set guifont=OperatorMonoLig\ Nerd\ Font:h20
 ToggleDarkAndLight

"Map CMD-# to tabs
for i in [1,2,3,4,5,6,7,8,9]
  execute "nnoremap <silent> <D-" . i . ">            :tabnext " . i . "<cr>"
  execute "vnoremap <silent> <D-" . i . ">       <c-u>:tabnext " . i . "<cr>"
  execute "tnoremap <silent> <D-" . i . "> <c-\\><c-n>:tabnext " . i . "<cr>"
endfor

let i = 0
execute "nnoremap <silent> <D-" . i . ">            :tabnext 10<cr>"
execute "vnoremap <silent> <D-" . i . ">       <c-u>:tabnext 10<cr>"
execute "tnoremap <silent> <D-" . i . "> <c-\\><c-n>:tabnext 10<cr>"
