" Fichier d'indentation Vim
" Fichiers              :  Relectures de la doc (*.rq)
" Responsable		:  Fabien Vayssi�re <fabien.vayssiere@laposte.net>
" Derni�re modification :  22 oct 2003


" Ne charge ce fichier que si aucun autre fichier d'indentation ne l'a �t�.
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

" Options locales.
setlocal indentexpr=GetRqIndent(v:lnum)

" Fonction d'indentation principale.
" Indente d'une tabulation apr�s une ligne � R�ponse �, ou comme la ligne
" pr�c�dente sinon.
function! GetRqIndent(nol)
    if (getline(a:nol - 1) =~ '^R�ponse .*$\c')
	return getbufvar("%", "&ts")
    else
	return indent(a:nol - 1)
    endif
endfunction

" vim:tw=78:ts=8:sts=4:fo=croq:
