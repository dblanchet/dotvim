" Vim filetype plugin file
" Language:	Vim on-line documentation
" Maintainer:	Fabien Vayssie`re <fabien.vayssiere@laposte.net>
" Last Change:	2004 Jan 02

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

" Don't load another plugin for this buffer
let b:did_ftplugin = 1


" Mappings
map <buffer><silent> <Tab>   :call JumpToLink("W")<CR>
map <buffer><silent> <S-Tab> :call JumpToLink("Wb")<CR>
map <buffer>	     <C-Tab> <S-Tab>
map <buffer>	     <CR>    <C-]>

function! JumpToLink(flags)
  " The pattern for a link is different whether the system uses EBCDIC or not
  if has("ebcdic")
    let linkpat = '\\\@<!|[^"*|]\+|'
  else
    let linkpat = '\\\@<!|[#-)!+-~]\+|'
  endif
  " Search the link
  if search(linkpat, a:flags)
    normal l
    return
  endif
  " Display a message if not found
  if a:flags !~ "b"
    echo "No next link"
  else
    echo "No previous link"
  endif
endfunction

" vim:tw=78:ts=8:sts=2:sw=2:fo=croq:
