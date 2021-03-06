
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

LMap N <leader>tl <Plug>tab-list :tabs<cr>
LMap N <leader>tn <Plug>tab-new :tabnew<cr>
LMap N <leader>tt <Plug>tab-terminal :tabnew \| e term://zsh<cr>
LMap N <leader>th <Plug>tab-help :tab help<space>
LMap N <leader>tm0 <Plug>tab-move-first :tabmove 0<cr>

" Utils {{{
"===============================================================================

nnoremap c* *Ncgn

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

LMap N <leader>ha <Plug>highlight-word-on  :call HighlightAllOfWord(1)<cr>
LMap N <leader>hA <Plug>highlight-word-off :call HighlightAllOfWord(0)<cr>

nnoremap <silent><nowait> <BS> :GitGutterAll<cr>:syntax sync minlines=1000<cr>:nohlsearch \| echo "" \|redraw! \| diffupdate \| normal \<Plug>(FastFoldUpdate) \| silent! call clever_f#reset()  <cr>

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

LMap N <leader>e<cr> <SID>remove-ctrl-M :e ++ff=dos<cr>

LMap N <leader>e<Tab> <SID>retab :retab<cr>

LMap N <leader>e<Space> <SID>strip-whitespace :call StripWhitespace()<cr>

" Underline {{{

" underline the current line
LMap N <leader>u= <Plug>underline-= :t.\|s/./=/g<cr>:nohls<cr>
LMap N <leader>u- <Plug>underline-- :t.\|s/./-/g<cr>:nohls<cr>
LMap N <leader>u~ <Plug>underline-~ :t.\|s/./\\~/g<cr>:nohls<cr>

"}}}

" Better copy/cut/paste {{{
LMap n <leader>d <Plug>delete-to-blackhole "_d
LMap n <leader>y <Plug>copy-to-+ "+y
LMap N <leader>+ <Plug>add-line-below o<esc>"+p
LMap N <leader>= <SID>paste-from-clip "+p
"}}}

" Indentation {{{
" indent visually without coming back to normal mode
vmap > >gv
vmap < <gv
LMap n <leader>ii <Plug>indent-to-next-brace-above :call IndentToNextBraceInLineAbove()<cr>
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

LMap N <leader>qq    <SID>Quit           :q<cr>
LMap N <leader>qa    <SID>quit-all       :qall<cr>
LMap N <leader>qQ    <SID>quit-all-force :qall!<cr>

LMap N <leader>wq    <SID>write-quit     :wq<cr>
LMap N <leader>ww    <SID>write          :w<cr>
LMap N <leader>wa    <SID>write-all      :wall<cr>
LMap N <leader>wu    <SID>update-file         :update<cr>

" save as root
LMap N <leader>ws    <SID>write-sudo      :w !sudo tee % > /dev/null<CR>

"}}}

" Path & File {{{

autocmd Filetype netrw nnoremap q :quit<cr>

  LMap N <leader>ev    <SID>Vimrc           :e ~/.config/nvim/init<cr>
  LMap N <leader>eg    <SID>gVimrc          :if has("nvim") \| e ~/.config/nvim/ginit.vim \| else \| e ~/.gvimrc \| endif<cr>
  LMap N <leader>e<BS> <SID>discard-changes :e! \| echo "changes discarded"<cr>

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
  LMap N <leader>ef <Plug>edit-in-% :e <C-R>=escape(expand('%:p:h'), ' ').'/'<CR>
  LMap N <leader>ep <Plug>edit-in-cwd :e <c-r>=escape(getcwd(), ' ').'/'<cr>

  " <c-y>f Copy the full path of the current file to the clipboard
  LMap !N <leader>fp <Plug>copy-file-path :let @+=expand("%:p")<cr>:echo "Copied current file  path '".expand("%:p")."' to clipboard"<cr>

  " rename current buffers file
  LMap N <leader>fr <Plug>rename-file :call RenameFile()<cr>

  LMap N <leader>tp <Plug>todo-project :e <c-r>=FindGitDirOrRoot()<cr>/todo.org<cr>
  LMap N <leader>to <Plug>todo-global :e ~/org/todo.org<cr>

  LMap N <Leader>s; <Plug>source-selection "vyy:@v<CR>
  LMap V <Leader>s; <Plug>source-selection "vy:@v<CR>
  LMap NV <Leader>sv <Plug>source-vimrc :unlet g:VIMRC_SOURCED<cr>:so $MYVIMRC<CR>
  "}}}

  " Toggles {{{
  "===============================================================================

  "toggle tabline
  nnoremap <silent> cot  :execute "set  showtabline=" . (&showtabline+2)%3<cr>

  nnoremap <c-k><c-d> :silent! call Preserve("normal gg=G")<cr>

  nnoremap cos :set scrollbind!<cr>

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

  LMap N <leader>la <Plug>laravel-edit-app :e <c-r>=FindGitDirOrRoot()<cr>/app/<cr>
  LMap N <leader>lo <Plug>laravel-edit-observes :e <c-r>=FindGitDirOrRoot()<cr>/app/Observers/<cr>
  LMap N <leader>lp <Plug>laravel-edit-providers :e <c-r>=FindGitDirOrRoot()<cr>/app/Providers/<cr>
  LMap N <leader>lP <Plug>laravel-edit-public :e <c-r>=FindGitDirOrRoot()<cr>/public/<cr>
  LMap N <leader>lv <Plug>laravel-edit-views :e <c-r>=FindGitDirOrRoot()<cr>/resources/views/<cr>
  LMap N <leader>lm <Plug>laravel-edit-migrations :e <c-r>=FindGitDirOrRoot()<cr>/database/migrations/<cr>
  LMap N <leader>lf <Plug>laravel-edit-factories :e <c-r>=FindGitDirOrRoot()<cr>/database/factories/<cr>
  LMap N <leader>ls <Plug>laravel-edit-seeds :e <c-r>=FindGitDirOrRoot()<cr>/database/seeds/<cr>
  LMap N <leader>lc <Plug>laravel-edit-controllers :e <c-r>=FindGitDirOrRoot()<cr>/app/Http/Controllers<cr>
  LMap N <leader>lr <Plug>laravel-edit-requests :e <c-r>=FindGitDirOrRoot()<cr>/app/Http/Requests/<cr>

  " Java
  "nnoremap  <leader>ej : exe "!cd " . shellescape(expand("%:h")) . " && javac " . expand ("%:t") . " && java " . expand("%:t:r")<cr>
  LMap N  <leader>ej <Plug>execute-java :call ExecuteJava()<cr>
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



  "rename text under curser or visually selected
  nnoremap gr *yiw:%s//<c-r>"/g<left><left>
  vnoremap gr y:%s/<c-r>"/<c-r>"/g<left><left>
