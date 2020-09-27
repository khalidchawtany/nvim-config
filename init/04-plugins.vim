 " prevent_vimrc_double_source {{{
if exists('g:_did_vimrc_plugins')
    finish
endif

let g:_did_vimrc_plugins = 1
 "}}} _ prevent_vimrc_double_source

" Libraries {{{

 " vital.vim {{{

 "Make vim faster with Vitalize
 call PM("vim-jp/vital.vim")

 "}}} _vital.vim

"}}}

 " Version Control & Diff {{{

 " vim-fugitive {{{

 if PM( 'tpope/vim-fugitive'
       \ , { 'on_cmd': [
       \     'Git', 'Gcd',     'Glcd',   'Gstatus',
       \     'Gcommit',  'Gmerge',  'Gpull',  'Gpush',
       \     'Gfetch',   'Ggrep',   'Glgrep', 'Glog',
       \     'Gllog',    'Gedit',   'Gsplit', 'Gvsplit',
       \     'Gtabedit', 'Gpedit',  'Gread',  'Gwrite',
       \     'Gwq',      'Gdiff',   'Gsdiff', 'Gvdiff',
       \     'Gmove', 'Gremove', 'Gblame', 'Gbrowse' ],
       \     'on_func': ['FugitiveDetect'],
       \     'on_ft': ['git'],
       \     'hook_post_source': "call FugitiveDetect(expand('%:p')) | if exists('g:NewFugitiveFile') | edit % | endif"
       \ })

   autocmd User fugitive
         \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
         \   nnoremap <buffer> .. :edit %:h<CR> |
         \ endif
   autocmd BufReadPost fugitive://* set bufhidden=delete
   " autocmd BufEnter * if &ft=="fugitive" | call feedkeys("o") | endif
   autocmd BufNewFile  fugitive://* call PM_SOURCE('vim-fugitive') | let g:NewFugitiveFile=1 | call feedkeys(';<BS>')
   " set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
    LMap N <leader>gs <SID>Status  :call FugitiveDetect(expand('%:p')) \| :Gstatus<cr>
    LMap N <leader>g<leader> <SID>TabStatus  :call FugitiveDetect(getcwd()) \| :Gtabedit :<cr>
    LMap N <leader>gc <SID>Commit  :call FugitiveDetect(getcwd()) \| execute ":Gcommit"<cr>
    LMap N <leader>gp <SID>Pull    :call FugitiveDetect(getcwd()) \| execute ":Gpull"<cr>
    LMap N <leader>gu <SID>Push    :call FugitiveDetect(getcwd()) \| execute ":Gpush" \| echo "Pushed :)"<cr>
    LMap N <leader>gr <SID>Read    :call FugitiveDetect(getcwd()) \| execute ":Gread"<cr>
    LMap N <leader>gw <SID>Write   :call FugitiveDetect(getcwd()) \| execute ":Gwrite"<cr>
    LMap N <leader>gdv <SID>V-Diff :call FugitiveDetect(getcwd()) \| execute ":Gvdiff"<cr>
    LMap N <leader>gds <SID>S-Diff :call FugitiveDetect(getcwd()) \| execute ":Gdiff"<cr>

    LMap N <leader>g<cr> <SID>FixLN :call FugitiveDetect(getcwd()) \| execute ":Gread\|Gwrite"<cr>
   " Fugitive Conflict Resolution
   nnoremap gdh :diffget //2<CR>
   nnoremap gdl :diffget //3<CR>

 endif
 "}}} _vim-fugitive
 " vim-twiggy{{{
 if PM('sodapopcan/vim-twiggy', {'on_cmd': 'Twiggy'})
     LMap N <leader>gb <SID>Twiggy :Twiggy<cr>
 endif
 " }}}
 " gv.vim {{{

   "Requires vim-fugitive
   if PM( 'junegunn/gv.vim', {
         \ 'depends': 'vim-fugitive',
         \ 'on_cmd': ['GV', 'GV!', 'GV?']
         \ })

     LMap N <leader>gl <SID>Log :GV<cr>
   endif

 "}}} _gv.vim
 "gitv {{{
 if PM("gregsexton/gitv",  {'on_cmd': ['Gitv']})
     LMap N <leader>gv <SID>Gitv :Gitv<cr>
 endif
 " }}}
 " vimagit {{{

 if PM( 'jreybert/vimagit', {'on_cmd': ['Magit'], 'on_map': ['\<leader>gm'], 'rev': 'next'} )
   " Don't show help as it can be toggled by h
   let g:magit_show_help=0
   "nnoremap <leader>G :Magit<cr>
   let g:magit_show_magit_mapping=''
   LMap N <leader>gm <SID>Magit :Magit<cr>
 endif
 "}}} _vimagit
 " DirDiff.vim {{{

   call PM( 'vim-scripts/DirDiff.vim', {'on_cmd': ['DirDiff']} )

 "}}} _DirDiff.vim
 "{{{ git-messenger.vim
  if PM('rhysd/git-messenger.vim', {
              \   'lazy' : 1,
              \   'on_cmd' : 'GitMessenger',
              \   'on_map' : '<Plug>(git-messenger',
              \ })
    let g:git_messenger_no_default_mappings = 1

   LMap N <leader>gg <SID>Git_Messenger :GitMessenger<cr>

  endif
 "}}} git-messenger.vim
 " vim-conflicted {{{
 if PM('christoomey/vim-conflicted',  {'on_cmd': ['Conflicted', 'Merger', 'GitNextConflict']})
     set stl+=%{ConflictedVersion()}
     " Use `gl` and `gu` rather than the default conflicted diffget mappings
     let g:diffget_local_map = 'gl'
     let g:diffget_upstream_map = 'gu'
     LMap N <leader>g] <SID>GitNextConflict :GitNextConflict<cr>
     LMap N <leader>g[ <SID>Conflicted :Conflicted<cr>

 endif
 " }}}
 " diffconflicts {{{
 call PM('whiteinge/diffconflicts', {'on_cmd': ['DiffConflicts']})
 " }}} _ diffconflicts

 "}}}

 " Content Editor {{{

 " Org
 " vim-notes {{{
 if PM('xolox/vim-notes')
     let g:notes_directories = ['~/Development/Notes']
     let g:notes_suffix = '.note'
     au BufEnter *.note syntax match notesXXX /\[[a-zA-Z]\]/
 endif
 "}}}
 " vim-speeddating {{{

   call PM( 'tpope/vim-speeddating', {'on_ft': ['org'], 'on_cmd': ['SpeedDatingFormat'], 'on_map': ['<Plug>SpeedDatingUp', '<Plug>SpeedDatingDown']} )

 "}}} _vim-speeddating
 " vim-orgmode {{{

   if PM( 'jceb/vim-orgmode', {'on_ft': 'org', 'merged': 1} )
     let g:org_agenda_files=['~/org/index.org']
     let g:org_todo_keywords=['TODO', 'FEEDBACK', 'VERIFY', 'WIP', '|', 'DONE', 'DELEGATED']
     let g:org_heading_shade_leading_stars = 1   "Hide the star noise
   endif

 "}}} _vim-orgmode
 "SyntaxRange {{{

    call PM('vim-scripts/SyntaxRange')

 "}}} _SyntaxRange
 "utl.vim{{{
   call PM( 'vim-scripts/utl.vim' )
 "_utl.vim}}}
 " vim-table-mode {{{

 if PM( 'dhruvasagar/vim-table-mode', {'on_cmd': ['TableModeEnable', 'TableModeToggle', 'Tableize']} )
   let g:table_mode_corner_corner="+"
   let g:table_mode_header_fillchar="="
 endif

 "}}} _vim-table-mode
 "{{{ Kronos.vim
 if PM('soywod/kronos.vim', {'on_map':['<plug>(kronos-'] })
   " nmap <cr>   <plug>(kronos-toggle)
   nmap K      <plug>(kronos-info)
   nmap gc     <plug>(kronos-context)
   nmap gh     <plug>(kronos-hide-done)
   nmap gw     <plug>(kronos-worktime)
   nmap <c-n>  <plug>(kronos-next-cell)
   nmap <c-p>  <plug>(kronos-prev-cell)
   nmap dic    <plug>(kronos-delete-in-cell)
   nmap cic    <plug>(kronos-change-in-cell)
   nmap vic    <plug>(kronos-visual-in-cell)
 endif
 "}}}"

 " Multi-edits

 " ag.vim {{{
 if PM('rking/ag.vim')
     call PM('Chun-Yang/vim-action-ag')
 endif
 "}}} _ag.vim

 "ack.vim {{{
 if PM('mileszs/ack.vim')
     if executable('ag')
         let g:ackprg = 'ag --vimgrep'
     endif
 endif
 "}}} _ack.vim
 " vim-fnr {{{

   "Requires pseudocl
   call PM( 'junegunn/vim-fnr', {'on_map': ['<Plug>(FNR)','<Plug>(FNR%)']} )

   " Defaults
   let g:fnr_flags   = 'gc'
   let g:fnr_hl_from = 'Todo'
   let g:fnr_hl_to   = 'IncSearch'

   "custom mapping
   nmap g;S <Plug>(FNR)
   xmap g;S <Plug>(FNR)
   nmap g;s <Plug>(FNR%)
   xmap g;s <Plug>(FNR%)

   " Special keys

   " Tab
       " i - case-insensitive match
       " w - word-boundary match (\<STRING\>)
       " g - substitute all occurrences
       " c - confirm each substitution
       " Tab or Enter to return
   " CTRL-N or CTRL-P
       " Auto-completion

 "}}}
 " vim-esearch {{{
 if PM('eugen0329/vim-esearch')
     au VimEnter * call SetEsearchMaps()
     function! SetEsearchMaps()
        " Start esearch prompt autofilled with one of g:esearch.use initial patterns
        call esearch#map('<leader>ff', 'esearch')
        " Start esearch autofilled with a word under the cursor
        call esearch#map('<leader>fw', 'esearch-word-under-cursor')

        call esearch#out#win#map('t',       'tab')
        call esearch#out#win#map('i',       'split')
        call esearch#out#win#map('s',       'vsplit')
        call esearch#out#win#map('<Enter>', 'open')
        call esearch#out#win#map('o',       'open')

        "    Open silently (keep focus on the results window)
        call esearch#out#win#map('T', 'tab-silent')
        call esearch#out#win#map('I', 'split-silent')
        call esearch#out#win#map('S', 'vsplit-silent')

        "    Move cursor with snapping
        call esearch#out#win#map('<C-n>', 'next')
        call esearch#out#win#map('<C-j>', 'next-file')
        call esearch#out#win#map('<C-p>', 'prev')
        call esearch#out#win#map('<C-k>', 'prev-file')

        call esearch#cmdline#map('<C-o><C-r>', 'toggle-regex')
        call esearch#cmdline#map('<C-o><C-s>', 'toggle-case')
        call esearch#cmdline#map('<C-o><C-w>', 'toggle-word')
        call esearch#cmdline#map('<C-o><C-h>', 'cmdline-help')
     endfunction
 endif
 "}}} _vim-esearch
 " vim-enmasse {{{

   call PM( 'Wolfy87/vim-enmasse',         { 'on_cmd': 'EnMasse'} )
   " EnMass the sublime like search and edit then save back to corresponding files

 "}}} _vim-enmasse
 " vim-swoop {{{

   call PM( 'pelodelfuego/vim-swoop', {'on_cmd': ['Swoop'], 'on_func':['Swoop', 'SwoopSelection', 'SwoopMulti', 'SwoopMultiSelection']} )
   let g:swoopUseDefaultKeyMap = 0

   LMap N <Leader>sm <Plug>swoop-multi :call SwoopMulti()<CR>
   LMap V <Leader>sm <Plug>swoop-multi :call SwoopMulti()<CR>
   LMap N <Leader>ss <Plug>swoop :call Swoop()<CR>
   LMap V <Leader>ss <Plug>swoop :call Swoop()<CR>

   function! Multiple_cursors_before()
     if exists('*SwoopFreezeContext') != 0
       call SwoopFreezeContext()
     endif
   endfunction

   function! Multiple_cursors_after()
     if exists('*SwoopUnFreezeContext') != 0
       call SwoopUnFreezeContext()
     endif
   endfunction

 "}}} _vim-swoop
 " vim-ags {{{

 call PM( 'gabesoft/vim-ags', {'on_cmd': ['Ags']} )

 "}}} _vim-ags
 " vim-multiple-cursors {{{

   call PM( 'terryma/vim-multiple-cursors' )

   let g:multi_cursor_use_default_mapping=0
   "Use ctrl-n to select next instance
    " Default mapping
    let g:multi_cursor_next_key='<C-n>'
    let g:multi_cursor_prev_key='<C-p>'
    let g:multi_cursor_skip_key='<C-x>'
    let g:multi_cursor_quit_key='<Esc>'

 "}}} _vim-multiple-cursors
 " vim-visual-multi {{{
 if PM('mg979/vim-visual-multi')
   fun! VM_Start()
     "this only works in devel branch, currently
     " highlightedyankoff
   endfun

   fun! VM_exit()
     " highlightedyankon
   endfun
   " let g:vm_plugins_compatibilty = {
   "       \'autopairs': {
   "       \   'var': 'b:autopairs_enabled',
   "       \   'maps': 'call autopairsinit()',
   "       \   'enable': 'let b:autopairs_enabled = 1',
   "       \   'disable': 'let b:autopairs_enabled = 0'}
   "       \}
 endif
 " }}}
 " vim-abolish {{{

   call PM( 'tpope/vim-abolish',           { 'on_cmd': ['S','Subvert', 'Abolish']} )

 "}}} _vim-abolish
 " vim-rengbang {{{

   call PM( 'deris/vim-rengbang',          { 'on_cmd': [ 'RengBang', 'RengBangUsePrev' ] } )

   "Use instead of increment it is much powerfull
   " RengBang \(\d\+\) Start# Increment# Select# %03d => 001, 002

 "}}} _vim-rengbang

 " vim-expand-region {{{

 "select something and press +,_
call PM('terryma/vim-expand-region')

"TODO: fix theses mappings
" map gj <Plug>(expand_region_expand)
" map gk <Plug>(expand_region_shrink)

 "}}} _vim-expand-region

 " Isolate
 " inline_edit.vim {{{

   call PM( 'AndrewRadev/inline_edit.vim', { 'on_cmd': ['InlineEdit']} )
   xnoremap <leader>ei <cmd>InlineEdit<cr>

 "}}} _inline_edit.vim
 " NrrwRgn {{{

 if PM( 'chrisbra/NrrwRgn', {
       \ 'on_cmd':
       \   [
       \    'NR', 'NarrowRegion', 'NW', 'NarrowWindow', 'WidenRegion',
       \    'NRV', 'NUD', 'NRPrepare', 'NRP', 'NRMulti', 'NRM',
       \    'NRS', 'NRNoSyncOnWrite', 'NRN', 'NRL', 'NRSyncOnWrite'
       \   ],
       \ 'on_map': ['<Plug>NrrwrgnDo']
       \ })

    LMap NVX <leader>rn <Plug>narrow-region <Plug>NrrwrgnDo

 endif

 "}}} _NrrwRgn

 " Yank
 "markbar {{{
if PM('Yilin-Yang/vim-markbar', {'on_map': ['<Plug>ToggleMarkbar']})
    nmap <leader>'' <Plug>ToggleMarkbar
endif
"}}} _markbar
 " UnconditionalPaste {{{

   if PM( 'vim-scripts/UnconditionalPaste', {'on_map': ['<Plug>UnconditionalPaste']} )
    Map n gPP  <Plug>UnconditionalPasteGPlusBefore
    Map n gPp  <Plug>UnconditionalPasteGPlusAfter
    Map n gpP  <Plug>UnconditionalPastePlusBefore
    Map n gpp  <Plug>UnconditionalPastePlusAfter
    Map n gUP  <Plug>UnconditionalPasteRecallUnjoinBefore
    Map n gUp  <Plug>UnconditionalPasteRecallUnjoinAfter
    Map n guP  <Plug>UnconditionalPasteUnjoinBefore
    Map n gup  <Plug>UnconditionalPasteUnjoinAfter
    Map n gQP  <Plug>UnconditionalPasteRecallQueriedBefore
    Map n gQp  <Plug>UnconditionalPasteRecallQueriedAfter
    Map n gqP  <Plug>UnconditionalPasteQueriedBefore
    Map n gqp  <Plug>UnconditionalPasteQueriedAfter
    Map n gQBP <Plug>UnconditionalPasteRecallDelimitedBefore
    Map n gQBp <Plug>UnconditionalPasteRecallDelimitedAfter
    Map n gqbP <Plug>UnconditionalPasteDelimitedBefore
    Map n gqbp <Plug>UnconditionalPasteDelimitedAfter
    Map n gBP  <Plug>UnconditionalPasteJaggedBefore
    Map n gBp  <Plug>UnconditionalPasteJaggedAfter
    Map n gsP  <Plug>UnconditionalPasteSpacedBefore
    Map n gsp  <Plug>UnconditionalPasteSpacedAfter
    Map n g#P  <Plug>UnconditionalPasteCommentedBefore
    Map n g#p  <Plug>UnconditionalPasteCommentedAfter
    Map n g>P  <Plug>UnconditionalPasteShiftedBefore
    Map n g>p  <Plug>UnconditionalPasteShiftedAfter
    Map n g[[P <Plug>UnconditionalPasteLessIndentBefore
    Map n g[[p <Plug>UnconditionalPasteLessIndentAfter
    Map n g]]P <Plug>UnconditionalPasteMoreIndentBefore
    Map n g]]p <Plug>UnconditionalPasteMoreIndentAfter
    Map n g]p  <Plug>UnconditionalPasteIndentedAfter
    Map n g[p  <Plug>UnconditionalPasteIndentedBefore
    Map n g[P  <Plug>UnconditionalPasteIndentedBefore
    Map n g]P  <Plug>UnconditionalPasteIndentedBefore
    Map n g,"P <Plug>UnconditionalPasteCommaDoubleQuoteBefore
    Map n g,"p <Plug>UnconditionalPasteCommaDoubleQuoteAfter
    Map n g,'P <Plug>UnconditionalPasteCommaSingleQuoteBefore
    Map n g,'p <Plug>UnconditionalPasteCommaSingleQuoteAfter
    Map n g,P  <Plug>UnconditionalPasteCommaBefore
    Map n g,p  <Plug>UnconditionalPasteCommaAfter
    Map n gbP  <Plug>UnconditionalPasteBlockBefore
    Map n gbp  <Plug>UnconditionalPasteBlockAfter
    Map n glP  <Plug>UnconditionalPasteLineBefore
    Map n glp  <Plug>UnconditionalPasteLineAfter
    Map n gcP  <Plug>UnconditionalPasteCharBefore
    Map n gcp  <Plug>UnconditionalPasteCharAfter
   endif

 "}}} _UnconditionalPaste

 " vim-copy-as-rtf {{{

 call PM( 'zerowidth/vim-copy-as-rtf', {'on_cmd': ['CopyRTF'], 'platform':'mac'} )

 "}}} _vim-copy-as-rtf

 " Single-edits
 " switch.vim {{{

   call PM( 'AndrewRadev/switch.vim', {'on_cmd':  ['Switch']} )

 "}}} _switch.vim
 " vim-exchange {{{

   call PM( 'tommcdo/vim-exchange', {'on_cmd':  ['ExchangeClear'] , 'on_map': ['<Plug>(Exchange']} )
   xmap c<cr><cr> <Plug>(Exchange)
   nmap c<cr>l    <Plug>(ExchangeLine)
   nmap c<cr>c    <Plug>(ExchangeClear)
   nmap c<cr><bs> <Plug>(ExchangeClear)
   nmap c<cr><cr> <Plug>(Exchange)

 "}}} _vim-exchange

 " tabular {{{

   call PM( 'godlygeek/tabular', {'on_cmd': ['Tabularize']} )

   nnoremap <leader>a& :Tabularize /&<CR>
   vnoremap <leader>a& :Tabularize /&<CR>
   nnoremap <leader>a= :Tabularize /=<CR>
   vnoremap <leader>a= :Tabularize /=<CR>
   nnoremap <leader>a: :Tabularize /:<CR>
   vnoremap <leader>a: :Tabularize /:<CR>
   nnoremap <leader>a:: :Tabularize /:\zs<CR>
   vnoremap <leader>a:: :Tabularize /:\zs<CR>
   nnoremap <leader>a> :Tabularize /=><CR>
   vnoremap <leader>a> :Tabularize /=><CR>
   nnoremap <leader>a, :Tabularize /,<CR>
   vnoremap <leader>a, :Tabularize /,<CR>
   nnoremap <leader>a<Bar> :Tabularize /<Bar><CR>
   vnoremap <leader>a<Bar> :Tabularize /<Bar><CR>
   nnoremap <leader>aa :Tabularize
   vnoremap <leader>aa :Tabularize

 "}}} _tabular
 " EasyAlign {{{

   call PM( 'junegunn/vim-easy-align',          {'on_cmd':  ['EasyAlign'], 'on_map':[ '<Plug>(EasyAlign)']} )

   " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
   vmap <Enter> <Plug>(EasyAlign)
   vnoremap g<Enter> :EasyAlign */[(,)]\+/<left><left><left><left>
   " Start interactive EasyAlign for a motion/text object (e.g. gaip)
   nmap g<cr> <Plug>(EasyAlign)
   let g:easy_align_ignore_comment = 0 " align comments

 "}}}
 " vim-sandwich {{{
 if PM('machakann/vim-sandwich')
 endif
 " }}}
 " Join{{{
  if PM('sk1418/Join', {'on_cmd': ['Join']})
  endif
 " }}} _Join
 " splitjoin.vim {{{

 call PM( 'AndrewRadev/splitjoin.vim' ,
       \ {
       \ 'on_map':['gS', 'gJ'],
       \ 'on_cmd': ['SplitjoinSplit', 'SplitjoinJoin'],
       \ 'hook_post_source': "call MapSplitJoin()"
       \ } )

 " Fix for gk/gj(goes to HOME/END) after splitjoin
 function MapSplitJoin()
   nnoremap gS :call Preserve('SplitjoinSplit')<cr>
   nnoremap gJ :call Preserve('SplitjoinJoin')<cr>
 endfunction

 "}}} _splitjoin.vim
 " vim-sort-motion {{{

  call PM( 'christoomey/vim-sort-motion', {'on_map': ['<Plug>Sort']} )
  map  gs  <Plug>SortMotion
  map  gss <Plug>SortLines
  vmap gs  <Plug>SortMotionVisual

 "}}} _vim-sort-motion

 " Comments
 " vim-commentary {{{
 call PM ('tpope/vim-commentary',
       \ {
       \ 'on_map':
       \ [
       \  '<Plug>Commentary',
       \  '<Plug>CommentaryLine',
       \  '<Plug>ChangeCommentary'
       \ ],
       \ 'on_cmd': [ 'Commentary' ]
       \ })
 vmap <leader>cc  <Plug>Commentary
 xmap <leader>cc  <Plug>Commentary
 nmap <leader>cc  <Plug>Commentary
 omap <leader>cc  <Plug>Commentary
 nmap <leader>cc <Plug>CommentaryLine
 nmap <leader>ce <Plug>ChangeCommentary
 nmap <leader>cu <Plug>Commentary<Plug>Commentary
 " }}} _vim-commentary
 " vim-tag-comment {{{
   " Comment out HTML properly
   call PM( 'mvolkmann/vim-tag-comment', {'on_cmd': ['ElementComment', 'ElementUncomment', 'TagComment', 'TagUncomment']} )
   nmap <leader>tc :ElementComment<cr>
   nmap <leader>tu :ElementUncomment<cr>
   nmap <leader>tC :TagComment<cr>
   nmap <leader>tU :TagUncomment<cr>

 "}}} _vim-tag-comment

 "}}}

 " Utils {{{

"codi {{{ The interactve scratchpad soulver alternative
    if PM('metakirby5/codi.vim', {'on_cmd':['Codi']})
    endif
"}}}

 " info-window.nvim {{{
 if PM('mcchrish/info-window.nvim')
     nnoremap <silent> <c-g><c-g> :InfoWindowToggle<cr>

     highlight link InfoWindowFloat StatusLine

     let g:infowindow_lines = [
                 \ " Line: " . line('.'),
                 \ " Column: " . col('.'),
                 \ " File: " . &filetype . ' - ' . &fileencoding . ' [' . &fileformat . ']',
                 \ ]
 endif
 "}}} _ info-window.nvim

 " dein-ui.vim {{{
 " Provies DeinUpdate command
 call PM('wsdjeg/dein-ui.vim', {'on_cmd': 'DeinUpdate'})
 "}}} _ dein-ui.vim

 " replay {{{
 call PM('wincent/replay', {'lazy': 1})
 "}}} _ replay

 " startuptime.vim {{{
 call PM('tweekmonster/startuptime.vim')
 "}}} _ startuptime.vim

 " matchit {{{
 call PM('chrisbra/matchit')
 "}}} _ matchit

 " call PM('rlue/vim-barbaric')
 "vim-xkbswitch {{{
 if PM('lyokha/vim-xkbswitch')
     if has('mac')
         " using https://github.com/vovkasm/input-source-switcher
         let g:XkbSwitchLib = '/Users/juju/Development/Applications/input-source-switcher/build/libInputSourceSwitcher.dylib'
     elseif has('win')
         let g:XkbSwitchLib = 'C:\Development\libxkbswitch64.dll'
         let g:XkbSwitchIMappingsTrData = 'C:\Development\charmap.txt'
     endif
     let g:XkbSwitchEnabled = 1
 endif
 "}}} _vim-xkbswitch

 " vim-fetch {{{
   call PM( 'kopischke/vim-fetch')              "Fixes how vim handles FN(LN:CN)
 "}}} _vim-fetch

 " pipe.vim {{{

   "Pipe !command output to vim
   call PM( 'NLKNguyen/pipe.vim' )
   let g:pipe_no_mappings = 1

   " " Use your key
   " nmap _<bar>     <Plug>PipePrompt
   " nmap <bar><bar> <Plug>PipeLast
   " nmap __         <Plug>PipeToggle
 "}}} _pipe.vim

 "vim-signature {{{
   call PM('kshenoy/vim-signature')
 "}}} _vim-signature'

 " vim-submode {{{
   "call PM( 'kana/vim-submode' )
   if PM( 'khalidchawtany/vim-submode' )
   let g:submode_timeout=0

   function WindowResized()
       if &ft == 'fern'
           let g:fern#drawer_width =  winwidth(0)
       endif
   endfunction

   au VimEnter * call BindSubModes()
   function! BindSubModes()
     " Window resize {{{
       call submode#enter_with('h/l', 'n', '', '<C-w>h', '<C-w><:call WindowResized()<cr>')
       call submode#enter_with('h/l', 'n', '', '<C-w>l', '<C-w>>:call WindowResized()<cr>')
       call submode#map('h/l', 'n', '', 'h', '<C-w><:call WindowResized()<cr>')
       " call submode#map('h/l', 'n', '', 'l', '<C-w>>')
       call submode#map('h/l', 'n', '', 'l', '<C-w>>:call WindowResized()<cr>')
       call submode#enter_with('j/k', 'n', '', '<C-w>j', '<C-w>-:call WindowResized()<cr>')
       call submode#enter_with('j/k', 'n', '', '<C-w>k', '<C-w>+:call WindowResized()<cr>')
       call submode#map('j/k', 'n', '', 'j', '<C-w>-:call WindowResized()<cr>')
       call submode#map('j/k', 'n', '', 'k', '<C-w>+:call WindowResized()<cr>')
     "}}} _Window resize
     " horizontal navigation {{{
       call submode#enter_with('H-Scroll', 'n', '', 'zl', 'zl')
       call submode#enter_with('H-Scroll', 'n', '', 'zh', 'zh')
       call submode#map('H-Scroll', 'n', '', 'l', 'zl')
       call submode#map('H-Scroll', 'n', '', 'h', 'zh')
       call submode#map('H-Scroll', 'n', '', 'k', '10zl')
       call submode#map('H-Scroll', 'n', '', 'j', '10zh')
     "}}} _Window resize
     " colorscheme chooser {{{
      call submode#enter_with('Colorscheme', 'n', '', 'c]c', ':<C-U>exe "NextColorScheme"<cr>')
      call submode#enter_with('Colorscheme', 'n', '', 'c[c', ':<C-U>exe "PrevColorScheme"<cr>')
      call submode#map('Colorscheme', 'n', '', 'j', ':<C-U>exe "NextColorScheme"<cr>')
      call submode#map('Colorscheme', 'n', '', 'k', ':<C-U>exe "PrevColorScheme"<cr>')
      "}}} _colorscheme chooser

     "Toggles FOLD {{{
       call submode#enter_with('toggle-fold', 'n', 's', 'cof', ':<C-U>exe "call ToggleFoldMethod()"<cr>')
       call submode#leave_with('toggle-fold', 'n', 's', '<Esc>')
       call submode#map(       'toggle-fold', 'n', 's', 'f', ':<C-U>exe "call ToggleFoldMethod()"<cr>')
       call submode#map(       'toggle-fold', 'n', 's', 'n', ':<C-U>exe "call ToggleFoldMethod()"<cr>')
       call submode#map(       'toggle-fold', 'n', 's', 'p', ':<C-U>exe "call ToggleFoldMethod(1)"<cr>')
       call submode#map(       'toggle-fold', 'n', 's', 's', ':<C-U>set foldmethod=syntax<cr>')
       call submode#map(       'toggle-fold', 'n', 's', 'i', ':<C-U>set foldmethod=indent<cr>')
       call submode#map(       'toggle-fold', 'n', 's', 'm', ':<C-U>set foldmethod=manual<cr>')
       call submode#map(       'toggle-fold', 'n', 's', '{', ':<C-U>set foldmethod=manual<cr>')
     "}}} _Toogles FOLD

     ""Toggles FoleMarker {{{
       "call submode#enter_with('toggle-marker', 'n', '', 'com', ':<C-U>exe "call ToggleFoldMarker()"<cr>')
       "call submode#leave_with('toggle-marker', 'n', '', '<Esc>')
       "call submode#map(       'toggle-marker', 'n', '', 'm', ':<C-U>exe "call ToggleFoldMarker()"<cr>')
       "call submode#map(       'toggle-marker', 'n', '', 'n', ':<C-U>exe "call ToggleFoldMarker()"<cr>')
       "call submode#map(       'toggle-marker', 'n', '', 'p', ':<C-U>exe "call ToggleFoldMarker()"<cr>')
     ""}}} _Toogles FoleMarker

     "Toggles {{{
       call submode#enter_with('toggle-mode', 'n', '', 'coo', ':<C-U>echo ""<cr>')
       call submode#leave_with('toggle-mode', 'n', '', '<Esc>')
       call submode#map(       'toggle-mode', 'n', '', 'f', ':<C-U>exe "call ToggleFoldMethod()"<cr>')
       call submode#map(       'toggle-mode', 'n', '', '{', ':<C-U>exe "call ToggleFoldMarker()"<cr>')
       call submode#map(       'toggle-mode', 'n', '', 'm', ':<C-U>exe "call ToggleMouseFunction()"<cr>')
       call submode#map(       'toggle-mode', 'n', '', ';', ':<C-U>set showcmd!<cr>')
       call submode#map(       'toggle-mode', 'n', '', ':', ':<C-U>set showcmd!<cr>')
       call submode#map(       'toggle-mode', 'n', '', 't', ':<C-U>exe "set showtabline=" . (&showtabline+2)%3<cr>')
       call submode#map(       'toggle-mode', 'n', '', '<space>', ':<C-U>exe "set laststatus=" . (&laststatus+2)%3<cr>')
       call submode#map(       'toggle-mode', 'n', '', 'q', ':<C-U>QFix<cr>')

     "}}} _Toggles

     "Undo/Redo {{{
       call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
       call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
       call submode#leave_with('undo/redo', 'n', '', '<Esc>')
       call submode#map('undo/redo', 'n', '', '-', 'g-')
       call submode#map('undo/redo', 'n', '', '+', 'g+')
     "}}} _Undo/Redo

     "Buffer {{{
       ""call submode#enter_with('buf', 'n', 's', ']b', ':<C-U>exe "bnext<Bar>hi Normal guibg=red"<cr>')
       ""call submode#enter_with('buf', 'n', 's', '[b', ':<C-U>exe "bprevious<Bar>hi Normal guibg=red"<cr>')
       "call submode#enter_with('buf', 'n', 's', ']b', ':<C-U>exe "bnext"<cr>')
       "call submode#enter_with('buf', 'n', 's', '[b', ':<C-U>exe "bprevious"<cr>')
       "call submode#map('buf', 'n', 's', ']', ':<C-U>exe "bnext"<cr>')
       "call submode#map('buf', 'n', 's', 'd', ':<C-U>exe "bdelete"<cr>')
       "call submode#map('buf', 'n', 's', 'k', ':<C-U>exe "bdelete!"<cr>')
       "call submode#map('buf', 'n', 's', 'o', ':<C-U>exe "BufOnly"<cr>')
       "call submode#map('buf', 'n', 's', '[', ':<C-U>exe "bprevious"<cr>')
       "call submode#map('buf', 'n', 's', 'l', ':<C-U>exe "buffers"<cr>')
       "autocmd! User buf_leaving :hi Normal guibg=#1B1D1E<cr>
     "}}} _Buffer

     "Jump/Edit {{{
       call submode#enter_with('Jump/Edit', 'n', 's', 'coj', ':<C-U>exe "silent! normal g,zO"<cr>')
       call submode#enter_with('Jump/Edit', 'n', 's', 'coe', ':<C-U>exe "silent! normal g,zO"<cr>')
       call submode#enter_with('Jump/Edit', 'n', 's', ']j', ':<C-U>exe "silent! normal g,zO"<cr>')
       call submode#enter_with('Jump/Edit', 'n', 's', '[j', ':<C-U>exe "silent! normal g;zO"<cr>')
       call submode#map('Jump/Edit', 'n', 's', ']', ':<C-U>exe "silent! normal g,zO"<cr>')
       call submode#map('Jump/Edit', 'n', 's', '[', ':<C-U>exe "silent! normal g;zO"<cr>')
       call submode#map('Jump/Edit', 'n', 's', 'n', ':<C-U>exe "silent! normal g,zO"<cr>')
       call submode#map('Jump/Edit', 'n', 's', 'p', ':<C-U>exe "silent! normal g;zO"<cr>')
       call submode#map('Jump/Edit', 'n', 's', 'j', ':<C-U>exe "silent! normal g,zO"<cr>')
       call submode#map('Jump/Edit', 'n', 's', 'k', ':<C-U>exe "silent! normal g;zO"<cr>')
     "}}} _Jum/Edit

   endfunction
 endif "PM()
 "}}}

 " vim-hydra {{{
 if PM('brenopacheco/vim-hydra')
 let s:example_hydra =
            \ {
            \   'name':        'example',
            \   'title':       'Example hydra',
            \   'show':        'popup',
            \   'exit_key':    "q",
            \   'feed_key':    v:true,
            \   'foreign_key': v:true,
            \   'keymap': [
            \     {
            \       'name': 'Window',
            \       'keys': [
            \         ['s', 'split',                    'split'],
            \         ['v', 'vsplit',                   'vsplit'],
            \         ['d', 'close',                    'close'],
            \         ['o', 'only',                     'only'],
            \       ]
            \     },
            \     {
            \       'name': 'Move to',
            \       'keys': [
            \         ['h', "norm \<C-w>h", '?'],
            \         ['j', "norm \<C-w>j", '?'],
            \         ['k', "norm \<C-w>k", '?'],
            \         ['l', "norm \<C-w>l", '?'],
            \       ]
            \     },
            \     {
            \       'name': 'Buffers',
            \       'keys': [
            \         ['b', 'Buffers', "Buffers", 'interactive'],
            \         ['n', "bn",       "next"],
            \         ['p', "bp",       "prev"],
            \         ['e', "enew!",    "empty"],
            \       ]
            \     },
            \   ]
            \ }
 endif
 silent call hydra#hydras#register(s:example_hydra)
 nnoremap <Leader>w :Hydra example<CR>
 "}}} _ vim-hydra

 " vim-unimpaired {{{
 call PM( 'tpope/vim-unimpaired')
 "}}} _vim-unimpaired

 "vim-sleuth {{{
 " Sets buffer options heuristically
 if PM('tpope/vim-sleuth')
   let g:sleuth_automatic = 0
 endif
 "}}} _vim-sleuth

 " vim-man {{{
   call PM( 'bruno-/vim-man', {'on_cmd': ['Man', 'SMan', 'VMan', 'Mangrep']} )
 "}}} _vim-man

 " vim-rsi {{{
   call PM( 'tpope/vim-rsi' )
 "}}} _vim-rsi

 " capture.vim {{{

   "Capture EX-commad in a buffer
   call PM( 'tyru/capture.vim', {'on_cmd': 'Capture'} )

 "}}} _capture.vim

 " vim-eunuch {{{

   call PM( 'tpope/vim-eunuch', {'on_cmd': [ 'Remove', 'Unlink', 'Move', 'Rename',
       \ 'Chmod', 'Mkdir', 'Find', 'Locate', 'SudoEdit', 'SudoWrite', 'Wall', 'W' ]})

 "}}} _vim-eunuch

 " vim-capslock {{{

 call PM( 'tpope/vim-capslock' ,{
       \ 'on_map':[
       \  ['n', '<Plug>CapsLockToggle'],
       \  ['n', '<Plug>CapsLockEnable'],
       \  ['n', '<Plug>CapsLockDisable']
       \ ]})
   imap <c-l>o <C-O><Plug>CapsLockToggle
   imap <c-l>e <C-O><Plug>CapsLockEnable
   imap <c-l>d <C-O><Plug>CapsLockDisable
 "}}} _vim-capslock

 " vim-repeat {{{

 call PM( 'tpope/vim-repeat' )

 "}}} _vim-repeat

 " vim-obsession {{{

   call PM( 'tpope/vim-obsession', {'on_cmd':['Obsession']} )

 "}}} _vim-obsession

 "close-buffers.vim {{{
 if PM('Asheq/close-buffers.vim')
     nnoremap <c-;>wh <cmd>Bdelete hidden<cr>
     nnoremap <c-;><c-w><c-h> <cmd>Bdelete hidden<cr>
 endif
 "}}} _close-buffers.vim

 " nvim-treesitter {{{
if PM('nvim-treesitter/nvim-treesitter', { 'merged': 0 })
lua <<EOF
require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,                    -- false will disable the whole extension
      disable = { },                    -- list of language that will be disabled
      custom_captures = {               -- mapping of user defined captures to highlight groups
        -- ["foo.bar"] = "Identifier"   -- highlight own capture @foo.bar with highlight group "Identifier", see :h nvim-treesitter-query-extensions
      },
    },
    incremental_selection = {
      enable = true,
      disable = {  },
      keymaps = {                       -- mappings for incremental selection (visual mappings)
        init_selection = "gnn",         -- maps in normal mode to init the node/scope selection
        node_incremental = "grn",       -- increment to the upper named parent
        scope_incremental = "grc",      -- increment to the upper scope (as defined in locals.scm)
        node_decremental = "grm",       -- decrement to the previous node
      }
    },
    refactor = {
      highlight_definitions = {
        enable = false
      },
      highlight_current_scope = {
        enable = false
      },
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = "grr"          -- mapping to rename reference under cursor
        }
      },
      navigation = {
        enable = true,
        keymaps = {
          goto_definition = "gnd",      -- mapping to go to definition of symbol under cursor
          list_definitions = "gnD"      -- mapping to list all definitions in current file
        }
      }
    },
    textobjects = { -- syntax-aware textobjects
    enable = true,
    disable = {},
    keymaps = {
        ["iL"] = { -- you can define your own textobjects directly here
          python = "(function_definition) @function",
          cpp = "(function_definition) @function",
          c = "(function_definition) @function",
          java = "(method_declaration) @function"
        },
        -- or you use the queries from supported languages with textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["aC"] = "@class.outer",
        ["iC"] = "@class.inner",
        ["ac"] = "@conditional.outer",
        ["ic"] = "@conditional.inner",
        ["ae"] = "@block.outer",
        ["ie"] = "@block.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["is"] = "@statement.inner",
        ["as"] = "@statement.outer",
        ["ad"] = "@comment.outer",
        ["am"] = "@call.outer",
        ["im"] = "@call.inner"
      }
    },
    -- ensure_installed = "all" -- one of "all", "language", or a list of languages
}
EOF
endif
 "}}} _ nvim-treesitter

 "chromatica {{{
 if PM('arakashic/chromatica.nvim')
     let test#strategy = "neovim"
 endif
 "}}} _chromatica

 " vim-autoswap {{{

   call PM( 'gioele/vim-autoswap' )

 "}}} _vim-autoswap

 " vim-scriptease {{{

 call PM( 'tpope/vim-scriptease', {
       \ 'on_ft': ['vim'],
       \ 'on_cmd': ['PP', 'Runtime', 'Time', 'Disarm', 'Scriptnames'. 'Verbose', 'Breakadd', 'Vedit', 'Vsplit', 'Vtabedit'],
       \ 'on_map': ['K', 'zS', 'g!']
       \ } )

 "}}} _vim-scriptease

 "greprtpscr {{{
 " Grep vim runtimepath and grep Scriptnames
 if PM('jyscao/vim-greprtpscr', {'on_cmd': ['GrepRtp', 'GrepScr']})
 endif
 "}}}

 " vim-debugger {{{
 call PM('haya14busa/vim-debugger',
       \ {'on_cmd': ['DebugOn', 'Debugger', 'Debug', 'StackTrace', 'CallStack', 'CallStackReport']})
 " }}} _vim-debugger

 " vim-scripts/Decho {{{
 " Debug vim scripts with ease using the echo of Decho and more
 call PM('vim-scripts/Decho', {
       \ 'on_cmd': ['Decho', 'DechoOn'],
       \ 'on_func': ['Decho', 'Dfunc', 'Dredir', 'DechoMsgOn', 'DechoRemOn', 'DechoTabOn', 'DechoVarOn'  ],
       \ })
     " Usage:
    " call Dfunc("YourFunctionName([arg1<".a:arg1."> arg2<".a:arg2.">])")
    " call Dret("YourFunctionName [returnvalue]")
 "}}} _vim-scripts/Decho

 "vCoolor.vim {{{
 call PM( 'KabbAmine/vCoolor.vim', {'on_cmd': ['VCoolor', 'VCoolIns']})
 "}}} _vCoolor.vim

 " investigate.vim {{{

 if PM( 'keith/investigate.vim', {'on_map': ['gK']} )
   let g:investigate_dash_for_blade="laravel"
   let g:investigate_dash_for_php="laravel"
   let g:investigate_use_dash=1
 endif

 "}}} _investigate.vim

 if PM('akiyosi/gonvim-fuzzy')
 endif

 "}}}

 " languages {{{
 "
 " Pythn
 "
if PM('relastle/vim-nayvy', {'on_ft': 'python'})

endif

 "SQL
 if PM('tpope/vim-dadbod')
 endif

 "vim-go {{{
 if PM('fatih/vim-go', {'on_ft': 'go'})
     ", { 'build': 'GoUpdateBinaries' }
 endif
 "}}} _ vim-go

 " Vue
 " vim-vue {{{
 call PM('posva/vim-vue')
 "}}} _ vim-vue

 " Advanced Syntax Highlighting
 "vim-polyglot {{{
if PM('sheerun/vim-polyglot')
  let g:polyglot_disabled =  ['typescript']
  autocmd BufNewFile,BufRead *.tsx setlocal filetype=typescript
 endif
"}}} _vim-polyglot
"
 " yats.vim {{{
    " call PM('HerringtonDarkholme/yats.vim')
 "}}} _ yats.vim

 "GoDot
 "vim-gdscript {{{
 if PM('quabug/vim-gdscript', {'on_ft': ['gdscript']})
   au BufRead,BufNewFile *.gd	set filetype=gdscript
 endif
 "}}} _vim-gdscript

 "Python
 "braceless.vim {{{
 call PM( 'tweekmonster/braceless.vim', {'on_ft': ['python']} )
 "}}} _braceless.vim

 "C#
 " omnisharp {{{

  if PM( 'nosami/Omnisharp', {'on_ft': ['cs']} )
   let g:OmniSharp_server_path = "/Volumes/Home/.config/nvim/plugged/Omnisharp/server/Omnisharp/bin/Debug/OmniSharp.exe"
   " let g:OmniSharp_server_type = 'roslyn'

   " Plug 'khalidchawtany/omnisharp-vim', {'branch': 'nUnitQuickFix'}

   let g:OmniSharp_selecter_ui = 'ctrlp'

   let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']

   "let g:OmniSharp_server_type = 'roslyn'
   autocmd Filetype cs,cshtml.html call SetOmniSharpOptions()

   function! SetOmniSharpOptions()

     if exists("g:SetOmniSharpOptionsIsSet")
       return
     endif

     source ~/.config/nvim/scripts/make_cs_solution.vim
     autocmd BufWritePost *.cs BuildCSharpSolution

     nnoremap <leader>oo :BuildCSharpSolution<cr>

     let g:SetOmniSharpOptionsIsSet = 1
     "can set preview here also but i found it causes flicker
     "set completeopt=longest,menuone

     "makes enter work like C-y, confirming a popup selection
     "inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

     setlocal omnifunc=OmniSharp#Complete

     " Builds can also run asynchronously with vim-dispatch installed
     nnoremap <localleader>b :wa!<cr>:OmniSharpBuildAsync<cr>
     nnoremap <localleader>tt :OmniSharpRunTests<cr>
     nnoremap <localleader>tf :OmniSharpRunTestFixture<cr>
     nnoremap <localleader>ta :OmniSharpRunAllTests<cr>
     nnoremap <localleader>tl :OmniSharpRunLastTests<cr>

     nnoremap <localleader>gd :OmniSharpGotoDefinition<cr>
     nnoremap <localleader>gi :OmniSharpFindImplementations<cr>
     nnoremap <localleader>gt :OmniSharpFindType<cr>
     nnoremap <localleader>gs :OmniSharpFindSymbol<cr>
     nnoremap <localleader>gu :OmniSharpFindUsages<cr>
     nnoremap <localleader>gm :OmniSharpFindMembers<cr>

     " cursor can be anywhere on the line containing an issue
     nnoremap <localleader>fi  :OmniSharpFixIssue<cr>
     nnoremap <localleader>fu :OmniSharpFixUsings<cr>

     nnoremap <localleader>tl :OmniSharpTypeLookup<cr>
     " Add syntax highlighting for types and interfaces
     nnoremap <localleader>ht :OmniSharpHighlightTypes<cr>

     nnoremap <localleader>d :OmniSharpDocumentation<cr>
     "navigate up by method/property/field
     nnoremap <localleader>nk :OmniSharpNavigateUp<cr>
     "navigate down by method/property/field
     nnoremap <localleader>nj :OmniSharpNavigateDown<cr>

     " Contextual code actions (requires CtrlP or unite.vim)
     nnoremap <localleader>a :OmniSharpGetCodeActions<cr>
     " Run code actions with text selected in visual mode to extract method
     vnoremap <localleader>a :call OmniSharp#GetCodeActions('visual')<cr>

     " rename with dialog
     nnoremap <localleader>rn :OmniSharpRename<cr>
     " rename without dialog - with cursor on the symbol to rename... ':Rename newname'

     " Force OmniSharp to reload the solution. Useful when switching branches etc.
     nnoremap <localleader>rs :OmniSharpReloadSolution<cr>
     nnoremap <localleader>= :OmniSharpCodeFormat<cr>
     " Load the current .cs file to the nearest project
     nnoremap <localleader>i :OmniSharpAddToProject<cr>

     " (Experimental - uses vim-dispatch or vimproc plugin) - Start the omnisharp server for the current solution
     nnoremap <localleader>ss :OmniSharpStartServer<cr>
     nnoremap <localleader>st :OmniSharpStopServer<cr>

   augroup omnisharp_commands
     autocmd!

     command! -nargs=1 RenameOmnisharp :call OmniSharp#RenameTo("<args>")

     " automatic syntax check on events (TextChanged requires Vim 7.4)
     autocmd BufEnter,TextChanged,InsertLeave *.cs,*.cshtml SyntasticCheck

     " Automatically add new cs files to the nearest project on save
     autocmd BufWritePost *.cs,*.cshtml call OmniSharp#AddToProject()

     "show type information automatically when the cursor stops moving
     "autocmd CursorHold *.cs,*.cshtml call OmniSharp#TypeLookupWithoutDocumentation()
   augroup END

   "set updatetime=500
   " Remove 'Press Enter to continue' message when type information is longer than one line.
   "set cmdheight=2
   endfunction

 endif
 "}}}

 " vim-csharp {{{

   call PM( 'OrangeT/vim-csharp', {'on_ft': ['cs']} )

 "}}} _vim-csharp

 " applescript
 " applescript {{{

   "call PM( 'vim-scripts/applescript.vim' ,     {'on_ft': ['applescript']} )
   call PM( 'vim-scripts/applescript.vim' )

 "}}} _applescript

 " markdown
 " vim-markdown {{{

   "call PM( 'tpope/vim-markdown', {'on_ft':['markdown']} )
   call PM( 'tpope/vim-markdown' )

 "}}} _vim-markdown

 " CSV
 " csv.vim {{{
 call PM( 'chrisbra/csv.vim', {'on_ft': ['csv']} )
 "}}} _ csv.vim

 " PHP
 "vdebug {{{
 if PM('joonty/vdebug', {'on_cmd': ['VdebugStart']})

     let g:vdebug_keymap = {
                 \    "run":               "<leader>dr",
                 \    "run_to_cursor":     "<leader>dc",
                 \    "step_over":         "<leader>do",
                 \    "step_into":         "<leader>di",
                 \    "step_out":          "<leader>dO",
                 \    "close":             "<leader>dq",
                 \    "detach":            "<leader>dD",
                 \    "set_breakpoint":    "<leader>db",
                 \    "get_context":       "<leader>dg",
                 \    "eval_under_cursor": "<leader>de",
                 \    "eval_visual":       "<Leader>dv",
                 \}
     nnoremap <leader>dd <cmd>VdebugStart<cr>

     " Allows Vdebug to bind to all interfaces.
     let g:vdebug_options = {
                 \ 'break_on_open':      0,
                 \ 'max_children':       128,
                 \ 'watch_window_style': 'compact',
                 \ 'ide_key':            'nvim',
                 \ 'server':             '127.0.0.1',
                 \ 'port':               '9001'
                 \}

     " Need to set as empty for this to work with Vagrant boxes.
     " let g:vdebug_options['server'] = ""

 endif
 "}}} _vdebug
 "php.vim {{{
 call PM('StanAngeloff/php.vim')
 "}}} _php.vim
 "vim-php-cs-fixer {{{
 if PM('stephpy/vim-php-cs-fixer')
     command! -nargs=1 Silent execute ':silent !'.<q-args> | execute ':redraw!'
     autocmd FileType php nnoremap <buffer> <c-k><c-d> <esc>:w<cr>:Silent php-cs-fixer fix %:p --level=symfony<cr>
 endif
 "}}} _vim-php-cs-fixer
 "vim-php-dictionary {{{
 call PM('nishigori/vim-php-dictionary', {'on_ft': 'php', 'rev': 'php7.1'})
 "}}} _vim-php-dictionary
 "vim-php-namespace {{{
 if PM('arnaud-lb/vim-php-namespace', {'for': 'php'})
     let g:php_namespace_sort_after_insert = 1
     augroup vim_php_namespace
         autocmd!
         autocmd FileType php nnoremap <Leader>pu :call PhpInsertUse()<CR>
                           \| nnoremap <Leader>pic  :PHPImportClass<cr>
                           \| nnoremap <Leader>pe   :PHPExpandFQCNAbsolute<cr>
                           \| nnoremap <Leader>pR   :PHPExpandFQCN<cr>
                           \| nnoremap <Leader>pE   :call PhpExpandClass()<CR>
                           \| nnoremap <Leader>ps    :call PhpSortUse()<CR>
     augroup END
endif
 "}}} _vim-php-namespace
 "phpactor {{{
 if PM('phpactor/phpactor' ,  {'build': 'composer install'}) ", 'rev': 'develop'})
     " let g:phpactorBranch = "develop"
     let g:phpactorOmniError = v:true
     let g:phpactorOmniAutoClassImport = v:true

     "TODO:
     " context-aware menu with all functions (ALT-m)
     nnoremap <D-M> :call phpactor#ContextMenu()<cr>

     " nnoremap gd :call phpactor#GotoDefinition()<CR>
     " nnoremap gu :call phpactor#FindReferences()<CR>

     " Extract method from selection
     vnoremap <silent><Leader>em :<C-U>call phpactor#ExtractMethod()<CR>
     " extract variable
     vnoremap <silent><Leader>ee :<C-U>call phpactor#ExtractExpression(v:true)<CR>
     nnoremap <silent><Leader>ee :call phpactor#ExtractExpression(v:false)<CR>
     " extract interface
     nnoremap <silent><Leader>rei :call phpactor#ClassInflect()<CR>

     autocmd FileType php setlocal omnifunc=phpactor#Complete

     " " Include use statement
     " nmap <Leader>u :call phpactor#UseAdd()<CR>

     " " Invoke the context menu
     " nmap <Leader>mm :call phpactor#ContextMenu()<CR>

     " " Invoke the navigation menu
     " nmap <Leader>nn :call phpactor#Navigate()<CR>

     " " Goto definition of class or class member under the cursor
     " nmap <Leader>o :call phpactor#GotoDefinition()<CR>

     " " Show brief information about the symbol under the cursor
     " nmap <Leader>K :call phpactor#Hover()<CR>

     " " Transform the classes in the current file
     " nmap <Leader>tt :call phpactor#Transform()<CR>

     " " Generate a new class (replacing the current file)
     " nmap <Leader>cc :call phpactor#ClassNew()<CR>

     " " Extract expression (normal mode)
     " nmap <silent><Leader>ee :call phpactor#ExtractExpression(v:false)<CR>

     " " Extract expression from selection
     " vmap <silent><Leader>ee :<C-U>call phpactor#ExtractExpression(v:true)<CR>

     " " Extract method from selection
     " vmap <silent><Leader>em :<C-U>call phpactor#ExtractMethod()<CR>



 endif
 "}}} _phpactor
 "vim-php-refactoring-toolbox {{{
 if PM('adoy/vim-php-refactoring-toolbox')
     let g:vim_php_refactoring_use_default_mapping = 0
     let g:vim_php_refactoring_default_property_visibility = 'private'
     let g:vim_php_refactoring_default_method_visibility = 'private'
     let g:vim_php_refactoring_auto_validate_visibility = 1
     let g:vim_php_refactoring_phpdoc = "pdv#DocumentCurrentLine"

     let g:vim_php_refactoring_use_default_mapping = 0
     nnoremap <leader>rlv :call PhpRenameLocalVariable()<CR>
     nnoremap <leader>rcv :call PhpRenameClassVariable()<CR>
     nnoremap <leader>rrm :call PhpRenameMethod()<CR>
     nnoremap <leader>reu :call PhpExtractUse()<CR>
     vnoremap <leader>rec :call PhpExtractConst()<CR>
     nnoremap <leader>rep :call PhpExtractClassProperty()<CR>
     nnoremap <leader>rnp :call PhpCreateProperty()<CR>
     nnoremap <leader>rdu :call PhpDetectUnusedUseStatements()<CR>
     nnoremap <leader>rsg :call PhpCreateSettersAndGetters()<CR>

 endif
 "}}} _vim-php-refactoring-toolbox
 "pdv {{{
 if PM('tobyS/pdv', {'on_ft': 'php'})
     call PM('tobyS/vmustache')
     nnoremap <leader>doc <cmd>call pdv#DocumentWithSnip()<cr>
     nnoremap <buffer>dos <C-p> :call pdv#DocumentWithSnip()<CR>
     let g:pdv_template_dir = $HOME ."/.config/nvim/dein/repos/github.com/tobyS/pdv/templates_snip"
 endif
 "}}} _pdv

 " vim-phpfmt {{{
 if PM('beanworks/vim-phpfmt')
   " A standard type: PEAR, PHPCS, PSR1, PSR2, Squiz and Zend
   let g:phpfmt_standard = 'PSR2'
   " Or your own defined source of standard (absolute or relative path):
   " let g:phpfmt_standard = '/path/to/custom/standard.xml'

   let g:phpfmt_autosave = 0
   " let g:phpfmt_command = '/path/to/phpcbf'
   " let g:phpfmt_tmp_dir = '/path/to/tmp/folder'
 endif
 "}}} _ vim-phpfmt

 " phpcd.vim {{{

 if PM( 'lvht/phpcd.vim',
       \ {
       \ 'if': 'has("nvim")',
       \ 'on_ft': ['php'],
       \ 'on_if': 'has("nvim")',
       \ 'on_event': 'VimEnter',
       \ 'build': 'sh -c "cd /Volumes/Home/.config/nvim/dein/repos/github.com/lvht/phpcd.vim && /usr/local/bin/composer update"'
       \ } )
   "call PM( 'vim-scripts/progressbar-widget', {'on_source': 'phpcd.vim'} ) " used for showing the index progress
   call PM( 'vim-scripts/progressbar-widget' )

   "Set PHP Completion options;
   "autocmd FileType php setlocal completeopt+=preview | setlocal omnifunc=phpcd#CompletePHP;
   "autocmd FileType php setlocal completeopt-=preview | setlocal omnifunc=phpcd#CompletePHP

   "Close Omni-Completion perview tip window to close when a selection is made
   autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

   "This on may cause slowness
   "autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
 endif " PM()
 "}}} _phpcd.vim
 " PHP-Indenting-for-VIm {{{

   "call PM( '2072/PHP-Indenting-for-VIm', {'on_ft': ['php']} )
   call PM( '2072/PHP-Indenting-for-VIm' )

 "}}} _PHP-Indenting-for-VIm
 " phpfolding.vim {{{

   "No more maintained
   "call PM( 'phpvim/phpfolding.vim', {'on_ft': ['php']} )
   "call PM( 'phpvim/phpfolding.vim' )
   call PM( 'phpvim/phpfold.vim',
         \ {
         \ 'if': '0'
         \ })
         "\ 'if': 'has("nvim")',
         "\ 'on_ft': ['php'],
         "\ 'on_if': 'has("nvim")',
         "\ 'on_event': 'VimEnter',
         "\ 'build' : 'composer update'
         "\ } )

 "}}} _phpfolding.vim
 " tagbar-phpctags.vim {{{

   call PM( 'vim-php/tagbar-phpctags.vim', {'on_ft': ['php']} )

 "}}} _tagbar-phpctags.vim
 " noahfredrerick/vim-composer {{{
 cal PM( 'noahfrederick/vim-composer',
       \ {
       \ 'for': 'php',
       \ 'on_cmd': ['Composer', 'Ecomposer', 'A', 'Dispatch']
       \ })
 "}}} _noahfredrerick/vim-composer

 " blade
 " vim-blade {{{

   call PM('jwalton512/vim-blade')

 "}}}

 " Web Dev
 " breeze.vim {{{

 if PM( 'gcmt/breeze.vim', {'on_map':
       \   [
       \       '<Plug>(breeze-jump-tag-forward)',
       \       '<Plug>(breeze-jump-tag-backward)',
       \       '<Plug>(breeze-jump-attribute-forward)',
       \       '<Plug>(breeze-jump-attribute-backward)',
       \       '<Plug>(breeze-next-tag)',
       \       '<Plug>(breeze-prev-tag)',
       \       '<Plug>(breeze-next-attribute)',
       \       '<Plug>(breeze-prev-attribute)'
       \ ] ,
       \'on_ft': ['php', 'blade', 'html', 'xhtml', 'xml']})

   au FileType html,blade,php,xml,xhtml call MapBreezeKeys()

   function! MapBreezeKeys()
     nmap <buffer> <leader>sj <Plug>(breeze-jump-tag-forward)
     nmap <buffer> <leader>sk <Plug>(breeze-jump-tag-backward)
     nmap <buffer> <leader>sl <Plug>(breeze-jump-attribute-forward)
     nmap <buffer> <leader>sh <Plug>(breeze-jump-attribute-backward)

     nmap <buffer> <c-s><c-j> <Plug>(breeze-next-tag)
     nmap <buffer> <c-s><c-k> <Plug>(breeze-prev-tag)
     nmap <buffer> <c-s><c-l> <Plug>(breeze-next-attribute)
     nmap <buffer> <c-s><c-h> <Plug>(breeze-prev-attribute)

     " <Plug>(breeze-next-tag-hl)
     " <Plug>(breeze-prev-tag-hl)
     " <Plug>(breeze-next-attribute-hl)
     " <Plug>(breeze-prev-attribute-hl)

   endfunction
 endif

 "}}}
 " emmet {{{

 if PM( 'mattn/emmet-vim', {'on_ft':['html','js', 'jsx','ts','xml','xsl','xslt','xsd','css','sass','scss','less','mustache', 'blade', 'php', 'vue']} )

   "let g:user_emmet_mode='a'         "enable all function in all mode.
   let g:user_emmet_mode='i'         "enable all function in insert mode
   let g:user_emmet_leader_key="<c-y>"
   let g:user_emmet_settings = {
         \  'javascript.jsx' : {
         \      'extends' : 'jsx',
         \  },
         \}
  imap   <C-y>,   <plug>(emmet-expand-abbr)
  imap   <C-y>;   <plug>(emmet-expand-word)
  imap   <C-y>u   <plug>(emmet-update-tag)
  imap   <C-y>d   <plug>(emmet-balance-tag-inward)
  imap   <C-y>D   <plug>(emmet-balance-tag-outward)
  imap   <C-y>n   <plug>(emmet-move-next)
  imap   <C-y>N   <plug>(emmet-move-prev)
  imap   <C-y>i   <plug>(emmet-image-size)
  imap   <C-y>/   <plug>(emmet-toggle-comment)
  imap   <C-y>j   <plug>(emmet-split-join-tag)
  imap   <C-y>k   <plug>(emmet-remove-tag)
  imap   <C-y>a   <plug>(emmet-anchorize-url)
  imap   <C-y>A   <plug>(emmet-anchorize-summary)
  imap   <C-y>m   <plug>(emmet-merge-lines)
  imap   <C-y>c   <plug>(emmet-code-pretty)
 endif

 "}}}

 " vim-closetag {{{
 "This plugin uses > of the clos tag to work in insert mode
 "<table|   => press > to have <table>|<table>
 "press > again to have <table>|<table>
 if PM( 'alvan/vim-closetag', {'on_ft': ['html', 'xml', 'blade', 'php']} )
   " # filenames like *.xml, *.html, *.xhtml, ...
   let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.blade.php,*.php"
 endif

 "}}}
 " closetag {{{

 "Ctrl+_ to close next unimpared tag
 call PM( 'vim-scripts/closetag.vim' , {'on_ft':['html','xml','xsl','xslt','xsd', 'blade', 'php', 'blade.php']} )
 "}}}

 "{{{ tagalong
  if PM('AndrewRadev/tagalong.vim')
    let g:tagalong_mappings = []
    " use tagalong#Trigger
    " then tagalong#Apply
  endif
 "}}} _tagalong

 "React Dev
 "vim-javascript {{{
   call PM('pangloss/vim-javascript')
   "}}} _vim-javascript
   "vim-jsx {{{
   call PM('mxw/vim-jsx')
   let g:jsx_ext_required = 1
   "}}} _vim-jsx
 " vim-ragtag {{{

 if PM( 'tpope/vim-ragtag', {'on_ft':['html','xml','xsl','xslt','xsd', 'blade', 'php', 'blade.php']} )
  let g:ragtag_global_maps = 1
 endif

 "}}} _vim-ragtag

 " asyncrun {{{
if PM('skywind3000/asyncrun.vim')
  autocmd BufWritePost *.js AsyncRun -post=checktime ./node_modules/.bin/eslint --fix %
 " let g:asyncrun_open = 10
endif
 "}}} _asyncrun

 " ale {{{
 if PM( 'w0rp/ale' )

   augroup ALE_HIGHLIGHT
       autocmd!
       autocmd VimEnter *  highlight ALEVirtualTextError  gui=underline,italic guifg=red
             \| highlight ALEVirtualTextInfo  gui=underline,italic guifg=white
             \| highlight ALEVirtualTextStyleError  gui=underline,italic guifg=orange
             \| highlight ALEVirtualTextStyleWarning  gui=underline,italic guifg=yellow
             \| highlight ALEVirtualTextWarning  gui=underline,italic guifg=yellow
   augroup END


   " let g:ale_fix_on_save = 0
   let g:ale_sign_error = '●' " Less aggressive than the default '>>'
   let g:ale_sign_warning = '●'
   let g:ale_lint_on_enter = 0 " Less distracting when opening a new file
   let g:ale_set_loclist = 0
   let g:ale_set_quickfix = 0
   let g:ale_virtualtext_cursor = 1
   let g:ale_virtualtext_prefix = ' '
   let g:ale_list_window_size = 5
   let g:ale_warn_about_trailing_blank_lines = 1
   let g:ale_warn_about_trailing_whitespace = 1
   let g:ale_statusline_format = ['E�%d', 'W�%d', 'OK']
   let g:ale_echo_msg_format = '[%linter%] %code% %s'
   let g:ale_javascript_prettier_use_local_config = 1
   let g:ale_javascript_prettier_options = '--config-precedence prefer-file --single-quote --no-bracket-spacing --no-editorconfig --print-width ' . &textwidth . ' --prose-wrap always --trailing-comma all --no-semi --end-of-line  lf'
   " Auto update the option when textwidth is dynamically set or changed in a ftplugin file
   au! OptionSet textwidth let g:ale_javascript_prettier_options = '--config-precedence prefer-file --single-quote --no-bracket-spacing --no-editorconfig --print-width ' . &textwidth . ' --prose-wrap always --trailing-comma all --no-semi'

   let g:ale_linter_aliases = {
       \ 'mail': 'markdown',
       \ 'html': ['html', 'css']
       \}

   let g:ale_linters = {
       \ 'javascript': ['eslint', 'flow'],
       \ 'php': ['langserver', 'phpcs'],
       \ 'go': ['gopls'],
       \}

   let g:ale_completion_enabled=1
   let g:ale_php_langserver_use_global=1
   if has('mac')
     let g:ale_php_langserver_executable=$HOME.'/.composer/vendor/bin/php-language-server.php'
   else
     let g:ale_php_langserver_executable='C:\Users\JuJu\AppData\Roaming\Composer\vendor\bin\php-language-server.bat'
   endif

   let g:ale_php_phpcs_use_global=1
   " let g:ale_php_phpcs_standard = 'laravel'
   if has('mac')
     let g:ale_php_langserver_executable=$HOME.'/.composer/vendor/bin/phpcs'
   else
     let g:ale_php_langserver_executable='C:\Users\JuJu\AppData\Roaming\Composer\vendor\bin\phpcs.bat'
   endif

   let g:ale_php_phpcbf_use_global=1
   let g:ale_php_phpcbf_standard='PSR2'
   let g:ale_php_phpcs_standard='phpcs.xml.dist'
   if has('mac')
     let g:ale_php_langserver_executable=$HOME.'/.composer/vendor/bin/phpcbf'
   else
     let g:ale_php_langserver_executable='C:\Users\JuJu\AppData\Roaming\Composer\vendor\bin\phpcbf.bat'
   endif

   let g:ale_fixers = {
       \   '*'         : ['remove_trailing_lines', 'trim_whitespace'],
       \   'markdown'  : [ 'prettier' ],
       \   'javascript': [ 'prettier' ],
       \   'css'       : [ 'prettier' ],
       \   'json'      : [ 'prettier' ],
       \   'scss'      : [ 'prettier' ],
       \   'yaml'      : [ 'prettier' ],
       \   'graphql'   : [ 'prettier' ],
       \   'html'      : [ 'prettier' ],
       \   'reason'    : [ 'refmt' ],
       \   'python'    : [ 'black' ],
       \   'php'       : [ 'phpcbf', 'php_cs_fixer', 'remove_trailing_lines', 'trim_whitespace' ],
       \}

   " Don't auto fix (format) files inside `node_modules`, `forks` directory, minified files and jquery (for legacy codebases)
   let g:ale_pattern_options_enabled = 1
   let g:ale_pattern_options = {
       \   '\.min\.(js\|css)$': {
       \       'ale_linters': [],
       \       'ale_fixers': []
       \   },
       \   'jquery.*': {
       \       'ale_linters': [],
       \       'ale_fixers': []
       \   },
       \   'node_modules/.*': {
       \       'ale_linters': [],
       \       'ale_fixers': []
       \   },
       \   'vendor/.*': {
       \       'ale_linters': [],
       \       'ale_fixers': []
       \   },
       \   'package.json': {
       \       'ale_fixers': []
       \   },
       \   'Sites/personal/forks/.*': {
       \       'ale_fixers': []
       \   },
   \}

 endif
 "}}} _ale

 " vim-test {{{

 if PM('janko-m/vim-test')  ", {'on_cmd': [ 'TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit' ]})
     " these "Ctrl mappings" work well when Caps Lock is mapped to Ctrl
     nnoremap <silent> t<C-n> :TestNearest<CR>
     nnoremap <silent> t<C-f> :TestFile<CR>
     nnoremap <silent> t<C-s> :TestSuite<CR>
     nnoremap <silent> t<C-t> :TestSuite<CR>
     nnoremap <silent> t<C-cr> :TestSuite<CR>
     nnoremap <silent> t<C-l> :TestLast<CR>
     nnoremap <silent> t<C-space> :TestLast<CR>
     nnoremap <silent> t<C-g> :TestVisit<CR>

     " let test#strategy = {
     "             \ 'nearest': 'asyncrun',
     "             \ 'file':    'asyncrun',
     "             \ 'suite':   'asyncrun',
     "             \}

     if PM('reinh/vim-makegreen')
     endif

 endif

 "}}} _vim-test

 "}}}

 " Snippets {{{

 " xptemplate {{{

 if PM( 'drmingdrmer/xptemplate',
         \ {
         \ 'if': 'has("nvim")',
         \ 'on_event': [ 'VimEnter'],
         \ 'on_if': 'has("nvim")'
         \ })
   if has('nvim')
     set runtimepath+=/Volumes/Home/.config/nvim/xpt-personal
     let g:xptemplate_key = '<c-\>'
     let g:xptemplate_nav_next = '<C-j>'
     let g:xptemplate_nav_prev = '<C-k>'
   endif

 endif
 "}}}
 " UltiSnips {{{

   "Don't lazy load using go to inser mode as this makes vim very slow
   if PM( 'SirVer/ultisnips') ", {
        "\ 'lazy': 1,
        "\ 'on_map': [ ['i', '<c-cr>'], ['i', '<c-cr>'] ],
        "\ 'on_cmd': ['UltiSnipsEdit'],
        "\ 'hook_post_source': 'call UltiSnips#FileTypeChanged()'
        "\ })
   "au VimEnter * au! UltiSnipsFileType
   ""augroup UltiSnipsFileType
   ""    autocmd!
   ""    autocmd FileType * call UltiSnips#FileTypeChanged()
   ""augroup END

   let g:UltiSnipsEnableSnipMate = 0
   let g:UltiSnipsExpandTrigger = "<c-cr>"            "ctrl+enter
   let g:UltiSnipsJumpForwardTrigger = "<c-cr>"       "ctrl+enter
   let g:UltiSnipsJumpBackwardTrigger = "<M-cr>"      "alt+enter

   let g:ultisnips_java_brace_style="nl"
   let g:Ultisnips_java_brace_style="nl"
   let g:UltiSnipsSnippetsDir="~/.config/nvim/UltiSnips"
   "let g:UltiSnipsSnippetDirectories = [ "/Volumes/Home/.config/nvim/plugged/vim-snippets/UltiSnips"]
   endif

 "}}}
 " vim-snippets {{{

   "call PM( 'honza/vim-snippets', {'on_source': ['ultisnips']} )
   call PM( 'honza/vim-snippets' )

 "}}} _vim-snippets

 "}}}

 " AutoCompletion {{{

 au filetype php set iskeyword+=$

 "coc.nvim {{{
 " if PM('neoclide/coc.nvim', {'rev': 'release', 'build': 'call coc#util#install()'})
 if PM('neoclide/coc.nvim', {'rev': 'master','build': 'yarn install --frozen-lockfile'})
     " {'build': 'npm install'}
     " Use tab for trigger completion with characters ahead and navigate.
     " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
     inoremap <silent><expr> <TAB>
                 \ pumvisible() ? "\<C-n>" :
                 \ <SID>check_back_space() ? "\<TAB>" :
                 \ coc#refresh()
     inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

     function! s:check_back_space() abort
         let col = col('.') - 1
         return !col || getline('.')[col - 1]  =~# '\s'
     endfunction

     " Use <c-space> for trigger completion.
     inoremap <silent><expr> <c-space> coc#refresh()

     " Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
     " Coc only does snippet and additional edit on confirm.
     inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
     " inoremap <expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

     " Use `[c` and `]c` for navigate diagnostics
     nmap <silent> [d <Plug>(coc-diagnostic-prev)
     nmap <silent> ]d <Plug>(coc-diagnostic-next)

     " Remap keys for gotos
     nmap <silent> gd <Plug>(coc-definition)
     nmap <silent> gy <Plug>(coc-type-definition)
     nmap <silent> gi <Plug>(coc-implementation)
     nmap <silent> gr <Plug>(coc-references)

     " Use K for show documentation in preview window
     nnoremap <silent> K :call <SID>show_documentation()<CR>

     function! s:show_documentation()
         if &filetype == 'vim'
             execute 'h '.expand('<cword>')
         else
             call CocAction('doHover')
         endif
     endfunction

     " Highlight symbol under cursor on CursorHold
     " autocmd CursorHold * silent call CocActionAsync('highlight')

     " Remap for rename current word
     nmap <leader>rn <Plug>(coc-rename)

     " Remap for format selected region
     vmap <leader>f  <Plug>(coc-format-selected)
     nmap <leader>f  <Plug>(coc-format-selected)

     augroup mygroup
         autocmd!
         " Setup formatexpr specified filetype(s).
         " autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
         autocmd FileType json setl formatexpr=CocAction('formatSelected')
         " Update signature help on jump placeholder
         autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
     augroup end

     " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
     vmap <leader>a  <Plug>(coc-codeaction-selected)
     nmap <leader>a  <Plug>(coc-codeaction-selected)

     " Remap for do codeAction of current line
     nmap <leader>ac  <Plug>(coc-codeaction)
     " Fix autofix problem of current line
     nmap <leader>qf  <Plug>(coc-fix-current)

     " Use `:Format` for format current buffer
     command! -nargs=0 Format :call FormatFile()
     nnoremap <c-k><c-f> :call FormatFile()<cr>

     function! FormatFile()
         execute "write"
       if &filetype == 'blade'
         normal mz
         execute ":%!blade-formatter --indent-size=2 %"
         normal `z
         return
       endif
       if &filetype == 'json'
         normal mz
         execute ":%!jq ."
         normal `z
         return
       endif

       call CocAction('format')
     endfunction

     " Use `:Fold` for fold current buffer
     command! -nargs=? Fold :call     CocAction('fold', <f-args>)

     " Add `:OR` command for organize imports of the current buffer.
     command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')


     " Add diagnostic info for https://github.com/itchyny/lightline.vim
     let g:lightline = {
                 \ 'colorscheme': 'onedark',
                 \ 'active': {
                 \   'left': [ [ 'mode', 'paste' ],
                 \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
                 \ },
                 \ 'component_function': {
                 \   'cocstatus': 'coc#status'
                 \ },
                 \ }


     if PM('antoinemadec/coc-fzf')
         ":CocFzfList	Equivalent to :CocList
         ":CocFzfList actions	Equivalent to :CocList actions
         ":CocFzfList commands	Equivalent to :CocList commands
         ":CocFzfList diagnostics	Equivalent to :CocList diagnostics. Toggle preview: '?'
         ":CocFzfList diagnostics --current-buf	Equivalent to :CocList diagnostics in the current buffer only
         ":CocFzfList extensions	Equivalent to :CocList extensions
         ":CocFzfList location	Equivalent to :CocList location. Toggle preview: '?'. Requires fzf.vim
         ":CocFzfList outline	Equivalent to :CocList outline, with colors. Requires ctags
         ":CocFzfList symbols	Equivalent to :CocList symbols
         ":CocFzfList symbols --kind {kind}	Equivalent to :CocList symbols -kind {kind}
         ":CocFzfList services	Equivalent to :CocList services
         ":CocFzfListResume	Equivalent to :CocListResume
         nnoremap <silent> <c-p><c--> :CocFzfList outline<cr>
         nnoremap <silent> <c-p>-     :CocFzfList location<cr>
         nnoremap <silent> <c-p>=     :CocFzfList diagnostic<cr>
         nnoremap <silent> <c-p><c-=> :CocFzfList diagnostic --current-buf<cr>
         nnoremap <silent> <c-p><c-0> :CocFzfList symbols<cr>
         nnoremap <silent> <c-p>0     :CocFzfList commands<cr>
         nnoremap <silent> <c-p><bs>  :CocFzfListResume<cr>

     endif


     " git gutter
     " navigate chunks of current buffer
     nmap [c <Plug>(coc-git-prevchunk)zz
     nmap ]c <Plug>(coc-git-nextchunk)zz


     " Show chunk info under cursor.
     nmap <leader>gi <Plug>(coc-git-chunkinfo)

     " Show commit contains current position
     nmap <leader>gh <Plug>(coc-git-commit)

     nnoremap <leader>hu :CocCommand git.chunkUndo<cr>
     nnoremap <leader>hw :CocCommand git.chunkStage<cr>
     nnoremap <leader>hs :CocCommand git.chunkStage<cr>

     " " show chunk diff at current position
     " nmap gs <Plug>(coc-git-chunkinfo)
     " " show commit contains current position
     " nmap gc <Plug>(coc-git-commit)


     " create text object for git chunks
     omap ig <Plug>(coc-git-chunk-inner)
     xmap ig <Plug>(coc-git-chunk-inner)
     omap ag <Plug>(coc-git-chunk-outer)
     xmap ag <Plug>(coc-git-chunk-outer)
 endif
 "}}} _coc.nvim

 " LanguageClient-neovim {{{
 if PM('autozimu/LanguageClient-neovim',
       \ {
       \ 'rev': 'next',
       \ 'build': 'bash install.sh',
       \ })
       "\ 'build': ':UpdateRemotePlugins'
   let g:LanguageClient_serverCommands = {
         \ 'rust':           ['rustup', 'run', 'nightly', 'rls'],
         \ 'python':         ['pyls'],
          \ 'go': ['/Users/juju/go/bin/gopls']
         \ }
         " \ 'javascript':     ['javascript-typescript-stdio'],
         " \ 'javascript.jsx': ['javascript-typescript-stdio'],
         " \ 'typescript':     ['javascript-typescript-stdio'],
         "
         autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()

   " Automatically start language servers.
   let g:LanguageClient_autoStart = 1

   " nnoremap <silent> gk :call LanguageClient_textDocument_hover()<CR>
   " nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
   " nnoremap <silent> gm :call LanguageClient_contextMenu()<CR>
   " nnoremap <silent> gR :call LanguageClient_textDocument_rename()<CR>
 endif
 "}}} _ LanguageClient-neovim

"LanguageServer-php-neovim {{{
 let $PHPLS_ALLOW_XDEBUG=0
call PM('roxma/LanguageServer-php-neovim', {'build': 'composer install && composer run-script parse-stubs'})
"}}} _LanguageServer-php-neovim

 " Command line
 " ambicmd {{{
 if PM( 'thinca/vim-ambicmd', {'on': []} )
   "Prevent ambicmd original mapping
   let g:vim_ambicmd_mapped = 1

   "cnoremap <c-cr> <CR>
   function! MapAmbiCMD()
     call PM_SOURCE('vim-ambicmd')
     cnoremap <expr> <Space> ambicmd#expand("\<Space>")
     cnoremap <expr> <c-CR>    ambicmd#expand("\<CR>")
     call feedkeys(':', 'n')
     nnoremap ; :
   endfunction
   nnoremap <silent> ; :call MapAmbiCMD()<cr>
 else
       nnoremap ; :
 endif
"}}}

"}}}

 " Operators {{{

 " operator-usr {{{

 call PM( 'kana/vim-operator-user' )

 "}}}
 " operator-camelize {{{

 if PM( 'tyru/operator-camelize.vim' )
   nmap <leader>ou <Plug>(operator-camelize)
   nmap <leader>oU <Plug>(operator-decamelize)
 endif

 "}}}
 " operator-blockwise {{{

 if PM( 'osyo-manga/vim-operator-blockwise', {'on_map': ['<Plug>(operator-blockwise-']} )
   nmap <leader>oY <Plug>(operator-blockwise-yank-head)
   nmap <leader>oD <Plug>(operator-blockwise-delete-head)
   nmap <leader>oC <Plug>(operator-blockwise-change-head)
 endif

 "}}}
 " operator-jerk {{{

 if PM( 'machakann/vim-operator-jerk' )
   nmap <leader>o>  <Plug>(operator-jerk-forward)
   nmap <leader>o>> <Plug>(operator-jerk-forward-partial)
   nmap <leader>o<  <Plug>(operator-jerk-backward)
   nmap <leader>o<< <Plug>(operator-jerk-backward-partial)
 endif

 "}}}

 "}}}

 " text-objects {{{

 "vim-indentwise {{{
 call PM( 'jeetsukumaran/vim-indentwise' ) " Use ]- ]+ ]= to move between indents
 "}}} _vim-indentwise
 " vim-swap {{{
 if PM( 'machakann/vim-swap', {'on_map': ['<Plug>(swap-'] } )
   let g:swap_no_default_key_mappings = 1
   nmap g<   <Plug>(swap-prev)
   nmap g>   <Plug>(swap-next)
   nmap g\|   <Plug>(swap-interactive)
 endif

 " _vim-swap }}}
 " argumentative {{{

 if PM( 'PeterRincker/vim-argumentative', {'on_map': ['<Plug>Argumentative_']} )

   "Move and manipultae arguments of a function
   nmap [; <Plug>Argumentative_Prev
   nmap ]; <Plug>Argumentative_Next
   xmap [; <Plug>Argumentative_XPrev
   xmap ]; <Plug>Argumentative_XNext
   nmap <; <Plug>Argumentative_MoveLeft
   nmap >; <Plug>Argumentative_MoveRight

 endif

 "}}}
 " argwrap {{{
 if PM( 'FooSoft/vim-argwrap', {'on_cmd': ['ArgWrap']} )

   nnoremap <silent> g;w :ArgWrap<CR>
   let g:argwrap_padded_braces = '[{('

 endif

 "}}}
 " sideways {{{

 if PM( 'AndrewRadev/sideways.vim',
                           \ {'on_cmd': ['SidewaysLeft', 'SidewaysRight',
                           \ 'SidewaysJumpLeft', 'SidewaysJumpRight']}
                           \)

   nnoremap s;k :SidewaysJumpRight<cr>
   nnoremap s;j :SidewaysJumpLeft<cr>
   nnoremap s;l :SidewaysJumpRight<cr>
   nnoremap s;h :SidewaysJumpLeft<cr>

   nnoremap c;k :SidewaysRight<cr>
   nnoremap c;j :SidewaysLeft<cr>
   nnoremap c;l :SidewaysRight<cr>
   nnoremap c;h :SidewaysLeft<cr>

 endif

 "}}}
 " vim-after-textobj {{{

 if PM( 'junegunn/vim-after-object' )
   " autocmd VimEnter * call after_object#enable('=', ':', '-', '#', ' ')
   " ]= and [= instead of a= and aa=
   autocmd VimEnter * call after_object#enable([']', '['], '=', ':', '-', '#', ' ', '>', '<')
 endif

 "}}}
 " targets.vim {{{

 call PM( 'wellle/targets.vim' )

"}}} _targets.vim
 " CamelCaseMotion {{{

   call PM( 'bkad/CamelCaseMotion' )
    "map <silent> w <Plug>CamelCaseMotion_w
    "map <silent> b <Plug>CamelCaseMotion_b
    "map <silent> e <Plug>CamelCaseMotion_e
    "map <silent> ge <Plug>CamelCaseMotion_ge

 "}}} _CamelCaseMotion

 "vim-textobj-user {{{
  call PM( 'kana/vim-textobj-user' )
  "}}} _vim-textobj-user

  "vim-textobj-sentence {{{
  call PM( 'reedes/vim-textobj-sentence' )            "is, as, ), (,   For real english sentences
                                                                             "also adds g) and g( for
                                                                             "sentence navigation
  "}}} _vim-textobj-sentence
  "vim-textobj-line {{{
  call PlugTextObj( 'kana/vim-textobj-line', 'll' )                        "il, al          for line
  "}}} _vim-textobj-line
  "vim-textobj-number {{{
  call PlugTextObj( 'haya14busa/vim-textobj-number', 'n' )                 "in, an          for numbers
  "}}} _vim-textobj-number
  "vim-textobj-functioncall {{{
  call PlugTextObj( 'machakann/vim-textobj-functioncall', 'C' )
  let g:textobj_functioncall_no_default_key_mappings =1
  "}}} _vim-textobj-functioncall
  " vim-textobj-function {{{
     call PlugTextObj( 'kana/vim-textobj-function', 'f' )
     let g:textobj_function_no_default_key_mappings =1
     Map vo iF <Plug>(textobj-function-I)
     Map vo aF <Plug>(textobj-function-A)
  " }}} _vim-textobj-function
  "vim-textobj-function-javascript {{{
  call PM('thinca/vim-textobj-function-javascript')
  "}}} _vim-textobj-function-javascript
  " vim-textobj-between {{{
  "ibX, abX                     for between two chars
  "changed to isX, asX          for between two chars
  call PlugTextObj( 'thinca/vim-textobj-between', 's' )
  let g:textobj_between_no_default_key_mappings =1
 "}}}
  " vim-textobj-any {{{
  "ia, aa          for (, {, [, ', ", <
  call PlugTextObj( 'rhysd/vim-textobj-anyblock', '<cr>', 0 )
  call PM('rhysd/vim-textobj-anyblock')
  let g:textobj_anyblock_no_default_key_mappings =1
  "}}}
  "vim-textobj-blockwise {{{
  "Don't try to lazyload this (Dein lazyloaded delimited :) )
  call PM( 'osyo-manga/vim-textobj-blockwise' ) "<c-v>iw, cIw    for block selection
  "}}} _vim-textobj-blockwise
  " vim-textobj-delimited {{{
    "id, ad, iD, aD   for Delimiters takes numbers d2id
  if PM( 'machakann/vim-textobj-delimited')
    Map vo id <Plug>(textobj-delimited-forward-i)
    Map vo ad <Plug>(textobj-delimited-forward-a)
    Map vo iD <Plug>(textobj-delimited-backward-i)
    Map vo aD <Plug>(textobj-delimited-backward-a)
  endif
  "}}} _vim-textobj-delimited
  "vim-textobj-pastedtext {{{
  if PM( 'saaguero/vim-textobj-pastedtext')
    "gb              for pasted text
    " Map vo gb <Plug>(textobj-pastedtext-text)
  endif
  "}}} _vim-textobj-pastedtext
  "vim-textobj-brace {{{
    call PlugTextObj ('Julian/vim-textobj-brace', 'j')                          "ij, aj          for all kinds of brces
    "}}} _vim-textobj-brace
    "vim-textobj-syntax {{{
    call PlugTextObj( 'kana/vim-textobj-syntax', 'y' )                          "iy, ay          for Syntax
    "}}} _vim-textobj-syntax
    "vim-textobj-url {{{
    call PlugTextObj( 'mattn/vim-textobj-url', 'u')                             "iu, au          for URL
    "}}} _vim-textobj-url
    "vim-textobj-comment {{{
    call PlugTextObj( 'glts/vim-textobj-comment', 'c' )
    Map vo aC <Plug>(textobj-comment-big-a)
    "}}} _vim-textobj-comment
  " vim-textobj-indblock {{{
    "io, ao, iO, aO  for indented blocks
    call PlugTextObj( 'glts/vim-textobj-indblock', 'o' )
    Map vo iO <Plug>(textobj-indblock-i)
    Map vo aO <Plug>(textobj-indblock-a)
  "}}} _vim-textobj-indblock
  " vim-textobj-indent {{{
    "ii, ai, iI, aI  for Indent
    call PlugTextObj( 'kana/vim-textobj-indent', 'i' )
    Map vo iI <Plug>(textobj-indent-same-i)
    Map vo aI <plug>(textobj-indent-same-a)
  "}}} _vim-textobj-indent
  " vim-textobj-fold {{{
    "iz, az          for folds
    call PlugTextObj ("kana/vim-textobj-fold", "z")

  "}}} _vim-textobj-fold
  " vim-textobj-variable-segment {{{

    "iv, av          for variable segment goO|rCome
    call PlugTextObj ("Julian/vim-textobj-variable-segment", "v")

  "}}} _vim-textobj-variable-segment
  " vim-textobj-lastpat {{{

    "i/, a/, i?, a?  for Searched pattern
  if PM( 'kana/vim-textobj-lastpat' , {'on_map': ['<Plug>(textobj-lastpat-n)', '<Plug>(textobj-lastpat-N)']} )
      Map vo i/ <Plug>(textobj-lastpat-n)
      Map vo i? <Plug>(textobj-lastpat-N)
  endif

  "}}} _vim-textobj-lastpat
  " vim-textobj-quote {{{

  " "TODO these mappings are fake
  " "iq, aq, iQ, aQ  for Curely quotes
  " call PlugTextObj( 'reedes/vim-textobj-quote', 'q' )

  " let g:textobj#quote#educate = 0               " 0=disable, 1=enable (def) autoconvert to curely

 "}}}
  " vim-textobj-xml {{{

    "ixa, axa        for XML attributes
  if PM( 'akiyan/vim-textobj-xml-attribute', {'on_map': ['<Plug>(textobj-xmlattribute-']} )

    let g:textobj_xmlattribute_no_default_key_mappings=1
    Map vo ax <Plug>(textobj-xmlattribute-xmlattribute)
    Map vo ix <Plug>(textobj-xmlattribute-xmlattributenospace)

  endif

  "}}}
  " vim-textobj-path {{{

    "i|, a|, i\, a\          for Path
  if PM( 'paulhybryant/vim-textobj-path', {'on_map': ['<Plug>(textobj-path-']} )

    let g:textobj_path_no_default_key_mappings =1

    Map vo a\\ <Plug>(textobj-path-next_path-a)
    Map vo i\\ <Plug>(textobj-path-next_path-i)
    Map vo a\\| <Plug>(textobj-path-prev_path-a)
    Map vo i\\| <Plug>(textobj-path-prev_path-i)

  endif

  "}}}
  " vim-textobj-datetime {{{

    "igda, agda,      or dates auto
    " igdd, igdf, igdt, igdz  means
    " date, full, time, timerzone
  if PM( 'kana/vim-textobj-datetime', {'on_map': ['<Plug>(textobj-datetime-']} )

    let g:textobj_datetime_no_default_key_mappings=1
    Map vo agda <Plug>(textobj-datetime-auto)
    Map vo agdd <Plug>(textobj-datetime-date)
    Map vo agdf <Plug>(textobj-datetime-full)
    Map vo agdt <Plug>(textobj-datetime-time)
    Map vo agdz <Plug>(textobj-datetime-tz)

    Map vo igda <Plug>(textobj-datetime-auto)
    Map vo igdd <Plug>(textobj-datetime-date)
    Map vo igdf <Plug>(textobj-datetime-full)
    Map vo igdt <Plug>(textobj-datetime-time)
    Map vo igdz <Plug>(textobj-datetime-tz)

  endif

  "}}}
  " vim-textobj-postexpr {{{
    "ige, age        for post expression
    call PlugTextObj( 'syngan/vim-textobj-postexpr', 'ge' )
    let g:textobj_postexpr_no_default_key_mappings =1

  "}}}
  " vim-textobj-multi {{{

    call PlugTextObj( 'osyo-manga/vim-textobj-multitextobj', 'm' )

    let g:textobj_multitextobj_textobjects_i = [
          \   "\<Plug>(textobj-url-i)",
          \   "\<Plug>(textobj-multiblock-i)",
          \   "\<Plug>(textobj-function-i)",
          \   "\<Plug>(textobj-entire-i)",
          \]

  "}}}
  " vim-textobj-keyvalue {{{

  if PM( 'vimtaku/vim-textobj-keyvalue', {'on_map': ['<Plug>(textobj-key-', '<Plug>(textobj-value-']} )

    let g:textobj_key_no_default_key_mappings=1
    Map vo ak  <Plug>(textobj-key-a)
    Map vo ik  <Plug>(textobj-key-i)
    Map vo aK  <Plug>(textobj-value-a)
    Map vo iK  <Plug>(textobj-value-i)

  endif

  "}}}
  " vim-textobj-space {{{

    "iS, aS i<Space> for contineous spaces
    call PlugTextObj( 'saihoooooooo/vim-textobj-space', '<Space>' )
    let g:textobj_space_no_default_key_mappings =1

  "}}}
  " vim-textobj-entire {{{
    "iG, aG          for entire document
    call PlugTextObj( 'kana/vim-textobj-entire', 'G' )
    let g:textobj_entire_no_default_key_mappings =1

  "}}}
  " vim-textobj-php {{{

    "i<, a<        for <?php ?>
    call PlugTextObj( 'akiyan/vim-textobj-php', '?' )
    let g:textobj_php_no_default_key_mappings =1

  "}}}
 "}}}

 " Navigation {{{

 "Windows, Buffers, Tabs
 "{{{ vim-CtrlSpace
 if PM('vim-ctrlspace/vim-ctrlspace', {'on_cmd': ['CtrlSpace']})

     " let g:CtrlSpaceSaveWorkspaceOnExit = 1

     nnoremap <silent> <C-Space><C-Space> :CtrlSpace<cr>

     let g:CtrlSpaceSymbols = { "File": "◯", "CTab": "▣", "Tabs": "▢" }
     if executable("ag")
         let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
     endif
 endif
 "}}} _vim-CtrlSpace

 " File
 " Telescope {{{
    if PM('nvim-lua/telescope.nvim')
        call PM('nvim-lua/popup.nvim')
        call PM('nvim-lua/plenary.nvim')
         " -- Fuzzy find over git files in your directory
        " require('telescope.builtin').git_files()

        " -- Grep files as you type (requires rg currently)
        " require('telescope.builtin').live_grep()

        " -- Use builtin LSP to request references under cursor. Fuzzy find over results.
        " require('telescope.builtin').lsp_references()

        " -- Convert currently quickfixlist to telescope
        " require('telescope.builtin').quickfix()

        " -- Convert currently loclist to telescope
        " require('telescope.builtin').loclist()

    endif
 " }}} _Telescopt

 "cpsm {{{
    call PM('nixprime/cpsm')
 "}}} _cpsm
 " FZF {{{
   if PM('junegunn/fzf', { 'build': 'sh -c "~/.config/nvim/dein/repos/github.com/junegunn/fzf/install --bin"', 'merged': 0 })
       " [Buffers] Jump to the existing window if possible
       let g:fzf_buffers_jump = 1

       " [[B]Commits] Customize the options used by 'git log':
       let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

       let g:fzf_command_prefix = 'Fzf'

       "Show FZF in a floating window
       let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7 } }
       " let $FZF_DEFAULT_OPTS='--layout=reverse'
       "let g:fzf_layout = { 'window': 'execute (tabpagenr()-1)."tabnew"' }
       "let g:fzf_layout = { 'window': '-tabnew' }

       au FileType fzf set nonu nornu

       if !has('nvim') && has('gui_running')
           let g:fzf_launcher = "fzf_iterm %s"
       endif


   command! -bang -nargs=* Rg
               \ call fzf#vim#grep(
               \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
               \   fzf#vim#with_preview(), <bang>0)

   nnoremap silent! <c-p><c-a> <cmd>Rg<cr>
   nnoremap silent! <c-p>a <cmd>Rg <c-r><c-w><cr>

    if has('mac')
        let $FZF_DEFAULT_OPTS=" --history=/Users/JuJu/.fzf_history --pointer=' ▶' --marker='◉' --reverse --bind 'ctrl-space:select-all,ctrl-l:jump'  --color=bg+:#cccccc,fg+:#444444,hl:#22aa44,hl+:#44ff44,gutter:#eeeeee,marker:#ff0000"
        let s:null = 'null'
    elseif has('win64')
        let $FZF_DEFAULT_OPTS=" --history=C:/Users/juju/.fzf_history --reverse --bind '::jump,;:jump-accept,ctrl-a:select-all'  --color=bg+:#cccccc,fg+:#444444,hl:#22aa44,hl+:#44ff44"
        let s:null = 'nul'
    endif


    let $FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!{.git,node_modules,vendor}/*" --glob "!*{.jpg,png}" 2> /dev/'.s:null

    command! -bang -nargs=* FZFAg call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!{.git,node_modules,vendor}/*" --color "always" '.shellescape(<q-args>) . ' 2> /dev/'.s:null, 1, <bang>0)


    command! -bang -nargs=* Rg2 call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
    nnoremap <silent> <c-p><c-a> :Rg2 <CR>
    nnoremap <silent> <c-p>a :Rg2 <C-R><C-W><CR>
    nnoremap <silent> <c-p><c-j> :FzfAg <CR>
    nnoremap <silent> <c-p>j :FzfAg <C-R><C-W><CR>


  if PM( 'junegunn/fzf.vim',
          \ {
          \   'on_map':
          \ [
          \   '<plug>(fzf-',
          \   ['i', '<plug>(fzf-complete-word)'],
          \   ['i', '<plug>(fzf-complete-path)'],
          \   ['i', '<plug>(fzf-complete-file-ag)'],
          \   ['i', '<plug>(fzf-complete-line)'],
          \   ['i', '<plug>(fzf-complete-buffer-line)'],
          \   ['i', '<plug>(fzf-complete-file)']
          \ ],
          \   'on_cmd': ['FzfFiles', 'FzfGitFiles', 'FzfBuffers', 'FzfColors', 'FzfAg', 'FzfLines',
          \              'FzfBLines', 'FzfTags', 'FzfBTags', 'FzfMaps', 'FzfMarks', 'FzfWindows',
          \              'FzfLocate', 'FzfHistory', 'FzfSnippets',
          \              'FzfCommits', 'FzfBCommits', 'FzfCommands', 'FzfHelptags']
          \ })
 " 'FzfHistory:', 'FzfHistory/',

 if PM('pbogut/fzf-mru.vim')
     " only show MRU files from within your cwd
     let g:fzf_mru_relative = 1
     nnoremap <c-p><c-u> :FZFMru<cr>
     nnoremap <c-p>u     :execute "FZFMru " expand('<cword>')<cr>
     " to enable found references displayed in fzf
     let g:LanguageClient_selectionUI = 'fzf'
 endif
   " [Buffers] Jump to the existing window if possible
   let g:fzf_buffers_jump = 1

   " Command Local Options {{{
      " [Files] Extra options for fzf
      "         e.g. File preview using coderay (http://coderay.rubychan.de/)
      let g:fzf_files_options =
            \ '--preview "(coderay {} || cat {}) 2> /dev/' . s:null . ' | head -'.&lines.'"'

      " [Buffers] Jump to the existing window if possible
      let g:fzf_buffers_jump = 1

      " [[B]Commits] Customize the options used by 'git log':
      let g:fzf_commits_log_options =
            \ '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

      " [Tags] Command to generate tags file
      let g:fzf_tags_command = 'ctags -R'

      " [Commands] --expect expression for directly executing the command
      "let g:fzf_commands_expect = 'alt-enter,ctrl-x'
   "}}} _Command Local Options

   function! s:find_git_root()
     return system('git rev-parse --show-toplevel 2> /dev/' . s:null)[:-2]
   endfunction

   function! Map_FZF(cmd, key, options, cword)
     exe "nnoremap <silent> <c-p><c-" . a:key . "> :" . a:cmd . a:options . "<cr>"
    "This type is where no args passed
     if a:cword == 0
       exe "nnoremap <silent> <c-p>" . a:key . " :" . a:cmd . a:options . "<cr>"

    "This type is where -q used pass args
     elseif a:cword == 1
       exe "nnoremap <silent> <c-p>" . a:key . " :" . a:cmd . a:options .
             \ " -q <c-r>=shellescape(expand('<cword>'))<cr>" . "<cr>"
       exe "vnoremap <silent> <c-p>" . a:key . " :<c-u>" . a:cmd . a:options .
             \ " -q <c-r>=shellescape(GetVisualSelection())<cr>" . "<cr>"

    "This type is where 'word DOES produce results
     elseif a:cword == 2
       exe "nnoremap <silent> <c-p>" . a:key . " :" . a:cmd . a:options .
             \ " '<c-r>=expand('<cword>')<cr><cr>"
       exe "vnoremap <silent> <c-p>" . a:key . " :<c-u>" . a:cmd . a:options .
             \ " '<c-r>=GetVisualSelection()<cr><cr>"

    "This type is where 'word does NOT produce results
     elseif a:cword == 3
       exe "nnoremap <silent> <c-p>" . a:key . " :" . a:cmd . a:options .
             \ " <c-r>=expand('<cword>')<cr><cr>"
       exe "vnoremap <silent> <c-p>" . a:key . " :<c-u>" . a:cmd . a:options .
             \ " <c-r>=GetVisualSelection()<cr><cr>"
     endif
     if has('nvim')
       exe "tnoremap <silent> <c-p><c-" . a:key . "> <c-\\><c-n>:" . a:cmd . a:options "<cr>"
     endif

   endfunction


"call Map_FZF  ( "COMMAND"   , "KEY"   , "OPTIONS"                                                                        , cw )
 call Map_FZF  ( "FZF "     , "d"     , " --reverse %:p:h "                                                              , 0  )
 call Map_FZF  ( "FZF "     , "r"     , " --reverse <c-r>=FindGitDirOrRoot()<cr>"                                        , 0  )
 call Map_FZF  ( "FzfFiles "    , "p"   , ''                                                                               , 2  )
 " call Map_FZF  ( "FzfAg"       , "a"     , ""                                                                               , 3  )
 call Map_FZF  ( "FzfLines"    , "L"     , ""                                                                               , 2  )
 call Map_FZF  ( "FzfBLines"   , "l"     , ""                                                                               , 2  )
 call Map_FZF  ( "FzfBTags"    , "t"     , ""                                                                               , 0  )
 call Map_FZF  ( "FzfTags"     , "]"     , ""                                                                               , 0  )
"call Map_FZF  ( "FzfLocate"    , "<cr>"  , "--reverse  %:p:h"                                                               , 0  )
 call Map_FZF  ( "FzfGitFiles"  , "v"     , ''                                                                               , 0  )
 call Map_FZF  ( "FzfCommits"  , "C"     , ""                                                                               , 0  )
 call Map_FZF  ( "FzfBCommits!" , "c"     , ""                                                                               , 0  )
 call Map_FZF  ( "FzfSnippets" , "s"     , ""                                                                               , 0  )
 call Map_FZF  ( "FzfMarks"    , "<c-'>" , ""                                                                               , 0  )
 call Map_FZF  ( "FzfMarks"    , "'"     , ""                                                                               , 0  )
 call Map_FZF  ( "FzfWindows"  , "w"     , ""                                                                               , 0  )
 call Map_FZF  ( "FzfHelptags" , "k"     , ""                                                                               , 0  )
 call Map_FZF  ( "FzfHistory" , "h"     , ""                                                                               , 0  )

 function! GetFunctions()
     let query = ''
     if &ft == 'php'
         let query = 'function'
     endif
     exe ':FzfBLines!' query
 endfunction
 nnoremap <silent> <c-p><c-f> <cmd>call GetFunctions()<cr>

 nnoremap <silent> <c-p><c-g> <cmd>FzfPreviewGitStatus<cr>
 nnoremap <silent> <c-p>g <cmd>FzfPreviewGitStatus<cr>

 "The last param is <bang>0 to make it fullscreen
 nnoremap <silent> <c-p>p :silent! call fzf#vim#files(getcwd(), {'options': '--reverse -q '.shellescape(expand('<cword>'))}, 1)<cr>


   "nmap <c-p><c-i> <plug>(fzf-maps-n)
   nnoremap <silent> <c-p><c-m> :FzfMaps!<cr>
   xmap <silent> <c-p><c-m> <plug>(fzf-maps-x)
   omap <silent> <c-p><c-m> <plug>(fzf-maps-o)

   imap <silent> <c-x><c-k> <plug>(fzf-complete-word)
   imap <silent> <c-x><c-f> <plug>(fzf-complete-path)
   imap <silent> <c-x><c-a> <plug>(fzf-complete-file-ag)
   imap <silent> <c-x><c-l> <plug>(fzf-complete-line)
   imap <silent> <c-x><c-i> <plug>(fzf-complete-buffer-line)
   imap <silent> <c-x><c-\> <plug>(fzf-complete-file)

   "Get all files including git ignore
   LMap N! <c-p><space> <Plug>FzfAllFiles :call fzf#run({"source":"ag -all -l  \"\" \| sort -u " , "sink":"edit"})<cr>
   " nnoremap <silent> <c-p><space> :call fzf#run({"source":"ag -all -l  \"\" \| sort -u " , "sink":"edit"})<cr>
   nnoremap <silent> <c-p><c-space> <cmd>FzfHistory!<cr>

   function! s:get_directories()
     call fzf#run({"source":"ag -l --nocolor -g \"\" | gawk 'NF{NF-=1};1' FS=/ OFS=/ | sort -u | uniq" , "sink":"Defx"})
    "find . -type d   -not -iwholename \"./.phpcd*\" -not -iwholename \"./node_modules*\" -not -iwholename \".\" -not -iwholename \"./vendor*\" -not -iwholename \"./.git*\"
    "ag -l --nocolor -g "" | awk 'NF{NF-=1};1' FS=/ OFS=/ | sort -u | uniq
   endfunction
   nnoremap <silent> <c-p>[ :call fzf#run({"source":"find . -type d", "sink":"Defx"})<cr>
   nnoremap <silent> <c-p><c-[> :cal <SID>get_directories()<cr>

   " Replace the default dictionary completion with fzf-based fuzzy completion
   " inoremap <expr> <c-x><c-k> fzf#complete('cat /usr/share/dict/words')

   function! PrintPathFunction(myParam)
     execute ":normal i".a:myParam
   endfunction
   command! -nargs=1 PrintPath call PrintPathFunction(<f-args>)

   function! PrintPathInNextLineFunction(myParam)
     put=a:myParam
   endfunction

   command! -nargs=1 PrintPathInNextLine call PrintPathInNextLineFunction(<f-args>)

   function! s:build_quickfix_list(lines)
       call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
       copen
       cc
   endfunction

   function! s:build_location_list(lines)
       call setloclist(0, map(copy(a:lines), '{ "filename": v:val }'))
       lopen
       ll
   endfunction


   let g:fzf_action = {
         \ 'ctrl-q': function('s:build_quickfix_list'),
         \ 'ctrl-l': function('s:build_location_list'),
         \ 'ctrl-m': 'e!',
         \ 'ctrl-t': 'tabedit!',
         \ 'ctrl-s': 'split',
         \ 'ctrl-v': 'vsplit' }
         " \ 'ctrl-i': 'PrintPath',
         " \ 'ctrl-o': 'PrintPathInNextLine',

   command! FZFMru call fzf#run({
         \ 'source':  reverse(s:all_files()),
         \ 'sink':    'edit',
         \ 'options': ' --reverse -m --no-sort -x',
         \ 'down':    '40%' })

function! s:all_files()
  return extend(
  \ filter(copy(v:oldfiles),
  \        "v:val !~ 'term:\\|fugitive:\\|NERD_tree\\|^/tmp/\\|.git/'"),
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

   " Tabs {{{
   function! s:tablist()
     redir => tabs
     silent tabs
     redir END
     let new_tabs = filter(split(tabs, '\n'), 'v:val =~ "Tab page"')
     let i = 0
     while i < len(new_tabs)
       let current_tab_buffers = map(tabpagebuflist(i + 1), "bufname(v:val)")
       let current_tab_buffers = map(current_tab_buffers, "substitute(v:val, 'term:.*', ':term:', '') ")
       let current_tab_buffers = map(current_tab_buffers, "substitute(v:val, '^.*/', '', '')")
       let new_tabs[i] = new_tabs[i] . '             '.join(current_tab_buffers, ' | ')
       let i = i + 1
     endwhile
     return new_tabs
   endfunction

   function! s:tabopen(e)
     "echomsg 'bufname='bufname("")
     "echomsg ':normal! '. matchstr(a:e, 'Tab page \zs[0-9]*\ze .*$').'gt'
     "execute 'normal! ' . matchstr(a:e, 'Tab page \zs[0-9]*\ze .*$').'gt'
     execute ':tabnext ' . matchstr(a:e, 'Tab page \zs[0-9]*\ze .*$')
     "let g:fzf_cmd='normal! ' . matchstr(a:e, 'Tab page \zs[0-9]*\ze .*$').'gt'
     "call timer_start(50, '<sid>SwitchTab', {'repeat': 1})
   endfunction
   "func! s:SwitchTab(timer)
   "execute g:fzf_cmd
   "endfunc

   if has('nvim')
     tmap <silent> <c-p><c-i> <c-\><c-n><c-p><c-i>
   endif

   command! FzfTabs :call fzf#run({
         \   'source':  reverse(<sid>tablist()),
         \   'sink':    function('<sid>tabopen'),
         \   'options': " --preview-window right:50%  --preview 'echo {}'  --bind ?:toggle-preview",
         \ })

   LMap N! <c-p><c-i> <plug>FzfTabs :FzfTabs<cr>

   "}}} _Tabs

   "open_buffers -term {{{
   function! s:buflist()
     redir => ls
     silent ls
     redir END
     "get all buffers excpt the ones that has term:// in them
     return  filter(split(ls, '\n'), 'v:val !~ "term://"')
   endfunction

   function! s:bufopen(e)
           let g:bufopen_cmd = get({'ctrl-s': 'split |',
                       \ 'ctrl-v': 'vertical split |',
                       \ 'ctrl-t': 'tabnew | '}, a:e[0], '')

           let bufferNumber = matchstr(a:e[1], '^[ 0-9]*')
           execute g:bufopen_cmd 'buffer' bufferNumber
           " execute 'buffer' matchstr(a:e, '^[ 0-9]*')
   endfunction


   " nnoremap <silent> <c-p><c-o> :call fzf#run({
   "       \   'source':  reverse(<sid>buflist()),
   "       \   'sink':    function('<sid>bufopen'),
   "       \   'options': '+m --reverse',
   "       \   'window':    '-tabnew'
   "       \ })<CR>
   nnoremap <silent> <c-p><c-o> <cmd>call fzf#run({
         \   'source':  reverse(<sid>buflist()),
         \   'sink*':    function('<sid>bufopen'),
         \   'options': '+m --reverse --expect=ctrl-t,ctrl-v,ctrl-s',
         \ })<CR>

   "}}} _open_buffers -term

   "FzfNeighbor {{{
   function! s:fzf_neighbouring_files()
       let current_file =expand("%")
       let cwd = fnamemodify(current_file, ':p:h')
       let command = 'ag -g "" -f ' . cwd . ' --depth 0'

       call fzf#run({
                   \ 'source': command,
                   \ 'sink':   'e',
                   \ 'options': '-m -x +s',
                   \ })
   endfunction

   command! FZFNeigh call s:fzf_neighbouring_files()
   nnoremap <silent> <c-p><c-n> <cmd>FZFNeigh<cr>
   "}}} _FzfNeighbor

   "Ag {{{
   function! s:ag_to_qf(line)
       let parts = split(a:line, ':')
       return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
                   \ 'text': join(parts[3:], ':')}
   endfunction

   function! s:ag_handler(lines)
       if len(a:lines) < 2 | return | endif

       let cmd = get({'ctrl-s': 'split',
                   \ 'ctrl-v': 'vertical split',
                   \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
       let list = map(a:lines[1:], 's:ag_to_qf(v:val)')

       let first = list[0]
       execute cmd escape(first.filename, ' %#\')
       execute first.lnum
       execute 'normal!' first.col.'|zz'

       if len(list) > 1
           call setqflist(list)
           copen
           wincmd p
       endif
   endfunction

   command! -nargs=* AgCustom call fzf#run({
               \ 'source':  printf('ag --nogroup --column --color "%s"',
               \                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
               \ 'sink*':    function('<sid>ag_handler'),
               \ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
               \            '--multi --bind=ctrl-a:select-all,ctrl-d:deselect-all '.
               \            '--color hl:68,hl+:110',
               \ 'down':    '50%'
               \ })
   nnoremap <silent> <c-p><c-q> <cmd>FZFNeigh<cr>
   "}}} _Ag

   "open_terms {{{
   function! s:termlist()
     redir => ls
     silent ls!
     redir END
     "get term:// buffers
     return  filter(filter(split(ls, '\n'), 'v:val =~ "term://"'), 'v:val !~ "fzf"')
   endfunction

   function! s:termtabopen(e)
     let l:term_buffer_id = str2nr(matchstr(a:e, '^[ 0-9]*'))
     let l:buffers_parent_tab = -1
      for i in range(tabpagenr('$'))
         if (index(tabpagebuflist(i + 1), l:term_buffer_id) >= 0)
           let l:buffers_parent_tab = i + 1
         endif
      endfor
      if (buffers_parent_tab >= 0)
        execute "tabnext " l:buffers_parent_tab
        execute bufwinnr(l:term_buffer_id) "wincmd w"
      else
        execute 'buffer' l:term_buffer_id
      endif
   endfunction
   nnoremap <silent> <c-p><c-;> <cmd>call fzf#run({
         \   'source':  reverse(<sid>termlist()),
         \   'sink':    function('<sid>termtabopen'),
         \   'options': '+m --reverse',
         \ })<CR>

   "}}} _open_terms


  endif

 endif

 " }}}
 " fzf-preview {{{
 if PM('yuki-ycino/fzf-preview.vim', {'on_cmd':[
             \ 'FzfPreviewProjectFiles',
             \ 'FzfPreviewGitFiles',
             \ 'FzfPreviewDirectoryFiles',
             \ 'FzfPreviewGitStatus',
             \ 'FzfPreviewBuffers',
             \ 'FzfPreviewProjectOldFiles',
             \ 'FzfPreviewProjectMruFiles',
             \ 'FzfPreviewProjectGrep',
             \ 'FzfPreviewOldFiles',
             \ 'FzfPreviewMruFiles',
             \ 'FzfPreviewFromResources'
             \ ]})

     " let g:fzf_preview_command = 'bat --color=always --style=grid {-1}' " Installed bat
     " let g:fzf_preview_command = 'bat --color=always --style=grid {-1}' " Installed bat

     call PM('Shougo/neomru.vim')
 endif
 " }}} _fzf-preview
 " neovim-fuzzy {{{
 " cloudhead/neovim-fuzzy
 if PM('bosr/fzy.vim', { 'rev': 'dev', 'on_cmd': ['FuzzyOpen', 'FuzzyOpenFiles']})
     nnoremap <c-p><c-e> <cmd> let g:fuzzy_winheight = winheight(0) \| FuzzyOpenFiles<cr>
     let g:fuzzy_winheight = 25
     let g:fuzzy_bufferpos = 'tab'
     " <Esc>     close fzy pane
     " <Enter>   open selected file with default open command
     " <Ctrl-S>  open selected file in new horizontal split
     " <Ctrl-V>  open selected file in new vertical split
     " <Ctrl-T>  open selected file in new tab
     " <Ctrl-N>  next entry
     " <Ctrl-P>  previous entry

    autocmd FileType fuzzy tnoremap <silent> <buffer> <Esc> <C-\><C-n>:FuzzyKill<CR>
    autocmd FileType fuzzy tnoremap <silent> <buffer> <C-T> <C-\><C-n>:FuzzyOpenFileInTab<CR>
    autocmd FileType fuzzy tnoremap <silent> <buffer> <C-S> <C-\><C-n>:FuzzyOpenFileInSplit<CR>
    autocmd FileType fuzzy tnoremap <silent> <buffer> <C-V> <C-\><C-n>:FuzzyOpenFileInVSplit<CR>
    autocmd FileType fuzzy tnoremap <silent> <buffer> <C-space> <C-\><C-n>:FuzzySwitch<CR>

     " let g:fuzzy_opencmd = 'vsplit'
 endif " PM()
 " }}} _neovim-fuzzy
 " vim-picker {{{
 if PM('srstevenson/vim-picker')
    let g:picker_custom_find_executable = 'rg'
    let g:picker_custom_find_flags = '--color never --files'
 endif
 " }}}
 " vim-clap {{{
    if PM('liuchengxu/vim-clap')

        ", { 'build': ':Clap install-binary' }

        let g:clap_popup_border = 'rounded'

        let g:clap_layout = { 'relative': 'editor', 'width': '78%', 'height': '35%', 'row': '20%', 'col': '11%' }
        let g:clap_open_action = {'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit', 'ctrl-o': 'edit' }
        let g:clap_selected_sign = {'text': ' >', 'texthl': "ClapSelectedSign", "linehl": "ClapSelected"}
        let g:clap_current_selection_sign = {'text': '>>', 'texthl': "ClapCurrentSelectionSign", "linehl": "ClapCurrentSelection"}
        let g:clap_popup_input_delay = 0


        " hi ClapPreview guibg=#fefefe
        " hi ClapDisplay guibg=#f9f9f9

        " hi ClapPreview guibg=#FCF4ED
        " hi ClapSpinner guibg=#f2ebe3 guifg=#333333
        " hi ClapDisplay guibg=#f2ebe3
        " hi ClapPopupCursor guibg=#f2ebe3
        " hi ClapInput guibg=#f2ebe3
        " hi ClapSearchText guibg=#f2ebe3 guifg=#2753B3
        " hi ClapCurrentSelection guibg=#f2fbe7 guifg=#2753B3
        " hi ClapFuzzyMatches1 guifg=#E703A3
        " hi ClapFuzzyMatches2 guifg=#CB0291
        " hi ClapFuzzyMatches3 guifg=#B80282
        " hi ClapFuzzyMatches4 guifg=#AC017A
        " hi ClapFuzzyMatches5 guifg=#A20173
        " hi ClapFuzzyMatches6 guifg=#95016A
        " hi ClapFuzzyMatches7 guifg=#86015F
        " hi ClapFuzzyMatches8 guifg=#7A0157
        " hi ClapFuzzyMatches9 guifg=#6C004D
        " hi ClapFuzzyMatches10 guifg=#600044
        " hi ClapFuzzyMatches11 guifg=#480033
        " hi ClapFuzzyMatches12 guifg=#380028
        let g:clap_theme = {
                    \ }
                    " \ 'input': {'guifg': 'red', 'ctermfg': 'red', 'guibg': 'red'},
                    " \ 'search_text': {'guifg': 'red', 'ctermfg': 'red'},
                    " \ 'selected': {'guifg': 'green', 'ctermfg': 'green'},
                    " \ 'spinner': {'guifg': 'green', 'ctermfg': 'green'},
                    " \ 'selected_sign': {'guifg': 'green', 'ctermfg': 'green'},
                    " \ 'current_selection': {'guifg': 'green', 'ctermfg': 'green'},
                    " \ 'current_selection_sign': {'guifg': 'green', 'ctermfg': 'green'},
                    " \ 'display': {'guifg': 'green', 'ctermfg': 'green'},
                    " \ 'preview': {'guifg': 'green', 'ctermfg': 'green'}
                    "
        " let g:clap_theme = 'material_design_dark'
        nnoremap <c-s>f        :Clap files<cr>
        nnoremap <c-s><c-s>f    :Clap files ++query=<cword><cr>
        nnoremap <c-s>-    :exec "Clap files " expand('%:h:p')<cr>

        nnoremap <c-s>l        :Clap blines<cr>
        nnoremap <c-s>L        :Clap lines<cr>
        nnoremap <c-s>o        :Clap buffers<cr>
        nnoremap <c-s>c        :Clap colors<cr>
        nnoremap <c-s>;        :Clap command<cr>
        nnoremap <c-s><cr>     :Clap command_history<cr>
        nnoremap <c-s>/        :Clap search_history<cr>
        nnoremap <c-s>gc       :Clap commits<cr>
        nnoremap <c-s>t        :Clap file_types<cr>
        nnoremap <c-s><c-f>    :Clap gfiles<cr>
        nnoremap <c-s>F        :Clap git_diff_files<cr>
        nnoremap <c-s>a        :Clap grep<cr>
        nnoremap <c-s><c-s>a    :Clap grep ++query=<cword><cr>
        nnoremap <c-s>j        :Clap jumps<cr>
        nnoremap <c-s>'        :Clap marks<cr>
        nnoremap <c-s>m        :Clap maps<cr>
        nnoremap <c-s>q        :Clap quickfix<cr>
        nnoremap <c-s>]        :Clap loclist<cr>
        nnoremap <c-s>r        :Clap registers<cr>
        nnoremap <c-s>y        :Clap yanks<cr>
        nnoremap <c-s>p        :Clap filer<cr>
        nnoremap <c-s>P        :Clap providers<cr>
        nnoremap <c-s>w        :Clap windows<cr>
        nnoremap <c-s>w        :Clap loclist<cr>


         " hi default link ClapInput   Visual
         " hi default link ClapDisplay Pmenu
         " hi default link ClapPreview PmenuSel
         " hi default link ClapMatches Search

         " " By default ClapQuery will use the bold fg of Normal and the same bg of ClapInput

         " hi ClapDefaultPreview          ctermbg=237 guibg=#3E4452
         " hi ClapDefaultSelected         cterm=bold,underline gui=bold,underline ctermfg=80 guifg=#5fd7d7
         " hi ClapDefaultCurrentSelection cterm=bold gui=bold ctermfg=224 guifg=#ffd7d7

         " hi default link ClapPreview          ClapDefaultPreview
         " hi default link ClapSelected         ClapDefaultSelected
         " hi default link ClapCurrentSelection ClapDefaultCurrentSelection

         " augroup ClapUserGroup
         "     autocmd!
         "     autocmd User ClapOnEnter   call ClapOnEnter()
         "     autocmd User ClapOnExit    call ClapOnExit()
         " augroup END
         "

         au filetype clap_input inoremap <buffer> <c-space> <cmd>call g:clap.preview.hide()()<cr>

        let g:clap_provider_commands = {
                    \ 'source': ['Clap debug', 'UltiSnipsEdit'],
                    \ 'sink': { selected -> execute(selected, '')},
                    \ }


        function! s:laravel_sink(selected)
            if has_key(g:clap, 'open_action')
                execute g:clap.open_action
            endif
            " call execute('edit ' .  g:clap_laravel_entries[a:selected])
            call execute('Clap files ' .  g:clap_laravel_entries[a:selected])
        endfunction

        let g:clap_laravel_entries =  {
                    \ 'App':             'app',
                    \ 'Assets':          'resources/assets/js',
                    \ 'Breads':          'resources/bread',
                    \ 'Controllers':     'app/Http/Controllers',
                    \ 'Factories':       'database/factories',
                    \ 'Helpers (PHP)':   'app/Helpers',
                    \ 'JS':              'public/js',
                    \ 'Migrations':      'database/migrations',
                    \ 'Models (JS)':     'resources/assets/js/models/',
                    \ 'Models (PHP)':    'app',
                    \ 'Observers':       'app/Observers',
                    \ 'Providers':       'app/Providers',
                    \ 'Public':          'public',
                    \ 'Requests':        'app/Http/Requests',
                    \ 'Resources':       'resources',
                    \ 'Router (JS)':     'resources/assets/js/router.js',
                    \ 'Router (Web)':    'routes/web',
                    \ 'Seeds':           'database/seeds',
                    \ 'Tests (Feature)': 'tests/Feature',
                    \ 'Tests (Unit)':    'tests/Unit',
                    \ 'Tests':           'tests',
                    \ 'Traits':          'app/traits',
                    \ 'Views (JS)':      'resources/assets/js/views',
                    \ 'Views (PHP)':     'resources/views',
                    \ 'components (JS)': 'resources/assets/js/components',
                    \ 'database (JS)':   'resources/assets/js/database',
                    \ 'models (JS)':     'resources/assets/js/models',
                    \ }

        "'sink': { selected -> execute('edit ' . FindGitDirOrRoot() . '/' . g:clap_laravel_entries[selected])},
        let g:clap_provider_laravel = {
                    \ 'source': sort(keys(g:clap_laravel_entries)),
                    \ 'sink': function('s:laravel_sink'),
                    \ 'support_open_action': v:true,
                    \ }


    endif
 " }}} _ vim-clap

 "floatLf-nvim {{{
    if PM('haorenW1025/floatLf-nvim')
 " LfToggle
 " LfToggleCurrentBuf
        let g:floatLf_autoclose = 1
        " let g:floatLf_lf_close = 'q'
        " let g:floatLf_lf_open = '<cr>'
        " let g:floatLf_lf_split = '<c-s>'
        " let g:floatLf_lf_vsplit = '<c-v>'
        " let g:floatLf_lf_tab = '<c-t>'

        let g:floatLf_border = 1
        " let g:floatLf_topleft_border = "?"
        " let g:floatLf_topright_border = "?"
        " let g:floatLf_botleft_border = "?"
        " let g:floatLf_botright_border = "?"
        " let g:floatLf_vertical_border = "?"
        " let g:floatLf_horizontal_border = "?"
    endif
 "}}} _ floatLf-nvim
 "nnn.vim {{{
    if PM('mcchrish/nnn.vim')

        " Start nnn in the current file's directory
        nnoremap <silent> <leader>_ :NnnPicker '%:p:h'<CR>

        " let g:nnn#replace_netrw = 1

         let g:nnn#command = "NNN_COLORS='4321' nnn -d"

         function! CopyLinestoRegister(lines)
             let joined_lines = join(a:lines, "\n")
             if len(a:lines) > 1
                 let joined_lines .= "\n"
             endif
             echom joined_lines
             let @+ = joined_lines
         endfunction

         let g:nnn#action = {
                     \ '<c-t>': 'tab split',
                     \ '<c-s>': 'split',
                     \ '<c-v>': 'vsplit',
                     \ '<c-y>': function('CopyLinestoRegister') }


        " Floating window (neovim)
        function! NNNlayout()
            let buf = nvim_create_buf(v:false, v:true)

            let height = &lines - (float2nr(&lines / 3))
            let width = float2nr(&columns - (&columns * 1 / 4))
            let start_x = float2nr(&columns * 1 / 8)
            let start_y = float2nr(height / 6)

            let opts = {
                    \ 'relative': 'editor',
                    \ 'row': start_y,
                    \ 'col': start_x,
                    \ 'width': width,
                    \ 'height': height,
                    \ }

            call nvim_open_win(buf, v:true, opts)
        endfunction
        " let g:nnn#layout = 'call NNNlayout()'
        let g:nnn#layout = { 'window': { 'width': 0.8, 'height': 0.6, 'highlight': 'Debug', 'border': 'rounded' } }
    endif
 "}}} _ nnn.vim

 " fern.vim {{{
    if PM('lambdalisue/fern.vim')
        let g:fern#drawer_width = 33

        if PM('khalidchawtany/fern-renderer-plain.vim')
            " let g:fern#renderer = "plain"
        endif
        nnoremap <silent> - :if bufname() == '' \| Fern .  \| else \| Fern %:h:p -drawer -keep -reveal=%:t \| endif \| <cr>
        nnoremap <silent> <leader>- :if bufname() == '' \| Fern .  \| else \| Fern %:h:p -wait -stay -reveal=%:t \| endif \| <cr>
        " nnoremap <silent> - :Fern %:h:p -drawer -reveal=% -width=33 -wait<cr>
        " nnoremap <leader>- :Fern %:p:h -toggle -reveal=% -drawer -width=33<cr>

        function! s:init_fern() abort
            nmap <buffer>  <c-j> <c-w><c-j>
            nmap <buffer>  <c-k> <c-w><c-k>
            nmap <buffer><nowait> <c-space> <Plug>(fern-action-mark:toggle)j
            nmap <buffer> - <Plug>(fern-action-leave)
            nmap <buffer> % <Plug>(fern-action-leave)
            nnoremap <buffer> q :<C-u>quit<CR>
            nnoremap <buffer><silent> q :<C-u>bwipeout %<CR>
            " nnoremap <buffer><silent> q <c-o>
            nnoremap <buffer> <c-l> <c-w>l
            setlocal norelativenumber
            setlocal nonumber
            setlocal foldcolumn=0

            if &background == 'light'
                hi FernRoot guifg=gray
                " hi FernBranch guifg=#0087af
                hi FernLeaf   guifg=#444444
            endif
        endfunction

        " use forn to browse dirs
        augroup customize-fern
            autocmd!
            autocmd FileType fern call s:init_fern()
        augroup END

         augroup my-fern-hijack
             autocmd!
             autocmd BufEnter * ++nested call s:hijack_directory()
         augroup END

         let g:file_browser = 'fern'
         nnoremap <silent> <leader><BS> <cmd>if g:file_browser == 'nnn' \| let g:file_browser='fern' \| else \| let g:file_browser='nnn' \| endif \| echom g:file_browser "is the default file browser"<cr>

         function! s:hijack_directory() abort
             if !isdirectory(expand('%'))
                 return
             endif
             let path = expand('%:p')
             " bwipeout %
             b#
             bd#

             if (g:file_browser == 'nnn')
                 execute "NnnPicker " path
             else
                 execute 'Fern ' path ' -drawer -keep -reveal=%:t'
             endif

             " execute "FloatermNew lf " path
             " execute "LfToggle " path
         endfunction
    endif
 " }}} _ fern.vim

 " vim-laravel {{{
    if PM('noahfrederick/vim-laravel')
        " :{E,S,V,T}asset 	Anything under assets/
        " :Ebootstrap 	Bootstrap files in boostrap/
        " :Echannel 	Broadcast channels
        " :Ecommand 	Console commands
        " :Econfig 	Configuration files
        " :Econtroller 	HTTP controllers
        " :Edoc 	The README.md file
        " :Eenv 	Your .env and .env.example
        " :Eevent 	Events
        " :Eexception 	Exceptions
        " :Efactory 	Model factories
        " :Ejob 	Jobs
        " :Elanguage 	Messages/translations
        " :Elib 	All class files under app/
        " :Elistener 	Event listeners
        " :Email 	Mailables
        " :Emiddleware 	HTTP middleware
        " :Emigration 	Database migrations
        " :Enotification 	Notifications
        " :Epolicy 	Auth policies
        " :Eprovider 	Service providers
        " :Erequest 	HTTP form requests
        " :Eresource 	HTTP resources
        " :Eroutes 	HTTP routes files
        " :Erule 	Validation rules
        " :Eseeder 	Database seeders
        " :Etest 	All class files under tests/
        " :Eview 	Blade templates
    endif
 " }}}
 " vim-projectionist {{{

  if PM( 'tpope/vim-projectionist')
  ", {'on_cmd': ['E', 'S', 'V', 'T', 'A', 'AS', 'AV', 'AT']} )
    let g:projectionist_heuristics = {
      \   "etc/rbenv.d/|bin/rbenv-*": {
      \     "bin/rbenv-*": {
      \        "type": "command",
      \        "template": ["#!/usr/bin/env bash"],
      \     },
      \     "etc/rbenv.d/*.bash": {"type": "hook"}
      \   },
      \   "gigant/accounting/": {
      \     "gigant/accounting/*.php": {"type": "v"},
      \     "gigant/accounting/php/*.php": {"type": "p"},
      \     "gigant/accounting/modals/*/": {"type": "m"},
      \     "gigant/accounting/js/*.js": {"type": "j"}
      \   },
      \   "abc_turtle/": {
      \     "abc_turtle/app/Http/Controllers/*Controller.php": {"type": "c"},
      \     "abc_turtle/app/*.php": {"type": "m"},
      \     "abc_turtle/resources/bread/*.php": {"type": "b"},
      \     "abc_turtle/resources/views/*s/": {"type": "v"}
      \   }
      \ }
    nnoremap <leader>pc :execute ":Ec ".expand("%:t:r")<cr>
    nnoremap <leader>pb :execute ":Eb ".expand("%:t:r")<cr>
    nnoremap <leader>pv :execute ":Ev ".expand("%:t:r")<cr>
    nnoremap <leader>pp :execute ":Ep ".expand("%:t:r")<cr>
    nnoremap <leader>pj :execute ":Ej ".expand("%:t:r")<cr>
    nnoremap <leader>pm :execute ":Em ".expand("%:t:r")<cr>
  endif

 "}}} _vim-projectionist
 " vim-dotenv {{{
   call PM( 'tpope/vim-dotenv', {'on_cmd':['Dotenv']} )
 "}}} _vim-dotenv

 " Content

 " aerojump.nvim {{{
 " if PM('ripxorip/aerojump.nvim')
 if PM('khalidchawtany/aerojump.nvim')
     " aerojump mappings
     " g:aerojump_keymaps

     " Create mappings (with leader)
     nmap gj<space> <Plug>(AerojumpSpace)
     nmap gjg <Plug>(AerojumpBolt)
     nmap gja <Plug>(AerojumpFromCursorBolt)
     nmap gjd <Plug>(AerojumpDefault)

 endif
 "}}} _ aerojump.nvim
 " any-jump {{{
  " if PM('khalidchawtany/any-jump.nvim')
  if PM('pechorin/any-jump.nvim')

    let g:any_jump_disable_default_keybindings = v:true
    " Jump to definition under cursore
    nnoremap gjj :AnyJump<CR>

    " open previous opened file (after jump)
    nnoremap gjb :AnyJumpBack<CR>
    nnoremap gjk :AnyJumpBack<CR>

    " open last closed search window again
    nnoremap gjl :AnyJumpLastResults<CR>

    au FileType any-jump nnoremap <buffer> o :call g:AnyJumpHandleOpen()<cr>
    au FileType any-jump nnoremap <buffer><CR> :call g:AnyJumpHandleOpen()<cr>
    au FileType any-jump nnoremap <buffer> p :call g:AnyJumpHandlePreview()<cr>
    au FileType any-jump nnoremap <buffer> <tab> :call g:AnyJumpHandlePreview()<cr>
    au FileType any-jump nnoremap <buffer> q :call g:AnyJumpHandleClose()<cr>
    au FileType any-jump nnoremap <buffer> <esc> :call g:AnyJumpHandleClose()<cr>
    au FileType any-jump nnoremap <buffer> u :call g:AnyJumpHandleUsages()<cr>
    au FileType any-jump nnoremap <buffer> U :call g:AnyJumpHandleUsages()<cr>
    au FileType any-jump nnoremap <buffer> b :call g:AnyJumpToFirstLink()<cr>
    au FileType any-jump nnoremap <buffer> T :call g:AnyJumpToggleGrouping()<cr>
    au FileType any-jump nnoremap <buffer> a :call g:AnyJumpToggleAllResults()<cr>
    au FileType any-jump nnoremap <buffer> A :call g:AnyJumpToggleAllResults()<cr>

    " Show line numbers in search rusults
    let g:any_jump_list_numbers = v:true

    " Auto search usages
    let g:any_jump_usages_enabled = v:false

    " Auto group results by filename
    let g:any_jump_grouping_enabled = v:false

    " Amount of preview lines for each search result
    let g:any_jump_preview_lines_count = 5

    " Max search results, other results can be opened via [a]
    let g:any_jump_max_search_results = 7

    let g:any_jump_window_width_ratio = 0.8

    " Prefered search engine: rg or ag
    let g:any_jump_search_prefered_engine = 'rg'
    " Ungrouped results ui variants:
    " - 'filename_first'
    " - 'filename_last'

    let g:any_jump_results_ui_style = 'filename_first' "

    autocmd FileType any-jump  setlocal nonumber
                \| setlocal norelativenumber
                \| setlocal foldcolumn=0
                \| nmap <c-c> <esc>
 endif
 " }}} _ any-jump
 " vim-stay {{{
    "Restore cursor when reopoening files
    call PM('kopischke/vim-stay')
 "}}} _vim-stay
 " nvim-miniyank {{{
if PM('bfredl/nvim-miniyank', {'if': 'has("nvim")'})
    let g:miniyank_filename = $HOME."/.config/nvim/.cache/miniyank.mpack"
    map p <Plug>(miniyank-autoput)
    map P <Plug>(miniyank-autoPut)
    map [p <Plug>(miniyank-cycle)

    map ]p <Plug>(miniyank-startput)
    map ]P <Plug>(miniyank-startPut)

    map <Leader><Leader>c <Plug>(miniyank-tochar)
    map <Leader><Leader>l <Plug>(miniyank-toline)
    map <Leader><Leader>b <Plug>(miniyank-toblock)

    let g:miniyank_maxitems = 1000
endif

 "}}} _nvim-miniyank
 "scalpel {{{
  if PM('wincent/scalpel', {'on_cmd': ['Scalpel'], 'on_map': ['<Plug>(Scalpel)']})
   nmap  g;r <Plug>(Scalpel)
  endif
 "}}} _scalpel
 " grepper {{{

 if PM( 'mhinz/vim-grepper', {'on_cmd': [ 'Grepper'], 'on_map': [ '<plug>(Grepper' ]} )

   xmap g\g <plug>(Grepper)
   cmap <c-g>n <plug>(GrepperNext)
   nmap g\g <plug>(GrepperMotion)
   xmap g\g <plug>(GrepperMotion)

   let g:grepper              = {}
   let g:grepper.programs     = ['ag', 'git', 'grep']
   let g:grepper.use_quickfix = 1
   let g:grepper.do_open      = 1
   let g:grepper.do_switch    = 1
   let g:grepper.do_jump      = 0

 endif

 "}}}
 "vim-side-search{{{
if PM('ddrscott/vim-side-search', {'on_cmd':['SideSearch']})
  " How should we execute the search?
  " --heading and --stats are required!
  let g:side_search_prg = 'ag --word-regexp'
        \. " --ignore='*.js.map'"
        \. " --heading --stats -B 1 -A 4"

  " Can use `vnew` or `new`
  let g:side_search_splitter = 'vnew'

  " I like 40% splits, change it if you don't
  let g:side_search_split_pct = 0.4

  " SideSearch current word and return to original window
  nnoremap g\s :SideSearch <C-r><C-w><CR> | wincmd p
  " Create an shorter `SS` command
  command! -complete=file -nargs=+ SS execute 'SideSearch <args>'
  " or command abbreviation
  cabbrev SS SideSearch
endif

 "}}}_vim-side-search
 " Clever-f {{{

if PM( 'rhysd/clever-f.vim') " , { \ 'on_map': [ '<Plug>(clever-f-' ], \ 'on_func': [ 'clever_f#reset' ] \ })

   Map nox F     <Plug>(clever-f-F)
   Map nox T     <Plug>(clever-f-T)
   Map nox f     <Plug>(clever-f-f)
   Map nox t     <Plug>(clever-f-t)
   "The following makes fFtF useless because of the time out
   "Map n   f<BS> <Plug>(clever-f-reset)

 endif

 "}}}
 " sneak.vim {{{
 if PM('justinmk/vim-sneak')
     let g:sneak#label = 1
      " Map nox ss <Plug>Sneak_s
      " Map nox SS <Plug>Sneak_S
 endif
 " }}} _sneak.vim
 " vim-easymotion {{{

  if PM( 'Lokaltog/vim-easymotion')

   map s         <Plug>(easymotion-prefix)
   map s;        <Plug>(easymotion-s2)
   map ss;       <Plug>(easymotion-sn)

   map sl        <Plug>(easymotion-lineforward)
   map sh        <Plug>(easymotion-linebackward)
   map s<space>  <Plug>(easymotion-lineanywhere)

   map ssf       <Plug>(easymotion-bd-f)
   map sst       <Plug>(easymotion-bd-t)
   map ssw       <Plug>(easymotion-bd-w)
   map ssW       <Plug>(easymotion-bd-W)
   map ssw       <Plug>(easymotion-bd-e)
   map ssE       <Plug>(easymotion-bd-E)
   map ssj       <Plug>(easymotion-bd-jk)
   map ssk       <Plug>(easymotion-bd-jk)
   map ssl       <Plug>(easymotion-bd-jk)
   map ssn       <Plug>(easymotion-bd-n)
   map ssa       <Plug>(easymotion-jumptoanywhere)
   map s<cr>       <Plug>(easymotion-repeat)

   map ssL    <Plug>(easymotion-eol-bd-jk)
   map ssH    <Plug>(easymotion-sol-bd-jk)

   map sSF    <Plug>(easymotion-overwin-f)
   map sS;    <Plug>(easymotion-overwin-f2)
   map sSW    <Plug>(easymotion-overwin-w)
   map sSL    <Plug>(easymotion-overwin-line)

" Default Maps {{{
"   Default Mapping      | Details
"   ---------------------|----------------------------------------------
"   <Leader>f{char}      | Find {char} to the right. See |f|.
"   <Leader>F{char}      | Find {char} to the left. See |F|.
"   <Leader>t{char}      | Till before the {char} to the right. See |t|.
"   <Leader>T{char}      | Till after the {char} to the left. See |T|.
"   <Leader>w            | Beginning of word forward. See |w|.
"   <Leader>W            | Beginning of WORD forward. See |W|.
"   <Leader>b            | Beginning of word backward. See |b|.
"   <Leader>B            | Beginning of WORD backward. See |B|.
"   <Leader>e            | End of word forward. See |e|.
"   <Leader>E            | End of WORD forward. See |E|.
"   <Leader>ge           | End of word backward. See |ge|.
"   <Leader>gE           | End of WORD backward. See |gE|.
"   <Leader>j            | Line downward. See |j|.
"   <Leader>k            | Line upward. See |k|.
"   <Leader>n            | Jump to latest "/" or "?" forward. See |n|.
"   <Leader>N            | Jump to latest "/" or "?" backward. See |N|.
"   <Leader>s            | Find(Search) {char} forward and backward.
"                        | See |f| and |F|.
" Unused Maps
"   More <Plug> Mapping Table         | (No assignment by default)
"   ----------------------------------|---------------------------------
"   <Plug>(easymotion-bd-f)           | See |<Plug>(easymotion-s)|
"   <Plug>(easymotion-bd-t)           | See |<Plug>(easymotion-bd-t)|
"   <Plug>(easymotion-bd-w)           | See |<Plug>(easymotion-bd-w)|
"   <Plug>(easymotion-bd-W)           | See |<Plug>(easymotion-bd-W)|
"   <Plug>(easymotion-bd-e)           | See |<Plug>(easymotion-bd-e)|
"   <Plug>(easymotion-bd-E)           | See |<Plug>(easymotion-bd-E)|
"   <Plug>(easymotion-bd-jk)          | See |<Plug>(easymotion-bd-jk)|
"   <Plug>(easymotion-bd-n)           | See |<Plug>(easymotion-bd-n)|
"   <Plug>(easymotion-jumptoanywhere) | See |<Plug>(easymotion-jumptoanywhere)|
"   <Plug>(easymotion-repeat)         | See |<Plug>(easymotion-repeat)|
"   <Plug>(easymotion-next)           | See |<Plug>(easymotion-next)|
"   <Plug>(easymotion-prev)           | See |<Plug>(easymotion-prev)|
"   <Plug>(easymotion-sol-j)          | See |<Plug>(easymotion-sol-j)|
"   <Plug>(easymotion-sol-k)          | See |<Plug>(easymotion-sol-k)|
"   <Plug>(easymotion-eol-j)          | See |<Plug>(easymotion-eol-j)|
"   <Plug>(easymotion-eol-k)          | See |<Plug>(easymotion-eol-k)|
"   <Plug>(easymotion-iskeyword-w)    | See |<Plug>(easymotion-iskeyword-w)|
"   <Plug>(easymotion-iskeyword-b)    | See |<Plug>(easymotion-iskeyword-b)|
"   <Plug>(easymotion-iskeyword-bd-w) | See |<Plug>(easymotion-iskeyword-bd-w)|
"   <Plug>(easymotion-iskeyword-e)    | See |<Plug>(easymotion-iskeyword-e)|
"   <Plug>(easymotion-iskeyword-ge)   | See |<Plug>(easymotion-iskeyword-ge)|
"   <Plug>(easymotion-iskeyword-bd-e) | See |<Plug>(easymotion-iskeyword-bd-e)|
"   <Plug>(easymotion-vim-n)          | See |<Plug>(easymotion-vim-n)|
"   <Plug>(easymotion-vim-N)          | See |<Plug>(easymotion-vim-N)|
"                                     |
"   Within Line Motion                | See |easymotion-within-line|
"   ----------------------------------|---------------------------------
"   <Plug>(easymotion-sl)             | See |<Plug>(easymotion-sl)|
"   <Plug>(easymotion-fl)             | See |<Plug>(easymotion-fl)|
"   <Plug>(easymotion-Fl)             | See |<Plug>(easymotion-Fl)|
"   <Plug>(easymotion-bd-fl)          | See |<Plug>(easymotion-sl)|
"   <Plug>(easymotion-tl)             | See |<Plug>(easymotion-tl)|
"   <Plug>(easymotion-Tl)             | See |<Plug>(easymotion-Tl)|
"   <Plug>(easymotion-bd-tl)          | See |<Plug>(easymotion-bd-tl)|
"   <Plug>(easymotion-wl)             | See |<Plug>(easymotion-wl)|
"   <Plug>(easymotion-bl)             | See |<Plug>(easymotion-bl)|
"   <Plug>(easymotion-bd-wl)          | See |<Plug>(easymotion-bd-wl)|
"   <Plug>(easymotion-el)             | See |<Plug>(easymotion-el)|
"   <Plug>(easymotion-gel)            | See |<Plug>(easymotion-gel)|
"   <Plug>(easymotion-bd-el)          | See |<Plug>(easymotion-bd-el)|
"   <Plug>(easymotion-lineforward)    | See |<Plug>(easymotion-lineforward)|
"   <Plug>(easymotion-linebackward)   | See |<Plug>(easymotion-linebackward)|
"   <Plug>(easymotion-lineanywhere)   | See |<Plug>(easymotion-lineanywhere)|
"                                     |
"   Multi Input Find Motion           | See |easymotion-multi-input|
"   ----------------------------------|---------------------------------
"   <Plug>(easymotion-s2)             | See |<Plug>(easymotion-s2)|
"   <Plug>(easymotion-f2)             | See |<Plug>(easymotion-f2)|
"   <Plug>(easymotion-F2)             | See |<Plug>(easymotion-F2)|
"   <Plug>(easymotion-bd-f2)          | See |<Plug>(easymotion-s2)|
"   <Plug>(easymotion-t2)             | See |<Plug>(easymotion-t2)|
"   <Plug>(easymotion-T2)             | See |<Plug>(easymotion-T2)|
"   <Plug>(easymotion-bd-t2)          | See |<Plug>(easymotion-bd-t2)|
"                                     |
"   <Plug>(easymotion-sl2)            | See |<Plug>(easymotion-sl2)|
"   <Plug>(easymotion-fl2)            | See |<Plug>(easymotion-fl2)|
"   <Plug>(easymotion-Fl2)            | See |<Plug>(easymotion-Fl2)|
"   <Plug>(easymotion-tl2)            | See |<Plug>(easymotion-tl2)|
"   <Plug>(easymotion-Tl2)            | See |<Plug>(easymotion-Tl2)|
"                                     |
"   <Plug>(easymotion-sn)             | See |<Plug>(easymotion-sn)|
"   <Plug>(easymotion-fn)             | See |<Plug>(easymotion-fn)|
"   <Plug>(easymotion-Fn)             | See |<Plug>(easymotion-Fn)|
"   <Plug>(easymotion-bd-fn)          | See |<Plug>(easymotion-sn)|
"   <Plug>(easymotion-tn)             | See |<Plug>(easymotion-tn)|
"   <Plug>(easymotion-Tn)             | See |<Plug>(easymotion-Tn)|
"   <Plug>(easymotion-bd-tn)          | See |<Plug>(easymotion-bd-tn)|
"                                     |
"   <Plug>(easymotion-sln)            | See |<Plug>(easymotion-sln)|
"   <Plug>(easymotion-fln)            | See |<Plug>(easymotion-fln)|
"   <Plug>(easymotion-Fln)            | See |<Plug>(easymotion-Fln)|
"   <Plug>(easymotion-bd-fln)         | See |<Plug>(easymotion-sln)|
"   <Plug>(easymotion-tln)            | See |<Plug>(easymotion-tln)|
"   <Plug>(easymotion-Tln)            | See |<Plug>(easymotion-Tln)|
"   <Plug>(easymotion-bd-tln)         | See |<Plug>(easymotion-bd-tln)|
"
"   Over Window Motion                | (No assignment by default)
"   ----------------------------------|---------------------------------
"   <Plug>(easymotion-overwin-f)      | See |<Plug>(easymotion-overwin-f)|
"   <Plug>(easymotion-overwin-f2)     | See |<Plug>(easymotion-overwin-f2)|
"   <Plug>(easymotion-overwin-line)   | See |<Plug>(easymotion-overwin-line)|
"   <Plug>(easymotion-overwin-w)      | See |<Plug>(easymotion-overwin-w)|
"
"-----------------------------------------------------------------------------
"}}}

   " keep cursor colum when JK motion
   let g:EasyMotion_startofline = 0
   let g:EasyMotion_force_csapprox = 1

 endif

 "}}} _vim-easymotion
 " vim-easymotion-segments {{{
  if PM( 'aykamko/vim-easymotion-segments', {'on_map': ['<Plug>(easymotion-']} )
   map su    <Plug>(easymotion-segments-LF)
   map sU    <Plug>(easymotion-segments-LB)
   map sc    <Plug>(easymotion-segments-RF)
   map sC    <Plug>(easymotion-segments-RB)
  endif
  "}}} _vim-easymotion-segments
 " Tagbar {{{

  if PM( 'majutsushi/tagbar', {'on_cmd':  [ 'Tagbar', 'TagbarToggle', ] } )
   nnoremap <silent> <leader>tb :TagbarToggle<CR>
 endif

 "}}}

 " History
 " undotree {{{

  if PM( 'mbbill/undotree' , {'on_cmd': ['UndotreeShow', 'UndotreeFocus', 'UndotreeToggle']} )

   "let g:undotree_WindowLayout = 2
   nnoremap <leader>ut :UndotreeToggle<cr>
   nnoremap <leader>us :UndotreeShow<cr>
 endif

 "}}} _undotree
 " Gundo.vim {{{
   call PM('sjl/gundo.vim')
 " }}} _gundo.vom

 " Buffers
 " vim-bufsurf {{{

if PM( 'ton/vim-bufsurf') ", {'on_cmd': ['BufSurfBack', 'BufSurfForward', 'BufSurfList']} )
  nnoremap ]w :BufSurfForward<cr>
  nnoremap [w :BufSurfBack<cr>
  nnoremap coB :BufSurfList<cr>
endif

 "}}} _vim-bufsurf
 " history-traverse {{{

 if PM( 'ckarnell/history-traverse', {'on_cmd': ['HisTravForward', 'HisTravBack']})
   nnoremap ]h :HisTravForward<cr>
   nnoremap [h :HisTravBack<cr>

   let g:history_ft_ignore = ['netrw', 'defx', 'nofile', 'fugitive', 'gitcommit']
 endif

 "}}} _history-traverse

 "Batch rename
 "fze {{{ manage files using FZF
    if PM('khalidchawtany/fze')
        nnoremap <c-p><c-x> <cmd>Fze<cr>
    endif
 "}}} _fxe
 "vim-renamer {{{
 call PM('qpkorr/vim-renamer')
 "}}} _vim-renamer
 " vim_drawer {{{
 if PM('samuelsimoes/vim-drawer', {
       \ 'on_cmd': ['VimDrawer'],
       \ 'hook_post_source': "nnoremap <leader>tt :e term://zsh<cr> | hi LightlineLeft_tabline_tabsel guibg=#444444 guifg=yellow "
       \ } )
   let g:vim_drawer_spaces = [
         \["img", "img\/"],
         \["js", "js\/"],
         \["css", "css\/"],
         \["public", "public\/"],
         \["factory", "factories\/"],
         \["seed", "seeds\/"],
         \["migration", "migrations\/"],
         \["request", "Requests\/"],
         \["middleWare", "Middleware\/"],
         \["controller", "Controller\.php"],
         \["model", "app\/"],
         \["view", "\.blade\.php$"],
         \["asset", "\.[js|css|scss|sass|less|stylus]$"],
         \["org", "\.[org]$"],
         \["config", "config\/"],
         \["route", "routes\/"],
         \["v-cmd", "vendor\/\.\*\/Commands\/\.\*.php"],
         \["v-bread", "vendor\/\.\*\/bread\/\.\*.php"],
         \["bread", "bread\/"],
         \["term", "term"],
         \["other", ""],
         \]
 "let g:vim_drawer_spaces = [ ["controller", "Controller\.php"], ["model", "app\/"], ["view", "\.blade\.php$"], ["asset", "\.[js|css|scss|sass|less|stylus]$"], ["org", "\.[org]$"], ["config", "config\/"], ["term", "term"] ]
   nnoremap <C-w><Space> :VimDrawer<CR>
   nnoremap <C-w><c-Space> :VimDrawerAutoClassificationToggle<CR>
 endif
 "}}} _vim-drawer
 " zoomwintab.vim {{{

 if PM( 'troydm/zoomwintab.vim', {'on_cmd': ['ZoomWinTabToggle']} )

   let g:zoomwintab_remap = 0
   " zoom with <META-O> in any mode
 endif

 "}}} _zoomwintab.vim
 "
 "{{{ vim-maximizer
 if PM('szw/vim-maximizer', {'on_cmd': ['MaximizerToggle']})
     let g:maximizer_set_default_mapping = 0

     nnoremap <silent> <c-w><c-o> :ZoomWinTabToggle<cr>
     inoremap <silent> <c-w><c-o> <c-\><c-n>:ZoomWinTabToggle<cr>a
     vnoremap <silent> <c-w><c-o> <c-\><c-n>:ZoomWinTabToggle<cr>gv
 endif
 "}}} _vim-maximizer

 " Finder
 " gtfo {{{

 if PM( 'justinmk/vim-gtfo', {'on_map': ['gof', 'got', 'goF', 'goT']} )
   let g:gtfo#terminals = { 'mac' : 'iterm' }
   nnoremap <silent> gof :<c-u>call gtfo#open#file("%:p")<cr>
   nnoremap <silent> got :<c-u>call gtfo#open#term("%:p:h", "")<cr>
   nnoremap <silent> goF :<c-u>call gtfo#open#file(getcwd())<cr>
   nnoremap <silent> goT :<c-u>call gtfo#open#term(getcwd(), "")<cr>
 endif

 "}}}

 " tmux
 " tmux-navigator {{{

 if PM( 'christoomey/vim-tmux-navigator' ,
       \ {'on_event': 'VimEnter', 'on_if': "exists('$TMUX')"}
       \ )

   if exists('$TMUX')
     let g:tmux_navigator_no_mappings = 1
     nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
     nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
     nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
     nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
     nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>
   endif
 endif

 "}}}

 " terminal
 " nvimux {{{
  if PM('hkupty/nvimux' ,{'on_event': 'VimEnter', 'on_if': 'has("nvim")'})
    "let g:nvimux_prefix = '<C-a>'
    "let g:nvimux_open_term_by_default = 1
    "let g:nvimux_new_window_buffer = 'single'
    "let g:nvimux_quickterm_direction = 'botright'
    "let g:nvimux_quickterm_orientation = 'vertical'
    "let g:nvimux_quickterm_scope = 't'
    "let g:nvimux_quickterm_size = '80'
  endif
 "}}} _nvimux
 "ctrlsf.vim {{{
 if PM('dyng/ctrlsf.vim')
     nmap     <C-;>ff <Plug>CtrlSFPrompt
     vmap     <C-;>ff <Plug>CtrlSFVwordPath
     vmap     <C-;>fF <Plug>CtrlSFVwordExec
     nmap     <C-;>fn <Plug>CtrlSFCwordPath
     nmap     <C-;>fp <Plug>CtrlSFPwordPath
     nnoremap <C-;>fo :CtrlSFOpen<CR>
     nnoremap <C-;>ft :CtrlSFToggle<CR>
     inoremap <C-;>ft <Esc>:CtrlSFToggle<CR>
 endif
 "}}} _ctrlsf.vim

 " }}} _Navigation

 " Folds {{{

 " vim-foldfocus {{{

  if PM( 'vasconcelloslf/vim-foldfocus', {'on_func': ['FoldFocus']} )

   nnoremap zF :call FoldFocus('vnew')<CR>
   nnoremap <leader>z<cr> :call FoldFocus('vnew')<CR>
   nnoremap <leader>zz  :call FoldFocus('e')<CR>
 endif

 "}}}} _vim-foldfocus

 " searchfold.vim {{{

  if PM( 'khalidchawtany/searchfold.vim' , {'on_map':  ['<Plug>SearchFold']} )

   " Search and THEN Fold the search term containig lines using <leader>z
   " or the the inverse using <leader>iz or restore original fold using <leader>Z
   nmap <Leader>zs   <Plug>SearchFoldNormal
   nmap <Leader>zi   <Plug>SearchFoldInverse
   nmap <Leader>zr   <Plug>SearchFoldRestore
   nmap <Leader>zw   <Plug>SearchFoldCurrentWord
 endif

 "}}} _searchfold.vim

 "}}}

 " Terminal {{{

 "vim-floaterm {{{
    if PM('voldikss/vim-floaterm')
        let g:floaterm_keymap_new    = '<F7>'
        let g:floaterm_keymap_prev   = '<C-BS>'
        let g:floaterm_keymap_next   = '<F9>'
        let g:floaterm_keymap_toggle = '<C-CR>'
        let g:floaterm_position      = 'center'
        let g:floaterm_width         = 0.75
        let g:floaterm_height         = 0.8
    endif
 "}}}

 " }}}

 " Themeing {{{

 " lightline {{{
 if PM( 'itchyny/lightline.vim' )

     let g:qf_disable_statusline = 1

   call PM( 'NovaDev94/lightline-onedark' )

   let g:lightline = {
         \ 'active': {
         \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
         \   'right': [ [ 'syntastic', 'lineinfo' ], ['noscrollbar']  , ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ]]
         \ },
         \ 'component_function': {
         \   'fugitive': 'LightLineFugitive',
         \   'filename': 'LightLineFilename',
         \   'filetype': 'MyFiletype',
         \   'fileformat': 'MyFileformat',
         \   'fileencoding': 'LightLineFileencoding',
         \   'mode': 'LightLineMode',
         \   'noscrollbar': 'noscrollbar#statusline',
         \ },
         \ 'component_type': {
         \   'syntastic': 'error',
         \ },
         \ 'subseparator': { 'left': '', 'right': '' },
         \ 'separator': { 'left': '', 'right': '' },
         \ }
"\ 'subseparator': { 'left': '', 'right': '' },
"\ 'separator': { 'left': '', 'right': '' },

   "\ 'component_expand': {
   "\   'syntastic': 'SyntasticStatuslineFlag',
   "\ },
   function! MyFiletype()
     return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() . "\u00A0" : 'no ft') : ''
   endfunction

   function! MyFileformat()
     "return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
     let fileformat = ""

     if &fileformat == "dos"
       let fileformat = ""
     elseif &fileformat == "unix"
       "let fileformat = ""
       let fileformat = ""
     elseif &fileformat == "mac"
       let fileformat = ""
     endif

     "Temporary (hopefully) fix for glyph issues in gvim (proper fix is with the
     "actual font patcher)
     let artifactFix = "\u00A0"
     let tabText = ""
     if(tabpagenr('$')>1)
       let tabText = tabpagenr('$') . "   " . ""
     endif
     "call system("set_iterm_badge_number neovim_tabcount ".tabpagenr('$'))

     return  tabText . artifactFix . fileformat
     "return fileformat
   endfunction

   " let g:lightline.colorscheme = 'onedark'
   let g:lightline.colorscheme = 'one'
   " let g:lightline.colorscheme = 'material'
   " let g:lightline.colorscheme = 'gruvbox'
   " let g:lightline.colorscheme = 'wombat'
   " let g:lightline.colorscheme = 'nova'

   function! LightLineModified()
     return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
   endfunction

   function! LightLineReadonly()
     return &ft !~? 'help' && &readonly ? '' : ''
   endfunction

   function! LightLineFilename()
     if exists('b:fname')
         return b:fname
     endif
     let fname = expand('%:t')
     if fname == 'zsh'
       return "  "
     endif
     return fname == '__Tagbar__' ? g:lightline.fname :
           \ fname =~ '__Gundo' ? '' :
           \ &ft == 'vimshell' ? vimshell#get_status_string() :
           \ ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
           \ ('' != fname ? fname : '[No Name]') .
           \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
   endfunction

   function! LightLineFugitive()
     try
       if expand('%:t') !~? 'Tagbar\|Gundo' && &ft !~? 'vimfiler' && exists('*fugitive#head')
         let mark = ' '  " edit here for cool mark     
         let _ = fugitive#head()
         return strlen(_) ? mark._ : ''
       endif
     catch
     endtry
     return ''
   endfunction

   function! LightLineFileformat()
     return winwidth(0) > 70 ? &fileformat : ''
   endfunction

   function! LightLineFiletype()
     return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
   endfunction

   function! LightLineFileencoding()
     return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
   endfunction

   function! LightLineMode()
     let fname = expand('%:t')
     return fname == '__Tagbar__' ? 'Tagbar' :
           \ fname == '__Gundo__' ? 'Gundo' :
           \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
           \ &ft == 'unite' ? 'Unite' :
           \ &ft == 'vimfiler' ? 'VimFiler' :
           \ &ft == 'vimshell' ? 'VimShell' :
           \ winwidth(0) > 60 ? lightline#mode() : ''
   endfunction

   let g:tagbar_status_func = 'TagbarStatusFunc'

   function! TagbarStatusFunc(current, sort, fname, ...) abort
     let g:lightline.fname = a:fname
     return lightline#statusline(0)
   endfunction

   augroup AutoSyntastic
     autocmd!
     autocmd BufWritePost *.c,*.cpp call s:syntastic()
   augroup END
   function! s:syntastic()
     SyntasticCheck
     " call lightline#update()
   endfunction

   let g:unite_force_overwrite_statusline = 0
   let g:vimfiler_force_overwrite_statusline = 0
   let g:vimshell_force_overwrite_statusline = 0


 endif " PM()
 "}}}

 " vim-startify {{{
 if PM( 'mhinz/vim-startify' )
   let g:startify_disable_at_vimenter = 0
   nnoremap <F1> :Startify<cr>
   let g:startify_lists = [
               \ { 'type': 'files',     'header': ['   MRU']            },
               \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
               \ { 'type': 'sessions',  'header': ['   Sessions']       },
               \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
               \ { 'type': 'commands',  'header': ['   Commands']       },
               \ ]

   let g:startify_files_number = 5

   "Make bookmarks for fast nav
   let g:startify_bookmarks = [ {'c': '~/.vimrc'}, '~/.zshrc' ]
   let g:startify_session_dir = '~/.config/nvim/.cache/startify/session'

   let g:startify_custom_header = [] "Remove the Cow
   "function! s:filter_header(lines) abort
   "let longest_line   = max(map(copy(a:lines), 'len(v:val)'))
   "let centered_lines = map(copy(a:lines),
   "\ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
   "return centered_lines
   "endfunction

   "let g:startify_custom_header =
   "\ s:filter_header(map(split(system('fortune -s| cowsay'), '\n'), '"   ". v:val') + ['',''])
  endif
 "}}}

 " goyo {{{
 if PM('junegunn/goyo.vim', {'on_cmd' :['Goyo']})
     let g:goyo_width = 100
     let g:goyo_linenr = 1

     function! ReturnHighlightTerm(group, term)
         " Store output of group to variable
         let output = execute('hi ' . a:group)

         " Find the term we're looking for
         return matchstr(output, a:term.'=\zs\S*')
     endfunction

     function! Goyo_enter()
         set noshowmode
         set noshowcmd
         set scrolloff=999

         let g:gui_fg = ReturnHighlightTerm('SignatureMarkText', 'guifg')
         let gui_bg = ReturnHighlightTerm('SignatureMarkText', 'guibg')
         execute ('hi SignatureMarkText guifg='.gui_bg)
     endfunction

     function! Goyo_leave()
         set showmode
         set showcmd
         set scrolloff=5
         execute ('hi SignatureMarkText guifg='.g:gui_fg)
     endfunction


   augroup RegisterGoyoAutoCommands
       autocmd!
       autocmd VimEnter *  autocmd! User GoyoEnter nested call Goyo_enter()
             \| autocmd! User GoyoLeave nested call Goyo_leave()
   augroup END
 endif
 " }}} _ goyo

 "colortuner {{{
 if PM('zefei/vim-colortuner', {'on_cmd' :['Colortuner']})
     let g:colortuner_preferred_schemes = ['Papercolor', 'palenight']
     function! s:goyo_enter()
         set noshowmode
         set noshowcmd
         set scrolloff=999
         set signcolumn=no
     endfunction

     function! s:goyo_leave()
         set showmode
         set showcmd
         set scrolloff=5
         set signcolumn=yes
     endfunction

     autocmd! User GoyoEnter nested call <SID>goyo_enter()
     autocmd! User GoyoLeave nested call <SID>goyo_leave()
 endif
 "}}} _colortuner

 " nvim-colorizer.lua {{{
 if PM('norcalli/nvim-colorizer.lua')
     " au vimenter lua require'colorizer'.setup()
     au VimEnter * lua require'colorizer'.setup()
 endif
 "}}} _ nvim-colorizer.lua

 "vim-stylus {{{
  "call PM('wavded/vim-stylus', {'on_ft': 'stylus'})
  if PM('wavded/vim-stylus')
    autocmd BufNewFile,BufRead *.styl setlocal filetype=stylus
  endif
 "}}}_vim-stylus

 " vim-better-whitespace {{{

 if PM( 'ntpeters/vim-better-whitespace' )
   let g:better_whitespace_filetypes_blacklist=['diff', 'nofile', 'qf', 'gitcommit', 'unite', 'vimfiler', 'help', 'any-jump', 'minimap']
   autocmd FileType unite DisableWhitespace
   autocmd FileType vimfiler DisableWhitespace
   autocmd FileType any-jump DisableWhitespace
 endif

 "}}}


 " minimap.vim {{{
 if PM('wfxr/minimap.vim')
     "Minimap
     "MinimapClose
     "MinimapToggle
     "MinimapRefresh
     "MinimapUpdateHighlight
     "g:minimap_left	= 0
     "g:minimap_width	 = 10
     "g:minimap_highlight = Title
     "g:minimap_auto_start	= 0
 endif
 "}}} _ minimap.vim

 " scrollbar.nvim {{{
 if PM('Xuyuanp/scrollbar.nvim')
     let g:scrollbar_max_size = 6

     let g:scrollbar_right_offset = 1

     let g:scrollbar_excluded_filetypes = ['nerdtree', 'tagbar']

     augroup your_config_scrollbar_nvim
         autocmd!

         autocmd CursorHold * silent! lua require('scrollbar').clear()

         autocmd BufEnter    * silent! lua require('scrollbar').show()
         autocmd BufLeave    * silent! lua require('scrollbar').clear()

         autocmd CursorMoved * silent! lua require('scrollbar').show()
         autocmd VimResized  * silent! lua require('scrollbar').show()

         autocmd FocusGained * silent! lua require('scrollbar').show()
         autocmd FocusLost   * silent! lua require('scrollbar').clear()
     augroup end
 endif
 "}}} _ scrollbar.nvim

 " vim-noscrollbar {{{

 call PM('gcavallanti/vim-noscrollbar')

 "}}} _vim-noscrollbar

 " vim-indentLine {{{

 if PM( 'Yggdroot/indentLine', {'lazy': 1} )
     let g:indentLine_first_char = '?'
     let g:indentLine_showFirstIndentLevel = 1
     let g:indentLine_setColors = 0
     let g:indentLine_char = ''
     " let g:indentLine_color_term=""
     " let g:indentLine_color_gui=""
     let g:indentLine_fileType=[] "Means all filetypes
     let g:indentLine_fileTypeExclude=[]
     let g:indentLine_bufNameExclude=[]
 endif

 "}}}

 " vim-indent-guides {{{

 call PM('nathanaelkane/vim-indent-guides', {'lazy' : 1})

 "}}} _vim-indent-guides

 "vim-devicons {{{
 call PM( 'ryanoasis/vim-devicons' )
 "}}} _vim-devicons

 "vim-thematic {{{
 call PM( 'reedes/vim-thematic' )
 "}}} _vim-thematic

 " golden-ratio {{{

 if PM( 'roman/golden-ratio' )
   nnoremap cog :<c-u>GoldenRatioToggle<cr>
  let g:golden_ratio_exclude_nonmodifiable = 1
  let g:golden_ratio_autocommand = 0
  let g:loaded_golden_ratio = 0
 endif

 "}}} _golden-ratio
 "
 " visual-split.vim {{{

   call PM( 'wellle/visual-split.vim' ) ", {'on': ['VSResize', 'VSSplit', 'VSSplitAbove', 'VSSplitBelow']}

 "}}} _visual-split.vim

 "vim-colorscheme-switcher {{{
 if PM('xolox/vim-colorscheme-switcher')
   call PM('xolox/vim-misc')
   nnoremap c]c :<c-u>hi clear \| NextColorScheme<cr>
   nnoremap c[c :<c-u>hi clear \| PrevColorScheme<cr>
   nnoremap c\c :<c-u>hi clear \| RandomColorScheme<cr>
 endif
 "}}} _vim-colorscheme-switcher

 "colorschemes {{{
 call PM('romgrk/github-light.vim')
 call PM('haishanh/night-owl.vim')
 call PM('liuchengxu/space-vim-dark')
 call PM('owickstrom/vim-colors-paramount')
 call PM('jacoborus/tender.vim')
 call PM('rakr/vim-one')
 call PM('nightsense/snow')
 call PM('NLKNguyen/papercolor-theme')
 call PM('trevordmiller/nova-vim')
 call PM('nightsense/snow')
 call PM('kristijanhusak/vim-hybrid-material')
 call PM('jdkanani/vim-material-theme')
 call PM('khalidchawtany/vim-materialtheme')
 call PM('aunsira/macvim-light')
 call PM('arcticicestudio/nord-vim')
 call PM('lifepillar/vim-wwdc17-theme')
 call PM('sonobre/briofita_vim')
 call PM('jakwings/vim-colors')
 call PM('aunsira/macvim-light')
 call PM('endel/vim-github-colorscheme')
 call PM('rakr/vim-colors-rakr')
 call PM('mswift42/vim-themes')
 call PM('vim-scripts/summerfruit256.vim')
 call PM('andbar-ru/vim-unicon')
 call PM('kamwitsta/flatwhite-vim')
 call PM('arzg/vim-colors-xcode')

 call PM('ayu-theme/ayu-vim')
 let ayucolor="dark"   " for dark version of theme
 " let ayucolor="mirage" " for mirage version of theme
 " let ayucolor="light"  " for light version of theme


 call PM('drewtempelmeyer/palenight.vim')
 let g:palenight_terminal_italics=1

 call PM('mhartington/oceanic-next')
 let g:airline_theme='oceanicnext'
 let g:oceanic_next_terminal_bold = 0
 let g:oceanic_next_terminal_italic = 1

 call PM('joshdick/onedark.vim')
 call PM('rakr/vim-one')
 let g:one_allow_italics = 1 " I love italic for comments

 call PM('rakr/vim-two-firewatch')
 let g:two_firewatch_italics=1

 call PM('reedes/vim-colors-pencil')
 let g:pencil_terminal_italics = 1
 "}}} _colorscheme

"}}} _Themeing

 " Presenters :) {{{

 " vim-which-key {{{
 if PM('liuchengxu/vim-which-key', {
             \     'hook_post_source': 'call which_key#register("<Space>", "g:which_key_map")',
             \     'on_cmd': ['WhichKey', 'WhichKey!']
             \})
        let g:mapleader = "\<Space>"
        let g:maplocalleader = ','
        nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
        nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>

         let g:which_key_map =  {}

          " You can pass a descriptive text to an existing mapping. {{{
         let g:which_key_map.f = { 'name' : '+file' }

         nnoremap <silent> <leader>fs :update<CR>
         let g:which_key_map.f.s = 'save-file'

         nnoremap <silent> <leader>fd :e $MYVIMRC<CR>
         let g:which_key_map.f.d = 'open-vimrc'

         nnoremap <silent> <leader>oq  :copen<CR>
         nnoremap <silent> <leader>ol  :lopen<CR>
         let g:which_key_map.o = {
                     \ 'name' : '+open',
                     \ 'q' : 'open-quickfix'    ,
                     \ 'l' : 'open-locationlist',
                     \ }
         "}}}
         " Create menus not based on existing mappings:{{{
         " Provide commands(ex-command, <Plug>/<C-W>/<C-d> mapping, etc.) and descriptions for existing mappings
         let g:which_key_map.b = {
                     \ 'name' : '+buffer' ,
                     \ '1' : ['b1'        , 'buffer 1']        ,
                     \ '2' : ['b2'        , 'buffer 2']        ,
                     \ 'd' : ['bd'        , 'delete-buffer']   ,
                     \ 'f' : ['bfirst'    , 'first-buffer']    ,
                     \ 'h' : ['Startify'  , 'home-buffer']     ,
                     \ 'l' : ['blast'     , 'last-buffer']     ,
                     \ 'n' : ['bnext'     , 'next-buffer']     ,
                     \ 'p' : ['bprevious' , 'previous-buffer'] ,
                     \ '?' : ['Buffers'   , 'fzf-buffer']      ,
                     \ }

         let g:which_key_map.l = {
                     \ 'name' : '+lsp'                                            ,
                     \ 'f' : ['LanguageClient#textDocument_formatting()'     , 'formatting']       ,
                     \ 'h' : ['LanguageClient#textDocument_hover()'          , 'hover']            ,
                     \ 'r' : ['LanguageClient#textDocument_references()'     , 'references']       ,
                     \ 'R' : ['LanguageClient#textDocument_rename()'         , 'rename']           ,
                     \ 's' : ['LanguageClient#textDocument_documentSymbol()' , 'document-symbol']  ,
                     \ 'S' : ['LanguageClient#workspace_symbol()'            , 'workspace-symbol'] ,
                     \ 'g' : {
                     \ 'name': '+goto',
                     \ 'd' : ['LanguageClient#textDocument_definition()'     , 'definition']       ,
                     \ 't' : ['LanguageClient#textDocument_typeDefinition()' , 'type-definition']  ,
                     \ 'i' : ['LanguageClient#textDocument_implementation()'  , 'implementation']  ,
                     \ },
                     \ }
         " }}}
         "To make the guide pop up Register the description dictionary for the prefix first (assuming Space is your leader key):
         " call which_key#register('<Space>', "g:which_key_map")
         nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
         vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

         let g:which_key_map_fzf = {}
         let g:which_key_map_fzf['<c-p>'] = {
                     \ 'name' : '+buffer' ,
                     \ '1' : ['b1'        , 'buffer 1']        ,
                     \ '2' : ['b2'        , 'buffer 2']        ,
                     \ 'd' : ['bd'        , 'delete-buffer']   ,
                     \ 'f' : ['bfirst'    , 'first-buffer']    ,
                     \ 'h' : ['Startify'  , 'home-buffer']     ,
                     \ 'l' : ['blast'     , 'last-buffer']     ,
                     \ 'n' : ['bnext'     , 'next-buffer']     ,
                     \ 'p' : ['bprevious' , 'previous-buffer'] ,
                     \ '?' : ['Buffers'   , 'fzf-buffer']      ,
                     \ }
          " call which_key#register('<c-p>', "g:which_key_map_fzf")
         nnoremap <silent> <c-p> :<c-u>WhichKey '<c-p>'<CR>
         vnoremap <silent> <c-p> :<c-u>WhichKeyVisual '<c-p>'<CR>

    endif
 " }}}vim-which-key


 "}}}

"call function(string(PM).'End')
call PM_END()
