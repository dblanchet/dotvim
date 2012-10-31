setlocal omnifunc=gocomplete#Complete

set makeprg=go\ build
set errorformat=%f:%l:%m
set tabstop=4

" Open quickfix window if an error is found.
function  DisplayQfWin()
  if len(getqflist()) > 0
    copen
  else
    cclose
  endif
endfunction
au QuickFixCmdPost make call DisplayQfWin()

