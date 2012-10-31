" File: zorglang.vim
" Summary: Convert text to Zorglang
" Author: David Blanchet <david.blanchet.at.free.fr>
" Last Change: 2004 july 26
" Version: 1.0
" URL: http://david.blanchet.free.fr/vim/zorglang.vim
" Based On: "Z comme Zorglub", T.15 of "Spirou & Fantasio", A. Franquin
" Description: Zorglub deprives people of their free will to turn them into
"   soldier. Zorglug "invented" the Zorglang to give orders to his
"   "zorglhommes".
"   This plugin may help you to give orders to your own zorglhommes.
" Installation:
"   Drop this file into your ~/.vim/plugin/ directory.
" Usage:
"   For a single word: ":call ZorgWord('ASingleWord')"
"   For buffer lines : ":[range]call ZorgLine()" or ":[range]ZorgConvert"
" Examples:
"   Convert a whole buffer : ":%Z" or ":%ZorgConvert"
"   Convert line 3 of the buffer : "3Z" or "3ZorgConvert"
"   Convert 3 lines from current one : ".,+2Z" or ".,+2ZorgConvert"

command! -range ZorgConvert :<line1>,<line2>call ZorgLine()

function! ZorgWord(word)
    let len = strlen(a:word)
    let mycount = 0
    let result = ""
    while mycount <= len
	let result = result . a:word[len - mycount]
	let mycount = mycount + 1
    endwhile
    return result
endfunction

function! ZorgLine()
    let olda = @a
    let @a = substitute(getline("."), '\i\i\+', '\=ZorgWord(submatch(0))', "g")
    normal 0D"ap
    let @a = olda
endfunction

