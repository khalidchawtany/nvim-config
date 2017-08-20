"  return "1"   => Indicates that thisline line has a foldlevel of ONE
"  return ">1"  => Indicates that thisline line starts a foldlevel of ONE
"  return "="   => Indicates that thisline line is same as above foldlevel
"  One could use the following to have nested folds
"
"                    if match(thisline, "^##") >= 0
"                      return ">2"
"                    elseif match(thisline, "^#") >= 0
"                      return ">1"
"                    else
"                      return "="
"                    endif

function! MarkdownFolds()
  let thisline  = getline(v:lnum)
  if match(thisline, "^#") >= 0
    return ">1"
  else
    return "="
  endif
endfunction

setlocal foldmethod=expr
setlocal foldexpr=MarkdownFolds()


function! MarkdownFoldText()
  let foldsize = (v:foldend - v:foldstart)
  return getline(v:foldstart) . '(' . foldsize  . 'lines )'
endfunction
setlocal foldtext=MarkdownFoldText()
