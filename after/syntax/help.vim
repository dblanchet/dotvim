" Ce fichier contient les �l�ments de syntaxe destin�s � s'ajouter � ceux d�j�
" existants pour supporter les modifications effectu�es par la traduction des
" fichiers d'aide de Vim.
" Pour l'utiliser, il vous suffit de le d�poser tel quel dans votre r�pertoire
" "~/.vim/after/syntax" (adaptez ce chemin selon votre plate-forme).
"
" Responsable		:  Fabien Vayssi�re <fabien.vayssiere@laposte.net>
" Derni�re modification :  17 f�v 2004
"

" � ajouter �ventuellement � la syntaxe globale (TODO contacter Bram)
syn match helpSpecial	    "\sN\."me=e-1 " N at end of sentence
syn match helpSpecial	    "\[+cmd]"
syn match helpSpecial	    "\[++opt]"
syn match helpSpecial	    "\[arg]"
syn match helpSpecial	    "\[arguments]"
syn match helpSpecial	    "\[ident]"
syn match helpSpecial	    "\[addr]"
syn match helpSpecial	    "\[group]"
syn match helpSpecial	    "{[-a-zA-Z0-9'"*+/:%#=[\]<>.,]\+}" " add * + /
syn match helpNormal	    ":|vim:|" " wrong highlight at section |modeline|

" �l�ments traduits
syn keyword helpNote	    NOTES
syn match helpVim	    "MANUEL d.*"
syn match helpSpecial	    "N-i"me=e-2
syn match helpNormal	    "N'[^t]"
syn match helpNormal	    "N�" " Ajout� pour � N�anmoins � : portabilit� ?
syn match helpNormal	    "N\.D"
syn match helpSpecial	    "\[plage]"
syn match helpSpecial	    "\[fichier]"
syn match helpSpecial	    "\[ligne]"
syn match helpSpecial	    "\[quant]"
syn match helpSpecial	    "\[pos]"
syn match helpSpecial	    "\[no]"
syn match helpSpecial	    "\[nb]"
syn match helpSpecial	    "\[+nb]"
syn match helpSpecial	    "\[-nb]"
syn match helpSpecial	    "\[a]"
syn match helpSpecial	    "\[adr]"
syn match helpSpecial	    "\[+nol]"
syn match helpSpecial	    "\[groupe]"
syn match helpSpecial	    "\[decal]"
syn match helpSpecial	    "\[texte]"
syn match helpSpecial	    "\[blanc]"
syn match helpSpecial       "CTRL-Attn"
syn match helpSpecial       "CTRL-PagePrec"
syn match helpSpecial       "CTRL-PageSuiv"
syn match helpSpecial       "CTRL-Inser"
syn match helpSpecial       "CTRL-Suppr"
syn match helpSpecial	    "CTRL-{car}"
syn region helpNotVi	    start="{Vi" start="{absent" start="{uniquement" end="}" contains=helpLeadBlank,helpHyperTextJump

" Ce qui suit n'int�resse que les traducteurs
syn keyword helpXXX	    XXX

hi link	helpXXX		    Todo

" vim:ts=8:sw=2:fo=tcq:tw=78:
