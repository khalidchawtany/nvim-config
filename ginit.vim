"source ~/.config/nvim/plugged/neovim-gui-shim/plugin/nvim_gui_shim.vim

"GuiFont sauce code pro light:h17
GuiFont! Sauce Code Pro Light Plus Nerd File Types Plus Font Awesome Plus Pomicons for Powerline:h17
"GuiFont Sauce Code Pro Light Plus Nerd File Types Plus Font Awesome Plus Pomicons for Powerline:h17
"GuiFont FuraMonoForPowerline Nerd Font:h19
let g:linespace = 11
call rpcnotify(0, 'Gui', 'Linespace', g:linespace)

command! Bigger :call rpcnotify(0, 'Gui', 'Font',  substitute(g:GuiFont, '\d\+$', '\=submatch(0)+1', ''))
command! Smaller :call rpcnotify(0, 'Gui', 'Font',  substitute(g:GuiFont, '\d\+$', '\=submatch(0)-1', ''))

nnoremap <silent> <D-=> :silent! Bigger<cr>
nnoremap <silent> <D--> :silent! Smaller<cr>

nnoremap <silent> <M-–> :let g:linespace=g:linespace-1<cr>:call rpcnotify(0, 'Gui', 'Linespace', g:linespace)<cr>:redraw!<cr>
nnoremap <silent> <M-≠> :let g:linespace=g:linespace+1<cr>:call rpcnotify(0, 'Gui', 'Linespace', g:linespace)<cr>:redraw!<cr>

set nottimeout
hi PmenuSel guibg=white guifg=#B34826

nnoremap <silent> <c-w><c-bs> :call GuiWindowMaximized((g:GuiWindowMaximized + 1) % 2)<cr>
nnoremap <silent> <M-cr> :call GuiWindowMaximized((g:GuiWindowMaximized + 1) % 2)<cr>
nnoremap <silent> <D-cr> :call GuiWindowFullScreen((g:GuiWindowFullScreen + 1) % 2)<cr>
nnoremap <silent> <c-w><c-cr> :call GuiWindowFullScreen((g:GuiWindowFullScreen + 1) % 2)<cr>
let g:WindowFrameless=1
nnoremap <silent> <c-w><bs>   :let g:WindowFrameless=(g:WindowFrameless + 1) % 2<cr>:call rpcnotify(0, 'Gui', 'WindowFrameless', g:WindowFrameless)<cr>


map <c-6> <c-^>
set mouse=a

"Map CMD-# to tabs
for i in [1,2,3,4,5,6,7,8,9]
  execute "nnoremap  <D-" . i . ">           :tabnext " . i . "<cr>"
  execute "vnoremap  <D-" . i . ">      <c-u>:tabnext " . i . "<cr>"
  execute "tnoremap  <D-" . i . "> <c-\\><c-n>:tabnext " . i . "<cr>"
endfor

"Start neovim-qt as maximized borderless.
call GuiWindowMaximized(1)<cr>
