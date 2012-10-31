" Fichier d'indentation Vim
" Fichiers              :  Relectures de la doc (*.rq)
" Responsable		:  Fabien Vayssière <fabien.vayssiere@laposte.net>
" Dernière modification :  22 oct 2003


" Ne charge ce fichier que si aucun autre fichier d'indentation ne l'a été.
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

" Options locales.
setlocal indentexpr=GetRqIndent(v:lnum)

" Fonction d'indentation principale.
" Indente d'une tabulation après une ligne « Réponse », ou comme la ligne
" précédente sinon.
function! GetRqIndent(nol)
    if (getline(a:nol - 1) =~ '^Réponse .*$\c')
	return getbufvar("%", "&ts")
    else
	return indent(a:nol - 1)
    endif
endfunction

" vim:tw=78:ts=8:sts=4:fo=croq:
