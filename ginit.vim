source ~/.config/nvim/plugged/neovim-gui-shim/plugin/nvim_gui_shim.vim

"GuiFont sauce code pro light:h21
GuiFont FuraMonoForPowerline Nerd Font:h19
call rpcnotify(0, 'Gui', 'Linespace', 13)

hi PmenuSel guibg=white guifg=#B34826

nnoremap <silent> <c-w><c-bs> :call GuiWindowMaximized((g:GuiWindowMaximized + 1) % 2)<cr>
nnoremap <silent> <c-w><c-cr> :call GuiWindowFullScreen((g:GuiWindowFullScreen + 1) % 2)<cr>
let g:WindowFrameless=0
nnoremap <silent> <c-w><bs>   :let g:WindowFrameless=(g:WindowFrameless + 1) % 2<cr>:call rpcnotify(0, 'Gui', 'WindowFrameless', g:WindowFrameless)<cr>


map <c-6> <c-^>

"Map CMD-# to tabs
for i in [1,2,3,4,5,6,7,8,9]
  execute "nnoremap  <D-" . i . ">           :tabnext " . i . "<cr>"
  execute "vnoremap  <D-" . i . ">      <c-u>:tabnext " . i . "<cr>"
  execute "tnoremap  <D-" . i . "> <c-\\><c-n>:tabnext " . i . "<cr>"
endfor
