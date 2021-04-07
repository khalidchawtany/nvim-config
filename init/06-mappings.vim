
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
LMap N <leader>td <Plug>tab-split :tab split<cr>
LMap N <leader>tt <Plug>tab-terminal :tabnew \| e term://zsh<cr>
LMap N <leader>th <Plug>tab-help :tab help<space>
LMap N <leader>tm0 <Plug>tab-move-first :tabmove 0<cr>

" Utils {{{
"===============================================================================
"
" nnoremap <expr> n 'Nn'[v:searchforward]
" nnoremap <expr> N 'nN'[v:searchforward]
nnoremap <expr> n (v:searchforward ? 'nzz' : 'Nzz')
nnoremap <expr> N (v:searchforward ? 'Nzz' : 'nzz')

nnoremap ]] ]]zz
nnoremap ][ ][zz
nnoremap [[ [[zz
nnoremap [] []zz


nnoremap c* *Ncgn

nnoremap <Leader><Leader> <c-^>

vnoremap <c-d> "dyo<esc>"dp

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

nnoremap <silent><nowait> <BS> :syntax sync minlines=1000<cr>:nohlsearch \| echo "" \|redraw! \| diffupdate \| normal \<Plug>(FastFoldUpdate) \| silent! call clever_f#reset()  <cr>

nnoremap <F12> :call ToggleMouseFunction()<cr>


nnoremap <c-s><space> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

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

nnoremap <c-w>O            :wincmd o\|tabonly\|BufOnly<cr>
nnoremap <c-;>wo           :tabonly \| BufOnly<cr>

nnoremap <c-;>wa           :BufOnly -1<cr>
nmap     <c-;>ww           <Plug>BW
nnoremap <silent> <c-;>wu  :silent! WipeoutUnmodified<cr>
nnoremap <c-;><c-;>wa      :tabonly \| BufOnly \| bufdo execute ":bw!"<cr>

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

cnoremap <D-v> <C-R>+
tnoremap <D-v> <C-\><C-N>pi
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

LMap N <leader>t<space>    <SID>TabOnly  :tabonly<cr>
LMap N <leader>q<space>    <SID>QuitTab  :tabclose<cr>
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

    if has('mac')
        LMap N <leader>ev    <SID>Vimrc           :tabe ~/.config/nvim/init<cr>
        LMap N <leader>eg    <SID>gVimrc          :if has("nvim") \| tabe ~/.config/nvim/ginit.vim \| else \| tabe ~/.gvimrc \| endif<cr>
    elseif has('win64')
        LMap N <leader>ev    <SID>Vimrc           :tabe C:\Users\JuJu\AppData\Local\nvim\init<cr>
        LMap N <leader>eg    <SID>gVimrc          :if has("nvim") \| tabe C:\Users\JuJu\AppData\Local\nvim\ginit.vim \| else \| tabe ~/.gvimrc \| endif<cr>
    endif
    LMap N <leader>e<BS> <SID>discard-changes :e! \| echo "changes discarded"<cr>

  "CD into:
  "current buffer file dir
  nnoremap cdf :lcd %:p:h<cr>:pwd<cr>
  nnoremap cd. :lcd <c-r>=fnamemodify(expand('%:h'), ':h')<cr><cr>:pwd<cr>

  nnoremap cdp :lcd <c-r>=GetPluginPath()<cr><cr>:pwd<cr>

  fun! GetPluginPath()
    let dirs = split(expand('%:p'), '/')
    let idx = index(dirs, 'plugins')
  "  filter(split(expand('%:h'), '/'), 'v:val == "plugins"')
    if(idx == -1)
      return '.'
    endif

    let path = '/'.join(dirs[:idx + 2], '/')
    return path
  endf

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

  LMap !N <leader>fp <Plug>copy-file-path :let @+=expand("%:p")<cr>:echo "Copied current file  path '".expand("%:p")."' to clipboard"<cr>
  LMap !N <leader>fn <Plug>copy-file-name :let @+=expand("%:p:t")<cr>:echo "Copied current file  path '".expand("%:p:t")."' to clipboard"<cr>

  " rename current buffers file
  LMap N <leader>fr <Plug>rename-file :call RenameFile()<cr>

  LMap N <leader>tp <Plug>todo-project :e <c-r>=FindGitDirOrRoot()<cr>/todo.org<cr>
  LMap N <leader>to <Plug>todo-global :e ~/org/todo.org<cr>
  LMap N <leader>Tp <Plug>todo-project-tab :tabe <c-r>=FindGitDirOrRoot()<cr>/todo.org<cr>
  LMap N <leader>To <Plug>todo-global-tab :tabe ~/org/todo.org<cr>

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

function! FindFile(path, ...)

  let root = FindGitDirOrRoot()

  let isOctober = isdirectory(root. '/plugins')
  let path = a:path

  if isOctober
    let currentFilePath = expand('%:.:h')

    if (stridx(expand('%:.:h'), 'plugins') >= 0)
      let firstPathSep = stridx(currentFilePath, '/', 8)
      let pluginPathSep = stridx(currentFilePath, '/', firstPathSep + 1)
      let pluginPath =  currentFilePath[:pluginPathSep]
      if (a:0 == 1)
        let path = pluginPath . a:1
      else
        let path = pluginPath . path
      endif
    else
      let path = root . '/plugins/'
    endif

  endif

  return path
endfunction


  "in test dd response
  nnoremap <leader>dr A;<cr>dd($response);<esc>jI$response<esc>
  "dd for selected variable
  vnoremap <leader>dd "ryodd(<c-r>r);<esc>
  vnoremap <leader>da "ryodd(<c-r>r->toArray());<esc>

  " Concole log
  nnoremap  <leader>cl "ryiwoconsole.log(<c-r>r);<esc>

  LMap N <leader>jr <Plug>laravel-edit-js-router      :e <c-r>=FindFile('/resources/assets/js/router.js')<cr><cr>
  LMap N <leader>jn <Plug>laravel-edit-js-navbar      :e <c-r>=FindFile('/resources/assets/js/components/navbar.vue')<cr><cr>
  LMap N <leader>jv <Plug>laravel-edit-js-views       :FzfFiles <c-r>=FindFile('/resources/assets/js/views/')<cr><cr>
  LMap N <leader>js <Plug>laravel-edit-js-store       :FzfFiles <c-r>=FindFile('/resources/assets/js/store/')<cr><cr>
  LMap N <leader>jd <Plug>laravel-edit-js-database    :FzfFiles <c-r>=FindFile('/resources/assets/js/database/')<cr><cr>
  LMap N <leader>jm <Plug>laravel-edit-js-models      :FzfFiles <c-r>=FindFile('/resources/assets/js/models/')<cr><cr>
  LMap N <leader>ja <Plug>laravel-edit-js-models      :FzfFiles <c-r>=FindFile('/resources/assets/js/models/')<cr><cr>

  LMap N <leader>jj <Plug>laravel-edit-assets-js      :FzfFiles <c-r>=FindFile('/resources/assets/js/')<cr><cr>
  LMap N <leader>jc <Plug>laravel-edit-js-components  :FzfFiles <c-r>=FindFile('/resources/assets/js/Components/')<cr><cr>
  LMap N <leader>jp <Plug>laravel-edit-js-pages      :FzfFiles <c-r>=FindFile('/resources/assets/js/Pages/')<cr><cr>
  LMap N <leader>jP <Plug>laravel-edit-js-plugins      :FzfFiles <c-r>=FindFile('/resources/assets/js/Plugins/')<cr><cr>
  LMap N <leader>ju <Plug>laravel-edit-js-utils      :FzfFiles <c-r>=FindFile('/resources/assets/js/Utils/')<cr><cr>
  LMap N <leader>jl <Plug>laravel-edit-js-layouts      :FzfFiles <c-r>=FindFile('/resources/assets/js/Layouts/')<cr><cr>

  LMap N <leader>Jr <Plug>laravel-tabedit-js-router      :tabe <c-r>=FindFile('/resources/assets/js/router.js')<cr><cr>
  LMap N <leader>Jn <Plug>laravel-edit-js-navbar         :tabe <c-r>=FindFile('/resources/assets/js/components/navbar.vue')<cr><cr>
  LMap N <leader>Jj <Plug>laravel-tabedit-assets-js      :tabe <c-r>=FindFile('/resources/assets/js/')<cr><cr>
  LMap N <leader>Jv <Plug>laravel-tabedit-js-views       :tabe <c-r>=FindFile('/resources/assets/js/views/')<cr><cr>
  LMap N <leader>Js <Plug>laravel-tabedit-js-store       :tabe <c-r>=FindFile('/resources/assets/js/store/')<cr><cr>
  LMap N <leader>Jc <Plug>laravel-tabedit-js-components  :tabe <c-r>=FindFile('/resources/assets/js/components/')<cr><cr>
  LMap N <leader>Jd <Plug>laravel-tabedit-js-database    :tabe <c-r>=FindFile('/resources/assets/js/database/')<cr><cr>
  LMap N <leader>Jm <Plug>laravel-tabedit-js-models      :tabe <c-r>=FindFile('/resources/assets/js/models/')<cr><cr>
  LMap N <leader>Ja <Plug>laravel-tabedit-js-models      :tabe <c-r>=FindFile('/resources/assets/js/models/')<cr><cr>

  LMap N <leader>lw <Plug>laravel-edit-public-web      :e <c-r>=FindFile('/routes/')<cr><cr>
  LMap N <leader>lu <Plug>laravel-edit-public          :e <c-r>=FindFile('/public/')<cr><cr>
  LMap N <leader>lj <Plug>laravel-edit-public-js       :FzfFiles <c-r>=FindFile('/public/js/')<cr><cr>
  LMap N <leader>lR <Plug>laravel-edit-resources       :FzfFiles <c-r>=FindFile('/resources/')<cr><cr>
  LMap N <leader>la <Plug>laravel-edit-app             :FzfFiles <c-r>=FindFile('/app/', 'models')<cr><cr>
  LMap N <leader>ll <Plug>laravel-edit-lang             :tabe <c-r>=FindFile('/lan/', 'lang')<cr><cr>
  LMap N <leader>le <Plug>laravel-edit-event             :tabe <c-r>=FindFile('/app/events/', 'classes/collection/event')<cr><cr>
  LMap N <leader>lc <Plug>laravel-edit-controllers     :FzfFiles <c-r>=FindFile('/app/Http/Controllers', 'controllers')<cr><cr>
  LMap N <leader>lf <Plug>laravel-edit-factories       :FzfFiles <c-r>=FindFile('/database/factories/')<cr><cr>
  LMap N <leader>lh <Plug>laravel-edit-helpers         :FzfFiles <c-r>=FindFile('/app/Helpers/')<cr><cr>
  LMap N <leader>lm <Plug>laravel-edit-migrations      :FzfFiles <c-r>=FindFile('/database/migrations/', 'updates')<cr><cr>
  LMap N <leader>lo <Plug>laravel-edit-observes        :FzfFiles <c-r>=FindFile('/app/Observers/')<cr><cr>
  LMap N <leader>lp <Plug>laravel-edit-providers       :FzfFiles <c-r>=FindFile('/app/Providers/', '/')<cr><cr>
  LMap N <leader>lr <Plug>laravel-edit-requests        :FzfFiles <c-r>=FindFile('/app/Http/Requests/')<cr><cr>
  LMap N <leader>ls <Plug>laravel-edit-seeds           :FzfFiles <c-r>=FindFile('/database/seeds/')<cr><cr>
  LMap N <leader>lT <Plug>laravel-edit-traits          :FzfFiles <c-r>=FindFile('/app/traits/')<cr><cr>
  LMap N <leader>lt <Plug>laravel-edit-tests           :FzfFiles <c-r>=FindFile('/tests/')<cr><cr>
  LMap N <leader>lv <Plug>laravel-edit-views           :FzfFiles <c-r>=FindFile('/resources/views/')<cr><cr>
  LMap N <leader>lB <Plug>laravel-edit-breads          :FzfFiles <c-r>=FindFile('/resources/bread/')<cr><cr>
  LMap N <leader>lbb <Plug>laravel-edit-breads         :FzfFiles <c-r>=FindFile('/resources/bread/')<cr><cr>
  LMap N <leader>lbc <Plug>laravel-edit-bread-command  :e <c-r>=FindFile('/vendor/Kjdion84/laraback/src/Commands/BreadCommand.php')<cr><cr>
  LMap N <leader>lbs <Plug>laravel-edit-bread-stubs    :e <c-r>=FindFile('/vendor/Kjdion84/laraback/resources/bread/stubs/default/')<cr><cr>

  LMap N <leader>Lu <Plug>laravel-tabedit-public          :tabe <c-r>=FindFile('/public/')<cr><cr>
  LMap N <leader>Lj <Plug>laravel-tabedit-public-js       :tabe <c-r>=FindFile('/public/js/')<cr><cr>
  LMap N <leader>LR <Plug>laravel-tabedit-resources       :tabe <c-r>=FindFile('/resources/')<cr><cr>
  LMap N <leader>Lw <Plug>laravel-tabedit-public-web      :tabe <c-r>=FindFile('/routes/')<cr><cr>
  LMap N <leader>La <Plug>laravel-tabedit-app             :tabe <c-r>=FindFile('/app/', 'models')<cr><cr>
  LMap N <leader>Ll <Plug>laravel-tabedit-lang             :tabe <c-r>=FindFile('/lan/', 'lang')<cr><cr>
  LMap N <leader>Le <Plug>laravel-tabedit-event             :tabe <c-r>=FindFile('/app/events/', 'classes/collection/event')<cr><cr>
  LMap N <leader>Lc <Plug>laravel-tabedit-controllers     :tabe <c-r>=FindFile('/app/Http/Controllers', 'controllers')<cr><cr>
  LMap N <leader>Lf <Plug>laravel-tabedit-factories       :tabe <c-r>=FindFile('/database/factories/')<cr><cr>
  LMap N <leader>Lh <Plug>laravel-tabedit-helpers         :tabe <c-r>=FindFile('/app/Helpers/')<cr><cr>
  LMap N <leader>Lm <Plug>laravel-tabedit-migrations      :tabe <c-r>=FindFile('/database/migrations/', 'updates')<cr><cr>
  LMap N <leader>Lo <Plug>laravel-tabedit-observes        :tabe <c-r>=FindFile('/app/Observers/')<cr><cr>
  LMap N <leader>Lp <Plug>laravel-tabedit-providers       :tabe <c-r>=FindFile('/app/Providers/', '/plugins')<cr><cr>
  LMap N <leader>Lr <Plug>laravel-tabedit-requests        :tabe <c-r>=FindFile('/app/Http/Requests/')<cr><cr>
  LMap N <leader>Ls <Plug>laravel-tabedit-seeds           :tabe <c-r>=FindFile('/database/seeds/')<cr><cr>
  LMap N <leader>LT <Plug>laravel-tabedit-traits          :tabe <c-r>=FindFile('/app/traits/')<cr><cr>
  LMap N <leader>Lt <Plug>laravel-tabedit-tests           :tabe <c-r>=FindFile('/tests/')<cr><cr>
  LMap N <leader>Lv <Plug>laravel-tabedit-views           :tabe <c-r>=FindFile('/resources/views/')<cr><cr>
  LMap N <leader>LB <Plug>laravel-tabedit-breads          :tabe <c-r>=FindFile('/resources/bread/')<cr><cr>
  LMap N <leader>Lbb <Plug>laravel-tabedit-breads         :tabe <c-r>=FindFile('/resources/bread/')<cr><cr>
  LMap N <leader>Lbc <Plug>laravel-tabedit-bread-command  :tabe <c-r>=FindFile('/vendor/Kjdion84/laraback/src/Commands/BreadCommand.php')<cr><cr>
  LMap N <leader>Lbs <Plug>laravel-tabedit-bread-stubs    :tabe <c-r>=FindFile('/vendor/Kjdion84/laraback/resources/bread/stubs/default/')<cr><cr>

  " Java
  "nnoremap  <leader>ej : exe "!cd " . shellescape(expand("%:h")) . " && javac " . expand ("%:t") . " && java " . expand("%:t:r")<cr>
  LMap N  <leader>ej <Plug>execute-java :call ExecuteJava()<cr>
  function! ExecuteJava()
    write
    exe "vsplit"
    exe "term cd " . shellescape(expand("%:h")) . " && javac " . expand ("%:t") . " && java " . expand("%:t:r")
    exe "startinsert"
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
  " nnoremap gr *yiw:%s//<c-r>"/g<left><left>
  nnoremap geR "xyiw:s/<c-r>x//g<left><left>
  nnoremap ger "xyiw:%S/<c-r>x//g<left><left>

  vnoremap geR y:s/<c-r>"/<c-r>"/g<left><left>
  vnoremap ger y:%S/<c-r>"/<c-r>"/g<left><left>

  nnoremap <leader>ji gg/import<cr>
