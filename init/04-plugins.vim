if exists('g:_did_vimrc_plugins')
    finish
endif

let g:_did_vimrc_plugins = 1


 " ----------------------------------------------------------------------------
" Libraries {{{
 " ----------------------------------------------------------------------------

 " vital.vim {{{

 "Make vim faster with Vitalize
 call PM("vim-jp/vital.vim")

 "}}} _vital.vim

"}}}
 " ----------------------------------------------------------------------------
 " Version Control & Diff {{{
 " ----------------------------------------------------------------------------
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
       \     'on_ft': ['git'],
       \     'hook_post_source': "call fugitive#detect(expand('%:p')) | if exists('g:NewFugitiveFile') | edit % | endif"
       \ })

   autocmd User fugitive
         \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
         \   nnoremap <buffer> .. :edit %:h<CR> |
         \ endif
   autocmd BufReadPost fugitive://* set bufhidden=delete
   autocmd BufNewFile  fugitive://* call PM_SOURCE('vim-fugitive') | let g:NewFugitiveFile=1 | call feedkeys(';<BS>')
   " set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
   LMap N <leader>gs <SID>Status  :call fugitive#detect(getcwd()) \| Gstatus<cr>
   LMap N <leader>gc <SID>Commit  :execute ":Gcommit"<cr>
   LMap N <leader>gp <SID>Pull    :execute ":Gpull"<cr>
   LMap N <leader>gu <SID>Push    :execute ":Gpush"<cr>
   LMap N <leader>gr <SID>Read    :execute ":Gread"<cr>
   LMap N <leader>gw <SID>Write   :execute ":Gwrite"<cr>
   LMap N <leader>gdv <SID>V-Diff :execute ":Gvdiff"<cr>
   LMap N <leader>gds <SID>S-Diff :execute ":Gdiff"<cr>

 endif
 "}}} _vim-fugitive
 " gv.vim {{{

   "Requires vim-fugitive
   if PM( 'junegunn/gv.vim', {
         \ 'depends': 'vim-fugitive',
         \ 'on_cmd': ['GV', 'GV!', 'GV?']
         \ })

     LMap N <leader>gl <SID>Log :GV<cr>
   endif

 "}}} _gv.vim
 " vim-gitgutter {{{

   call PM( 'airblade/vim-gitgutter' )

 "}}} _vim-gitgutter
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
 " vim-diff-enhanced {{{

 if PM( 'chrisbra/vim-diff-enhanced' )
   " started In Diff-Mode set diffexpr (plugin not loaded yet)
   if &diff
     let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
   endif
 endif
 "}}} _vim-diff-enhanced
 " Recover-With-Diff{{{

 call PM( 'chrisbra/Recover.vim' )

 "}}} _Recover-With-Diff

 call PM('rickhowe/diffchar.vim')

 "}}}
 " ----------------------------------------------------------------------------
 " Content Editor {{{
 " ----------------------------------------------------------------------------

 " Org
 " vim-speeddating {{{

   call PM( 'tpope/vim-speeddating', {'on_ft': ['org'],'on_map': ['<Plug>SpeedDatingUp', '<Plug>SpeedDatingDown']} )

 "}}} _vim-speeddating
 " vim-orgmode {{{

   "call PM( 'jceb/vim-orgmode', {'on_ft': 'org'} )
   if PM( 'jceb/vim-orgmode', {'on_ft': 'org'} )
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
 " calendar.vim {{{

   call PM( 'itchyny/calendar.vim', {'on_cmd': ['Calendar'] } )
   let g:calendar_date_month_name = 1

 "}}} _calendar.vim
 " calendar-vim {{{

   call PM( 'mattn/calendar-vim', {'on_cmd': ['CalendarH', 'CalendarT'], 'on_func':['calendar#show'] } )

 "}}} _calendar-vim

 " Multi-edits
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
 " vim-enmasse {{{

   call PM( 'Wolfy87/vim-enmasse',         { 'on_cmd': 'EnMasse'} )
   " EnMass the sublime like search and edit then save back to corresponding files

 "}}} _vim-enmasse
 " vim-swoop {{{

   call PM( 'pelodelfuego/vim-swoop', {'on_cmd': ['Swoop'], 'on_func':['Swoop', 'SwoopSelection', 'SwoopMulti', 'SwoopMultiSelection']} )
   let g:swoopUseDefaultKeyMap = 0

   " nmap <Leader>ml :call SwoopMulti()<CR>
   " vmap <Leader>ml :call SwoopMultiSelection()<CR>
   " nmap <Leader>l :call Swoop()<CR>
   " vmap <Leader>l :call SwoopSelection()<CR>

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
 " inline_edit.vim {{{

   call PM( 'AndrewRadev/inline_edit.vim', { 'on_cmd': ['InlineEdit']} )

 "}}} _inline_edit.vim
 " vim-multiple-cursors {{{

 "TODO: Set some mapping
   call PM( 'terryma/vim-multiple-cursors' )

   let g:multi_cursor_use_default_mapping=0
   "Use ctrl-n to select next instance
    " Default mapping
    let g:multi_cursor_next_key='<C-n>'
    let g:multi_cursor_prev_key='<C-p>'
    let g:multi_cursor_skip_key='<C-x>'
    let g:multi_cursor_quit_key='<Esc>'

 "}}} _vim-multiple-cursors
 " vim-markmultiple {{{

 call PM( 'adinapoli/vim-markmultiple', {'on_func':['MarkMultiple']} )
 let g:mark_multiple_trigger = "<C-n>"

 nnoremap <C-N>  :call MarkMultiple()<CR>
 xnoremap <C-N>  :call MarkMultiple()<CR>

 "if effect remains on screen clear with "call MarkMultipleClean()"
 "Map <c-bs>
 Map  NV <c-bs> :call\ MarkMultipleClean()<cr>

 "}}} _vim-markmultiple
 " multichange.vim {{{

 call PM( 'AndrewRadev/multichange.vim' )
 let g:multichange_mapping        = 'sm'
 let g:multichange_motion_mapping = 'm'

 "}}} _multichange.vim
 " vim-multiedit {{{

 call PM( 'hlissner/vim-multiedit' , { 'on_cmd': [
       \   'MultieditAddMark', 'MultieditAddRegion',
       \   'MultieditRestore', 'MultieditHop', 'Multiedit',
       \   'MultieditClear', 'MultieditReset'
       \ ] } )

   let g:multiedit_no_mappings = 1
   let g:multiedit_auto_reset = 1

   "Force multiedit key bindings and make it faster :)
   au VimEnter * call BindMultieditKeys()
   "au User vim-multiedit call BindMultieditKeys()

   function! BindMultieditKeys()

     " Insert a disposable marker after the cursor
     nnoremap <leader>ma :MultieditAddMark a<CR>

     " Insert a disposable marker before the cursor
     nnoremap <leader>mi :MultieditAddMark i<CR>

     " Make a new line and insert a marker
     nnoremap <leader>mo o<Esc>:MultieditAddMark i<CR>
     nnoremap <leader>mO O<Esc>:MultieditAddMark i<CR>

     " Insert a marker at the end/start of a line
     nnoremap <leader>mA $:MultieditAddMark a<CR>
     nnoremap <leader>mI ^:MultieditAddMark i<CR>

     " Make the current selection/word an edit region
     vnoremap <leader>m :MultieditAddRegion<CR>
     nnoremap <leader>mm viw:MultieditAddRegion<CR>

     " Restore the regions from a previous edit session
     nnoremap <leader>mu :MultieditRestore<CR>

     " Move cursor between regions n times
     noremap ]gc :MultieditHop 1<CR>
     noremap [gc :MultieditHop -1<CR>

     " Start editing!
     nnoremap <leader>ms :Multiedit<CR>

     " Clear the word and start editing
     nnoremap <leader>mc :Multiedit!<CR>

     " Unset the region under the cursor
     nnoremap <silent> <leader>md :MultieditClear<CR>

     " Unset all regions
     nnoremap <silent> <leader>mr :MultieditReset<CR>

     nmap <silent> <leader>mn <leader>mm/<C-r>=expand("<cword>")<CR><CR>
     nmap <silent> <leader>mp <leader>mm?<C-r>=expand("<cword>")<CR><CR>

   endfunction

 "}}} _vim-multiedit
 " vim-abolish {{{

   call PM( 'tpope/vim-abolish',           { 'on_cmd': ['S','Subvert', 'Abolish']} )

 "}}} _vim-abolish
 " vim-rengbang {{{

   call PM( 'deris/vim-rengbang',          { 'on_cmd': [ 'RengBang', 'RengBangUsePrev' ] } )

   "Use instead of increment it is much powerfull
   " RengBang \(\d\+\) Start# Increment# Select# %03d => 001, 002

 "}}} _vim-rengbang
 " vim-rectinsert {{{

   call PM( 'deris/vim-rectinsert',        { 'on_cmd': ['RectInsert', 'RectReplace'] } )

 "}}} _vim-rectinsert

 " Isolate
 " NrrwRgn {{{

 call PM( 'chrisbra/NrrwRgn', {
       \ 'on_cmd':
       \   [
       \    'NR', 'NarrowRegion', 'NW', 'NarrowWindow', 'WidenRegion',
       \    'NRV', 'NUD', 'NRPrepare', 'NRP', 'NRMulti', 'NRM',
       \    'NRS', 'NRNoSyncOnWrite', 'NRN', 'NRL', 'NRSyncOnWrite'
       \   ],
       \ 'on_map': ['<Plug>NrrwrgnDo']
       \ })

 nmap <leader>nr <Plug>NrrwrgnDo

 "}}} _NrrwRgn

 " Yank
 " vim-peekaboo {{{

   call PM( 'junegunn/vim-peekaboo' )

   " Default peekaboo window
   let g:peekaboo_window = 'vertical botright 30new'

   " Delay opening of peekaboo window (in ms. default: 0)
   let g:peekaboo_delay = 200

   " Compact display; do not display the names of the register groups
   let g:peekaboo_compact = 1

 "}}} _vim-peekaboo
 " UnconditionalPaste {{{

   call PM( 'vim-scripts/UnconditionalPaste', {'on_map': ['<Plug>UnconditionalPaste']} )
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

 "}}} _UnconditionalPaste

 " vim-copy-as-rtf {{{

 call PM( 'zerowidth/vim-copy-as-rtf', {'on_cmd': ['CopyRTF']} )

 "}}} _vim-copy-as-rtf

 " Single-edits
 " switch.vim {{{

   call PM( 'AndrewRadev/switch.vim', {'on_cmd':  ['Switch']} )

 "}}} _switch.vim
 " vim-exchange {{{

   call PM( 'tommcdo/vim-exchange', {'on_cmd':  ['ExchangeClear'] , 'on_map': ['<Plug>(Exchange']} )
   xmap c<cr><cr>     <Plug>(Exchange)
   nmap c<cr>l    <Plug>(ExchangeLine)
   nmap c<cr>c    <Plug>(ExchangeClear)
   nmap c<cr><bs> <Plug>(ExchangeClear)
   nmap c<cr><cr> <Plug>(Exchange)

 "}}} _vim-exchange

 " EasyAlign {{{

   call PM( 'junegunn/vim-easy-align',          {'on_cmd':  ['EasyAlign'], 'on_map':[ '<Plug>(EasyAlign)']} )

   " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
   vmap <Enter> <Plug>(EasyAlign)
   vnoremap g<Enter> :EasyAlign */[(,)]\+/<left><left><left><left>
   " Start interactive EasyAlign for a motion/text object (e.g. gaip)
   nmap g<cr> <Plug>(EasyAlign)
   let g:easy_align_ignore_comment = 0 " align comments

 "}}}
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
 " vim-surround {{{
 " ----------------------------------------------------------------------------
 call PM( 't9md/vim-surround_custom_mapping' )
 call PM( 'tpope/vim-surround', {
                           \   'on_map' :[
                           \      '<Plug>Dsurround' , '<Plug>Csurround',
                           \      '<Plug>Ysurround' , '<Plug>YSurround',
                           \      '<Plug>Yssurround', '<Plug>YSsurround',
                           \      '<Plug>YSsurround', '<Plug>VgSurround',
                           \      '<Plug>VSurround' , '<Plug>ISurround',
                           \      ['i', '<Plug>Isurround'],
                           \      ['i', '<Plug>ISurround']
                           \ ]} )
   let g:surround_no_mappings=1
   nmap dS <Plug>Dsurround
   nmap cS <Plug>Csurround
   nmap c<cr> <Plug>Csurround
   nmap y<cr> <Plug>Ysurround
   nmap yS <Plug>YSurround
   nmap y<cr><cr> <Plug>Yssurround
   nmap ySS <Plug>YSsurround
   xmap S <Plug>VSurround
   xmap gS <Plug>VgSurround
   "Original mappings
   "=================
   "nmap ds  <Plug>Dsurround
   "nmap cs  <Plug>Csurround
   "nmap cS  <Plug>CSurround
   "nmap ys  <Plug>Ysurround
   "nmap yS  <Plug>YSurround
   "nmap yss <Plug>Yssurround
   "nmap ySs <Plug>YSsurround
   "nmap ySS <Plug>YSsurround
   "xmap S   <Plug>VSurround
   "xmap gS  <Plug>VgSurround

   imap <C-G>s <Plug>Isurround
   imap <C-G>S <Plug>ISurround
   imap <C-S> <Plug>Isurround

 "}}}
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
   nnoremap gS :call Preserve('SplitjoinSplit')<cr><c-o>
   nnoremap gJ :call Preserve('SplitjoinJoin')<cr><c-o>
 endfunction

 "}}} _splitjoin.vim
 " vim-sort-motion {{{

  call PM( 'christoomey/vim-sort-motion', {'on_map': ['<Plug>Sort']} )
  map  gs  <Plug>SortMotion
  map  gss <Plug>SortLines
  vmap gs  <Plug>SortMotionVisual

 "}}} _vim-sort-motion
 " vim-tag-comment {{{
   " Comment out HTML properly
   call PM( 'mvolkmann/vim-tag-comment', {'on_cmd': ['ElementComment', 'ElementUncomment', 'TagComment', 'TagUncomment']} )
   nmap <leader>tc :ElementComment<cr>
   nmap <leader>tu :ElementUncomment<cr>
   nmap <leader>tC :TagComment<cr>
   nmap <leader>tU :TagUncomment<cr>

 "}}} _vim-tag-comment

 " Comments
 " nerdcommenter {{{

 if PM( 'scrooloose/nerdcommenter', {'on_map': [ '<Plug>NERDCommenter' ]} )
   "call s:SetUpForNewFiletype(&filetype, 1)

   Map nx  <leader>c<Space>     <Plug>NERDCommenterToggle
   Map nx  <leader>ca           <Plug>NERDCommenterAltDelims
   Map nx  <leader>cb           <Plug>NERDCommenterAlignBoth
   Map nx  <leader>ci           <Plug>NERDCommenterInvert
   Map nx  <leader>cl           <Plug>NERDCommenterAlignLeft
   Map nx  <leader>cm           <Plug>NERDCommenterMinimal
   Map nx  <leader>cn           <Plug>NERDCommenterNested
   Map nx  <leader>cs           <Plug>NERDCommenterSexy
   Map nx  <leader>cu           <Plug>NERDCommenterUncomment
   Map nx  <leader>cy           <Plug>NERDCommenterYank
   Map nx  <leader>cc           <Plug>NERDCommenterComment
   Map n   <leader>cA           <Plug>NERDCommenterAppend
   Map n   <leader>c$           <Plug>NERDCommenterToEOL

 endif

 "}}} _nerdcommenter
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
 xmap gc  <Plug>Commentary
 nmap gc  <Plug>Commentary
 omap gc  <Plug>Commentary
 nmap gcc <Plug>CommentaryLine
 nmap cgc <Plug>ChangeCommentary
 nmap gcu <Plug>Commentary<Plug>Commentary
 " }}} _vim-commentary
   " Plug 'tomtom/tcomment_vim'

 " Auto-manipulators
 " vim-endwise {{{
   "Plug 'tpope/vim-endwise', {'on': []}

   ""Lazy load endwise
   "augroup load_endwise
     "autocmd!
     "autocmd InsertEnter * call plug#load('vim-endwise') | autocmd! load_endwise
   "augroup END

 "}}} _vim-endwise
 " vim-closer {{{

   call PM( 'rstacruz/vim-closer' )

 "}}} _vim-closer
 " delimitmate {{{
 "XXXX
 call PM( 'Raimondi/delimitMate', {'on_event': ['InsertEnter']} )
   " au FileType blade let b:delimitMate_autoclose = 0
 "}}}
 "}}}
 " ----------------------------------------------------------------------------
 " Utils {{{
 " ----------------------------------------------------------------------------
 call PM('wincent/replay')

 " pipe.vim {{{

   "Pipe !command output to vim
   call PM( 'NLKNguyen/pipe.vim' )

 "}}} _pipe.vim

 "vim-signature {{{
   call PM('kshenoy/vim-signature')
 "}}} _vim-signature'

 " vim-submode {{{
   "call PM( 'kana/vim-submode' )
   if PM( 'khalidchawtany/vim-submode' )
   let g:submode_timeout=0

   au VimEnter * call BindSubModes()
   function! BindSubModes()
     " Window resize {{{
       call submode#enter_with('h/l', 'n', '', '<C-w>h', '<C-w><')
       call submode#enter_with('h/l', 'n', '', '<C-w>l', '<C-w>>')
       call submode#map('h/l', 'n', '', 'h', '<C-w><')
       call submode#map('h/l', 'n', '', 'l', '<C-w>>')
       call submode#enter_with('j/k', 'n', '', '<C-w>j', '<C-w>-')
       call submode#enter_with('j/k', 'n', '', '<C-w>k', '<C-w>+')
       call submode#map('j/k', 'n', '', 'j', '<C-w>-')
       call submode#map('j/k', 'n', '', 'k', '<C-w>+')
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

 " vim-unimpaired {{{
 call PM( 'tpope/vim-unimpaired' )
 "}}} _vim-unimpaired
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
 "call PM( 'duggiefresh/vim-easydir' )

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
 " vim-debugger {{{
 call PM('haya14busa/vim-debugger',
       \ {'on_cmd': ['DebugOn', 'Debugger', 'debug', 'StackTrace', 'CallStack', 'CallStackReport']})
 " }}} _vim-debugger
 " vim-scripts/Decho {{{
 call PM('vim-scripts/Decho', {
       \ 'on_cmd': ['Decho', 'DechoOn'],
       \ 'on_func': ['Decho', 'Dfunc', 'Dredir', 'DechoMsgOn', 'DechoRemOn', 'DechoTabOn', 'DechoVarOn'  ],
       \ })
     " Usage:
    " call Dfunc("YourFunctionName([arg1<".a:arg1."> arg2<".a:arg2.">])")
    " call Dret("YourFunctionName [returnvalue]")
 "}}} _vim-scripts/Decho

 call PM( 'KabbAmine/vCoolor.vim')
 " investigate.vim {{{

 if PM( 'keith/investigate.vim', {'on_map': ['gK']} )
   let g:investigate_dash_for_blade="laravel"
   let g:investigate_dash_for_php="laravel"
   let g:investigate_use_dash=1
 endif

 "}}} _investigate.vim

 if PM('machakann/vim-highlightedyank')
   map y <Plug>(highlightedyank)
   let g:highlightedyank_highlight_duration = 750
   highlight link HighlightedyankRegion Visual
 endif
 "}}}
 " ----------------------------------------------------------------------------
 " languages {{{
 " ----------------------------------------------------------------------------

 "GoDot
 if PM('quabug/vim-gdscript', {'on_ft': ['gdscript']})
   au BufRead,BufNewFile *.gd	set filetype=gdscript
 endif

 "Python
 call PM( 'tweekmonster/braceless.vim', {'on_ft': ['python']} )

 " Java
 " Plug 'tpope/vim-classpath'

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

     if exists(":DeopleteEnable")
       DeopleteEnable
       let g:deoplete#omni_patterns.cs='.*[^=\);]'
       let g:deoplete#sources.cs=['omni', 'buffer', 'member', 'tag', 'file']
     endif

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
 call PM( 'chrisbra/csv.vim', {'on_ft': ['csv']} )

 " PHP
 " phpcomplete.vim {{{

   "Plug 'shawncplus/phpcomplete.vim'

 "}}} _phpcomplete.vim
 " phpcomplete-extended {{{

    "Plug 'm2mdas/phpcomplete-extended'
    "let g:phpcomplete_index_composer_command = "composer"
    "autocmd  FileType  php setlocal omnifunc=phpcomplete_extended#CompletePHP

 "}}}
  "Plug 'm2mdas/phpcomplete-extended-laravel'
 " pdv {{{

   "call PM( 'tobyS/vmustache', {'on_ft': ['PHP']} )
   call PM( 'tobyS/vmustache' )
   "call PM( 'tobyS/pdv', {'on_ft': ['PHP']} )
   if PM( 'tobyS/pdv' )
     let g:pdv_template_dir = $HOME ."/.config/nvim/plugged/pdv/templates_snip"
     nnoremap <buffer> <C-p> :call pdv#DocumentWithSnip()<CR>
   endif

 "}}} _pdv

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

   if PM_ISS('deoplete.nvim')
     let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
     let g:deoplete#ignore_sources.php = ['phpcd', 'omni', 'javacomplete2', 'look']
     let g:deoplete#omni#input_patterns = get(g:, 'deoplete#omni#input_patterns', {})
     let g:deoplete#omni#input_patterns.php =  '\w+|[^. \t]->\w*|\w+::\w*'
   endif
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

 "let g:loaded_matchit=1
 "let g:loaded_matchparen=1
 function OptimizePHPSyntax()
   syn clear phpHereDoc
   syn clear phpNowDoc
   syn clear phpParent
   "syn clear phpFloat
   "syn clear phpOperator
   "syn clear phpComparison
   "syn clear phpRelation
 endfunction

 augroup php_and_family
   au!
   au BufWinEnter *.php call OptimizePHPSyntax()
 augroup END

 "Go
 call PM( 'fatih/vim-go', {'on_ft': ['go']} )

 if PM_ISS('deoplete.nvim')
   call PM( 'zchee/deoplete-go', {
         \ 'on_ft': ['go'],
         \ 'build': 'sh -c "/usr/bin/make"',
         \ 'on_event': 'VimEnter',
         \ 'on_if': 'has("nvim")'
         \ } )
 endif

 "Rust
 " vim-racer {{{

 if PM( 'racer-rust/vim-racer', {'on_ft': ['rust']} )
   let g:racer_cmd = "/Volumes/Home/.cargo/bin/racer"
   let $RUST_SRC_PATH="/Volumes/Home/Development/Applications/rust/src/"
 endif

 "}}} _vim-racer

 " blade
 " vim-blade {{{

   "call PM( 'xsbeats/vim-blade', {'on_ft':['blade'] } )
   "call PM( 'xsbeats/vim-blade' )
   ""au BufNewFile,BufRead *.blade.php set filetype=html
   "au BufNewFile,BufRead *.blade.php set filetype=blade

   call PM('jwalton512/vim-blade')

 "}}}
   call PM('johnhamelink/blade.vim', {'on_if': '0'})

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

 if PM( 'mattn/emmet-vim', {'on_ft':['html','xml','xsl','xslt','xsd','css','sass','scss','less','mustache', 'blade', 'php']} )

   "let g:user_emmet_mode='a'         "enable all function in all mode.
   let g:user_emmet_mode='i'         "enable all function in insert mode
   let g:user_emmet_leader_key="<c-'><c-;>"
 endif

 "}}}
 " vim-hyperstyle {{{

   call PM( 'rstacruz/vim-hyperstyle', {'on_ft': ['css']} )

 "}}} _vim-hyperstyle
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
 " MatchTagAlways {{{

 if PM( 'Valloric/MatchTagAlways' , {'on_if': 0, 'on_ft':['html', 'php','xhtml','xml','blade', 'js', 'vim']} )
   let g:mta_filetypes = {
         \ 'html' : 1,
         \ 'xhtml' : 1,
         \ 'xml' : 1,
         \ 'jinja' : 1,
         \ 'blade' : 1,
         \ 'php' : 1,
         \ 'js' : 1,
         \ 'vim' : 1,
         \}
   nnoremap <leader>% :MtaJumpToOtherTag<cr>
 endif

 "}}}"Always match html tag

 " vim-ragtag {{{

 if PM( 'tpope/vim-ragtag', {'on_ft':['html','xml','xsl','xslt','xsd', 'blade', 'php', 'blade.php']} )
  let g:ragtag_global_maps = 1
 endif

 "}}} _vim-ragtag

 " Compilers
 " vimproc.vim {{{

   call PM( 'Shougo/vimproc.vim', {'build': 'sh -c "/usr/bin/make"'} )

 "}}} _vimproc.vim
 " vim-dispatch {{{

   call PM( 'tpope/vim-dispatch' )

 "}}} _vim-dispatch
 " neomake {{{

 if PM( 'benekastah/neomake', {'on_cmd': ['Neomake']} )

   " autocmd! BufWritePost * Neomake
   " let g:neomake_airline = 0
   let g:neomake_error_sign = { 'text': '✘', 'texthl': 'ErrorSign' }
   let g:neomake_warning_sign = { 'text': ':(', 'texthl': 'WarningSign' }
 endif

 "}}} _neomake
 " vim-accio {{{

   call PM( 'pgdouyon/vim-accio', {'on_cmd': ['Accio']} )

 "}}} _vim-accio
 " syntastic {{{

 if PM( 'scrooloose/syntastic', {'on_cmd': ['SyntasticCheck']} )

   let g:syntastic_scala_checkers=['']
   let g:syntastic_always_populate_loc_list = 1
   let g:syntastic_check_on_open = 1
   let g:syntastic_error_symbol = "✗"
   let g:syntastic_warning_symbol = "⚠"
 endif

 "}}} _syntastic
 " vim-test {{{

   call PM( 'janko-m/vim-test', {'on_cmd': [ 'TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit' ]} )

 "}}} _vim-test

 " vim-fetch {{{
   call PM( 'kopischke/vim-fetch' )              "Fixes how vim handles FN(LN:CN)
 "}}} _vim-fetch

"call PM ( 'gilligan/vim-lldb', {'if': '!has("nvim")'} )
"http://blog.rplasil.name/2016/03/how-to-debug-neovim-python-remote-plugin.html
call PM ( 'critiqjo/lldb.nvim', {'if': 'g:python2_host_prog != "/usr/local/bin/python"'} )
call PM ( 'critiqjo/lldb.nvim' )

 call PM('joonty/vdebug')

 "}}}
 " ----------------------------------------------------------------------------
 " Snippets {{{
 " ----------------------------------------------------------------------------

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
 " ----------------------------------------------------------------------------
 " AutoCompletion {{{
 " ----------------------------------------------------------------------------

 "deoplete
 " deoplete.nvim {{{

 if PM( 'Shougo/deoplete.nvim',
       \ {
       \ 'on_event': ['InsertEnter', 'VimEnter'],
       \ 'on_if': 'has("nvim")' ,
       \ 'hook_post_source' :
       \ "
       \        call deoplete#custom#set('member', 'file', 9999)
       \     |  call deoplete#custom#set('member', 'rank', 9998)
       \     |  call deoplete#custom#set('buffer', 'rank', 9997)
       \     |  call deoplete#custom#set('ultisnips', 'rank', 9996)
       \     |  call deoplete#custom#set('omni', 'rank', 9995)
       \ "
       \ })
       "\    call deoplete#custom#set('_', 'matchers', ['matcher_full_fuzzy'])
       "\  | call deoplete#custom#set('_', 'sorters', ['sorter_word'])

   let g:deoplete#auto_complete_delay=0

   "let g:deoplete#omni_patterns = {} //This disables all features
   let g:deoplete#enable_fuzzy_completion = 1
   let g:deoplete#auto_completion_start_length = 1
   let g:deoplete#enable_at_startup = 1
   let g:deoplete#enable_ignore_case = 1
   let g:deoplete#enable_smart_case = 1
   let g:deoplete#enable_camel_case = 1
   "let g:deoplete#enable_refresh_always = 1
   let g:deoplete#max_abbr_width = 0
   let g:deoplete#max_menu_width = 0
   let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})
		let g:deoplete#omni#input_patterns.ruby =  ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::']
		let g:deoplete#omni#input_patterns.java = '[^. *\t]\.\w*'
   let g:deoplete#ignore_sources = {}
   let g:deoplete#ignore_sources._ = ['javacomplete2']
   "inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
   "inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"
   set isfname-==

   "My Settings
   "let g:deoplete#omni#input_patterns.php = [ '[^. \t0-9]\.\w*', '[^. \t0-9]\->\w*', '[^. \t0-9]\::\w*', ]
   "let g:deoplete#sources = {}
   "let g:deoplete#sources._ = ['buffer', 'ultisnips', 'file']
   "let g:deoplete#sources.php = ['buffer', 'ultisnips', 'file',  'omni', 'member', 'tag']
   let g:deoplete#delimiters = ['/', '.', '::', ':', '#', '->']

 endif
 "}}} _deoplete.nvim
 " neoinclude.vim {{{

   call PM( 'Shougo/neoinclude.vim' , { 'on_event': 'VimEnter', 'on_if': 'has("nvim")' })

 "}}} _neoinclude.vim
 " neco-syntax {{{

  "Slows down PHP files so much
   "call PM( 'Shougo/neco-syntax' )

 "}}} _neco-syntax
 " neco-vim {{{

   call PM( 'Shougo/neco-vim' , { 'on_event': 'VimEnter', 'on_if': 'has("nvim")' })

 "}}} _neco-vim
 " echodoc.vim {{{

   call PM( 'Shougo/echodoc.vim', { 'on_event': 'VimEnter', 'on_if': 'has("nvim")' })

 "}}} _echodoc.vim
 " neco-look {{{
 call PM('ujihisa/neco-look', { 'on_event': 'VimEnter', 'on_if': 'has("nvim")' })
 "}}} _neco-look


 " Command line
 " ambicmd {{{

 "XXXXX
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
 " ----------------------------------------------------------------------------
 " Operators {{{
 " ----------------------------------------------------------------------------

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
 " ----------------------------------------------------------------------------
 " text-objects {{{
 " ----------------------------------------------------------------------------
 call PM( 'jeetsukumaran/vim-indentwise' ) " Use ]- ]+ ]= to move between indents

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

  call PM( 'kana/vim-textobj-user' )

  call PM( 'reedes/vim-textobj-sentence' )            "is, as, ), (,   For real english sentences
                                                                             "also adds g) and g( for
                                                                             "sentence navigation
  call PlugTextObj( 'kana/vim-textobj-line', 'll' )                        "il, al          for line
  call PlugTextObj( 'haya14busa/vim-textobj-number', 'n' )                 "in, an          for numbers
  call PlugTextObj( 'machakann/vim-textobj-functioncall', 'C' )
  let g:textobj_functioncall_no_default_key_mappings =1

  " vim-textobj-function {{{
     call PlugTextObj( 'kana/vim-textobj-function', 'f' )
     let g:textobj_function_no_default_key_mappings =1
     Map vo iF <Plug>(textobj-function-I)
     Map vo aF <Plug>(textobj-function-A)
  " }}} _vim-textobj-function

  " vim-textobj-between {{{
  "ibX, abX                     for between two chars
  "changed to isX, asX          for between two chars
  call PlugTextObj( 'thinca/vim-textobj-between', 's' )
  let g:textobj_between_no_default_key_mappings =1
 "}}}

  " vim-textobj-any {{{
  "ia, aa          for (, {, [, ', ", <
  call PlugTextObj( 'rhysd/vim-textobj-anyblock', '<cr>' )
  let g:textobj_anyblock_no_default_key_mappings =1
  "}}}

  "Don't try to lazyload this (Dein lazyloaded delimited :) )
  call PM( 'osyo-manga/vim-textobj-blockwise' ) "<c-v>iw, cIw    for block selection

  " vim-textobj-delimited {{{
    "id, ad, iD, aD   for Delimiters takes numbers d2id
  if PM( 'machakann/vim-textobj-delimited', {'on_map': ['<Plug>(textobj-delimited-']} )
    Map vo id <Plug>(textobj-delimited-forward-i)
    Map vo id <Plug>(textobj-delimited-forward-i)
    Map vo ad <Plug>(textobj-delimited-forward-a)
    Map vo ad <Plug>(textobj-delimited-forward-a)
    Map vo iD <Plug>(textobj-delimited-backward-i)
    Map vo iD <Plug>(textobj-delimited-backward-i)
    Map vo aD <Plug>(textobj-delimited-backward-a)
    Map vo aD <Plug>(textobj-delimited-backward-a)
  endif
  "}}} _vim-textobj-delimited

  if PM( 'saaguero/vim-textobj-pastedtext', {'on_map': ['<Plug>(textobj-pastedtext-text)']} )
    "gb              for pasted text
    Map vo gb <Plug>(textobj-pastedtext-text)
  endif

    call PlugTextObj ("Julian/vim-textobj-brace", "j")                          "ij, aj          for all kinds of brces

    call PlugTextObj( 'kana/vim-textobj-syntax', 'y' )                          "iy, ay          for Syntax
    call PlugTextObj( 'mattn/vim-textobj-url', 'u')                             "iu, au          for URL
    call PlugTextObj( 'glts/vim-textobj-comment', 'c' )
    Map vo aC <Plug>(textobj-comment-big-a)

  " vim-textobj-indblock {{{
    "io, ao, iO, aO  for indented blocks
    call PlugTextObj( 'glts/vim-textobj-indblock', 'o' )
    Map vo iO <Plug>(textobj-indblock-i)
    Map vo aO <Plug>(textobj-indblock-a)
  "}}} _vim-textobj-indblock
"
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
  if PM( 'kana/vim-textobj-lastpat' , {'on_map': ['<Plug>(textobj-lastpat-n)', '<Plug>(textobj-lastpat-n)']} )
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
 " ----------------------------------------------------------------------------
 " Navigation {{{
 " ----------------------------------------------------------------------------
 "{{{ vim-CtrlSpace
 if PM('vim-ctrlspace/vim-ctrlspace')
   nnoremap <silent> <C-Space><C-Space> :CtrlSpace<cr>
   let g:CtrlSpaceSymbols = { "File": "◯", "CTab": "▣", "Tabs": "▢" }
   if executable("ag")
     let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
   endif
 endif
 "}}} _vim-CtrlSpace

 " File
 " denite.vim{{{
   if PM( 'Shougo/denite.nvim' )
    " Change mappings.
    call denite#custom#map('_', "<C-j>", '<denite:move_to_next_line>')
    call denite#custom#map('_', "<C-k>", '<denite:move_to_prev_line>')
    call denite#custom#map('_', "<C-;>", '<denite:input_command_line>')
    call denite#custom#var('file_rec', 'command',
          \ ['rg', '--threads', '2', '--files', '--glob', '!.git'])
  endif

 " }}} _dnite.vim

 call PM('nixprime/cpsm')

 " neomru.vim {{{

  if PM( 'Shougo/neomru.vim' )
   "call unite#custom#source(  'neomru/file', 'matchers',  ['matcher_project_files', 'matcher_fuzzy'])
   "nnoremap <silent> <leader>pr :Unite neomru/file<cr>
   "nnoremap <silent> [unite]d \ :<C-u>Unite -buffer-name=files -default-action=lcd neomru/directory<CR>

   command! ProjectFiles call unite#custom#source( 'neomru/file', 'matchers', ['matcher_project_files', 'matcher_fuzzy'])
   nnoremap <silent> <leader>pr :ProjectFiles<cr>
 endif

 "}}} _neomru.vim

 " unite.vim {{{

if PM( 'Shougo/unite.vim') 
      "\ {
      "\ 'on_cmd': ['Unite', 'UniteWithCursorWord'],
      "\ 'on_func': ['unite#custom#', 'unite#custom#source'],
      "\ })

   "Plug 'Shougo/unite.vim'
   call PM( 'Shougo/unite-outline' )
   call PM( 'Shougo/unite-build' )
   call PM( 'Shougo/unite-help' )
   call PM( 'Shougo/unite-sudo' )
   call PM( 'Shougo/unite-session' )
   "Plug 'Shougo/neoyank.vim'   "Breaks a lazyloading on some plugins like sort-motion
   call PM( 'tsukkee/unite-tag' )
   " unite-bookmark-file {{{

  if PM( 'liquidz/unite-bookmark-file' )
   ":Unite bookmark/file
   let g:unite_bookmark_file = '~/.config/nvim/.cache/unite-bookmark-file'
 endif

   "}}} _unite-bookmark-file
   call PM( 'ujihisa/unite-colorscheme' )
   call PM( 'ujihisa/unite-locate' )
   call PM( 'sgur/unite-everything' )
   call PM( 'tacroe/unite-mark' )
   call PM( 'tacroe/unite-alias' )
   call PM( 'hakobe/unite-script' )
   call PM( 'soh335/unite-qflist' )
   call PM( 'thinca/vim-unite-history' )
   call PM( 'sgur/unite-qf' )
   call PM( 'oppara/vim-unite-cake' )
   call PM( 't9md/vim-unite-ack' )
   call PM( 'Sixeight/unite-grep' )
   call PM( 'kannokanno/unite-todo' )
   call PM( 'osyo-manga/unite-fold' )
   call PM( 'osyo-manga/unite-highlight' )
   " unite-fasd.vim {{{

  if PM( 'critiqjo/unite-fasd.vim' )
   " Path to fasd script (must be set)
   let g:unite_fasd#fasd_path = '/usr/local/bin/fasd'
   " Path to fasd cache -- defaults to '~/.fasd'
   let g:unite_fasd#fasd_cache = '~/.fasd'
   " Allow `fasd -A` on `BufRead`
   let g:unite_fasd#read_only = 0
   "Unite fasd OR Unite fasd:mru
  endif

   "}}} _unite-fasd.vim

   autocmd! User unite.vim  call SetUpUniteMenus()
   "au VimEnter * call SetUpUniteMenus()
   function! SetUpUniteMenus()

     " Enable fuzzy matching and sorting in all Unite functions
     call unite#filters#matcher_default#use(['matcher_fuzzy'])
     " call unite#filters#sorter_default#use(['sorter_rank'])
     call unite#filters#sorter_default#use(['sorter_selecta'])

     let g:unite_source_menu_menus = {} " Useful when building interfaces at appropriate places

     " More Unite menus {{{
     " Interface for OS interaction
     let g:unite_source_menu_menus.osinteract = {
           \ 'description' : 'OS interaction and configs',
           \}
     let g:unite_source_menu_menus.osinteract.command_candidates = [
           \[' alternate file', 'A'],
           \[' generate tags in buffer dir', 'cd %:p:h | Dispatch! ctags .'],
           \[' cd to buffer directory', 'cd %:p:h'],
           \[' cd to project directory', 'Rooter'],
           \[' create .projections.json', 'cd %:p:h | e .projections.json'],
           \[' Battery status', 'Unite -buffer-name=ubattery output:echo:system("~/battery")'],
           \[' Scratch notes', 'Unite -buffer-name=unotes -start-insert junkfile'],
           \[' Source vimrc', 'so $MYVIMRC'],
           \[' Edit vimrc', 'e $MYVIMRC'],
           \]
     nnoremap <silent> <c-;><c-;><c-l> :Unite -silent -buffer-name=osinteract -quick-match menu:osinteract<CR>
     "}}}

   endfunction

   nnoremap <silent> <leader>p<space> :Unite -auto-resize outline<cr>
   nnoremap <silent> <leader>po :Unite -auto-resize buffer<cr>

   let g:unite_data_directory=$HOME.'/.config/nvim/.cache/unite'

   let g:unite_force_overwrite_statusline = 0
   let g:unite_winheight = 10
   let g:unite_data_directory='~/.config/nvim/.cache/unite'
   let g:unite_enable_start_insert=1
   let g:unite_source_history_yank_enable=1
   let g:unite_prompt='» '
   let g:unite_split_rule = 'botright'

   if executable('ag')
     let g:unite_source_grep_command='ag'
     let g:unite_source_grep_default_opts='--nocolor --nogroup -S -C4'
     let g:unite_source_grep_recursive_opt=''
     let g:unite_source_rec_async_command=['ag --nocolor --nogroup --ignore ".hg" --ignore ".svn" --ignore ".git" --ignore ".bzr" --hidden -g ""']
   endif

   " Custom mappings for the unite buffer
   autocmd FileType unite call s:unite_settings()
   function! s:unite_settings()
     " Play nice with supertab
     let b:SuperTabDisabled=1
     " Enable navigation with control-j and control-k in insert mode
     imap <buffer> <C-j>    <Plug>(unite_select_next_line)
     imap <buffer> <C-k>    <Plug>(unite_select_previous_line)
     imap <buffer> <esc>    <esc> <Plug>(unite_all_exit)
     nmap <buffer> <bs>     <Plug>(unite_delete_backward_path)
     nmap <silent> <buffer> <esc> <Plug>(unite_all_exit) " Close Unite view
   endfunction

   function! Open_current_file_dir(args)
     let [args, options] = unite#helper#parse_options_args(a:args)
     let path = expand('%:h')
     let options.path = path
     call unite#start(args, options)
   endfunction

   nnoremap <c-;><c-;>cd :call Open_current_file_dir('-no-split file')<cr>

   " Execute help.
   nnoremap <c-;><c-;>h  :<C-u>Unite -start-insert help<CR>
   " Execute help by cursor keyword.
   nnoremap <silent> <c-;><c-;><C-h>  :<C-u>UniteWithCursorWord help<CR>

   "call unite#custom#source('buffer,file,file_rec',
   "\ 'sorters', 'sorter_length')

   "CtrlP & NerdTree combined
   nnoremap <silent> <c-;><c-;>F :Unite -auto-resize file/async  file_rec/async<cr>
   nnoremap <silent> <c-;><c-;>f :Unite -auto-resize file_rec/async<cr>
   nnoremap <silent> <c-;><c-;><c-f> :Unite -auto-resize file_rec/async<cr>

   nnoremap <silent> <c-;><c-;>d :Unite -auto-resize directory_rec/async<cr>
   nnoremap <silent> <c-;><c-;>o :Unite -auto-resize file_mru<cr>

   nnoremap <silent> <c-;><c-;>l :Unite -auto-resize outline<cr>

   "Grep commands
   nnoremap <silent> <c-;><c-;>g :Unite -auto-resize grep:.<cr>
   nnoremap <silent> <c-;><c-;><c-g> :Unite -auto-resize grep:/<cr>
   "Content search like Ag anc Ack
   nnoremap <c-;><c-;>/ :Unite grep:.<cr>

   "Hostory & YankRing
   let g:unite_source_history_yank_enable = 1
   nnoremap <c-;><c-;>y :Unite history/yank<cr>
   nnoremap <c-;><c-;>: :Unite history/command<cr>
   nnoremap <c-;><c-;>/ :Unite history/search<cr>

   nnoremap <c-;><c-;>? :Unite mapping<cr>

   "LustyJuggler
   nnoremap <c-;><c-;>b :Unite -quick-match buffer<cr>
   nnoremap <c-;><c-;><c-b> :Unite buffer<cr>

   "LustyJuggler
   nnoremap <c-;><c-;>t :Unite -quick-match tab<cr>
   nnoremap <c-;><c-;><c-t> :Unite tab<cr>

   "Line Search
   nnoremap <c-;><c-;>l :Unite line<cr>
   nnoremap <c-;><c-;>L :Unite -quick-match line<cr>
 endif
 "}}} _unite.vim
 " FZF {{{
   if PM('junegunn/fzf', { 'build': 'sh -c "~/.config/nvim/dein/repos/github.com/junegunn/fzf/install --bin"', 'merged': 0 })
   "call PM('junegunn/fzf', { 'on_source': ['fzf.vim'] })
   "call PM('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
   "set rtp+=/usr/local/opt/fzf
   "call PM('/usr/local/Cellar/fzf/HEAD', {
         "\ 'on_cmd': ['FZF'],
         "\ 'on_func': ['fzf#run', 'fzf#vim']
         "\ })
   "call PM('junegunn/fzf', {'build': 'brew reinstall --HEAD fzf','rev': 'd6a99c0391b3859c5db9a0072b366caaf3278f18',  'merged': 0 })
   "call PM('junegunn/fzf', {'build': '/usr/local/bin/brew reinstall --HEAD fzf',  'merged': 0 })

   "Fix fzf already running error
   "au TermClose *FZF* bw!
   "au TermClose *FZF* BW

   if !has('nvim') && has('gui_running')
     let g:fzf_launcher = "fzf_iterm %s"
   endif

    "let g:fzf_layout = { 'window': 'execute (tabpagenr()-1)."tabnew"' }
    "let g:fzf_layout = { 'window': '-tabnew' }

    let $FZF_DEFAULT_OPTS="--reverse --bind '::jump,;:jump-accept'"

    let $FZF_DEFAULT_COMMAND='ag -l -g ""'
    "Use rg instead of ag {{{
      "let $FZF_DEFAULT_COMMAND='/Volumes/Home/.cargo/bin/rg --files --no-ignore --hidden --follow --glob "!.git/*"'

      "" --column: Show column number
      "" --line-number: Show line number
      "" --no-heading: Do not show file headings in results
      "" --fixed-strings: Search term as a literal string
      "" --ignore-case: Case insensitive search
      "" --no-ignore: Do not respect .gitignore, etc...
      "" --hidden: Search hidden files and folders
      "" --follow: Follow symlinks
      "" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
      "" --color: Search color options

      "if has('neovm')
        "command! -bang -nargs=* Find call fzf#vim#grep('/Volumes/Home/.cargo/bin/rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
      "else
        "command! -bang -nargs=* Find call fzf#vim#grep('/Volumes/Home/.cargo/bin/rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
      "endif
    "}}}

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
          \   'on_cmd': ['Files', 'GitFiles', 'Buffers', 'Colors', 'Ag', 'Lines',
          \               'BLines', 'Tags', 'BTags', 'Maps', 'Marks', 'Windows',
          \               'Locate', 'History', 'History:', 'History/', 'Snippets',
          \               'Commits', 'BCommits', 'Commands', 'Helptags']
          \ })

   " [Buffers] Jump to the existing window if possible
   let g:fzf_buffers_jump = 1

   " Command          | List
   " ---              | ---
   " `Files [PATH]`   | Files (similar to `:FZF`)
   " `GitFiles`       | Git files
   " `Buffers`        | Open buffers
   " `Colors`         | Color schemes
   " `Ag [PATTERN]`   | [ag][ag] search result (`ALT-A` to select all, `ALT-D` to deselect all)
   " `Lines`          | Lines in loaded buffers
   " `BLines`         | Lines in the current buffer
   " `Tags [QUERY]`   | Tags in the project (`ctags -R`)
   " `BTags [QUERY]`  | Tags in the current buffer
   " `Marks`          | Marks
   " `Windows`        | Windows
   " `Locate PATTERN` | `locate` command output
   " `History`        | `v:oldfiles` and open buffers
   " `History:`       | Command history
   " `History/`       | Search history
   " `Snippets`       | Snippets ([UltiSnips][us])
   " `Commits`        | Git commits (requires [fugitive.vim][f])
   " `BCommits`       | Git commits for the current buffer
   " `Commands`       | Commands
   " `Maps`           | Normal mode mappings
   " `Helptags`       | Help tags <sup id="a1">[1](#helptags)</sup>
   " `Filetypes`      | File types

   " Command Local Options {{{
      " [Files] Extra options for fzf
      "         e.g. File preview using coderay (http://coderay.rubychan.de/)
      let g:fzf_files_options =
            \ '--preview "(coderay {} || cat {}) 2> /dev/null | head -'.&lines.'"'

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
     return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
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
 call Map_FZF  ( "silent! FZF! "     , "d"     , " --reverse %:p:h "                                                              , 0  )
 call Map_FZF  ( "silent! FZF! "     , "r"     , " --reverse <c-r>=FindGitDirOrRoot()<cr>"                                        , 0  )
 call Map_FZF  ( "silent! Files! "    , "p"   , ''                                                                               , 2  )
 call Map_FZF  ( "silent! Buffers"   , "b"     , ""                                                                               , 0  )
 call Map_FZF  ( "silent! Ag!"       , "a"     , ""                                                                               , 3  )
 call Map_FZF  ( "silent! Lines!"    , "L"     , ""                                                                               , 2  )
 call Map_FZF  ( "silent! BLines!"   , "l"     , ""                                                                               , 2  )
 call Map_FZF  ( "silent! BTags!"    , "t"     , ""                                                                               , 0  )
 call Map_FZF  ( "silent! Tags!"     , "]"     , ""                                                                               , 0  )
"call Map_FZF  ( "silent! Locate"    , "<cr>"  , "--reverse  %:p:h"                                                               , 0  )
 call Map_FZF  ( "silent! GitFiles"  , "v"     , ''                                                                               , 0  )
 call Map_FZF  ( "silent! Commits!"  , "g"     , ""                                                                               , 0  )
 call Map_FZF  ( "silent! BCommits!" , "G"     , ""                                                                               , 0  )
 call Map_FZF  ( "silent! Snippets!" , "s"     , ""                                                                               , 0  )
 call Map_FZF  ( "silent! Marks!"    , "<c-'>" , ""                                                                               , 0  )
 call Map_FZF  ( "silent! Marks!"    , "'"     , ""                                                                               , 0  )
 call Map_FZF  ( "silent! Windows!"  , "w"     , ""                                                                               , 0  )
 call Map_FZF  ( "silent! Helptags!" , "k"     , ""                                                                               , 0  )

 "The last param is <bang>0 to make it fullscreen
 nnoremap <silent> <c-p>p :silent! call fzf#vim#files(getcwd(), {'options': '--reverse -q'.shellescape(expand('<cword>'))}, 1)<cr>


   "nmap <c-p><c-i> <plug>(fzf-maps-n)
   nnoremap <silent> <c-p><c-m> :Maps!<cr>
   xmap <silent> <c-p><c-m> <plug>(fzf-maps-x)
   omap <silent> <c-p><c-m> <plug>(fzf-maps-o)

   imap <silent> <c-x><c-k> <plug>(fzf-complete-word)
   imap <silent> <c-x><c-f> <plug>(fzf-complete-path)
   imap <silent> <c-x><c-a> <plug>(fzf-complete-file-ag)
   imap <silent> <c-x><c-l> <plug>(fzf-complete-line)
   imap <silent> <c-x><c-i> <plug>(fzf-complete-buffer-line)
   imap <silent> <c-x><c-\> <plug>(fzf-complete-file)

   function GetDirectories()
     call fzf#run({"source":"ag -l --nocolor -g \"\" | awk 'NF{NF-=1};1' FS=/ OFS=/ | sort -u | uniq" , "sink":"NERDTree"})
    "find . -type d   -not -iwholename \"./.phpcd*\" -not -iwholename \"./node_modules*\" -not -iwholename \".\" -not -iwholename \"./vendor*\" -not -iwholename \"./.git*\"
    "ag -l --nocolor -g "" | awk 'NF{NF-=1};1' FS=/ OFS=/ | sort -u | uniq
   endfunction
   nnoremap <silent> <c-p>[ :call fzf#run({"source":"find . -type d", "sink":"NERDTree"})<cr>
   nnoremap <silent> <silent> <c-p><c-[> :cal GetDirectories()<cr>

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

   let g:fzf_action = {
         \ 'ctrl-m': 'e!',
         \ 'ctrl-t': 'tabedit!',
         \ 'ctrl-x': 'split',
         \ 'ctrl-o': 'PrintPathInNextLine',
         \ 'ctrl-i': 'PrintPath',
         \ 'ctrl-v': 'vsplit' }

   command! FZFMru call fzf#run({
         \ 'source':  reverse(s:all_files()),
         \ 'sink':    'edit',
         \ 'options': ' --reverse -m --no-sort -x',
         \ 'window':  '-tabnew'
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

   nnoremap <silent> <c-p><c-i> :call fzf#run({
         \   'source':  reverse(<sid>tablist()),
         \   'sink':    function('<sid>tabopen'),
         \   'options': " --revese --preview-window right:50%  --preview 'echo {}'  --bind ?:toggle-preview",
         \   'window':    '-tabnew'
         \ })<cr>

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
     execute 'buffer' matchstr(a:e, '^[ 0-9]*')
   endfunction

   nnoremap <silent> <c-p><c-o> :call fzf#run({
         \   'source':  reverse(<sid>buflist()),
         \   'sink':    function('<sid>bufopen'),
         \   'options': '+m --reverse',
         \   'window':    '-tabnew'
         \ })<CR>
         "\   'down':    len(<sid>buflist()) + 2

   "}}} _open_buffers -term

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
     echomsg l:term_buffer_id
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
   nnoremap <silent> <c-p><c-;> :call fzf#run({
         \   'source':  reverse(<sid>termlist()),
         \   'sink':    function('<sid>termtabopen'),
         \   'options': '+m --reverse',
         \   'window':    '-tabnew'
         \ })<CR>

   "}}} _open_terms
  endif

 endif

 " }}}
 " neovim-fuzzy {{{
 if PM('cloudhead/neovim-fuzzy', {'on_cmd': ['FuzzyOpen']})
  nnoremap <c-p><c-e> :silent! FuzzyOpen<cr>
 endif " PM()
 " }}} _neovim-fuzzy

 " ranger.vim {{{

   call PM( 'francoiscabrol/ranger.vim' )
   call PM( 'rbgrouleff/bclose.vim' )
   let g:ranger_map_keys = 0
   nnoremap <leader>ar :call OpenRanger()<CR>

 "}}} _ranger.vim
 " vim-dirvish {{{

  if PM( 'justinmk/vim-dirvish' )         " {-} file browser
   ":'<,'>Shdo mv {} {}-copy.txt
    augroup my_dirvish_events
      autocmd!

      "autocmd FileType dirvish nnoremap <buffer> <leader>r :Rename <c-r>=getline('.')<cr><space>
      "autocmd FileType dirvish nnoremap <buffer> <leader>m :Move   <c-r>=shellescape(getline('%'))<cr>
      "autocmd FileType dirvish nnoremap <buffer> <leader>c :saveas <c-r>=@%<cr><space>

      " Map t to "open in new tab".
      autocmd FileType dirvish
        \  nnoremap <buffer> t :call dirvish#open('tabedit', 0)<CR>
        \ |xnoremap <buffer> t :call dirvish#open('tabedit', 0)<CR>

      if PM_ISS('vim-fugitive')
        " Enable :Gstatus and friends.
        autocmd FileType dirvish call fugitive#detect(@%)
      endif

      " Map CTRL-R to reload the Dirvish buffer.
      autocmd FileType dirvish nnoremap <buffer> <C-R> :<C-U>Dirvish %<CR>

      " Map `gh` to hide dot-prefixed files.
      " To "toggle" this, just press `R` to reload.
      autocmd FileType dirvish nnoremap <buffer>
        \ gh :keeppatterns g@\v/\.[^\/]+/?$@d<cr>
    augroup END

  else
    nnoremap - :e %:h<cr>
  endif

 "}}} _vim-dirvish
 " vim-vinegar {{{

   call PM( 'tpope/vim-vinegar' )

 "}}} _vim-vinegar
 " NERDTree {{{

  if PM( 'scrooloose/nerdtree', {'on_cmd':  ['NERDTreeToggle', 'NERDTreeCWD', 'NERDTreeFind', 'NERDTree'] } )
   "call PM('tiagofumo/vim-nerdtree-syntax-highlight', { 'depends': 'nerdtree' })
   "Plug 'scrooloose/nerdtree'
  "Plug 'jistr/vim-nerdtree-tabs'

   "let g:loaded_netrw       = 1 "Disable Netrw
   "let g:loaded_netrwPlugin = 1 "Disable Netrw

   "let g:nerdtree_tabs_open_on_gui_startup = 0
   let g:nerdtree_tabs_open_on_gui_startup = !$NVIM_TUI_ENABLE_TRUE_COLOR

   let NERDTreeQuitOnOpen=1
   let NERDTreeWinSize = 23

   " Don't display these kinds of files
   let NERDTreeIgnore=[ '\.ncb$', '\.suo$', '\.vcproj\.RIMNET', '\.obj$',
         \ '\.ilk$', '^BuildLog.htm$', '\.pdb$', '\.idb$',
         \ '\.embed\.manifest$', '\.embed\.manifest.res$',
         \ '\.intermediate\.manifest$', '^mt.dep$', '^.OpenIDE$', '^.git$', '^TestResult.xml$', '^.paket$', '^paket.dependencies$','^paket.lock$', '^paket.template$', '^.agignore$', '^.AutoTest.config$',
         \ '^.gitignore$', '^.idea$' , '^tags$']

   let NERDTreeShowHidden=1
   let NERDTreeShowBookmarks=1

   " nnoremap <c-;><c-l> :NERDTreeTabsToggle<cr>
   nnoremap <c-;><c-l><c-l> :NERDTreeToggle<cr>
   nnoremap <c-;><c-l><c-d> :NERDTreeCWD<cr>
   nnoremap <c-;><c-l><c-f> :NERDTreeFind<cr>

   function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
     exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
     exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
   endfunction

   call NERDTreeHighlightFile('jade', 'green', 'none', 'green', 'none')
   call NERDTreeHighlightFile('md', 'blue', 'none', '#6699CC', 'none')
   call NERDTreeHighlightFile('config', 'yellow', 'none', '#d8a235', 'none')
   call NERDTreeHighlightFile('conf', 'yellow', 'none', '#d8a235', 'none')
   call NERDTreeHighlightFile('json', 'green', 'none', '#d8a235', 'none')
   call NERDTreeHighlightFile('html', 'yellow', 'none', '#d8a235', 'none')
   call NERDTreeHighlightFile('css', 'cyan', 'none', '#5486C0', 'none')
   call NERDTreeHighlightFile('scss', 'cyan', 'none', '#5486C0', 'none')
   call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', 'none')
   call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', 'none')
   call NERDTreeHighlightFile('ts', 'Blue', 'none', '#6699cc', 'none')
   call NERDTreeHighlightFile('ds_store', 'Gray', 'none', '#686868', 'none')
   call NERDTreeHighlightFile('gitconfig', 'black', 'none', '#686868', 'none')
   call NERDTreeHighlightFile('gitignore', 'Gray', 'none', '#7F7F7F', 'none')

 endif
 "}}}

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
      \   }
      \ }
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

 " vim-stay {{{

call PM('kopischke/vim-stay')

 "}}} _vim-stay

 " nvim-miniyank {{{

call PM('bfredl/nvim-miniyank', {'if': 'has("nvim")'})

 "}}} _nvim-miniyank

 " vim-pseudocl {{{

   call PM( 'junegunn/vim-pseudocl' ) "Required by oblique & fnr

 "}}} _vim-pseudocl

 " vim-oblique {{{
if PM( 'junegunn/vim-oblique', {'on_map': [ '<Plug>(Oblique-' ]} )

 let g:oblique#enable_cmap=0
 "let g:oblique#clear_highlight=0

 Map nx  #  <Plug>(Oblique-#)
 Map nx  *  <Plug>(Oblique-*)
 Map nox /  <Plug>(Oblique-/)
 Map nox ?  <Plug>(Oblique-?)
 Map n   g# <Plug>(Oblique-g#)
 Map n   g* <Plug>(Oblique-g*)
 Map nox z/ <Plug>(Oblique-F/)
 Map nox z? <Plug>(Oblique-F?)

 "Make n/N move forward/backwards regardless of search direction
 "Map nx  n  <Plug>(Oblique-n)
 "Map nx  N  <Plug>(Oblique-N)
 "noremap <expr> n 'Nn'[v:searchforward]
 "noremap <expr> N 'nN'[v:searchforward]
 nmap <expr>n ['<Plug>(Oblique-N)','<Plug>(Oblique-n)'][v:searchforward]
 nmap <expr>N ['<Plug>(Oblique-n)','<Plug>(Oblique-N)'][v:searchforward]

 autocmd! User Oblique       AnzuUpdateSearchStatusOutput
 autocmd! User ObliqueStar   AnzuUpdateSearchStatusOutput
 autocmd! User ObliqueRepeat AnzuUpdateSearchStatusOutput

 endif

 "}}}
 "scalpel {{{
  if PM('wincent/scalpel', {'on_cmd': ['Scalpel'], 'on_map': ['<Plug>(Scalpel)']})
   nmap  g;r <Plug>(Scalpel)
  endif
 "}}} _scalpel

 " vim-anzu {{{

 if PM( 'osyo-manga/vim-anzu', {'on_cmd': ['AnzuUpdateSearchStatusOutput']} )
  "Let anzu display numbers only. The search is already displayed by Oblique
  let g:anzu_status_format = ' (%i/%l)'
 endif

 "}}} _vim-anzu
 " vim-fuzzysearch {{{

  if PM( 'ggVGc/vim-fuzzysearch', {'on_cmd': ['FuzzySearch']} )
   nnoremap g\f :FuzzySearch<cr>
 endif

 "}}} _vim-fuzzysearch
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
 " vim-easymotion {{{

  if PM( 'Lokaltog/vim-easymotion', {'on_map': ['<Plug>(easymotion-']} )

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

   map <c-s>L    <Plug>(easymotion-eol-bd-jk)
   map <c-s>H    <Plug>(easymotion-sol-bd-jk)

   map <c-s>f    <Plug>(easymotion-overwin-f)
   map <c-s>;    <Plug>(easymotion-overwin-f2)
   map <c-s>w    <Plug>(easymotion-overwin-w)
   map <c-s>l    <Plug>(easymotion-overwin-line)

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
  nnoremap ]h :BufSurfForward<cr>
  nnoremap [h :BufSurfBack<cr>
  nnoremap coB :BufSurfList<cr>
endif

 "}}} _vim-bufsurf

 " vim_drawer {{{
  if PM('samuelsimoes/vim-drawer', {'on_cmd': ['VimDrawer']} )
   let g:vim_drawer_spaces = [
         \["model", "app"],
         \["controller", "Http\/Controllers"],
         \["view", "\.html\.erb$|\.blade\.php$"],
         \["asset", "\.[js|css]$"],
         \["term", "^term"]
         \]
   nnoremap <C-w><Space> :VimDrawer<CR>
 endif
 "}}} _vim-drawer
 " zoomwintab.vim {{{

 if PM( 'troydm/zoomwintab.vim', {'on_cmd': ['ZoomWinTabToggle']} )

   let g:zoomwintab_remap = 0
   " zoom with <META-O> in any mode
   nnoremap <silent> <c-w><c-o> :ZoomWinTabToggle<cr>
   inoremap <silent> <c-w><c-o> <c-\><c-n>:ZoomWinTabToggle<cr>a
   vnoremap <silent> <c-w><c-o> <c-\><c-n>:ZoomWinTabToggle<cr>gv
 endif

 "}}} _zoomwintab.vim

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
  if PM('hkupty/nvimux',
          \ {'on_event': 'VimEnter', 'on_if': 'has("nvim")'})
    let g:nvimux_prefix='<c-cr>'
    "call PM('hkupty/nvimux')
  endif
 "}}} _nvimux
 " neoterm {{{

if PM( 'kassio/neoterm',
       \ {
       \ 'on_func': [ 'neoterm#test#libs#add', 'neoterm#repl#set'],
       \ 'on_cmd':
       \   [
       \     'T',
       \     'Tnew',
       \     'Tmap',
       \     'Tpos',
       \     'TTestSetTerm',
       \     'TTestLib',
       \     'TTestClearStatus',
       \     'TREPLSetTerm',
       \     'REPLSend',
       \     'REPLSendFile',
       \     'Topen',
       \     'Tclose',
       \     'Ttoggle'
       \   ]
       \ }
       \)

   let g:neoterm_clear_cmd = "clear; printf '=%.0s' {1..80}; clear"
   let g:neoterm_position = 'vertical'
   let g:neoterm_automap_keys = '<leader>tt'

   nnoremap <silent> <f9> :call neoterm#repl#line()<cr>
   vnoremap <silent> <f9> :call neoterm#repl#selection()<cr>

   " " TODO fix these mappings were disabled find alternatives
   " " run set test lib
   " nnoremap <silent> <leader>rt :call neoterm#test#run('all')<cr>
   " nnoremap <silent> <leader>rf :call neoterm#test#run('file')<cr>
   " nnoremap <silent> <leader>rn :call neoterm#test#run('current')<cr>
   " nnoremap <silent> <leader>rr :call neoterm#test#rerun()<cr>

   " " Useful maps
   " " closes the all terminal buffers
   " nnoremap <silent> <leader>tc :call neoterm#close_all()<cr>
   " " clear terminal
   " nnoremap <silent> <leader>tl :call neoterm#clear()<cr>

 endif
 "}}} _neoterm

 "}}} _Navigation
 " ----------------------------------------------------------------------------
 " Folds {{{
 " ----------------------------------------------------------------------------

 " vim-foldfocus {{{

  if PM( 'vasconcelloslf/vim-foldfocus', {'on_func': ['FoldFocus']} )
   nnoremap <leader>z<cr> :call FoldFocus('vnew')<CR>
   nnoremap <leader>zz<cr>  :call FoldFocus('e')<CR>
 endif

 "}}}} _vim-foldfocus

 " searchfold.vim {{{

  if PM( 'khalidchawtany/searchfold.vim' , {'on_map':  ['<Plug>SearchFold']} )

   " Search and THEN Fold the search term containig lines using <leader>z
   " or the the inverse using <leader>iz or restore original fold using <leader>Z
   nmap <Leader>zs   <Plug>SearchFoldNormal
   nmap <Leader>zi   <Plug>SearchFoldInverse
   nmap <Leader>ze   <Plug>SearchFoldRestore
   nmap <Leader>zw   <Plug>SearchFoldCurrentWord
 endif

 "}}} _searchfold.vim

 "}}}
 " ----------------------------------------------------------------------------
 "Database {{{
 " ----------------------------------------------------------------------------

 " dbext.vim {{{

 if PM( 'vim-scripts/dbext.vim' )
   let g:dbext_default_profile_mysql_local = 'type=MYSQL:user=root:passwd=root:dbname=younesdb:extra=-t'
 endif

 "}}} _dbext.vim

 " pipe-mysql.vim {{{
   call PM( 'NLKNguyen/pipe-mysql.vim' )
 "}}} _pipe-mysql.vim

 "}}}
 " ----------------------------------------------------------------------------
 " neovim-qt {{{
 " ----------------------------------------------------------------------------
   call PM( 'equalsraf/neovim-gui-shim' )
 " }}}
 " ----------------------------------------------------------------------------
 " gonvim {{{
 " ----------------------------------------------------------------------------
 call PM('dzhou121/neovim-fzf-shim')
 "}}} _gonvim
 " ----------------------------------------------------------------------------
 " Nyaovim {{{
 " ----------------------------------------------------------------------------
 if exists('g:nyaovim_version')
   call PM( 'rhysd/nyaovim-popup-tooltip' )
   call PM( 'rhysd/nyaovim-mini-browser' )
   call PM( 'rhysd/nyaovim-markdown-preview' )
 endif
"}}}
 " ----------------------------------------------------------------------------
 " Themeing {{{
 " ----------------------------------------------------------------------------

 " vim-startify {{{
 if PM( 'mhinz/vim-startify' )
   let g:startify_disable_at_vimenter = 0
   nnoremap <F1> :Startify<cr>
   let g:startify_list_order = ['files', 'dir', 'bookmarks', 'sessions']
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

 " vim-css-color {{{

   if PM( 'ap/vim-css-color', { 'on_ft':['css','scss','sass','less','styl']} )
     "au BufWinEnter *.vim call css_color#init('hex', '', 'vimHiGuiRgb,vimComment,vimLineComment,vimString')
     "au BufWinEnter *.blade.php call css_color#init('css', 'extended', 'htmlString,htmlCommentPart,phpStringSingle')
   endif

 "}}} _vim-css-color
 "vim-stylus {{{
  "call PM('wavded/vim-stylus', {'on_ft': 'stylus'})
  if PM('wavded/vim-stylus')
    autocmd BufNewFile,BufRead *.styl setlocal filetype=stylus
  endif
 "}}}_vim-stylus
 " vim-better-whitespace {{{

 if PM( 'ntpeters/vim-better-whitespace' )
   let g:better_whitespace_filetypes_blacklist=['diff', 'nofile', 'qf', 'gitcommit', 'unite', 'vimfiler', 'help', 'leaderGuide']
   autocmd FileType unite DisableWhitespace
   autocmd FileType vimfiler DisableWhitespace
 endif

 "}}}

 " vim-noscrollbar {{{

 call PM('gcavallanti/vim-noscrollbar')

 "}}} _vim-noscrollbar
 " vim-indentLine {{{

 if PM( 'Yggdroot/indentLine', {'lazy': 1} )
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

 call PM( 'ryanoasis/vim-devicons' )
 call PM( 'reedes/vim-thematic' )

 "Golden Ratio
 " golden-ratio {{{

 if PM( 'roman/golden-ratio' )
   nnoremap cog :<c-u>GoldenRatioToggle<cr>
 endif

 "}}} _golden-ratio
 " visual-split.vim {{{

   call PM( 'wellle/visual-split.vim' ) ", {'on': ['VSResize', 'VSSplit', 'VSSplitAbove', 'VSSplitBelow']}

 "}}} _visual-split.vim

 if PM('xolox/vim-colorscheme-switcher')
   call PM('xolox/vim-misc')
   nnoremap c]c :<c-u>NextColorScheme<cr>
   nnoremap c[c :<c-u>PrevColorScheme<cr>
   nnoremap c\c :<c-u>RandomColorScheme<cr>
 endif

 "colorschemes
   call PM('kristijanhusak/vim-hybrid-material')
   call PM('jdkanani/vim-material-theme')
   call PM('khalidchawtany/vim-materialtheme')
   call PM('gkjgh/cobalt')
   call PM('ajmwagar/vim-dues')
   call PM('rakr/vim-one')
   call PM('kudabux/vim-srcery-drk')
   call PM('1995parham/tomorrow-night-vim')
   call PM('prognostic/plasticine')
   call PM('sjl/badwolf')
   call PM('jakwings/vim-colors')
   call PM('vim-scripts/Shades-of-Amber')
   call PM('preocanin/greenwint')
   call PM('lu-ren/SerialExperimentsLain')
   call PM('aunsira/macvim-light')
   call PM('NewProggie/NewProggie-Color-Scheme')
   call PM('LanFly/vim-colors')
   call PM('nightsense/seabird')
   call PM('ayu-theme/ayu-vim')
   call PM('lifepillar/vim-wwdc17-theme')
   call PM('sonobre/briofita_vim')
   call PM('jakwings/vim-colors')
   call PM('dim13/xedit.vim')
   call PM('aunsira/macvim-light')
 "}}}
 " ----------------------------------------------------------------------------
 " Presenters :) {{{
 " ----------------------------------------------------------------------------

 " vim-leader-guide {{{
    if PM('hecal3/vim-leader-guide') 

      nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
      vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>

      let g:leaderGuide_max_size = 10
      let g:leaderGuide_submode_mappings = { '<C-C>': 'win_close', '<C-F>': 'page_down', '<C-B>': 'page_up'}
      au FileType leaderGuide set norelativenumber

      "let g:leaderGuide_run_map_on_popup = 0
      let g:leaderGuide_flatten=0

      let g:lmap =  {}
      let g:lmap.a   = { 'name' : 'Tabularize' }
      let g:lmap.e   = { 'name' : 'Edit' }
      let g:lmap.g   = { 'name' : 'Git' }
      let g:lmap.h   = { 'name' : 'Help' }
      let g:lmap.g.d = { 'name' : 'Diff' }
      let g:lmap.s   = { 'name' : 'Search' }
      let g:lmap.f   = { 'name' : 'File' }
      let g:lmap.o   = { 'name' : 'Open' }
      let g:lmap.t   = { 'name' : 'Tab' }
      let g:lmap.q   = { 'name' : 'Quit' }
      let g:lmap.r   = { 'name' : 'Replace' }
      let g:lmap.w   = { 'name' : 'Write' }

      let g:leaderGuide_sort_horizontal=1

      " If you use NERDCommenter:
      let g:lmap.c = { 'name' : 'Comments' }
      " Define some descriptions
      let g:lmap.c.c = ['call feedkeys("\<Plug>NERDCommenterComment")','Comment']
      let g:lmap.c[' '] = ['call feedkeys("\<Plug>NERDCommenterToggle")','Toggle']
      " The Descriptions for other mappings defined by NerdCommenter, will default
      " to their respective commands.

      function! s:my_displayfunc()
        let g:leaderGuide#displayname =
              \ substitute(g:leaderGuide#displayname, '\c<cr>$', '', '')
        let g:leaderGuide#displayname =
              \ substitute(g:leaderGuide#displayname, '^<Plug>', '', '')
        let g:leaderGuide#displayname =
              \ substitute(g:leaderGuide#displayname, '^<SID>', '', '')
      endfunction
      let g:leaderGuide_displayfunc = [function("s:my_displayfunc")]

      call leaderGuide#register_prefix_descriptions("<Space>", "g:lmap")
    endif
 " _vim-leader-guide }}}

 "}}}
 " ----------------------------------------------------------------------------




"call function(string(PM).'End')
call PM_END()
