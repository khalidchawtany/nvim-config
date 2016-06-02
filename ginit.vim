source ~/.config/nvim/plugged/neovim-gui-shim/plugin/nvim_gui_shim.vim

"GuiFont sauce code pro light:h21
GuiFont FuraMonoForPowerline Nerd Font:h19
call rpcnotify(0, 'Gui', 'Linespace', 13)

hi PmenuSel guibg=white guifg=#B34826

nnoremap <silent> <c-w><c-bs> :call GuiWindowMaximized((g:GuiWindowMaximized + 1) % 2)<cr>
nnoremap <silent> <c-w><c-cr> :call GuiWindowFullScreen((g:GuiWindowFullScreen + 1) % 2)<cr>
let g:WindowFrameless=0
nnoremap <silent> <c-w><bs>   :let g:WindowFrameless=(g:WindowFrameless + 1) % 2<cr>:call rpcnotify(0, 'Gui', 'WindowFrameless', g:WindowFrameless)<cr>


cnoremap <S-lt> <
"cnoremap <t_ü>< <
map <c-6> <c-^>
