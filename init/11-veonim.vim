if !exists('veonim')
    finish
endif

set linespace=20
" set guifont=FuraMono\ Nerd\ Font:h20
" set guifont=FuraCode\ Nerd\ Font:h18
" set guifont=RobotoMono\ Nerd\ Font:h18

set guifont=Operator\ Mono\ Lig:h20

" extensions for web dev
" VeonimExt 'veonim/ext-css'
" VeonimExt 'veonim/ext-json'
" VeonimExt 'veonim/ext-html'
" VeonimExt 'vscode:extension/sourcegraph.javascript-typescript'

set guicursor=n:block-CursorNormal,i:hor10-CursorInsert,v:block-CursorVisual
hi! CursorNormal guibg=#f3a082
hi! CursorInsert guibg=#f3a082
hi! CursorVisual guibg=#6d33ff


" workspace management
" let g:vn_project_root = '~/Projects'
" nno <silent> <c-t>p :call Veonim('vim-create-dir', g:vn_project_root)<cr>
" nno <silent> ,r :call Veonim('change-dir', g:vn_project_root)<cr>

" multiplexed vim instance management
nno <silent> <c-t>c :Veonim vim-create<cr>
nno <silent> <c-g> :Veonim vim-switch<cr>
nno <silent> <c-t>, :Veonim vim-rename<cr>

" workspace functions
nno <silent> <c-p><c-p> :Veonim files<cr>
nno <silent> ,e :Veonim explorer<cr>
nno <silent> <c-p><c-o> :Veonim buffers<cr>
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




 let g:vscode_extensions = [
  \'vscode.typescript-language-features'
\]


 " let g:veonim_key_transforms = [
 "  \{'mode': 'all', 'event': 'hold', 'match': {'key': ';'}, 'transform': "e=>({key:';'+e.key})"},
 "  \{'mode': 'all', 'event': 'up', 'match': {'key': 'Meta', 'metaKey': 'true'}, 'transform': "e=>({key:'<Esc>'})"}
" \]

 " let g:veonim_remap_modifiers = [
 "  \{"from": "C", "to": "D"},
 "  \{"from": "D", "to": "C"}
" \]


 let g:vscode_extensions = [
  \'vscode.typescript-language-features',
  \'vscode.json-language-features',
  \'vscode.css-language-features',
  \'vscode.markdown-language-features',
  \'vscode.html-language-features',
  \'vscode.php-language-features',
\]

  " \'rust-lang.rust',
  " \'ms-vscode.go',
  " \'ms-python.python',

 let g:vscode_config = {
  \'tsserver.trace.server': 'verbose',
  \'typescript.tsserver.trace': 'verbose'
\}

 unmap /
 unmap ?
