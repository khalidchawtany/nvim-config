if !exists('g:gonvim_running')
  finish
endif

set guifont=Roboto\ Mono\ for\ PowerLine:h18
set linespace=20
cnoremap <D-�><space> <c-i>



augroup your_config_scrollbar_nvim
  autocmd!
augroup end


let $FZF_DEFAULT_OPTS .= ' --layout=reverse'

let $FZF_DEFAULT_OPTS="--preview-window noborder  --history=/Users/JuJu/.fzf_history --pointer=' ▶' --marker='◉' --reverse --bind 'ctrl-space:select-all,ctrl-l:jump'  --color=bg+:#cccccc,fg+:#444444,hl:#22aa44,hl+:#44ff44,gutter:#eeeeee,marker:#ff0000"

function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  let height = &lines
  let width = float2nr(&columns + 9 - (&columns / 4))
  let col_offset =(&columns + 9 - width) / 2
  let opts = {
        \ 'relative': 'editor',
        \ 'row': 1,
        \ 'col': col_offset,
        \ 'width': width ,
        \ 'height': height / 2
        \ }

  let win = nvim_open_win(buf, v:true, opts)
  call setwinvar(win, '&winhl', 'NormalFloat:Normal')

  " this is to remove all line numbers and so on from the window
  setlocal
        \ buftype=nofile
        \ nobuflisted
        \ bufhidden=hide
        \ nonumber
        \ norelativenumber
        \ signcolumn=no
endfunction

let g:fzf_layout = { 'window': 'call FloatingFZF()' }
