
" Use smaller font while diffing,
" so all files fit in screen.
let in_diff_mode = 0
windo let in_diff_mode = in_diff_mode + &l:diff
if in_diff_mode > 0
  if has("win32")
    set guifont=Consolas:h9:cANSI
  elseif has("mac")
    set guifont=Consolas:h16 " Big, nice Mac screens...
  endif
else
  if has("win32")
    set guifont=:h18
  elseif has("mac")
    set guifont=Consolas:h20
  endif
endif
unlet in_diff_mode

" Nice with Morning colorscheme.
highlight LineNr guibg=grey80

