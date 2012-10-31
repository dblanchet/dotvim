" Fichier de syntaxe Vim
" Fichiers              :  Relectures de la doc (*.rq)
" Responsable		:  Fabien Vayssière <fabien.vayssiere@laposte.net>
" Dernière modification :  08 oct 2003

" Efface la syntaxe existante.
if version >= 600
    if exists("b:current_syntax")
	finish
    endif
else
    syntax clear
endif

" Ignore la casse.
syn case ignore


" Définit les groupes de syntaxe.
syn match rqErreur	  "\%(.\n\)\@<=\%(\s\+\n\)\+\%(ligne :\)\@="

syn match rqCommentaire	  "^#.*$"
syn match rqCommentaire   "^fichier :.*"

syn match rqRelecture	  "^ligne :.*"he=s+7 contains=rqNoLigne
syn match rqRelecture	  "^remarque :"
syn match rqRelecture	  "^-.*$"he=s+1
syn match rqRelecture	  "^+.*$"he=s+1
syn match rqRelecture	  "^statut :.*"he=s+8 contains=rqATraiter

syn match rqNormal	  "\<ligne\s[^:]"me=e-1 nextgroup=rqNoLigne
syn match rqNormal	  "\<l\.\s" nextgroup=rqNoLigne

syn match rqNoLigne	  "\d\+\%(-\d\+\)\=" contained

syn match rqReponse	  "^réponse .\{-}:"

syn keyword rqATraiter	  souffrance contained

" Définit la coloration par défaut.
if version >= 508 || !exists("did_rq_syntax_inits")
    if version < 508
	let did_rq_syntax_inits = 1
	command -nargs=+ HiLink hi link <args>
    else
	command -nargs=+ HiLink hi def link <args>
    endif

    HiLink rqErreur	    Error
    HiLink rqCommentaire    Comment
    HiLink rqRelecture	    Statement
    HiLink rqReponse	    Special
    HiLink rqNoLigne	    Number
    HiLink rqATraiter	    Todo

    delcommand HiLink
endif

let b:current_syntax = "rq"
" vim:tw=78:ts=8:sts=4:fo=croq:
