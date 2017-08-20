"source ~/.config/nvim/plugged/neovim-gui-shim/plugin/nvim_gui_shim.vim

"GuiFont sauce code pro light:h17
GuiFont! Sauce Code Pro Light Plus Nerd File Types Plus Font Awesome Plus Pomicons for Powerline:h15
"GuiFont Sauce Code Pro Light Plus Nerd File Types Plus Font Awesome Plus Pomicons for Powerline:h17
"GuiFont FuraMonoForPowerline Nerd Font:h16

let g:gui_fonts = [
      \ 'Sauce Code Pro Light Plus Nerd File Types Plus Font Awesome Plus Pomicons for Powerline',
      \ 'FuraMonoForPowerline Nerd Font',
      \ 'Envy Code R',
      \ 'LiterationMonoPowerline Nerd Font',
      \ 'PT Mono for Powerline',
      \ 'Ubuntu Mono for Powerline',
      \ 'FuraMonoForPowerLine Nerd Font'
      \ ]

let g:current_gui_font_index = 0
function! ToggleFont(dir)
  let g:current_gui_font_index += a:dir
  let g:current_gui_font_index = g:current_gui_font_index % len(g:gui_fonts)
  execute 'GuiFont! ' g:gui_fonts[g:current_gui_font_index]
  echo g:gui_fonts[g:current_gui_font_index].":".substitute(g:GuiFont, '\d\+$', '\=submatch(0)+1', '')
endfunction
command! NextFont call ToggleFont(1)
command! PrevFont call ToggleFont(-1)
nnoremap c]f :<c-u>NextFont<cr>
nnoremap c[f :<c-u>PrevFont<cr>

let g:linespace = 10
call rpcnotify(0, 'Gui', 'Linespace', g:linespace)

command! Bigger :call rpcnotify(0, 'Gui', 'Font',  substitute(g:GuiFont, '\d\+$', '\=submatch(0)+1', ''))
command! Smaller :call rpcnotify(0, 'Gui', 'Font',  substitute(g:GuiFont, '\d\+$', '\=submatch(0)-1', ''))

nnoremap <silent> <D-=> :silent! Bigger<cr>
nnoremap <silent> <D--> :silent! Smaller<cr>

nnoremap <silent> <M-–> :let g:linespace=g:linespace-1<cr>:call rpcnotify(0, 'Gui', 'Linespace', g:linespace)<cr>:redraw!<cr>
nnoremap <silent> <M-≠> :let g:linespace=g:linespace+1<cr>:call rpcnotify(0, 'Gui', 'Linespace', g:linespace)<cr>:redraw!<cr>

nnoremap <silent> <c-w><c-bs> :call GuiWindowMaximized((g:GuiWindowMaximized + 1) % 2)<cr>
nnoremap <silent> <M-cr> :call GuiWindowMaximized((g:GuiWindowMaximized + 1) % 2)<cr>
nnoremap <silent> <D-cr> :call GuiWindowFullScreen((g:GuiWindowFullScreen + 1) % 2)<cr>
nnoremap <silent> <c-w><c-cr> :call GuiWindowFullScreen((g:GuiWindowFullScreen + 1) % 2)<cr>
let g:WindowFrameless=1
nnoremap <silent> <c-w><bs>   :let g:WindowFrameless=(g:WindowFrameless + 1) % 2<cr>:call rpcnotify(0, 'Gui', 'WindowFrameless', g:WindowFrameless)<cr>


set mouse=a
set nottimeout
hi PmenuSel guibg=white guifg=#B34826



"Make c-^ consitent between terminal and GUI
map <c-6> <c-^>

"Make CMD+V paste from external clipboard
nnoremap <D-V> <c-\><c-n>"+p
tnoremap <D-V> <c-\><c-n>"+pi
cnoremap <D-V> <c-r>+
vnoremap <D-V> "+p

inoremap <D-V> <c-\><c-n>:set paste<cr>"+p:set nopaste<cr>li
nnoremap <D-P> <c-\><c-n>"+p
tnoremap <D-P> <c-\><c-n>"+pi
cnoremap <D-P> <c-r>+
vnoremap <D-P> "+p
inoremap <D-P> <c-\><c-n>:set paste<cr>"+p:set nopaste<cr>li

vnoremap <D-C> "+y
vnoremap <D-Y> "+y

"Prevent neovim-qt to map HYPER
Map NOIV <M-C-D-Space> <nop>
Map NOIV <M-C-D-S-Space> <nop>
"Map CMD-# to tabs
for i in [1,2,3,4,5,6,7,8,9]
  execute "nnoremap <silent> <D-" . i . ">            :tabnext " . i . "<cr>"
  execute "vnoremap <silent> <D-" . i . ">       <c-u>:tabnext " . i . "<cr>"
  execute "tnoremap <silent> <D-" . i . "> <c-\\><c-n>:tabnext " . i . "<cr>"
endfor


"***************MUST BE LAST LINE*******
"Start neovim-qt as maximized borderless.
call GuiWindowMaximized(1)<cr>

"Fix the lldb path
" ln -s /usr/local/Cellar/llvm/HEAD-f63894b/lib/liblldb.4.0.0.dylib /usr/local/Cellar/llvm/HEAD-f63894b/lib/python2.7/site-packages/_lldb.so
let $PYTHONPATH="/usr/local/Cellar/llvm/HEAD-f63894b/lib/python2.7/site-packages/lldb:$PYTHONPATH"
