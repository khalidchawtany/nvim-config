" let NVIM_QT_RUNTIME_PATH="./Contents/Resources/runtime"

"GuiFont! Source Code Pro for PowerLine:h18
set guifont=Operator\ Mono\ Lig:h17

" Support ligature
call rpcnotify(0, 'Gui', 'Option', 'RenderLigatures', 1)
nnoremap co<cr> :call rpcnotify(0, 'Gui', 'Option', 'RenderLigatures', 1)<cr>
nnoremap cO<cr> :call rpcnotify(0, 'Gui', 'Option', 'RenderLigatures', 0)<cr>

let g:gui_fonts = [
      \ 'Operator Mono Lig:h17',
      \ 'Monaco:h17',
      \ 'Source Code Pro for PowerLine:h17',
      \ 'PT Mono:17',
      \ 'Fura Mono Nerd Font:17'
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

"command! Bigger :call rpcnotify(0, 'Gui', 'Font',  substitute(g:GuiFont, '\d\+$', '\=submatch(0)+1', ''))
"command! Smaller :call rpcnotify(0, 'Gui', 'Font',  substitute(g:GuiFont, '\d\+$', '\=submatch(0)-1', ''))

command! Bigger :let g:gui_fonts[g:current_gui_font_index]=substitute(g:gui_fonts[g:current_gui_font_index], '\d\+$', '\=submatch(0)+1', '') | call rpcnotify(0, 'Gui', 'Font', g:gui_fonts[g:current_gui_font_index])
command! Smaller :let g:gui_fonts[g:current_gui_font_index]=substitute(g:gui_fonts[g:current_gui_font_index], '\d\+$', '\=submatch(0)-1', '') | call rpcnotify(0, 'Gui', 'Font', g:gui_fonts[g:current_gui_font_index])

nnoremap <silent> <D-=> :silent! Bigger<cr>
nnoremap <silent> <D--> :silent! Smaller<cr>

nnoremap <silent> <M-D--> :let g:linespace=g:linespace-1<cr>:call rpcnotify(0, 'Gui', 'Linespace', g:linespace)<cr>:redraw!<cr>
nnoremap <silent> <M-D-=> :let g:linespace=g:linespace+1<cr>:call rpcnotify(0, 'Gui', 'Linespace', g:linespace)<cr>:redraw!<cr>

nnoremap <silent> <c-w>m :call GuiWindowMaximized((g:GuiWindowMaximized + 1) % 2)<cr>
nnoremap <silent> <c-w>f :call GuiWindowFullScreen((g:GuiWindowFullScreen + 1) % 2)<cr>
let g:WindowFrameless=0
nnoremap <silent> <c-w><bs>   :let g:WindowFrameless=(g:WindowFrameless + 1) % 2<cr>:call rpcnotify(0, 'Gui', 'WindowFrameless', g:WindowFrameless)<cr>

set mouse=a
set nottimeout

if &background == "light"
    hi PmenuSel guibg=darkorange guifg=#B34826
else
    hi PmenuSel guibg=darkorange guifg=#B34826
endif

"Don't use gui tabline and Popup menu
" call rpcnotify(0, "Gui", "Option", "Tabline", "false")
" call rpcnotify(0, 'Gui', 'Option', 'Popupmenu', 0) 

if ! exists('g:fvim_loaded')
    GuiTabline 0
    GuiPopupmenu 0
endif



"Make c-^ consitent between terminal and GUI
map <c-6> <c-^>

"Make CMD+V paste from external clipboard
nnoremap <D-V> <c-\><c-n>"+p
tnoremap <D-V> <c-\><c-n>"+pi
cnoremap <D-V> <c-r>+
vnoremap <D-V> "+p

nnoremap <D-S> <cmd>w<cr>

inoremap <D-V> <c-\><c-n>:set paste<cr>"+p:set nopaste<cr>li
nnoremap <D-P> <c-\><c-n>"+p
tnoremap <D-P> <c-\><c-n>"+pi
cnoremap <D-P> <c-r>+
vnoremap <D-P> "+p
inoremap <D-P> <c-\><c-n>:set paste<cr>"+p:set nopaste<cr>li

vnoremap <D-C> "+y
vnoremap <D-Y> "+y
" tnoremap <D-v> <C-\><C-N>"+pA
nnoremap <D-v> <C-\><C-N>"+pA
vnoremap <D-c> "+y

"Prevent neovim-qt to map HYPER
Map NOIV <M-C-D-Space> <nop>
Map NOIV <M-C-D-S-Space> <nop>
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


"Fix the lldb path
" ln -s /usr/local/Cellar/llvm/HEAD-f63894b/lib/liblldb.4.0.0.dylib /usr/local/Cellar/llvm/HEAD-f63894b/lib/python2.7/site-packages/_lldb.so
if has('mac')
    let $PYTHONPATH="/usr/local/Cellar/llvm/HEAD-f63894b/lib/python2.7/site-packages/lldb:$PYTHONPATH"
endif

 if exists('g:fvim_loaded')
    " good old 'set guifont' compatibility
    " Ctrl-ScrollWheel for zooming in/out
    nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
    nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
    nnoremap <A-CR> :FVimToggleFullScreen<CR>
    " FVimCursorSmoothMove v:true
    " FVimCursorSmoothBlink v:true
endif



"***************MUST BE LAST LINE*******
"Start neovim-qt as maximized borderless.
call GuiWindowMaximized(2)
