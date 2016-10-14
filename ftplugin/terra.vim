" Vim filetype plugin file
" Language:     Terra
" Maintainer:   Jak Wings
" Last Change:  2016 October 14

if exists('b:did_ftplugin')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim


setlocal comments=s:--[[,m:\ ,e:]],f:--
setlocal commentstring=--%s
setlocal formatoptions-=t fo+=c fo+=r fo+=o fo+=q fo+=l fo+=j

setlocal path=
setlocal includeexpr=
setlocal include=\\v^\\s*import>
setlocal define=\\v^\\s*%(function\|terra\|local\|global\|var)>
setlocal isident=@,48-57,_
setlocal iskeyword=@,48-57,_
setlocal suffixesadd=.t
setlocal matchpairs=(:),{:},[:]

let b:match_ignorecase = 0
let b:match_skip = 'terra#MatchSkip()'
let b:match_words = '\v<%(function|terra|if|while|for|quote|escape)>\m:\v<%(then|elseif|else|do|in)>|\|\m:\<end\>,\<repeat\>:\<until\>,\[\(=*\)\[:\]\1\],(:),\[:\],{:}'
source $VIMRUNTIME/macros/matchit.vim

let b:undo_ftplugin = 'set comments< commentstring< formatoptions< path< include< includeexpr< define< isident< iskeyword< suffixesadd< matchpairs<'
      \ . ' | unlet! b:match_ignorecase b:match_skip b:match_words'


let &cpo = s:cpo_save
unlet s:cpo_save

let b:did_ftplugin = 1
