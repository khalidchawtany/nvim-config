function! s:JobHandler(job_id, data, event)
  if a:event == 'stdout'

    " let qflist = getqflist()
    let qflist = []
    let errors_qflist = []
    let warnings_qflist = []
    let tests_qflist = []

    for item in a:data

      if item != ""

        execute "let dictionary_item = " . item
        let item_text = dictionary_item["text"]

        "Popultae errors_qflist
        if stridx(item_text, "Error:") == 0
          execute "call add(errors_qflist, " item ")"

        "Popultae warnings_qflist
        elseif stridx(item_text, "Warning:") == 0
          execute "call add(warnings_qflist, " item ")"

        "Popultae tests_qflist
        else
          execute "call add(tests_qflist, " item ")"
        endif

      endif

    endfor

    let warning_count  = len(warnings_qflist)
    if len(errors_qflist) > 0 || len(tests_qflist) > 2
      copen
    else
      echomsg "... " . warning_count . "   warnings."
      let notifymsg = "No warnings"
      if warning_count > 1
        let notifymsg = warning_count . " warnings"
      endif
      call system('growlnotify -t "C# Built" -n "NeoVim" -N "CS Build" -m "' . warning_count . ' warnings." -a Neovim')
    endif

    if warning_count > 0
      let warnings_qflist_seperator = [
            \{"text":""},
            \{"text":"================================================="}]
      let warnings_qflist = warnings_qflist_seperator + warnings_qflist

    endif

    "Combine all qflist items in a away that errors shown first then test
    "results later warnings
    let qflist = errors_qflist + tests_qflist + warnings_qflist
    call setqflist(qflist)
    " call append(line('$'), str)
  elseif a:event == 'stderr'
    " let str = self.shell.' stderr: '.join(a:data)
  else
    " let str = self.shell.' exited'
  endif

endfunction
let s:callbacks = {
      \ 'on_stdout': function('s:JobHandler'),
      \ 'on_stderr': function('s:JobHandler'),
      \ 'on_exit': function('s:JobHandler')
      \ }

command! BuildCSharpSolution cclose | call jobstart(['bash', '-c', 'make | gawk -f ~/dotfiles/nvim/test_make.awk'], extend({'shell': 'shell 1'}, s:callbacks))


