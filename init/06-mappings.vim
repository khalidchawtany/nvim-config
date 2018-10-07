
"Fix difference between terminal and GUI
"=======================================
"Set these symbols from iTerm and remap them in n/vim
Map iovxnct  ‰   <c-cr>
Map iovxnct  ◊   <c-'>
Map iovxnct  Ú   <c-;>
Map iovxnct  Ą   <c-bs>
Map iovxnct  ⌂   <M-cr>
Map iovxnct  Ặ   <s-cr>
Map iovxnct  ◊Ú  <C-'><C-;>

nnoremap <leader>tl :tabs<cr>
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>tt :tabnew \| e term://zsh<cr>
nnoremap <leader>th :tab help<space>

" Utils {{{
"===============================================================================

nnoremap c* *Ncgn

nnoremap <leader>tm0 :tabmove 0<cr>

nnoremap <Leader><Leader> <c-^>

"Shift-Enter is like ]<space>
inoremap <silent> <s-cr> <esc>m`o<esc>``a

" toggle the last search pattern register between the last two search patterns
function! s:ToggleSearchPattern()
  let next_search_pattern_index = -1
  if @/ ==# histget('search', -1)
    let next_search_pattern_index = -2
  endif
  let @/ = histget('search', next_search_pattern_index)
endfunction
nnoremap <silent> co/ :<C-u>call <SID>ToggleSearchPattern()<CR>

nnoremap <leader>ha :call HighlightAllOfWord(1)<cr>
nnoremap <leader>hA :call HighlightAllOfWord(0)<cr>

nnoremap <silent> <BS> :syntax sync minlines=1000<cr>:nohlsearch \| echo "" \|redraw! \| diffupdate \| normal \<Plug>(FastFoldUpdate) \| silent! call clever_f#reset() <cr>

nnoremap <F12> :call ToggleMouseFunction()<cr>

vnoremap . :norm.<CR>

" { and } skip over closed folds
nnoremap <expr> } foldclosed(search('^$', 'Wn')) == -1 ? "}" : "}j}"
nnoremap <expr> { foldclosed(search('^$', 'Wnb')) == -1 ? "{" : "{k{"

" Jump to next/previous merge conflict marker
nnoremap <silent> ]> /\v^(\<\|\=\|\>){7}([^=].+)?$<CR>
nnoremap <silent> [> ?\v^(\<\|\=\|\>){7}([^=].+)\?$<CR>

" Move visual lines
nnoremap <silent> j gj
nnoremap <silent> k gk

noremap  H ^
vnoremap H ^
onoremap H ^
noremap  L $
vnoremap L g_
onoremap L $

"nnoremap ; : "ambicmd remaps this
nnoremap : ;
vnoremap ; :
vnoremap : ;

"Make completion more comfortable
inoremap <c-j> <c-n>
inoremap <c-k> <c-p>

inoremap <C-U> <C-G>u<C-U>

if !exists('$TMUX')
  nnoremap <silent> <c-h> <c-w><c-h>
  nnoremap <silent> <c-j> <c-w><c-j>
  nnoremap <silent> <c-k> <c-w><c-k>
  nnoremap <silent> <c-l> <c-w><c-l>
endif

"" Highlight TODO markers
"hi todo cterm=bold ctermfg=231 ctermbg=232 gui=bold guifg=#FFFFFF guibg=bg
"match todo '\v^(\<|\=|\>){7}([^=].+)?$'
"match todo '\v^(\<|\=|\>){7}([^=].+)?$'

"}}}

" Folds {{{
"===============================================================================

" Close all folds except this
nnoremap z<Space> zMzv
nnoremap z0 :set foldlevel=0<cr>
nnoremap z1 :set foldlevel=1<cr>
nnoremap z2 :set foldlevel=2<cr>
nnoremap z3 :set foldlevel=3<cr>
nnoremap z4 :set foldlevel=4<cr>
nnoremap z5 :set foldlevel=5<cr>
nnoremap z6 :set foldlevel=6<cr>
nnoremap z7 :set foldlevel=7<cr>
nnoremap z8 :set foldlevel=8<cr>
nnoremap z9 :set foldlevel=9<cr>

autocmd Filetype neosnippet,cs call ToggleFoldMarker()
"}}}

" Terminal {{{
"===============================================================================
if has('nvim')
  tnoremap <c-o> <c-\><c-n>
endif
"tnoremap <expr> <esc> &filetype == 'fzf' ? "\<esc>" : "\<c-\>\<c-n>"
"}}}

" Window & Buffer {{{
"===============================================================================

" Shrink to fit number of lines
nmap <silent> <c-w>S :execute ":resize " . line('$')<cr>

" Maximize current split
nnoremap <c-w>M <C-w>_<C-w><Bar>

" Buffer deletion commands {{{

nnoremap <c-w>O            :BufOnly<cr>
nnoremap <c-;>wa           :BufOnly -1<cr>
nmap     <c-;>ww           <Plug>BW
nnoremap <silent> <c-;>wu  :silent! WipeoutUnmodified<cr>
nnoremap <c-;><c-;>wa      :bufdo execute ":bw!"<cr>

"}}}

"}}}

" Text editting {{{
"===============================================================================
"nnoremap <leader>b :center 80<CR>hhv0r#A<SPACE><ESC>40A#<ESC>d80<BAR>YppVr#kk.

"TODO: conflicts with script-ease
command! SplitLine :normal! i<CR><ESC>,ss<cr>
nnoremap <c-g>K :call Preserve('SplitLine')<cr>
nnoremap <c-g><c-K> :call Preserve('SplitLine')<cr>

" Put empty line around (requires UnImpaired)
nnoremap \<Space> :normal [ ] <cr>

" Suck from below/above
nnoremap <C-g>j i<Esc>+y$ddgi<c-r>0<Esc>
nnoremap <C-g>k i<Esc>-y$ddgi<c-r>0<Esc>

" Uppercase from insert mode while you are at the end of a word
inoremap <C-u> <esc>mzgUiw`za

"Remove ^M from a file
LMap N <leader>e<cr> <SID>remove-ctrl-M :e ++ff=dos<cr>

"Retab file
LMap N <leader>e<Tab> <SID>Retab :retab<cr>

"Strip whitespace
LMap N <leader>e<Space> <SID>remove-whitespace :call StripWhitespace()<cr>

" Underline {{{

" underline the current line
nnoremap <leader>U= :t.\|s/./=<cr>:nohls<cr>
nnoremap <leader>U- :t.\|s/./-<cr>:nohls<cr>
nnoremap <leader>U~ :t.\|s/./\\~<cr>:nohls<cr>

"only underline from H to L
nnoremap <leader>u= "zyy"zp<c-v>$r=
nnoremap <leader>u- "zyy"zp<c-v>$r-
nnoremap <leader>u~ "zyy"zp<c-v>$r~

"}}}

" Better copy/cut/paste {{{
noremap <leader>d "_d
noremap <leader>y "+y
nnoremap <leader>+ o<esc>"+p
"noremap <leader>= "+p
LMap N <leader>= <SID>Paste_from_clip "+p
"}}}

" Indentation {{{
" indent visually without coming back to normal mode
vmap > >gv
vmap < <gv
nmap <leader>ii :call IndentToNextBraceInLineAbove()<cr>
"}}}

" Move visual block
vnoremap <c-j> :m '>+1<CR>gv=gv
vnoremap <c-k> :m '<-2<CR>gv=gv

" select last matched item
nnoremap <c-g>/ //e<Enter>v??<Enter>
nnoremap <c-g>sl //e<Enter>v??<Enter>

" Reselect the text you just entered
nnoremap gV `[v`]
nnoremap <c-g>si `[v`]
"}}}

" Writting and Quitting {{{
"===============================================================================

nnoremap <leader>qq :q<cr>
LMap N <leader>qq    <SID>Quit           :q<cr>
LMap N <leader>qa    <SID>Quit_All       :qall<cr>
LMap N <leader>qQ    <SID>Forcr_Quit_All :qall!<cr>

LMap N <leader>wq    <SID>Write_Quit     :wq<cr>
LMap N <leader>ww    <SID>Write          :w<cr>
LMap N <leader>wa    <SID>Write_All      :wall<cr>
LMap N <leader>wu    <SID>Update         :update<cr>

" save as root
LMap N <leader>ws    <SID>SudoWrite      :w !sudo tee % > /dev/null<CR>

"}}}

" Path & File {{{

autocmd Filetype netrw nnoremap q :quit<cr>

LMap N <leader>ev    <SID>Vimrc           :e ~/.config/nvim/init<cr>
LMap N <leader>eg    <SID>gVimrc          :if has("nvim") \| e ~/.config/nvim/ginit.vim \| else \| e ~/.gvimrc \| endif<cr>
  LMap N <leader>e<BS> <SID>Discard_changes :e! \| echo "changes discarded"<cr>

  "CD into:
  "current buffer file dir
  nnoremap cdf :lcd %:p:h<cr>:pwd<cr>
  "current working dir
  nnoremap cdc :lcd <c-r>=expand("%:h")<cr>/
  "git dir ROOT
  nnoremap cdg :lcd <c-r>=FindGitDirOrRoot()<cr><cr>

  nnoremap cdd :lcd /Volumes/Home/.config/nvim/dein/repos/github.com/<cr>
  nnoremap cdv :lcd /Volumes/Home/.config/nvim/<cr>

  "Open current directory in Finder
  "nnoremap gof :silent !open .<cr>

  nnoremap ycd :!mkdir -p %:p:h<CR>

  "Go to alternate file
  nnoremap go <C-^>

  " edit in the path of current file
  nnoremap <leader>ef :e <C-R>=escape(expand('%:p:h'), ' ').'/'<CR>
  nnoremap <leader>ep :e <c-r>=escape(getcwd(), ' ').'/'<cr>

  " <c-y>f Copy the full path of the current file to the clipboard
  nnoremap <silent> <leader>cp :let @+=expand("%:p")<cr>:echo "Copied current file
        \ path '".expand("%:p")."' to clipboard"<cr>

  " rename current buffers file
  nnoremap <Leader>fr :call RenameFile()<cr>

  " Edit todo list for project
  nnoremap <leader>tp :e <c-r>=FindGitDirOrRoot()<cr>/todo.org<cr>

  " Edit GLOBAL todo list
  nnoremap <leader>to :e ~/org/todo.org<cr>

  " evaluate selected vimscript | line | whole vimrc (init.vim)
  vnoremap <Leader>s; "vy:@v<CR>
  nnoremap <Leader>s; "vyy:@v<CR>
  nnoremap <silent> <leader>sv :unlet g:VIMRC_SOURCED<cr>:so $MYVIMRC<CR>
  "}}}

  " Toggles {{{
  "===============================================================================

  "toggle tabline
  nnoremap <silent> cot  :execute "set  showtabline=" . (&showtabline+2)%3<cr>

  nnoremap <c-k><c-d> :silent! call Preserve("normal gg=G")<cr>

  "toggle showcmd
  nnoremap co: :set showcmd!<cr>
  nnoremap co; :set showcmd!<cr>

  "Toggle laststatus (statusline | statusbar)
  nnoremap <silent> co<space> :execute "set laststatus=" . (&laststatus+2)%3<cr>

  nnoremap  coq :QFix<cr>
  command! QFix call QFixToggle()
  function! QFixToggle()
    for i in range(1, winnr('$'))
      let bnum = winbufnr(i)
      if getbufvar(bnum, '&buftype') == 'quickfix'
        cclose
        return
      endif
    endfor
    copen
  endfunction
  "}}}

  " Command-line Mode Key Mappings {{{
  "===============================================================================

  cnoremap <c-a> <home>
  cnoremap <c-e> <end>
  cnoremap <c-j> <down>
  cnoremap <c-k> <up>
  cnoremap <c-h> <left>
  cnoremap <c-l> <right>
  cnoremap <c-g>p <C-\>egetcwd()<CR>
  cnoremap <c-g>f <C-r>=expand("%")<CR>

  "}}}

  " Languages {{{
  "===============================================================================

  " Laravel

  function! EditIfExists(path)
      if !empty(glob(a:path))
          execute ":edit" a:path "<cr>"
      else
          echo "path does not exist!"
      endif
  endfunction

  nnoremap <leader>lv :e <c-r>=FindGitDirOrRoot()<cr>/resources/views/<cr>
  " nnoremap <leader>lv call EditIfExists(<c-r>=FindGitDirOrRoot()<cr>/resources/views/)
  nnoremap <leader>lm :e <c-r>=FindGitDirOrRoot()<cr>/database/migrations/<cr>
  nnoremap <leader>lf :e <c-r>=FindGitDirOrRoot()<cr>/database/factories/<cr>
  nnoremap <leader>ls :e <c-r>=FindGitDirOrRoot()<cr>/database/seeds/<cr>
  nnoremap <leader>lc :e <c-r>=FindGitDirOrRoot()<cr>/app/Http/Controllers<cr>
  nnoremap <leader>la :e <c-r>=FindGitDirOrRoot()<cr>/app/<cr>
  nnoremap <leader>lp :e <c-r>=FindGitDirOrRoot()<cr>/public/<cr>

  " Java
  "nnoremap  <leader>ej : exe "!cd " . shellescape(expand("%:h")) . " && javac " . expand ("%:t") . " && java " . expand("%:t:r")<cr>
  nnoremap  <leader>ej :call ExecuteJava()<cr>
  function! ExecuteJava()
    write
    exe "tab term cd " . shellescape(expand("%:h")) . " && javac " . expand ("%:t") . " && java " . expand("%:t:r")
  endfunction

  " HTML
  au FileType html,blade inoremap <buffer> >>     ></<C-X><C-O><Esc>%i
  au FileType html,blade inoremap <buffer> >><CR> ></<C-X><C-O><Esc>%i<CR><ESC>O

  "}}}

  nnoremap <silent> [I :call List("i", 0, 0)<CR>
  nnoremap <silent> ]I :call List("i", 0, 1)<CR>
  xnoremap <silent> [I :<C-u>call List("i", 1, 0)<CR>
  xnoremap <silent> ]I :<C-u>call List("i", 1, 1)<CR>
  nnoremap <silent> [D :call List("d", 0, 0)<CR>
  nnoremap <silent> ]D :call List("d", 0, 1)<CR>
  xnoremap <silent> [D :<C-u>call List("d", 1, 0)<CR>
  xnoremap <silent> ]D :<C-u>call List("d", 1, 1)<CR>

  "noremap <F4> :call DiffMe()<CR>



  nnoremap gr *yiw:%s//<c-r>"/g<left><left>
  vnoremap gr y:%s/<c-r>"/<c-r>"/g<left><left>
