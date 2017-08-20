if &compatible
  set nocompatible               " Be iMproved
endif

set runtimepath^=/Volumes/Home/.config/nvim/dein/repos/github.com/Shougo/dein.vim
call dein#begin(expand('/Volumes/Home/.config/nvim/dein'))

call dein#add('Shougo/dein.vim')
call dein#add( 'kopischke/vim-fetch' )

call dein#end()
filetype plugin indent on
