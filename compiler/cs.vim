" " Vim compiler file
" " Compiler:	Microsoft Visual Studio C#
" " Maintainer:	Zhou YiChao (broken.zhou@gmail.com)
" " Previous Maintainer:	Joseph H. Yao (hyao@sina.com)
" " Last Change:	2012 Apr 30

" if exists("current_compiler")
  " finish
" endif
" let current_compiler = "cs"
" let s:keepcpo= &cpo
" set cpo&vim

" if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  " command -nargs=* CompilerSet setlocal <args>
" endif

" CompilerSet errorformat&
" CompilerSet errorformat+=%f(%l\\,%v):\ %t%*[^:]:\ %m,
            " \%trror%*[^:]:\ %m,
            " \%tarning%*[^:]:\ %m

" CompilerSet makeprg=csc\ %

" let &cpo = s:keepcpo
" unlet s:keepcpo


let current_compiler = "xbuild"
let s:keepcpo= &cpo
set cpo&vim

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet errorformat=\ %#%f(%l\\\,%c):\ %m
" CompilerSet makeprg=xbuild\ /nologo\ /v:q\ /property:GenerateFullPaths=true
CompilerSet makeprg=make

let &cpo = s:keepcpo
unlet s:keepcpo


" errorformat=%*[^"]"%f"%*\D%l: %m,"%f"%*\D%l: %m,%-G%f:%l: (Each undeclared identifier is reported only once,%-G%f:%l: for each function it appears in.),%-GIn file included from %f:%l:%c:,%-GIn file included from %f:%l:%c\,,%-GIn file included from %f:%l:%c,%-GIn file included from %f:%l,%-G%*[ ]from %f:%l:%c,%-G%*[ ]from %f:%l:,%-G%*[ ]from %f:%l\,,%-G%*[ ]from %f:%l,%f:%l:%c:%m,%f(%l):%m,%f:%l:%m,"%f"\, line %l%*\D%c%*[^ ] %m,%D%*\a[%*\d]: Entering directory %*[`']%f',%X%*\a[%*\d]: Leaving directory %*[`']%f',%D%*\a: Entering directory %*[`']%f',%X%*\a: Leaving directory %*[`']%f',%DMaking %*\a in %f,%f|%l| %m
