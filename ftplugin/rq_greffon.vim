" Greffon de type de fichier Vim
" Fichiers              :  Relectures de la doc (*.rq*)
" Créateur              :  Fabien Vayssière <fabienDOTvayssiereATlaposteDOTnet>
" Responsable actuel    :  David Blanchet <david DOT blanchet AT free DOT fr>
" Dernière modification :  10 avr 2005
" URL                   :  http://david.blanchet.free.fr/vim/rq.vim


" Installation du greffon
" -----------------------
"  
" 1. Ajoutez les lignes suivantes à votre fichier vimrc (sans le '"' au début
" de la ligne) et METTEZ-LES À JOUR :
"
"           let Rq_Auteur = "Votre Nom <VotreAdresse@Electronique>" 
"           let Rq_Initiales = "VosInitiales" 
"           
" Par exemple :
" 
" let Rq_Auteur = "David Blanchet <david DOT blanchet AT free DOT fr>" 
" let Rq_Initiales = "DB" 
"
" NOTE : Si vous omettez cette étape, ces informations vous serons demandées à
" chaque ouverture de fichier de remarques.
"
" 2. Ajoutez ces lignes dans votre fichier ~/.vim/filetype.vim (sans le '"' au
" début de la ligne) :
" 
"   if has("autocmd")
"       augroup filetypedetect
"       au BufRead,BufNewfile *.rq* setf rq
"       au BufNewfile *.rq* if exists("*CreerEntete")|call CreerEntete()|endif
"       augroup END
"   endif
"
" 3. Vous pouvez également (mais ce n'est pas obligatoire) ajouter un mappage
" pour simplifier l'ouverture des fichiers de remarques. Pour cela, ajoutez
" cette ligne dans votre vimrc :
"
"           nmap <F2> :split %.rq<CR>
"
" Vous pouvez remplacer "<F2>" par la touche qui vous convient.


" Mappages
" --------
"  
" - globaux :
"              ,n      Saute à l'emplacement de la remarque suivante
"              ,p      Saute à l'emplacement de la remarque précedente
"              ,f      Saute à l'emplacement de la première remarque
"              ,l      Saute à l'emplacement de la dernière remarque
"              ,N      Comme ",n", pour une remarque à traiter
"              ,P      Comme ",p", pour une remarque à traiter
"              ,F      Comme ",f", pour une remarque à traiter
"              ,L      Comme ",l", pour une remarque à traiter
"              ,a      Ajoute une réponse à une remarque
"              ,x      Reporte le texte proposé dans le fichier relu
" - pour le fichier de remarques uniquement :
"              ,s      Saute à la ligne concernée par la remarque courante
"              ,j      Saute à la prochaine réponse courante du correspondant
"              ,k      Saute à la précédente réponse courante du correspondant
"              ,g      Insère des statistiques à propos des remarques
"              ,e      Crée l'en-tête du fichier de remarques 
"              ,R      Ajoute une remarque vide
"              ,w      Enregistre sans mise à jour des en-têtes
" - pour le fichier relu uniquement :
"              ,s      Retourne dans le fichier de remarques
"              ,r      Ajoute une remarque à propos de la ligne courante
"
" Pour un détail des mappages inclus ainsi qu'une explication du format
" retenu pour le fichier de remarques, faire ":help relecture". Se reporter au
" fichier rq.txt en cas de problème.


" Changements {{{1
" -----------
"
" 24 fév 2003 (FV) :
"   - Création du script.
"
" 26 fév 2003 (FV) :
"   - Ajout de la prise en compte du décalage potentiel entre la ligne indiquée
"     dans la remarque et le fichier en cours de modification.
"
" 27 fév 2003 (DB) :
"   - Ajout des fonctions « suivante », « précédente » et d'insertion des
"     remarques
"
" 05 mar 2003 (DB) :
"   - Intégration des mappages de FV
"   - Ajout des mappages pour passer d'une remarque à une autre en restant dans
"     le fichier en cours de relecture/modification.
"
" 12 mar 2003 (FV) :
"   - Ajout de routines diverses.
"   - Modification de InsererRemarque(), afin que les remarques soient
"     insérées au « bon endroit » dans le fichier de remarques.
"
" 13 mar 2003 (DB) :
"   - Ajout des fonctions AllerARelu() et AllerARemarques().
"     Mise à jour des autres fonctions et mappages en conséquence.
"   - Ajout des replis.
"
" 15 mar 2003 (DB) :
"   - Mise à jour des différentes fonctions avec les solutions de FV et DB.
"
" 19 mar 2003 (DB) :
"   - Petites retouches de confort.
"
" 23 mar 2003 (FV) :
"   - Ajout de fonctions de navigation pour les remarques à traiter (c.-à-d.
"     statut « en souffrance » ou vide) : ,N ,P ,F ,L.
"   - Redéfinition de la gestion du décalage de ligne (par ligne de contexte).
"   - Nettoyage superficiel (fonctions créées pour les mappages recherchant
"     une chaîne, avec gestion de messages ; mappages ajoutés afin de rendre
"     l'ensemble plus homogène ; définitions de fonctions forcées par '!').
"
" 06 avr 2003 (FV, intégré par DB) :
"   - Ajout des mappages ,a amélioré (détermine l'entête approprié) et de ,A
"     pour sauter à la réponse suivante du correspondant.
"   - Correction de bugs mineurs et autres effets de bords.
"
" 09 avr 2003 (FV) :
"   - Rajout du mécanisme de mise à jour des en-têtes par autocommande.
"   - Amélioration de la recherche des contextes.
"   - Corrections et ajustements mineurs (mappage <F4> supprimé ; portée des
"     variables revue ; orthographe).
"
" 26 avr 2003 (FV) :
"   - Support d'une coloration limitée pour indiquer le contexte actuel.
"   - Contrôle du décalage « contextuel » (dépend du nb. de lignes du fichier).
"   - Additif pour les tabulations écrasées dans les lignes de contexte.
"
" 27 mai 2003 (DB) :
"   - Modifications mineures (exprat et messages du greffon).
"   - Ajout de la création de l'en-tête.
"
" 01 jun 2003 (FV) :
"   - Correction de bogues (placements défectueux avec ,p, ,P et ,l, boucle
"     sans fin en l'absence de remarques, problèmes de compatibilité Vi).
"   - Ajout autocommande pour les statistiques.
"   - Ajustements mineurs (pour la création d'en-tête, les statistiques, la
"     robustesse des sauts, la « silenciosité »).
"
" 04 jun 2003 (DB) :
"   - Ajustements mineurs (fonctions de saut et commentaires notamment).
"   - Mise à jour de la documentation. 

" 11 jun 2003 (FV) :
"   - Modifs de confort (stats), corrections (recherche de contexte) et
"     amélioration de la validation du format des remarques.
"
" 12 jun 2003 (DB) :
"   - Appel de la fonction ExtraireChainesReponses() sur l'événement
"     BufWinEnter pour que les variables utilisées dans les en-têtes soient
"     correctement initialisées à chaque fichier de remarques.
"   - Ajout et mise en oeuvre de la fonction VerifierIdentification().
"
" 01 jui 2003 (DB) :
"   - Ajout de la section "Installation" dans la documentation et au début du
"     greffon.
"   - Modification de la prise en charge des informations sur l'utilisateur
"     (ajout des variables globales Rq_Auteur et Rq_Initiales).
"
" 29 jui 2003 (DB) :
"   - Correction de la documentation et retouches mineures du greffon.
"
" 04 oct 2003 (FV) :
"   - Correction de la documentation (DB). 
"   - fonction InsererStat() : conditionnelle ajoutée pour tester si le tampon
"     a été modifié (permet à ",w" de fonctionner normalement).
"   - fonction SauterRemarque() : positionnement de marques pour éviter un
"     bogue de mauvais placement en cas de remarques longues ; modification
"     de la prise en compte du décalage.
"   - mappages : ajout de ",S", synonyme de ",s" (pour Verr Maj).
"   - finalisation du script : rajout de "b:undo_ftplugin", nouveauté 6.2.
"
" 15 jui 2004 (DB) :
"   - Extension de la numérotation des remarques (après "quater").
"   - Corrections mineures (variables, orthographe des commentaires, ...)
"   - Ajout du comptage des dernières réponses du correspondant dans les
"     statistiques.
"   - Ajustements mineurs dans la documentation.
"
" 29 déc 2004 (DB) :
"   - Retouche sur la finalisation du script (ajout de '!', la non existance
"     de certaines variables provoquait des messages d'erreur à l'ouverture
"     des fichiers de remarques).
"   - Ajout (en commentaire) du code pour remplacer les bis/ter/etc. par des
"     nombres. Rechercher PROTO pour trouver le code à modifier. Tests
"     nécessaires.
"   - Corrections mineures dans la documentation.
"
" 05 fév 2005 (DB) :
"   - Ajout du mappage ",a" depuis le fichier relu. 
"   - Ajout de la fonction EchangerTexte, pour remplacer les lignes du fichier
"     relu par la proposition du relecteur.
"   - Mappages ",x" appelant EchangerTexte depuis n'importe où.
"   - Mise à jour de la doc.
"
" 10 avr 2005 (DB) :
"   - Problème : le comptage des remarques du correspondant ne fonctionnait
"     que si les messages Vim était en français.
"     Solution : baser le comptage sur des éléments indépendants.
"     Fonction : InsererStat()
"
" TODO {{{1
" Bogues :
"   - Le tampon relu n'est plus reconnu si l'aide pour le fichier original
"     concerné a été invoquée puis fermée.
"     Cause : vient du fait que Vim ne sait gérer qu'une seule fenêtre
"     d'aide, et que si deux sont ouvertes manuellement portant le même nom de
"     fichier, il n'y en a qu'une qui est indiquée dans la liste des tampons.
" Autres idées : 
"   - Remplacer bis/ter/cie par des nombres, plus facilement gérables,
"     traduisibles, etc. Fonction à l'état de proto. Compatibilité descendante
"     OK : les anciens fichiers de remarques sont bien lus par le greffon
"     nouveau. Problème de compatibilité ascendante : les nouveaux fichiers ne
"     sont pas bien lu par les greffons anciens. Rupture incontournable ?
"   - Améliorer la fonction RechercherContexte().
"   - Les marques 'c et 'h sont positionnées par le greffon ; cela peut avoir
"     des effets de bords si elles sont aussi utilisées par l'utilisateur.
"     Comment faire ?
"   - Baser le passage du fichier de remarques au fichier relu et inversement
"     sur des critères plus fiables que le nom des fichiers.
"   - Ajouter des fonctionnalités pour faciliter la lecture parallèle de la
"     version originale et de sa traduction. Pistes : scrollbind, convention
"     de noms de fichiers.
"   - Initialiser la variable s:decal pour ",f" ? Pb : Les variables de
"     scripts ne sont pas utilisables dans les mappages. Utiliser une variable
"     globale ("g:").
"   - Traduire et mettre en ligne sur http://vim.sf.net ?
"
" }}}


" Implantation :

" Initialisation et configuration {{{1
" Quitter si greffon déjà chargé pour le tampon courant.
if (exists("b:did_ftplugin"))
    finish
endif
let b:did_ftplugin = 1

if !exists('Rq_Auteur')
    let Rq_Auteur = "<Votre adresse électronique ici>"
endif
if !exists('Rq_Initiales')
    let Rq_Initiales = "<Vos initiales ici>"
endif

" Travailler sans compatibilité Vi.
let s:cpo_sauv = &cpo
set cpo&vim

" Variables et options locales.
let s:decal = 0
let s:msg = ""
let b:mon_changedtick = b:changedtick
setlocal comments=b:#,:-,:+
setlocal fo=tcroql

" Syntaxe mise en oeuvre dans ce script-même.
" (Utilisez Statement ou Normal au lieu de Search
" si vous ne souhaitez pas de surbrillance).
hi def link rqLigneContexte Search

" Autocommandes
au BufWinEnter  *.rq* call ExtraireChainesReponses() 
au BufWritePre  *.rq* silent exe "call InsererStat()"
au BufWritePre  *.rq* call MettreAJourDate()
au BufWritePost *.rq* let b:mon_changedtick = b:changedtick
" }}}

" Mappages {{{1
" Consulter l'en-tête de ce fichier pour connaître leur effet.

" Pour le fichier de remarques :
map <buffer><silent> ,s :call SauterRemarque()<CR>
map <buffer> ,S ,s
map <buffer><silent> ,n :call RemarqueSuivante()<CR>,s
map <buffer><silent> ,p :call RemarquePrecedente()<CR>,s
map <buffer><silent> ,f gg:call RemarqueSuivante()<CR>,s
map <buffer><silent> ,l G:call RemarquePrecedente()<CR>,s
map <buffer><silent> ,N :call SauterRemarqueATraiterSuivante()<CR>
map <buffer><silent> ,P :call SauterRemarqueATraiterPrecedente()<CR>
map <buffer><silent> ,F gg:call SauterRemarqueATraiterSuivante()<CR>
map <buffer><silent> ,L G:call SauterRemarqueATraiterPrecedente()<CR>
map <buffer><silent> ,j :call ReponseSuivante()<CR>
map <buffer><silent> ,k :call ReponsePrecedente()<CR>
map <buffer><silent> ,e :call CreerEntete()<CR>
map <buffer><silent> ,g :call InsererStat()<CR>
map <buffer> ,a k}k:call append(".", b:entete_prochain . " : ")<CR>jA
map <buffer> ,R oLigne : <CR>Remarque : <CR>-<CR><BS>+<CR><BS>Statut : <CR><Esc>5kA
map <buffer> ,w :let b:mon_changedtick = b:changedtick<CR>:write<CR>
map <buffer> ,r <Nop>
map <buffer> ,x :call EchangerTexte()<CR>

" Pour le fichier relu :
map <silent> ,r :call InsererRemarque()<CR>
map <silent> ,n :call AllerARemarques("normal ,n")<CR>
map <silent> ,p :call AllerARemarques("normal ,p")<CR>
map <silent> ,f :call AllerARemarques("normal ,f")<CR>
map <silent> ,l :call AllerARemarques("normal ,l")<CR>
map <silent> ,N :call AllerARemarques("normal ,N")<CR>
map <silent> ,P :call AllerARemarques("normal ,P")<CR>
map <silent> ,F :call AllerARemarques("normal ,F")<CR>
map <silent> ,L :call AllerARemarques("normal ,L")<CR>
map <silent> ,s :call AllerARemarques()<CR>:call search("^statut\\s*:\\c", "W")<CR>
map ,S ,s
map <silent> ,a :call AllerARemarques("normal ,a")<CR>
map <silent> ,x :call AllerARemarques("normal ,x")<CR>
" }}}

function! VerifierIdentification () "{{{1
" Vérifie si l'utilisateur du greffon a
" donné ses coordonnées. Les lui demande
" si besoin.
    if (g:Rq_Auteur =~ '^<Votre')
        let reponse = inputdialog("[rq.vim] Entrez votre adresse électronique (Consultez \"rq.txt\" pour éviter cette demande) : ") 
        if reponse != ""
            let g:Rq_Auteur = reponse
        endif
    endif
    if (g:Rq_Initiales =~ '^<Vos')
        let reponse = inputdialog("[rq.vim] Entrez vos initiales (Consultez \"rq.txt\" pour éviter cette demande) : ") 
        if reponse != ""
            let g:Rq_Initiales = reponse
        endif
    endif
endfunction
    
function! ExtraireChainesReponses () "{{{1
" Extrait la chaîne utilisée pour la dernière réponse du correspondant.
" Détermine celle à utiliser pour ses réponses personnelles.
" Fixe : les variables b:entete_actuel et b:entete_prochain.
    let b:entete_actuel = ""
    let b:entete_prochain = ""
    let niveaureponse = ""
    normal gg
    if search("^fichier\\c", "W") == 0
        echo '[rq.vim] En-tête incomplet, essayez ",e" pour générer un nouvel en-tête'
        return
    endif
    call VerifierIdentification()
    " Parcourt tous les en-têtes de réponses...
    while search("^#\\s*réponses\\c", "bW")
        if getline(".") !~ g:Rq_Initiales
            " ... s'arrête au premier ne contenant pas ses initiales...
            let b:entete_actuel = substitute(getline("."),
                        \'#\s*réponses\(.*\)\s*:\c',
                        \'^Réponse\1', "")
            let niveaureponse = substitute(b:entete_actuel,
                        \'\^Réponse\s*\(\l*\)\s*\u\+', '\1', "")
" PROTO                 \'\^Réponse\s*\(\w*\)\s*\u\+', '\1', "")
            let niveaureponse = substitute(niveaureponse,
                        \'\s*\(.\{-}\)\s*', '\1', '')
            " ... si l'en-tête précédent est de niveau différent, notre
            " réponse aura le même niveau que celle du correspondant...
            if search('^#\s*réponses\c', "bW") != 0
                if getline(".") =~ "^#\\s*réponses\\s\\+\\c" . niveaureponse
                            \. ".*$"
                    " ... sinon, on « incrémente » le niveau de sa réponse.
                    " Pour les « très bavards » : 11 fois=undecies,
                    " 12=duodecies, 13=tredecies, 14=quattuordecies,
                    " 15=quindecies, 16=sexies decies / sedecies / sexdecies,
                    " 17=septemdecies / septendecies / septies decies,
                    " 18=duodevicies / octies decies / duodevicies,
                    " 19=undevicies / novies decies, 20=undevicie / vicies.
                    if niveaureponse =~ "novies"
                        let niveaureponse = "decies "
                    elseif niveaureponse =~ "octies"
                        let niveaureponse = "novies "
                    elseif niveaureponse =~ "septies"
                        let niveaureponse = "octies "
                    elseif niveaureponse =~ "sexies"
                        let niveaureponse = "septies "
                    elseif niveaureponse =~ "quinquies"
                        let niveaureponse = "sexies "
                    elseif niveaureponse =~ "quater"
                        let niveaureponse = "quinquies "
                    elseif niveaureponse =~ "ter"
                        let niveaureponse = "quater "
                    elseif niveaureponse =~ "bis"
                        let niveaureponse = "ter "
                    elseif niveaureponse == ""
                        let niveaureponse = "bis "
                    endif
" PROTO             if niveaureponse =~ "quater"
" PROTO                 let niveaureponse = 4
" PROTO             elseif niveaureponse =~ "ter"
" PROTO                 let niveaureponse = 3
" PROTO             elseif niveaureponse =~ "bis"
" PROTO                 let niveaureponse = 2
" PROTO             endif
" PROTO             let niveaureponse = niveaureponse + 1
" PROTO             let niveaureponse = niveaureponse . " "
                endif
            endif
            break
        endif
        normal k
    endwhile
    let b:entete_prochain = "Réponse " . niveaureponse . g:Rq_Initiales
    " Revient à la dernière position connue dans le fichier.
    normal g'"
endfunction

function! InsererStat () "{{{1
" Calcule quelques statistiques concernant
" la prise en compte des remarques.
" (uniquement si le tampon a été modifié).
    if b:mon_changedtick != b:changedtick
        let rqTotal = 0
        let rqFait = 0
        let rqSouffrance = 0
        let rqRejete = 0
        normal mcHmhgg
        if (line("'c") <= 7) || (line("'h") <= 7)
            " Éviter la suppression des marques au cas
            " où elles seraient sur les stats (coupage des lignes).
            normal mcmh
        endif
        " Calcul...
        while search('^ligne\s*: \c', "W") != 0
            normal j
            let rqTotal = rqTotal + 1
            if (search('^Statut\s*:\s\c', "W") != 0)
                let statut = getline(".")
                if (statut =~ '^Statut\s*:\s*fait\c') ||
                            \(statut =~ '^Statut\s*:\s*RAS\c')
                    let rqFait = rqFait + 1
                endif
                if (statut =~ '^Statut\s*:\s*rejeté\c')
                    let rqRejete = rqRejete + 1
                endif
                if (statut =~ '^Statut\s*:\s\+.\+souffrance\c') ||
                            \(statut =~ '^Statut\s*:\s*$\c')
                    let rqSouffrance = rqSouffrance + 1
                endif
            endif
        endwhile
        " Nombre de réponses du correspondant.
        let rqReponses = 0
        normal gg
        while search('^' . b:entete_prochain . '\s*:\c', "W") != 0
            let rqReponses = rqReponses + 1
        endwhile
        " ... et affichage (si au moins 2 remarques).
        if rqTotal > 1
            let sRejete = ""
            let sFait = ""
            let sReponse = ""
            if rqRejete > 1
                let sRejete = "s"
            endif
            if rqFait > 1
                let sFait = "s"
            endif
            if rqReponses > 1
                let sReponse = "s"
            endif
            normal gg
            /^fichier :\c/
            if search("^# Statistiques :", "bW") != 0
                " Si déjà des stats, on les efface.
                silent exe 'normal k"_d}'
            endif
            normal gg
            call append(".", "\#\t" . rqReponses . " réponse" . sReponse . " du correspondant")
            call append(".", "\#\t -+-")
            call append(".", "\#\t" . rqSouffrance . " en attente")
            call append(".", "\#\t" . rqRejete . " rejetée" . sRejete)
            call append(".", "\#\t" . rqFait . " prise" . sFait . " en compte")
            call append(".", "\# Statistiques : " . rqTotal . " remarques dont")
            call append(".", "")
        endif
        normal 'hzt`c
        echo "Statistiques mises à jour"
    endif
endfunction

function! MettreAJourDate () "{{{1
" Met à jour les en-têtes d'un tampon s'il a été modifié.
    if b:mon_changedtick != b:changedtick
        normal mcHmhgg
        if search("^fichier\\c", "W") == 0
            echoerr "[rq.vim] Champ « Fichier » manquant dans le fichier de remarques"
            return
        endif
        normal {{jj
        " Si le dernier en-tête émane du correspondant,
        " rajoute son propre en-tête.
        if getline(".") !~ g:Rq_Auteur
            normal }
            call append(".", '')
            call append(".", '# Dernière modification :')
            call append(".", '# ' . g:Rq_Auteur)
            call append(".", substitute(b:entete_prochain,
                               \"réponse\\(.*\\)\\c", "# Réponses\\1 :", ""))
        endif
        " Met à jour la dernière date de modification.
        normal G
        if search("^#\\s*dernière modification\\s*:\\c", "bW") != 0
            normal f:"_D
            call append(".", ': ' . strftime("%d %b %Y"))
        else
            echoerr "[rq.vim] Aucune date de dernière modification trouvée"
        endif
        normal J'hzt`c
    endif
endfunction

function! CreerEntete () "{{{1
" Génère un en-tête valide de fichier de remarques.
    if (expand("%:e") ==? "rq")
        if (line('$') == 1) && (getline('$') == "")
            call VerifierIdentification()
            " Le fichier est vide, on ajoute l'en-tête.
            call append(0, "Fichier : " . expand("%:t:r") . " ")
            call append(0, "")
            call append(0, "")
            call append(0, "\# Dernière modification : ")
            call append(0, "\# " . g:Rq_Auteur)
            call append(0, "\# Remarques de relecture :")
            call append(0, "")
            call append(0, "\# Traduction de la documentation de VIM.\tvim:tw=78:ts=8:ft=rq:")
            normal gg
            /^Fichier :/
            exe "normal 72A#\<Esc>73|\"_DG"
            call MettreAJourDate()
            call ExtraireChainesReponses()
            normal G
        else
            echo "Le fichier n'est pas vide, création d'en-tête impossible"
        endif
    else
        echohl ErrorMsg
        echo "[rq.vim] Le fichier n'a pas la bonne extension (.rq)"
        echohl None
    endif
endfunction

function! ReponseSuivante () "{{{1
" Saute à réponse suivante du correspondant s'il y en a une.
    if b:entete_actuel != ""
        if search(b:entete_actuel, "W") == 0
            echo "Dernière réponse du correspondant"
        else
            normal zz
        endif
    else
        echo "Impossible de trouver les réponses du correspondant"
    endif
endfunction

function! ReponsePrecedente () "{{{1
" Saute à réponse précédente du correspondant s'il y en a une.
    if b:entete_actuel != ""
        if search(b:entete_actuel, "bW") == 0
            echo "Pas de réponse précédente du correspondant"
        else
            normal zz
        endif
    else
        echo "Impossible de trouver les réponses du correspondant"
    endif
endfunction

function! RemarqueSuivante () "{{{1
" Amène à la remarque suivante.
    if search("^ligne\\s*: \\c", "W") != 0
        normal zt
    else
        let s:msg = "Pas de remarque suivante"
    endif
endfunction

function! RemarquePrecedente () "{{{1
" Amène à la remarque précédente.
    if search("^ligne\\s*: \\c", "bW") != 0
        normal zt
    else
        let s:msg = "Pas de remarque précédente"
    endif
endfunction

function! AllerARelu () "{{{1
" Trouve le fichier relu correspondant au fichier
" remarques en cours d'édition et y amène le curseur.
" Retourne : 1 si le fichier est trouvé, 0 sinon.
" Prérequis : les fichiers relu ET de remarques sont ouverts.
    let dest = bufwinnr(expand("%:t:r"))
    if (dest == -1) || (bufname(winbufnr(dest)) == bufname(winbufnr(0)))
        return 0
    endif
    exe dest . 'wincmd w'
    return 1
endfunction

function! AllerARemarques (...) "{{{1
" Trouve le fichier de remarques correspondant au fichier
" relu en cours d'édition et y amène le curseur.
" Exécute la commande la commande passée en argument
" si la fenêtre est trouvée. 
" Retourne : 1 si le fichier est trouvé, 0 sinon.
" Prérequis : les fichiers relu ET de remarques sont ouverts.
    let dest = bufwinnr(expand("%:t") . ".rq")
    if (dest == -1)
        echo "Impossible de trouver le tampon " . expand("%:t") . ".rq"
        return 0
    endif
    exe dest . 'wincmd w'
    if (a:0 != 0)
        exe a:1
    endif
    return 1
endfunction

function! ExtraireLigneRq () "{{{1
" Recherche la ligne « Ligne : » précédente
" sans boucler et sans messages.
" Retourne : le numéro de la ligne correspondante,
" 0 si non trouvé.
    normal k}
    if search("^ligne\\s*: \\c", "bW") != 0
        let lignerq = substitute(getline("."),
                    \'^Ligne\s*:\s*\(\d\+\).*$\c', '\1', "")
    else
        let lignerq = 0
    endif
    normal zt
    return lignerq
endfunction

function! SauterRemarque () "{{{1
" Saute à la première ligne concernée par une remarque
" (suit les lignes de contexte si possible).
    if s:msg == ""
        syntax clear rqLigneContexte
        silent! exe "normal mcHmh'ck}"
        " Extraire le numéro de ligne de la remarque courante.
        let nol = ExtraireLigneRq()
        " Extraire les 1ères lignes de contexte (ancien '-' et nouveau '+').
        let ancienContexte = ExtraireContexte("-")
        let nouveauContexte = ExtraireContexte("+")
        " Vérifier que le remarque sous le
        " curseur est valide.
	if s:msg == "" 
            ?^ligne\s*:\c?
            normal ztmc
            " Passer dans la fenêtre de remarques, en 
            " cherchant le meilleur endroit possible.
            if AllerARelu()
                let lignefin = line("$")
                " Commencer la recherche en prenant le décalage en compte...
                execute ":" . nol
                silent! execute "normal " . s:decal . "j10k"
                let contexte = RechercherContexte(ancienContexte,
                            \nouveauContexte)
                if (contexte == "")
                    " ... puis sans décalage...
                    execute ":" . nol
                    silent! execute "normal 10k"
                    let contexte = RechercherContexte(ancienContexte, nouveauContexte)
                endif
                if (contexte == "")
                    " ... et si on ne trouve rien, se placer sur la ligne
                    " donnée par la remarque.
                    execute ":" . (nol + s:decal)
                else
                    " Le contexte est trouvé, calcul du décalage.
                    let anciendecal = s:decal
                    let s:decal = line(".") - nol
                    if s:decal >= (anciendecal + 40 + lignefin * 0.1)
                        execute ":" . nol
                        let s:decal = 0
                    else
                        call AllerARemarques()
                        " Activer la surbrillance du
                        " contexte correspondant.
                        execute "syntax match rqLigneContexte \"[-+]\\s*"
                                    \. escape(contexte, '"') . "$\"he=s+1"
                        normal 'czt
                        call AllerARelu()
                    endif
                endif
                normal zz
                echo ""
            else
                echo "Impossible de trouver le tampon " . expand("%:t:r")
            endif
        else
            echo s:msg
        endif
    else
        call AllerARelu()
        echo s:msg
    endif
    let s:msg = ""
endfunction

function! ExtraireContexte (symbole) "{{{1
" Recherche la première ligne de contexte débutant
" par "symbole", sans dépasser la ligne de Statut.
" Retourne : cette ligne débarrassée de "symbole".
    let contexte = ""
    " Parcourt toutes les lignes jusqu'au « Statut » suivant.
    while getline(".") !~ '^statut\c'
        if getline(".") =~ "^" . a:symbole . "."
            " Extrait la ligne de contexte (les caractères
            " spéciaux sont protégés par '\').
            let contexte = escape(substitute(getline("."), '^' . a:symbole
                        \. '\(.*\)$', '\1', ""),
                        \'.*^$~\[]')
            break
        elseif getline(".") =~ '^\s*$'
            " Ligne vide.
            let s:msg = "Pas de remarque sous le curseur ou remarque mal structurée"
            normal 'hzt`c
            break
        endif
        normal j
    endwhile
    if s:msg == ""
        normal k
    endif
    " Renvoie une chaîne introuvable s'il n'y aucune ligne de contexte.
    " (évite la correspondance avec les lignes vides).
    if contexte == ""
        let contexte = "DEMAINDÈSLAUBE"
    endif
    return contexte
endfunction

function! RechercherContexte (ancien, nouveau) "{{{1
" Recherche au mieux les lignes de contexte passées en argument.
" Renvoie : la ligne de contexte qui correspond, une chaîne vide sinon.
    " D'abord, recherche une correspondance entière.
    " Les tabulations sont parfois écrasées.
    let ancien = a:ancien 
    while ancien =~ "\\t"
        let ancien = substitute(ancien, "\\([^\t]*\\)\\t\\+\\([^\t]*\\)",
                    \"\\1\\\\t\\\\+\\2", "")
    endwhile
    if search("^" . ancien . "$", "W")
        return ancien
    endif
    let nouveau = a:nouveau
    while nouveau =~ "\\t"
        let nouveau = substitute(nouveau, "\\([^\t]*\\)\\t\\+\\([^\t]*\\)",
                    \"\\1\\\\t\\\\+\\2", "")
    endwhile
    if search("^" . nouveau . "$", "W")
        return nouveau
    endif
    " Puis une correspondance partielle.
    let ancien = substitute(a:ancien, "\\s*\\(.*\\)", "\\1", "")
    while ancien =~ "\\t"
        let ancien = substitute(ancien, "\\([^\t]*\\)\\t\\+\\([^\t]*\\)",
                    \"\\1\\\\t\\\\+\\2", "")
    endwhile
    if search(ancien, "W")
        return ancien
    endif
    let nouveau = substitute(a:nouveau, "\\s*\\(.*\\)", "\\1", "")
    while nouveau =~ "\\t"
        let nouveau = substitute(nouveau, "\\([^\t]*\\)\\t\\+\\([^\t]*\\)",
                    \"\\1\\\\t\\\\+\\2", "")
    endwhile
    if search(nouveau, "W")
        return nouveau
    endif
    " Puis une correspondance partielle sans la casse.
    let ic_sauv = &ic
    set ic
    if search(ancien, "W")
        let &ic = ic_sauv
        return ancien
    endif
    if search(nouveau, "W")
        let &ic = ic_sauv
        return nouveau
    endif
    " Puis une correspondance partielle sans casse tronquée.
    " TODO : N'y a-t-il pas un moyen plus simple de faire cela ?
    let ancien = substitute(a:ancien, "\\s*\\(.*\\)", "\\1", "")
    while ancien =~ "\\s"
        let ancien = substitute(ancien, "\\(\\S\\+\\)\\s\\+\\(\\S*\\)",
                       \"\\1\\\\_s*\\2", "")
    endwhile
    if search(ancien, "W")
        let &ic = ic_sauv
        return ancien
    endif
    let nouveau = substitute(a:nouveau, "\\s*\\(.*\\)", "\\1", "")
    while nouveau =~ "\\s"
        let nouveau = substitute(nouveau, "\\(\\S\\+\\)\\s\\+\\(\\S*\\)",
                        \"\\1\\\\_s*\\2", "")
    endwhile
    if search(nouveau, "W")
        let &ic = ic_sauv
        return nouveau
    endif
    let &ic = ic_sauv
    return ""
endfunction

function! SauterRemarqueATraiterSuivante () "{{{1
" Saute à l'emplacement de la prochaine remarque à traiter.
    let lcur = line(".")
    normal }
    if search('^statut\s*:\(\s\+en souffrance\)\=\s*$\c', "W") != 0
        call SauterRemarque()
    else
        " S'il n'y a pas de remarque à traiter vers l'avant,
        " reviens à la dernière remarque à traiter.
        if search('^statut\s*:\(\s\+en souffrance\)\=\s*$\c', "bW") != 0
            call SauterRemarque()
            echo "Dernière remarque à traiter"
        else
            " S'il n'y a aucune remarque à traiter...
            exe ":" . lcur
            echo "Aucune remarque à traiter"
        endif
    endif
endfunction

function! SauterRemarqueATraiterPrecedente () "{{{1
" Saute à l'emplacement de la remarque à traiter précédente.
    let lcur = line(".")
    if search('^statut\s*:\(\s\+en souffrance\)\=\s*$\c', "bW") != 0
        call SauterRemarque()
    else
        " S'il n'y a pas de remarque à traiter vers l'arrière,
        " revient à la première remarque à traiter.
        if search('^statut\s*:\(\s\+en souffrance\)\=\s*$\c', "W") != 0
            call SauterRemarque()
            echo "Première remarque à traiter"
        else
            " S'il n'y a aucune remarque à traiter...
            exe ":" . lcur
            echo "Aucune remarque à traiter"
        endif
    endif
endfunction

function! InsererRemarque () range "{{{1
" Insérer une remarque.
" Prérequis : le fichier de remarques ET le fichier relu sont ouverts.
    let nblignes = a:lastline - a:firstline + 1
    " Copier la plage, ...
    execute "yank " . nblignes
    " ... changer de fenêtre si possible, ...
    if AllerARemarques()
        " ... et coller les lignes.
        let nol = "Ligne : " . a:firstline . 
                    \(nblignes == 1 ? "" : "-" . a:lastline)
        normal G
        " Insérer au bon endroit.
        while (ExtraireLigneRq() > a:firstline)
            normal k
        endwhile
        execute 'normal k}zzo' . nol . 
                    \"\<Esc>oRemarque : \<CR>Statut : \<CR>\<Esc>2kpkp"
        " Préciser une plage à une fonction ne la prenant pas en compte
        " lance son appel pour chaque ligne de la plage.
        execute '.,+' . (nblignes - 1) . 'call InsererSymbole("-")'
        normal j
        execute '.,+' . (nblignes - 1) . 'call InsererSymbole("+")'
        ?^remarque :\c?
        startinsert!
    endif
endfunction

function! InsererSymbole (symbole)
" Insérer une chaîne au début d'une ligne.
    execute 'normal 0i' . a:symbole
endfunction

function! EchangerTexte () " {{{1
" Remplace (si possible) la VO par la proposition
" du relecteur.
    " Trouver les lignes à remplacer...
    normal k}
    if search("^ligne\\s*: \\c", "bW") != 0
        let s:lstart = substitute(getline("."), 
                    \'^Ligne\s*:\s*\(\d\+\(-\d\+\)\=\).*$\c', '\1', "")
    else
        echo "[rq.vim] Impossible d'analyser la remarque"
        return
    endif
    if s:lstart =~ '\d-\d'
        let s:lend = substitute(s:lstart, '\d\+-\(\d\+\)', '\1', "")
        let s:lstart = substitute(s:lstart, '\(\d\+\)-\d\+', '\1', "")
    else
        let s:lend = s:lstart
    endif
    " ... extraire les lignes de remplacement...
    let @a = ""
    /^+/
    while (getline('.') =~ '^+.*$')
        let @A = substitute(getline('.'), '+\(.*\)$', '\1', '') . "\n"
        normal j
    endwhile
    " et Effectuer le remplacement.
    call SauterRemarque()
    if s:msg =~ ""
        execute ".,+" . (s:lend - s:lstart) . "delete"
        put! a
    else
        echo "[rq.vim] Impossible de trouver les lignes à remplacer"
    endif
endfunction
" }}}

" Rétablissement des paramètres initiaux {{{1
let b:undo_ftplugin = "setlocal fo< comments<"
        \. "| unlet! s:decal s:msg b:mon_changedtick b:entete_prochain"
        \. "| unlet! b:entete_actuel"
let &cpo = s:cpo_sauv
unlet s:cpo_sauv
" }}}

" vim:tw=78:ts=8:sts=4:et:fo=croq:fdm=marker:
